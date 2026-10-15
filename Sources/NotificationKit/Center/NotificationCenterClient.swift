import Foundation

/// The operations NotificationKit needs from the system's notification center.
///
/// ``UserNotificationCenterClient`` talks to `UNUserNotificationCenter`;
/// ``InMemoryNotificationCenter`` keeps everything in memory for unit tests and SwiftUI
/// previews. Give either one to ``NotificationScheduler``.
public protocol NotificationCenterClient: Sendable {
    /// Asks the user for permission. Returns whether alerts, sounds or badges were allowed.
    func requestAuthorization(options: AuthorizationOptions) async throws -> Bool
    /// The current notification settings.
    func settings() async -> NotificationSettings
    /// Adds a notification request. A request with the same identifier is replaced.
    func add(_ notification: LocalNotification) async throws
    /// Identifiers of the requests that have not been delivered yet.
    func pendingNotificationIDs() async -> [String]
    /// Identifiers of the notifications shown in Notification Center.
    func deliveredNotificationIDs() async -> [String]
    func removePendingNotifications(withIDs ids: [String]) async
    func removeDeliveredNotifications(withIDs ids: [String]) async
    /// Replaces the registered categories.
    func setCategories(_ categories: [NotificationCategory]) async
    /// Sets the number on the app icon; 0 clears it.
    func setBadgeCount(_ count: Int) async throws
}
