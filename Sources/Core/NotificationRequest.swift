import Foundation
import UserNotifications

/// Comprehensive notification request model with advanced configuration options
@available(iOS 15.0, *)
public struct NotificationRequest {
    
    // MARK: - Properties
    public let identifier: String
    public let title: String
    public let body: String
    public let subtitle: String?
    public let sound: UNNotificationSound?
    public let badge: NSNumber?
    public let categoryIdentifier: String?
    public let userInfo: [AnyHashable: Any]
    public let trigger: NotificationTrigger
    public let imageURL: URL?
    public let deepLink: String?
    public let priority: NotificationPriority
    public let expirationDate: Date?
    public let customData: [String: Any]
    
    // MARK: - Initialization
    public init(
        identifier: String,
        title: String,
        body: String,
        subtitle: String? = nil,
        sound: UNNotificationSound? = nil,
        badge: NSNumber? = nil,
        categoryIdentifier: String? = nil,
        userInfo: [AnyHashable: Any] = [:],
        trigger: NotificationTrigger = .immediate,
        imageURL: URL? = nil,
        deepLink: String? = nil,
        priority: NotificationPriority = .normal,
        expirationDate: Date? = nil,
        customData: [String: Any] = [:]
    ) {
        self.identifier = identifier
        self.title = title
        self.body = body
        self.subtitle = subtitle
        self.sound = sound
        self.badge = badge
        self.categoryIdentifier = categoryIdentifier
        self.userInfo = userInfo
        self.trigger = trigger
        self.imageURL = imageURL
        self.deepLink = deepLink
        self.priority = priority
        self.expirationDate = expirationDate
        self.customData = customData
    }
    
    // MARK: - Builder Pattern
    public static func builder() -> NotificationRequestBuilder {
        return NotificationRequestBuilder()
    }
}

// MARK: - Notification Trigger
@available(iOS 15.0, *)
public enum NotificationTrigger {
    case immediate
    case timeInterval(TimeInterval)
    case calendar(DateComponents)
    case location(CLCircularRegion)
}

// MARK: - Notification Priority
@available(iOS 15.0, *)
public enum NotificationPriority: Int {
    case low = 0
    case normal = 1
    case high = 2
    case critical = 3
    
    public var userNotificationPriority: UNNotificationPriority {
        switch self {
        case .low:
            return .low
        case .normal:
            return .normal
        case .high:
            return .high
        case .critical:
            return .critical
        }
    }
}

// MARK: - Builder Pattern
@available(iOS 15.0, *)
public class NotificationRequestBuilder {
    private var identifier: String = UUID().uuidString
    private var title: String = ""
    private var body: String = ""
    private var subtitle: String?
    private var sound: UNNotificationSound?
    private var badge: NSNumber?
    private var categoryIdentifier: String?
    private var userInfo: [AnyHashable: Any] = [:]
    private var trigger: NotificationTrigger = .immediate
    private var imageURL: URL?
    private var deepLink: String?
    private var priority: NotificationPriority = .normal
    private var expirationDate: Date?
    private var customData: [String: Any] = [:]
    
    public func identifier(_ identifier: String) -> NotificationRequestBuilder {
        self.identifier = identifier
        return self
    }
    
    public func title(_ title: String) -> NotificationRequestBuilder {
        self.title = title
        return self
    }
    
    public func body(_ body: String) -> NotificationRequestBuilder {
        self.body = body
        return self
    }
    
    public func subtitle(_ subtitle: String?) -> NotificationRequestBuilder {
        self.subtitle = subtitle
        return self
    }
    
    public func sound(_ sound: UNNotificationSound?) -> NotificationRequestBuilder {
        self.sound = sound
        return self
    }
    
    public func badge(_ badge: NSNumber?) -> NotificationRequestBuilder {
        self.badge = badge
        return self
    }
    
    public func categoryIdentifier(_ categoryIdentifier: String?) -> NotificationRequestBuilder {
        self.categoryIdentifier = categoryIdentifier
        return self
    }
    
    public func userInfo(_ userInfo: [AnyHashable: Any]) -> NotificationRequestBuilder {
        self.userInfo = userInfo
        return self
    }
    
    public func trigger(_ trigger: NotificationTrigger) -> NotificationRequestBuilder {
        self.trigger = trigger
        return self
    }
    
    public func imageURL(_ imageURL: URL?) -> NotificationRequestBuilder {
        self.imageURL = imageURL
        return self
    }
    
    public func deepLink(_ deepLink: String?) -> NotificationRequestBuilder {
        self.deepLink = deepLink
        return self
    }
    
    public func priority(_ priority: NotificationPriority) -> NotificationRequestBuilder {
        self.priority = priority
        return self
    }
    
    public func expirationDate(_ expirationDate: Date?) -> NotificationRequestBuilder {
        self.expirationDate = expirationDate
        return self
    }
    
    public func customData(_ customData: [String: Any]) -> NotificationRequestBuilder {
        self.customData = customData
        return self
    }
    
    public func build() -> NotificationRequest {
        return NotificationRequest(
            identifier: identifier,
            title: title,
            body: body,
            subtitle: subtitle,
            sound: sound,
            badge: badge,
            categoryIdentifier: categoryIdentifier,
            userInfo: userInfo,
            trigger: trigger,
            imageURL: imageURL,
            deepLink: deepLink,
            priority: priority,
            expirationDate: expirationDate,
            customData: customData
        )
    }
}

// MARK: - Convenience Initializers
@available(iOS 15.0, *)
public extension NotificationRequest {
    
    /// Create a simple notification request
    static func simple(
        title: String,
        body: String,
        identifier: String = UUID().uuidString
    ) -> NotificationRequest {
        return NotificationRequest(
            identifier: identifier,
            title: title,
            body: body
        )
    }
    
    /// Create a notification request with time interval
    static func scheduled(
        title: String,
        body: String,
        timeInterval: TimeInterval,
        identifier: String = UUID().uuidString
    ) -> NotificationRequest {
        return NotificationRequest(
            identifier: identifier,
            title: title,
            body: body,
            trigger: .timeInterval(timeInterval)
        )
    }
    
    /// Create a notification request with calendar date
    static func scheduled(
        title: String,
        body: String,
        date: Date,
        identifier: String = UUID().uuidString
    ) -> NotificationRequest {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return NotificationRequest(
            identifier: identifier,
            title: title,
            body: body,
            trigger: .calendar(components)
        )
    }
    
    /// Create a rich notification with image
    static func rich(
        title: String,
        body: String,
        imageURL: URL,
        identifier: String = UUID().uuidString
    ) -> NotificationRequest {
        return NotificationRequest(
            identifier: identifier,
            title: title,
            body: body,
            imageURL: imageURL
        )
    }
    
    /// Create a notification with deep link
    static func withDeepLink(
        title: String,
        body: String,
        deepLink: String,
        identifier: String = UUID().uuidString
    ) -> NotificationRequest {
        return NotificationRequest(
            identifier: identifier,
            title: title,
            body: body,
            deepLink: deepLink
        )
    }
}

// MARK: - Validation
@available(iOS 15.0, *)
public extension NotificationRequest {
    
    var isValid: Bool {
        return !identifier.isEmpty && !title.isEmpty && !body.isEmpty
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if identifier.isEmpty {
            errors.append("Identifier cannot be empty")
        }
        
        if title.isEmpty {
            errors.append("Title cannot be empty")
        }
        
        if body.isEmpty {
            errors.append("Body cannot be empty")
        }
        
        if let expirationDate = expirationDate, expirationDate < Date() {
            errors.append("Expiration date cannot be in the past")
        }
        
        return errors
    }
} 