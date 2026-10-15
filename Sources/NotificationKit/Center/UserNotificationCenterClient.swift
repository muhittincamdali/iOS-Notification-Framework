import Foundation
@preconcurrency import UserNotifications

/// ``NotificationCenterClient`` backed by `UNUserNotificationCenter.current()`.
///
/// The center is looked up on each call, so creating the client is free and safe in processes
/// without an app bundle (such as `swift test`), as long as none of its methods run there.
public struct UserNotificationCenterClient: NotificationCenterClient {
    private let calendar: Calendar

    /// - Parameter calendar: Converts one-time ``NotificationTrigger/date(_:)`` triggers into
    ///   the date components the system expects. Its time zone is kept, so the notification
    ///   fires at the same moment even if the user travels.
    public init(calendar: Calendar = .autoupdatingCurrent) {
        self.calendar = calendar
    }

    private var center: UNUserNotificationCenter { .current() }

    public func requestAuthorization(options: AuthorizationOptions) async throws -> Bool {
        try await center.requestAuthorization(options: options.unOptions)
    }

    public func settings() async -> NotificationSettings {
        let settings = await center.notificationSettings()
        return NotificationSettings(
            authorizationStatus: AuthorizationStatus(settings.authorizationStatus),
            alertsEnabled: settings.alertSetting == .enabled,
            soundsEnabled: settings.soundSetting == .enabled,
            badgesEnabled: Self.badgesEnabled(settings),
            timeSensitiveEnabled: settings.timeSensitiveSetting == .enabled,
            criticalAlertsEnabled: settings.criticalAlertSetting == .enabled
        )
    }

    public func add(_ notification: LocalNotification) async throws {
        try notification.validate(calendar: calendar)
        let request = try UNNotificationRequest(
            identifier: notification.id,
            content: NotificationContentMapper.content(for: notification),
            trigger: NotificationContentMapper.trigger(for: notification.trigger, calendar: calendar)
        )
        try await center.add(request)
    }

    public func pendingNotificationIDs() async -> [String] {
        await center.pendingNotificationRequests().map(\.identifier)
    }

    public func deliveredNotificationIDs() async -> [String] {
        #if os(tvOS)
        return []
        #else
        return await center.deliveredNotifications().map(\.request.identifier)
        #endif
    }

    public func removePendingNotifications(withIDs ids: [String]) async {
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }

    public func removeDeliveredNotifications(withIDs ids: [String]) async {
        center.removeDeliveredNotifications(withIdentifiers: ids)
    }

    public func setCategories(_ categories: [NotificationCategory]) async {
        center.setNotificationCategories(Set(categories.map(NotificationContentMapper.category(for:))))
    }

    /// Sets the number on the app icon. watchOS apps have no icon badge, so there it does nothing.
    public func setBadgeCount(_ count: Int) async throws {
        guard count >= 0 else { throw NotificationValidationError.negativeBadge(count) }
        #if !os(watchOS)
        try await center.setBadgeCount(count)
        #endif
    }

    private static func badgesEnabled(_ settings: UNNotificationSettings) -> Bool {
        #if os(watchOS)
        false
        #else
        settings.badgeSetting == .enabled
        #endif
    }
}

extension AuthorizationOptions {
    var unOptions: UNAuthorizationOptions {
        var options: UNAuthorizationOptions = []
        if contains(.alert) { options.insert(.alert) }
        if contains(.sound) { options.insert(.sound) }
        if contains(.badge) { options.insert(.badge) }
        if contains(.provisional) { options.insert(.provisional) }
        if contains(.criticalAlert) { options.insert(.criticalAlert) }
        if contains(.providesAppNotificationSettings) { options.insert(.providesAppNotificationSettings) }
        return options
    }
}

extension AuthorizationStatus {
    init(_ status: UNAuthorizationStatus) {
        switch status {
        case .denied: self = .denied
        case .authorized: self = .authorized
        case .provisional: self = .provisional
        #if os(iOS) || os(visionOS)
        case .ephemeral: self = .ephemeral
        #endif
        default: self = .notDetermined
        }
    }
}

extension InterruptionLevel {
    var unLevel: UNNotificationInterruptionLevel {
        switch self {
        case .passive: .passive
        case .active: .active
        case .timeSensitive: .timeSensitive
        case .critical: .critical
        }
    }
}
