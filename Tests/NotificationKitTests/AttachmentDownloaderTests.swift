import Foundation
import Testing
@preconcurrency import UserNotifications
@testable import NotificationKit

// The stub protocol's handler is shared, so these tests run one at a time.
@Suite("Attachment downloader", .serialized)
struct AttachmentDownloaderTests {
    let directory = FileManager.default.temporaryDirectory.appendingPathComponent("nk-tests-\(UUID().uuidString)")
    let png = Data([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]) + Data(repeating: 7, count: 200)

    func downloader(limits: AttachmentDownloader.Limits = .init(), _ handler: @escaping @Sendable (URLRequest) -> StubURLProtocol.Response) -> AttachmentDownloader {
        AttachmentDownloader(session: StubURLProtocol.session(handler), limits: limits, directory: directory)
    }

    func filesLeft() -> [String] {
        (try? FileManager.default.contentsOfDirectory(atPath: directory.path)) ?? []
    }

    @Test("downloads an image into a file with the right extension and type")
    func downloadsImage() async throws {
        let body = png
        let loader = downloader { _ in .init(headers: ["Content-Type": "image/png; charset=binary"], body: body) }
        let attachment = try await loader.download(URL(string: "https://example.com/photo")!, id: "photo")
        #expect(attachment.id == "photo")
        #expect(attachment.url.pathExtension == "png")
        #expect(attachment.typeHint == "public.png")
        #expect(try Data(contentsOf: attachment.url) == body)
        try? FileManager.default.removeItem(at: directory)
    }

    @Test("uses the file extension when the server sends a generic type")
    func extensionFallback() async throws {
        let loader = downloader { _ in .init(headers: ["Content-Type": "application/octet-stream"], body: Data([1, 2, 3])) }
        let attachment = try await loader.download(URL(string: "https://example.com/clip.MP4")!)
        #expect(attachment.typeHint == "public.mpeg-4")
        try? FileManager.default.removeItem(at: directory)
    }

    @Test("accepts only https unless http is allowed")
    func requiresHTTPS() async throws {
        let loader = downloader { _ in .init(headers: ["Content-Type": "image/png"], body: Data([1])) }
        for text in ["http://example.com/a.png", "file:///etc/hosts", "ftp://example.com/a.png", "data:image/png;base64,AA=="] {
            await #expect(throws: AttachmentDownloader.DownloadError.insecureURL) { try await loader.download(URL(string: text)!) }
        }
    }

    @Test("rejects a redirect from https to http")
    func rejectsDowngradeRedirect() async throws {
        let loader = downloader { request in
            if request.url?.scheme == "https" { return .init(redirect: URL(string: "http://example.com/a.png")!) }
            return .init(headers: ["Content-Type": "image/png"], body: Data([1]))
        }
        await #expect(throws: AttachmentDownloader.DownloadError.insecureURL) {
            try await loader.download(URL(string: "https://example.com/a.png")!)
        }
        #expect(filesLeft().isEmpty)
    }

    @Test("rejects a file the server says is too large without reading it")
    func rejectsAnnouncedSize() async throws {
        let loader = downloader(limits: .init(image: 100)) { _ in
            .init(headers: ["Content-Type": "image/jpeg", "Content-Length": "5000"], body: Data(count: 5_000))
        }
        await #expect(throws: AttachmentDownloader.DownloadError.tooLarge(limit: 100)) {
            try await loader.download(URL(string: "https://example.com/a.jpg")!)
        }
        #expect(filesLeft().isEmpty)
    }

    @Test("stops a download that grows past the limit and deletes the partial file")
    func stopsUnannouncedLargeBody() async throws {
        let loader = downloader(limits: .init(image: 1_000)) { _ in
            .init(headers: ["Content-Type": "image/gif"], body: Data(count: 200_000))
        }
        await #expect(throws: AttachmentDownloader.DownloadError.tooLarge(limit: 1_000)) {
            try await loader.download(URL(string: "https://example.com/a.gif")!)
        }
        #expect(filesLeft().isEmpty)
    }

    @Test("applies the limit of the media kind")
    func perKindLimits() async throws {
        let loader = downloader(limits: .init(image: 10, audio: 10_000, video: 10)) { _ in
            .init(headers: ["Content-Type": "audio/mpeg"], body: Data(count: 5_000))
        }
        let attachment = try await loader.download(URL(string: "https://example.com/a.mp3")!)
        #expect(attachment.typeHint == "public.mp3")
        try? FileManager.default.removeItem(at: directory)
    }

    @Test("rejects unsupported types, error statuses and empty bodies")
    func rejectsBadResponses() async throws {
        let html = downloader { _ in .init(headers: ["Content-Type": "text/html"], body: Data("<html>".utf8)) }
        await #expect(throws: AttachmentDownloader.DownloadError.unsupportedType("text/html")) {
            try await html.download(URL(string: "https://example.com/a.png")!)
        }
        let missing = downloader { _ in .init(status: 404, headers: ["Content-Type": "image/png"]) }
        await #expect(throws: AttachmentDownloader.DownloadError.badStatus(404)) {
            try await missing.download(URL(string: "https://example.com/a.png")!)
        }
        let empty = downloader { _ in .init(headers: ["Content-Type": "image/png"]) }
        await #expect(throws: AttachmentDownloader.DownloadError.empty) {
            try await empty.download(URL(string: "https://example.com/a.png")!)
        }
        #expect(filesLeft().isEmpty)
    }
}

@Suite("Media attachment service", .serialized)
struct MediaAttachmentServiceTests {
    #if !os(watchOS)
    @Test("attaches the downloaded media and leaves content without a URL unchanged")
    func attachesMedia() async throws {
        let png = try #require(Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="))
        let session = StubURLProtocol.session { _ in .init(headers: ["Content-Type": "image/png"], body: png) }
        let downloader = AttachmentDownloader(session: session)

        let content = UNMutableNotificationContent()
        content.title = "New photo"
        content.userInfo = ["media-url": "https://example.com/photo.png"]
        let enriched = await MediaAttachmentService.content(for: content, downloader: downloader)
        #expect(enriched.title == "New photo")
        #expect(enriched.attachments.count == 1)

        let plain = UNMutableNotificationContent()
        plain.title = "No media"
        #expect(await MediaAttachmentService.content(for: plain, downloader: downloader) === plain)

        let insecure = UNMutableNotificationContent()
        insecure.userInfo = ["media-url": "http://example.com/photo.png"]
        #expect(await MediaAttachmentService.content(for: insecure, downloader: downloader).attachments.isEmpty)
    }
    #endif

    @Test("hands content to the system exactly once, whichever finishes first")
    func deliversOnce() {
        final class Counter: @unchecked Sendable {
            let lock = NSLock()
            var titles: [String] = []
        }
        let counter = Counter()
        let delivery = OneTimeDelivery()
        let fallback = UNMutableNotificationContent()
        fallback.title = "fallback"
        delivery.prepare(fallback: fallback) { content in counter.lock.withLock { counter.titles.append(content.title) } }
        let enriched = UNMutableNotificationContent()
        enriched.title = "enriched"
        DispatchQueue.concurrentPerform(iterations: 50) { index in
            if index.isMultiple(of: 2) { delivery.deliver(enriched) } else { delivery.deliverFallback() }
        }
        #expect(counter.titles.count == 1)
    }
}
