import Foundation
@preconcurrency import UserNotifications

/// Receives notification events from the system and hands them to the app as values.
///
/// Create one when the app starts, keep it alive (the system holds its delegate weakly) and
/// call ``install(on:)`` before the app finishes launching, so a tap that launched the app is
/// not missed:
///
/// ```swift
/// @main
/// struct MyApp: App {
///     let events = NotificationEventHandler()
///     init() { events.install() }
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .task {
///                     for await response in events.responses { handle(response) }
///                 }
///         }
///     }
/// }
/// ```
public final class NotificationEventHandler: NSObject, UNUserNotificationCenterDelegate, Sendable {
    /// Decides how a notification is shown while the app is in the foreground.
    public typealias PresentationHandler = @Sendable (ReceivedNotification) async -> PresentationOptions

    /// Responses in the order the user gave them. The stream keeps the newest
    /// ``bufferSize`` responses that nobody has read yet and drops older ones, so it cannot
    /// grow without bound when the app does not listen.
    public let responses: AsyncStream<NotificationResponse>
    /// Notifications that arrived while the app was in the foreground, with the same buffering.
    public let presentations: AsyncStream<ReceivedNotification>
    public let bufferSize: Int

    private let responseContinuation: AsyncStream<NotificationResponse>.Continuation
    private let presentationContinuation: AsyncStream<ReceivedNotification>.Continuation
    private let presentation: PresentationHandler

    /// - Parameters:
    ///   - bufferSize: Unread events kept per stream, at least 1.
    ///   - presentation: Options for foreground notifications; shows them like background ones
    ///     by default.
    public init(bufferSize: Int = 32, presentation: @escaping PresentationHandler = { _ in .standard }) {
        let size = max(1, bufferSize)
        self.bufferSize = size
        (responses, responseContinuation) = AsyncStream.makeStream(of: NotificationResponse.self, bufferingPolicy: .bufferingNewest(size))
        (presentations, presentationContinuation) = AsyncStream.makeStream(of: ReceivedNotification.self, bufferingPolicy: .bufferingNewest(size))
        self.presentation = presentation
        super.init()
    }

    deinit {
        responseContinuation.finish()
        presentationContinuation.finish()
    }

    /// Makes this handler the delegate of `center`.
    public func install(on center: UNUserNotificationCenter = .current()) {
        center.delegate = self
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        let received = ReceivedNotification(notification)
        presentationContinuation.yield(received)
        return await presentation(received).unOptions
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        responseContinuation.yield(NotificationResponse(response))
    }
}

extension ReceivedNotification {
    init(_ notification: UNNotification) {
        let content = notification.request.content
        self.init(
            id: notification.request.identifier,
            title: content.title,
            subtitle: content.subtitle,
            body: content.body,
            categoryID: content.categoryIdentifier,
            threadID: content.threadIdentifier,
            userInfo: JSONValue.lenientObject(from: content.userInfo),
            date: notification.date,
            isRemote: notification.request.trigger is UNPushNotificationTrigger
        )
    }
}

extension NotificationResponse {
    init(_ response: UNNotificationResponse) {
        let action: Action = switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier: .open
        case UNNotificationDismissActionIdentifier: .dismiss
        default: .custom(response.actionIdentifier)
        }
        self.init(
            notification: ReceivedNotification(response.notification),
            action: action,
            textInput: (response as? UNTextInputNotificationResponse)?.userText
        )
    }
}

extension PresentationOptions {
    var unOptions: UNNotificationPresentationOptions {
        var options: UNNotificationPresentationOptions = []
        if contains(.banner) { options.insert(.banner) }
        if contains(.list) { options.insert(.list) }
        if contains(.sound) { options.insert(.sound) }
        if contains(.badge) { options.insert(.badge) }
        return options
    }
}
