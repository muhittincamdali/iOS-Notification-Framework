import Foundation
import UserNotifications

// MARK: - UNNotificationRequest Extensions

extension UNNotificationRequest {
    
    /// Creates a notification request from NotificationContent
    static func create(from content: NotificationContent, at date: Date) -> UNNotificationRequest {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = content.title
        notificationContent.body = content.body
        notificationContent.categoryIdentifier = content.category
        notificationContent.userInfo = content.userInfo ?? [:]
        
        // Set priority based on notification priority
        switch content.priority {
        case .low:
            notificationContent.interruptionLevel = .passive
        case .normal:
            notificationContent.interruptionLevel = .active
        case .high:
            notificationContent.interruptionLevel = .timeSensitive
        case .critical:
            notificationContent.interruptionLevel = .critical
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        return UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
    }
    
    /// Creates a notification request from RichNotificationContent
    static func create(from content: RichNotificationContent, at date: Date) -> UNNotificationRequest {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = content.title
        notificationContent.body = content.body
        notificationContent.categoryIdentifier = content.category
        notificationContent.userInfo = content.userInfo ?? [:]
        
        // Set priority based on notification priority
        switch content.priority {
        case .low:
            notificationContent.interruptionLevel = .passive
        case .normal:
            notificationContent.interruptionLevel = .active
        case .high:
            notificationContent.interruptionLevel = .timeSensitive
        case .critical:
            notificationContent.interruptionLevel = .critical
        }
        
        // Add media attachment if available
        if let mediaURL = content.mediaURL, let mediaType = content.mediaType {
            let attachment = UNNotificationAttachment(
                identifier: "media",
                url: URL(string: mediaURL)!,
                options: [UNNotificationAttachmentOptionsTypeHintKey: mediaType.rawValue]
            )
            notificationContent.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        return UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
    }
}

// MARK: - UNNotificationContent Extensions

extension UNNotificationContent {
    
    /// Extracts NotificationContent from UNNotificationContent
    var toNotificationContent: NotificationContent {
        return NotificationContent(
            title: title,
            body: body,
            category: categoryIdentifier,
            priority: priorityFromInterruptionLevel,
            userInfo: userInfo
        )
    }
    
    /// Gets priority from interruption level
    private var priorityFromInterruptionLevel: NotificationPriority {
        switch interruptionLevel {
        case .passive:
            return .low
        case .active:
            return .normal
        case .timeSensitive:
            return .high
        case .critical:
            return .critical
        @unknown default:
            return .normal
        }
    }
}

// MARK: - Date Extensions

extension Date {
    
    /// Creates a date from time components
    static func fromTimeComponents(_ components: DateComponents) -> Date? {
        return Calendar.current.date(from: components)
    }
    
    /// Adds time components to date
    func addingTimeComponents(_ components: DateComponents) -> Date? {
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    /// Gets time components from date
    var timeComponents: DateComponents {
        return Calendar.current.dateComponents([.hour, .minute, .second], from: self)
    }
    
    /// Checks if date is in quiet hours (10 PM - 8 AM)
    var isInQuietHours: Bool {
        let hour = Calendar.current.component(.hour, from: self)
        return hour >= 22 || hour <= 8
    }
    
    /// Gets next appropriate time (outside quiet hours)
    var nextAppropriateTime: Date {
        if isInQuietHours {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: self)
            components.hour = 9
            components.minute = 0
            components.second = 0
            return calendar.date(from: components) ?? self
        }
        return self
    }
}

// MARK: - String Extensions

extension String {
    
    /// Validates notification content
    var isValidNotificationContent: Bool {
        return !isEmpty && count <= 200
    }
    
    /// Sanitizes notification content
    var sanitizedNotificationContent: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\t", with: " ")
    }
    
    /// Checks if string contains inappropriate content
    var containsInappropriateContent: Bool {
        let inappropriateWords = ["spam", "scam", "urgent", "limited time", "act now"]
        let lowercased = self.lowercased()
        
        for word in inappropriateWords {
            if lowercased.contains(word) {
                return true
            }
        }
        
        return false
    }
}

// MARK: - Array Extensions

extension Array where Element == NotificationContent {
    
    /// Filters notifications by category
    func filterByCategory(_ category: String) -> [NotificationContent] {
        return filter { $0.category == category }
    }
    
    /// Filters notifications by priority
    func filterByPriority(_ priority: NotificationPriority) -> [NotificationContent] {
        return filter { $0.priority == priority }
    }
    
    /// Sorts notifications by priority
    func sortedByPriority() -> [NotificationContent] {
        return sorted { $0.priority.rawValue > $1.priority.rawValue }
    }
    
    /// Groups notifications by category
    func groupedByCategory() -> [String: [NotificationContent]] {
        return Dictionary(grouping: self) { $0.category }
    }
}

// MARK: - Dictionary Extensions

extension Dictionary where Key == String, Value == Any {
    
    /// Safely gets string value
    func getString(_ key: String) -> String? {
        return self[key] as? String
    }
    
    /// Safely gets int value
    func getInt(_ key: String) -> Int? {
        return self[key] as? Int
    }
    
    /// Safely gets double value
    func getDouble(_ key: String) -> Double? {
        return self[key] as? Double
    }
    
    /// Safely gets bool value
    func getBool(_ key: String) -> Bool? {
        return self[key] as? Bool
    }
    
    /// Safely gets date value
    func getDate(_ key: String) -> Date? {
        if let timeInterval = self[key] as? TimeInterval {
            return Date(timeIntervalSince1970: timeInterval)
        }
        return nil
    }
}

// MARK: - NotificationPriority Extensions

extension NotificationPriority {
    
    /// Gets authorization options for priority
    var authorizationOptions: UNAuthorizationOptions {
        switch self {
        case .low:
            return [.alert, .sound]
        case .normal:
            return [.alert, .sound, .badge]
        case .high:
            return [.alert, .sound, .badge]
        case .critical:
            return [.alert, .sound, .badge, .provisional]
        }
    }
    
    /// Gets interruption level for priority
    var interruptionLevel: UNNotificationInterruptionLevel {
        switch self {
        case .low:
            return .passive
        case .normal:
            return .active
        case .high:
            return .timeSensitive
        case .critical:
            return .critical
        }
    }
}

// MARK: - MediaType Extensions

extension MediaType {
    
    /// Gets file extension for media type
    var fileExtension: String {
        switch self {
        case .image:
            return "jpg"
        case .video:
            return "mp4"
        case .audio:
            return "m4a"
        case .gif:
            return "gif"
        }
    }
    
    /// Gets MIME type for media type
    var mimeType: String {
        switch self {
        case .image:
            return "image/jpeg"
        case .video:
            return "video/mp4"
        case .audio:
            return "audio/m4a"
        case .gif:
            return "image/gif"
        }
    }
    
    /// Gets UNNotificationAttachmentOptions for media type
    var attachmentOptions: [String: Any] {
        return [UNNotificationAttachmentOptionsTypeHintKey: self.rawValue]
    }
}

// MARK: - RecurringInterval Extensions

extension RecurringInterval {
    
    /// Gets interval duration in seconds
    var seconds: TimeInterval {
        switch self {
        case .minute:
            return 60
        case .hourly:
            return 3600
        case .daily:
            return 86400
        case .weekly:
            return 604800
        case .monthly:
            return 2592000
        case .yearly:
            return 31536000
        case .custom:
            return 0 // Custom intervals are handled separately
        }
    }
    
    /// Gets calendar component for interval
    var calendarComponent: Calendar.Component? {
        switch self {
        case .minute:
            return .minute
        case .hourly:
            return .hour
        case .daily:
            return .day
        case .weekly:
            return .weekOfYear
        case .monthly:
            return .month
        case .yearly:
            return .year
        case .custom:
            return nil
        }
    }
}

// MARK: - NotificationAnalytics Extensions

extension NotificationAnalytics {
    
    /// Gets performance score (0-100)
    var performanceScore: Int {
        let deliveryScore = Int(deliveryRate * 40) // 40% weight
        let responseScore = Int(responseRate * 40) // 40% weight
        let errorScore = max(0, 20 - Int(Double(errorCount) * 2)) // 20% weight
        
        return min(100, deliveryScore + responseScore + errorScore)
    }
    
    /// Gets performance level
    var performanceLevel: String {
        let score = performanceScore
        
        switch score {
        case 90...100:
            return "Excellent"
        case 80..<90:
            return "Good"
        case 70..<80:
            return "Fair"
        case 60..<70:
            return "Poor"
        default:
            return "Very Poor"
        }
    }
    
    /// Checks if analytics indicate good performance
    var isPerformingWell: Bool {
        return deliveryRate >= 0.8 && responseRate >= 0.1 && errorCount < 5
    }
}

// MARK: - NotificationError Extensions

extension NotificationError {
    
    /// Checks if error is recoverable
    var isRecoverable: Bool {
        switch self {
        case .permissionDenied, .contentInvalid, .actionInvalid:
            return false
        case .schedulingFailed, .notificationNotFound, .analyticsError, .systemError, .networkError, .securityError:
            return true
        }
    }
    
    /// Gets error category
    var category: String {
        switch self {
        case .permissionDenied:
            return "Permission"
        case .schedulingFailed, .notificationNotFound:
            return "Scheduling"
        case .contentInvalid, .actionInvalid:
            return "Content"
        case .analyticsError:
            return "Analytics"
        case .systemError, .networkError, .securityError:
            return "System"
        }
    }
    
    /// Gets suggested recovery action
    var recoverySuggestion: String {
        switch self {
        case .permissionDenied:
            return "Request notification permissions from user"
        case .schedulingFailed:
            return "Check notification center availability and retry"
        case .notificationNotFound:
            return "Verify notification identifier exists"
        case .contentInvalid:
            return "Validate notification content before scheduling"
        case .actionInvalid:
            return "Ensure action handlers are properly registered"
        case .analyticsError:
            return "Check analytics service availability"
        case .systemError:
            return "Retry operation after system restart"
        case .networkError:
            return "Check network connectivity and retry"
        case .securityError:
            return "Verify authentication and permissions"
        }
    }
} 