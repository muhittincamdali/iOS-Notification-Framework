import Foundation
@preconcurrency import UserNotifications

/// A Notification Service Extension that attaches the image, audio or video named in the push.
///
/// Create a Notification Service Extension target, add NotificationKit to it, and make its
/// principal class a subclass:
///
/// ```swift
/// import NotificationKit
///
/// final class NotificationService: MediaAttachmentService {}
/// ```
///
/// Send the push with `mutable-content: 1` and the file's URL under ``mediaURLKey``:
///
/// ```json
/// {"aps": {"alert": {"title": "New photo"}, "mutable-content": 1},
///  "media-url": "https://example.com/photo.jpg"}
/// ```
///
/// If the download fails or time runs out, the notification is shown without the attachment.
open class MediaAttachmentService: UNNotificationServiceExtension {
    /// The payload key that holds the media URL.
    open var mediaURLKey: String { "media-url" }

    /// The downloader used for the media. Override it to change limits or the session.
    open var downloader: AttachmentDownloader { AttachmentDownloader() }

    private let delivery = OneTimeDelivery()

    override open func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        let original = request.content
        delivery.prepare(fallback: original, handler: contentHandler)
        let key = mediaURLKey
        let downloader = downloader
        Task { [delivery] in
            let content = await Self.content(for: original, mediaURLKey: key, downloader: downloader)
            delivery.deliver(content)
        }
    }

    override open func serviceExtensionTimeWillExpire() {
        delivery.deliverFallback()
    }

    /// The content with the downloaded attachment, or the original content if there is no media
    /// URL or the download fails.
    public static func content(
        for content: UNNotificationContent,
        mediaURLKey: String = "media-url",
        downloader: AttachmentDownloader = AttachmentDownloader()
    ) async -> UNNotificationContent {
        #if os(watchOS)
        return content
        #else
        guard let text = content.userInfo[mediaURLKey] as? String,
              text.count <= DeepLinkRouter<Never>.maximumLinkLength,
              let url = URL(string: text),
              let mutable = content.mutableCopy() as? UNMutableNotificationContent,
              let downloaded = try? await downloader.download(url),
              let attachment = try? NotificationContentMapper.attachment(for: downloaded)
        else { return content }
        try? FileManager.default.removeItem(at: downloaded.url)
        mutable.attachments = [attachment]
        return mutable
        #endif
    }
}

/// Calls the content handler exactly once, whichever comes first: the download or the
/// system's timeout.
final class OneTimeDelivery: @unchecked Sendable {
    private let lock = NSLock()
    private var handler: ((UNNotificationContent) -> Void)?
    private var fallback: UNNotificationContent?

    func prepare(fallback: UNNotificationContent, handler: @escaping (UNNotificationContent) -> Void) {
        lock.withLock {
            self.fallback = fallback
            self.handler = handler
        }
    }

    func deliver(_ content: UNNotificationContent) {
        take()?(content)
    }

    func deliverFallback() {
        let fallback = lock.withLock { self.fallback }
        if let fallback { deliver(fallback) }
    }

    private func take() -> ((UNNotificationContent) -> Void)? {
        lock.withLock {
            defer { handler = nil }
            return handler
        }
    }
}
