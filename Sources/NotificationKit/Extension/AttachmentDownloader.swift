import Foundation

/// Downloads the image, audio or video of a push into a local file, within Apple's size limits.
///
/// A Notification Service Extension has about 30 seconds and little memory, and the URL comes
/// from a server, so the downloader:
///
/// - accepts only `https` URLs (unless ``allowsInsecureHTTP`` is set),
/// - accepts only the media types the system can attach (JPEG, PNG, GIF, HEIC; MP3, M4A, AIFF,
///   WAV; MP4, MOV, MPEG),
/// - stops as soon as more bytes arrive than the type allows (10 MB images, 5 MB audio, 50 MB
///   video), whether or not the server announced the size, and streams to disk instead of
///   holding the file in memory.
public struct AttachmentDownloader: Sendable {
    /// What kind of media a file is.
    public enum MediaKind: String, Sendable, Hashable {
        case image, audio, video
    }

    /// Why a download was rejected.
    public enum DownloadError: Error, Hashable, Sendable {
        /// The URL is not `https` (or `http` when allowed).
        case insecureURL
        /// The server answered with a status outside 200...299.
        case badStatus(Int)
        /// The media type cannot be attached to a notification.
        case unsupportedType(String)
        /// The file is larger than the limit for its kind.
        case tooLarge(limit: Int)
        /// The server sent no bytes.
        case empty
    }

    /// Size limits per kind, in bytes. Apple's limits are the defaults.
    public struct Limits: Sendable, Hashable {
        public var image: Int
        public var audio: Int
        public var video: Int

        public init(image: Int = 10_000_000, audio: Int = 5_000_000, video: Int = 50_000_000) {
            self.image = image
            self.audio = audio
            self.video = video
        }

        func limit(for kind: MediaKind) -> Int {
            switch kind {
            case .image: image
            case .audio: audio
            case .video: video
            }
        }
    }

    struct MediaType: Hashable {
        let kind: MediaKind
        let fileExtension: String
        let typeIdentifier: String
    }

    static let mediaTypes: [String: MediaType] = [
        "image/jpeg": MediaType(kind: .image, fileExtension: "jpg", typeIdentifier: "public.jpeg"),
        "image/png": MediaType(kind: .image, fileExtension: "png", typeIdentifier: "public.png"),
        "image/gif": MediaType(kind: .image, fileExtension: "gif", typeIdentifier: "com.compuserve.gif"),
        "image/heic": MediaType(kind: .image, fileExtension: "heic", typeIdentifier: "public.heic"),
        "audio/mpeg": MediaType(kind: .audio, fileExtension: "mp3", typeIdentifier: "public.mp3"),
        "audio/mp4": MediaType(kind: .audio, fileExtension: "m4a", typeIdentifier: "com.apple.m4a-audio"),
        "audio/x-m4a": MediaType(kind: .audio, fileExtension: "m4a", typeIdentifier: "com.apple.m4a-audio"),
        "audio/aiff": MediaType(kind: .audio, fileExtension: "aiff", typeIdentifier: "public.aiff-audio"),
        "audio/x-aiff": MediaType(kind: .audio, fileExtension: "aiff", typeIdentifier: "public.aiff-audio"),
        "audio/wav": MediaType(kind: .audio, fileExtension: "wav", typeIdentifier: "com.microsoft.waveform-audio"),
        "audio/x-wav": MediaType(kind: .audio, fileExtension: "wav", typeIdentifier: "com.microsoft.waveform-audio"),
        "video/mp4": MediaType(kind: .video, fileExtension: "mp4", typeIdentifier: "public.mpeg-4"),
        "video/quicktime": MediaType(kind: .video, fileExtension: "mov", typeIdentifier: "com.apple.quicktime-movie"),
        "video/mpeg": MediaType(kind: .video, fileExtension: "mpg", typeIdentifier: "public.mpeg")
    ]

    /// Types by file extension, for servers that send `application/octet-stream`.
    static let typesByExtension: [String: MediaType] = {
        var result: [String: MediaType] = [:]
        for type in mediaTypes.values { result[type.fileExtension] = type }
        result["jpeg"] = mediaTypes["image/jpeg"]
        return result
    }()

    public let session: URLSession
    public let limits: Limits
    public let allowsInsecureHTTP: Bool
    /// The folder downloads are written to; the system moves the file away when it attaches it.
    public let directory: URL

    public init(
        session: URLSession = .shared,
        limits: Limits = Limits(),
        allowsInsecureHTTP: Bool = false,
        directory: URL = FileManager.default.temporaryDirectory.appendingPathComponent("NotificationKitDownloads", isDirectory: true)
    ) {
        self.session = session
        self.limits = limits
        self.allowsInsecureHTTP = allowsInsecureHTTP
        self.directory = directory
    }

    /// Downloads `url` and returns an attachment that points at the local file.
    public func download(_ url: URL, id: String = "media") async throws -> NotificationAttachment {
        guard isAllowed(url) else { throw DownloadError.insecureURL }
        let (bytes, response) = try await session.bytes(from: url)
        // URLSession follows redirects, so the final URL is checked as well.
        guard let finalURL = response.url, isAllowed(finalURL) else { throw DownloadError.insecureURL }
        let status = (response as? HTTPURLResponse)?.statusCode ?? 200
        guard (200...299).contains(status) else { throw DownloadError.badStatus(status) }
        let type = try Self.mediaType(mimeType: response.mimeType, url: url)
        let limit = limits.limit(for: type.kind)
        if response.expectedContentLength > Int64(limit) { throw DownloadError.tooLarge(limit: limit) }

        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let file = directory.appendingPathComponent(UUID().uuidString).appendingPathExtension(type.fileExtension)
        do {
            try await write(bytes, to: file, limit: limit)
        } catch {
            try? FileManager.default.removeItem(at: file)
            throw error
        }
        return NotificationAttachment(id: id, url: file, typeHint: type.typeIdentifier)
    }

    private func isAllowed(_ url: URL) -> Bool {
        let scheme = url.scheme?.lowercased()
        return scheme == "https" || (allowsInsecureHTTP && scheme == "http")
    }

    static func mediaType(mimeType: String?, url: URL) throws(DownloadError) -> MediaType {
        let mime = mimeType?.lowercased().split(separator: ";").first.map { $0.trimmingCharacters(in: .whitespaces) }
        if let mime, let type = mediaTypes[mime] { return type }
        if mime == nil || mime == "application/octet-stream" || mime == "binary/octet-stream",
           let type = typesByExtension[url.pathExtension.lowercased()] {
            return type
        }
        throw .unsupportedType(mime ?? url.pathExtension)
    }

    private func write(_ bytes: URLSession.AsyncBytes, to file: URL, limit: Int) async throws {
        guard FileManager.default.createFile(atPath: file.path, contents: nil) else {
            throw CocoaError(.fileWriteUnknown)
        }
        let handle = try FileHandle(forWritingTo: file)
        defer { try? handle.close() }
        let chunkSize = 64 * 1024
        var buffer = Data()
        buffer.reserveCapacity(chunkSize)
        var total = 0
        for try await byte in bytes {
            total += 1
            guard total <= limit else { throw DownloadError.tooLarge(limit: limit) }
            buffer.append(byte)
            if buffer.count == chunkSize {
                try handle.write(contentsOf: buffer)
                buffer.removeAll(keepingCapacity: true)
            }
        }
        try handle.write(contentsOf: buffer)
        guard total > 0 else { throw DownloadError.empty }
    }
}
