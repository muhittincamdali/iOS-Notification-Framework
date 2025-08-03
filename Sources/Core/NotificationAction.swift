import Foundation
import UserNotifications

/// Custom notification action model for interactive notifications
@available(iOS 15.0, *)
public struct NotificationAction {
    
    // MARK: - Properties
    public let identifier: String
    public let title: String
    public let options: UNNotificationActionOptions
    public let handler: ((UNNotificationResponse) -> Void)?
    
    // MARK: - Initialization
    public init(
        identifier: String,
        title: String,
        options: UNNotificationActionOptions = [],
        handler: ((UNNotificationResponse) -> Void)? = nil
    ) {
        self.identifier = identifier
        self.title = title
        self.options = options
        self.handler = handler
    }
    
    // MARK: - Convenience Initializers
    public static func reply(
        identifier: String = "reply",
        title: String = "Reply",
        handler: ((UNNotificationResponse) -> Void)? = nil
    ) -> NotificationAction {
        return NotificationAction(
            identifier: identifier,
            title: title,
            options: [.foreground],
            handler: handler
        )
    }
    
    public static func like(
        identifier: String = "like",
        title: String = "Like",
        handler: ((UNNotificationResponse) -> Void)? = nil
    ) -> NotificationAction {
        return NotificationAction(
            identifier: identifier,
            title: title,
            options: [.foreground],
            handler: handler
        )
    }
    
    public static func share(
        identifier: String = "share",
        title: String = "Share",
        handler: ((UNNotificationResponse) -> Void)? = nil
    ) -> NotificationAction {
        return NotificationAction(
            identifier: identifier,
            title: title,
            options: [.foreground],
            handler: handler
        )
    }
    
    public static func dismiss(
        identifier: String = "dismiss",
        title: String = "Dismiss",
        handler: ((UNNotificationResponse) -> Void)? = nil
    ) -> NotificationAction {
        return NotificationAction(
            identifier: identifier,
            title: title,
            options: [.destructive],
            handler: handler
        )
    }
    
    public static func snooze(
        identifier: String = "snooze",
        title: String = "Snooze",
        handler: ((UNNotificationResponse) -> Void)? = nil
    ) -> NotificationAction {
        return NotificationAction(
            identifier: identifier,
            title: title,
            options: [],
            handler: handler
        )
    }
    
    public static func view(
        identifier: String = "view",
        title: String = "View",
        handler: ((UNNotificationResponse) -> Void)? = nil
    ) -> NotificationAction {
        return NotificationAction(
            identifier: identifier,
            title: title,
            options: [.foreground],
            handler: handler
        )
    }
    
    public static func accept(
        identifier: String = "accept",
        title: String = "Accept",
        handler: ((UNNotificationResponse) -> Void)? = nil
    ) -> NotificationAction {
        return NotificationAction(
            identifier: identifier,
            title: title,
            options: [.foreground],
            handler: handler
        )
    }
    
    public static func decline(
        identifier: String = "decline",
        title: String = "Decline",
        handler: ((UNNotificationResponse) -> Void)? = nil
    ) -> NotificationAction {
        return NotificationAction(
            identifier: identifier,
            title: title,
            options: [.destructive],
            handler: handler
        )
    }
}

// MARK: - Action Categories
@available(iOS 15.0, *)
public extension NotificationAction {
    
    /// Predefined action categories for common use cases
    static let categories: [String: [NotificationAction]] = [
        "message": [
            .reply(),
            .like(),
            .share(),
            .dismiss()
        ],
        "reminder": [
            .snooze(),
            .view(),
            .dismiss()
        ],
        "invitation": [
            .accept(),
            .decline(),
            .view()
        ],
        "alert": [
            .view(),
            .dismiss()
        ]
    ]
    
    /// Get actions for a specific category
    static func actions(for category: String) -> [NotificationAction] {
        return categories[category] ?? []
    }
}

// MARK: - Action Builder
@available(iOS 15.0, *)
public class NotificationActionBuilder {
    private var identifier: String = UUID().uuidString
    private var title: String = ""
    private var options: UNNotificationActionOptions = []
    private var handler: ((UNNotificationResponse) -> Void)?
    
    public func identifier(_ identifier: String) -> NotificationActionBuilder {
        self.identifier = identifier
        return self
    }
    
    public func title(_ title: String) -> NotificationActionBuilder {
        self.title = title
        return self
    }
    
    public func options(_ options: UNNotificationActionOptions) -> NotificationActionBuilder {
        self.options = options
        return self
    }
    
    public func handler(_ handler: @escaping (UNNotificationResponse) -> Void) -> NotificationActionBuilder {
        self.handler = handler
        return self
    }
    
    public func build() -> NotificationAction {
        return NotificationAction(
            identifier: identifier,
            title: title,
            options: options,
            handler: handler
        )
    }
} 