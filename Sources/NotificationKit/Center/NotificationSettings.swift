import Foundation

/// What the app asks permission for.
public struct AuthorizationOptions: OptionSet, Sendable, Hashable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let alert = AuthorizationOptions(rawValue: 1 << 0)
    public static let sound = AuthorizationOptions(rawValue: 1 << 1)
    public static let badge = AuthorizationOptions(rawValue: 1 << 2)
    /// Deliver quietly to the notification list without asking first. The user decides later,
    /// from the notification itself, whether to keep them.
    public static let provisional = AuthorizationOptions(rawValue: 1 << 3)
    /// Critical alerts. Needs an entitlement that Apple grants on request.
    public static let criticalAlert = AuthorizationOptions(rawValue: 1 << 4)
    /// Adds a link to the app's own notification settings in the system's Settings app.
    public static let providesAppNotificationSettings = AuthorizationOptions(rawValue: 1 << 5)

    /// Alerts, sounds and badges: what most apps ask for.
    public static let standard: AuthorizationOptions = [.alert, .sound, .badge]
}

/// Whether the user allows the app to post notifications.
public enum AuthorizationStatus: String, Sendable, Hashable, Codable {
    /// The app has not asked yet.
    case notDetermined
    /// The user turned notifications off.
    case denied
    /// The user allowed notifications.
    case authorized
    /// Notifications are delivered quietly until the user decides.
    case provisional
    /// Allowed for a limited time (App Clips).
    case ephemeral

    /// Whether the app can schedule notifications that the user will see.
    public var allowsDelivery: Bool {
        switch self {
        case .authorized, .provisional, .ephemeral: true
        case .notDetermined, .denied: false
        }
    }
}

/// A snapshot of the user's notification settings for the app.
public struct NotificationSettings: Sendable, Hashable {
    public var authorizationStatus: AuthorizationStatus
    public var alertsEnabled: Bool
    public var soundsEnabled: Bool
    public var badgesEnabled: Bool
    public var timeSensitiveEnabled: Bool
    public var criticalAlertsEnabled: Bool

    public init(
        authorizationStatus: AuthorizationStatus,
        alertsEnabled: Bool = false,
        soundsEnabled: Bool = false,
        badgesEnabled: Bool = false,
        timeSensitiveEnabled: Bool = false,
        criticalAlertsEnabled: Bool = false
    ) {
        self.authorizationStatus = authorizationStatus
        self.alertsEnabled = alertsEnabled
        self.soundsEnabled = soundsEnabled
        self.badgesEnabled = badgesEnabled
        self.timeSensitiveEnabled = timeSensitiveEnabled
        self.criticalAlertsEnabled = criticalAlertsEnabled
    }
}
