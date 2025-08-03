//
//  NotificationContent.swift
//  NotificationFramework
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// Represents the content of a notification.
///
/// This struct encapsulates all the information needed to create a notification,
/// including the title, body, sound, and other properties.
///
/// ## Example Usage
/// ```swift
/// let content = NotificationContent(
///     title: "Welcome!",
///     body: "Thank you for using our app",
///     category: "welcome",
///     sound: .default,
///     badge: 1
/// )
/// ```
@available(iOS 15.0, *)
public struct NotificationContent {
    
    // MARK: - Properties
    
    /// The title of the notification.
    public let title: String
    
    /// The body text of the notification.
    public let body: String
    
    /// The category identifier for the notification.
    public let category: String
    
    /// The sound to play when the notification is delivered.
    public let sound: UNNotificationSound?
    
    /// The badge number to display on the app icon.
    public let badge: NSNumber?
    
    /// Additional user info to attach to the notification.
    public let userInfo: [AnyHashable: Any]
    
    /// The thread identifier for grouping notifications.
    public let threadIdentifier: String?
    
    /// The target content identifier for the notification.
    public let targetContentIdentifier: String?
    
    /// The interruption level for the notification.
    public let interruptionLevel: UNNotificationInterruptionLevel
    
    /// The relevance score for the notification.
    public let relevanceScore: Double
    
    /// Custom actions for the notification.
    public let actions: [NotificationAction]
    
    /// The notification's priority level.
    public let priority: NotificationPriority
    
    /// Whether the notification should be delivered silently.
    public let isSilent: Bool
    
    // MARK: - Initialization
    
    /// Creates a new notification content instance.
    ///
    /// - Parameters:
    ///   - title: The title of the notification.
    ///   - body: The body text of the notification.
    ///   - category: The category identifier for the notification.
    ///   - sound: The sound to play when the notification is delivered.
    ///   - badge: The badge number to display on the app icon.
    ///   - userInfo: Additional user info to attach to the notification.
    ///   - threadIdentifier: The thread identifier for grouping notifications.
    ///   - targetContentIdentifier: The target content identifier for the notification.
    ///   - interruptionLevel: The interruption level for the notification.
    ///   - relevanceScore: The relevance score for the notification.
    ///   - actions: Custom actions for the notification.
    ///   - priority: The notification's priority level.
    ///   - isSilent: Whether the notification should be delivered silently.
    public init(
        title: String,
        body: String,
        category: String = "default",
        sound: UNNotificationSound? = .default,
        badge: NSNumber? = nil,
        userInfo: [AnyHashable: Any] = [:],
        threadIdentifier: String? = nil,
        targetContentIdentifier: String? = nil,
        interruptionLevel: UNNotificationInterruptionLevel = .active,
        relevanceScore: Double = 0.5,
        actions: [NotificationAction] = [],
        priority: NotificationPriority = .normal,
        isSilent: Bool = false
    ) {
        self.title = title
        self.body = body
        self.category = category
        self.sound = sound
        self.badge = badge
        self.userInfo = userInfo
        self.threadIdentifier = threadIdentifier
        self.targetContentIdentifier = targetContentIdentifier
        self.interruptionLevel = interruptionLevel
        self.relevanceScore = relevanceScore
        self.actions = actions
        self.priority = priority
        self.isSilent = isSilent
    }
}

/// Represents rich media notification content with attachments.
///
/// This struct extends `NotificationContent` with support for rich media
/// attachments such as images, videos, and audio files.
///
/// ## Example Usage
/// ```swift
/// let richContent = RichNotificationContent(
///     title: "New Product Available",
///     body: "Check out our latest collection",
///     mediaURL: "https://example.com/image.jpg",
///     actions: [
///         NotificationAction(title: "View", identifier: "view_action"),
///         NotificationAction(title: "Share", identifier: "share_action")
///     ]
/// )
/// ```
@available(iOS 15.0, *)
public struct RichNotificationContent {
    
    // MARK: - Properties
    
    /// The base notification content.
    public let content: NotificationContent
    
    /// The URL of the media attachment.
    public let mediaURL: URL?
    
    /// The type of media attachment.
    public let mediaType: MediaType
    
    /// The thumbnail image data.
    public let thumbnailData: Data?
    
    /// The duration of the media (for audio/video).
    public let duration: TimeInterval?
    
    /// The subtitle for the notification.
    public let subtitle: String?
    
    /// The summary argument for the notification.
    public let summaryArgument: String?
    
    /// The summary argument count for the notification.
    public let summaryArgumentCount: Int?
    
    // MARK: - Initialization
    
    /// Creates a new rich notification content instance.
    ///
    /// - Parameters:
    ///   - content: The base notification content.
    ///   - mediaURL: The URL of the media attachment.
    ///   - mediaType: The type of media attachment.
    ///   - thumbnailData: The thumbnail image data.
    ///   - duration: The duration of the media (for audio/video).
    ///   - subtitle: The subtitle for the notification.
    ///   - summaryArgument: The summary argument for the notification.
    ///   - summaryArgumentCount: The summary argument count for the notification.
    public init(
        content: NotificationContent,
        mediaURL: URL? = nil,
        mediaType: MediaType = .image,
        thumbnailData: Data? = nil,
        duration: TimeInterval? = nil,
        subtitle: String? = nil,
        summaryArgument: String? = nil,
        summaryArgumentCount: Int? = nil
    ) {
        self.content = content
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.thumbnailData = thumbnailData
        self.duration = duration
        self.subtitle = subtitle
        self.summaryArgument = summaryArgument
        self.summaryArgumentCount = summaryArgumentCount
    }
    
    /// Creates a new rich notification content instance with basic parameters.
    ///
    /// - Parameters:
    ///   - title: The title of the notification.
    ///   - body: The body text of the notification.
    ///   - mediaURL: The URL of the media attachment.
    ///   - actions: Custom actions for the notification.
    public init(
        title: String,
        body: String,
        mediaURL: URL? = nil,
        actions: [NotificationAction] = []
    ) {
        let content = NotificationContent(
            title: title,
            body: body,
            actions: actions
        )
        
        self.init(content: content, mediaURL: mediaURL)
    }
}

/// Represents a custom action for a notification.
///
/// This struct defines a custom action that can be performed when a user
/// interacts with a notification.
///
/// ## Example Usage
/// ```swift
/// let action = NotificationAction(
///     title: "View Details",
///     identifier: "view_details",
///     options: [.foreground]
/// )
/// ```
@available(iOS 15.0, *)
public struct NotificationAction {
    
    // MARK: - Properties
    
    /// The title of the action.
    public let title: String
    
    /// The identifier of the action.
    public let identifier: String
    
    /// The options for the action.
    public let options: UNNotificationActionOptions
    
    /// The icon for the action (iOS 15.0+).
    public let icon: UNNotificationActionIcon?
    
    /// The text input button title for text input actions.
    public let textInputButtonTitle: String?
    
    /// The text input placeholder for text input actions.
    public let textInputPlaceholder: String?
    
    // MARK: - Initialization
    
    /// Creates a new notification action instance.
    ///
    /// - Parameters:
    ///   - title: The title of the action.
    ///   - identifier: The identifier of the action.
    ///   - options: The options for the action.
    ///   - icon: The icon for the action (iOS 15.0+).
    ///   - textInputButtonTitle: The text input button title for text input actions.
    ///   - textInputPlaceholder: The text input placeholder for text input actions.
    public init(
        title: String,
        identifier: String,
        options: UNNotificationActionOptions = [],
        icon: UNNotificationActionIcon? = nil,
        textInputButtonTitle: String? = nil,
        textInputPlaceholder: String? = nil
    ) {
        self.title = title
        self.identifier = identifier
        self.options = options
        self.icon = icon
        self.textInputButtonTitle = textInputButtonTitle
        self.textInputPlaceholder = textInputPlaceholder
    }
}

/// Represents the priority level of a notification.
///
/// This enum defines different priority levels that can be assigned to notifications
/// to control their delivery and presentation.
@available(iOS 15.0, *)
public enum NotificationPriority: Int, CaseIterable {
    
    /// Low priority notification.
    case low = 0
    
    /// Normal priority notification.
    case normal = 1
    
    /// High priority notification.
    case high = 2
    
    /// Critical priority notification.
    case critical = 3
    
    /// The display name for the priority level.
    public var displayName: String {
        switch self {
        case .low:
            return "Low"
        case .normal:
            return "Normal"
        case .high:
            return "High"
        case .critical:
            return "Critical"
        }
    }
    
    /// The UNAuthorizationOptions corresponding to this priority level.
    public var authorizationOptions: UNAuthorizationOptions {
        switch self {
        case .low:
            return [.alert, .sound]
        case .normal:
            return [.alert, .sound, .badge]
        case .high:
            return [.alert, .sound, .badge, .provisional]
        case .critical:
            return [.alert, .sound, .badge, .provisional, .criticalAlert]
        }
    }
}

/// Represents the type of media attachment.
///
/// This enum defines different types of media that can be attached to notifications.
@available(iOS 15.0, *)
public enum MediaType: String, CaseIterable {
    
    /// Image media type.
    case image = "image"
    
    /// Video media type.
    case video = "video"
    
    /// Audio media type.
    case audio = "audio"
    
    /// GIF media type.
    case gif = "gif"
    
    /// The file extension for this media type.
    public var fileExtension: String {
        switch self {
        case .image:
            return "jpg"
        case .video:
            return "mp4"
        case .audio:
            return "mp3"
        case .gif:
            return "gif"
        }
    }
    
    /// The MIME type for this media type.
    public var mimeType: String {
        switch self {
        case .image:
            return "image/jpeg"
        case .video:
            return "video/mp4"
        case .audio:
            return "audio/mpeg"
        case .gif:
            return "image/gif"
        }
    }
}

/// Represents a recurring schedule for notifications.
///
/// This struct defines how notifications should be repeated over time.
///
/// ## Example Usage
/// ```swift
/// let schedule = RecurringSchedule(
///     interval: .daily,
///     startDate: Date(),
///     endDate: Date().addingTimeInterval(86400 * 7), // 7 days
///     timeComponents: DateComponents(hour: 9, minute: 0) // 9:00 AM
/// )
/// ```
@available(iOS 15.0, *)
public struct RecurringSchedule {
    
    // MARK: - Properties
    
    /// The interval at which the notification should repeat.
    public let interval: RecurringInterval
    
    /// The start date for the recurring schedule.
    public let startDate: Date
    
    /// The end date for the recurring schedule (optional).
    public let endDate: Date?
    
    /// The time components for when the notification should be delivered.
    public let timeComponents: DateComponents
    
    /// The maximum number of notifications to schedule.
    public let maxNotifications: Int?
    
    /// Whether the schedule should repeat indefinitely.
    public let repeatsIndefinitely: Bool
    
    // MARK: - Initialization
    
    /// Creates a new recurring schedule instance.
    ///
    /// - Parameters:
    ///   - interval: The interval at which the notification should repeat.
    ///   - startDate: The start date for the recurring schedule.
    ///   - endDate: The end date for the recurring schedule (optional).
    ///   - timeComponents: The time components for when the notification should be delivered.
    ///   - maxNotifications: The maximum number of notifications to schedule.
    ///   - repeatsIndefinitely: Whether the schedule should repeat indefinitely.
    public init(
        interval: RecurringInterval,
        startDate: Date,
        endDate: Date? = nil,
        timeComponents: DateComponents,
        maxNotifications: Int? = nil,
        repeatsIndefinitely: Bool = false
    ) {
        self.interval = interval
        self.startDate = startDate
        self.endDate = endDate
        self.timeComponents = timeComponents
        self.maxNotifications = maxNotifications
        self.repeatsIndefinitely = repeatsIndefinitely
    }
}

/// Represents the interval for recurring notifications.
///
/// This enum defines different intervals at which notifications can be repeated.
@available(iOS 15.0, *)
public enum RecurringInterval: Int, CaseIterable {
    
    /// Repeat every minute.
    case minute = 60
    
    /// Repeat every hour.
    case hour = 3600
    
    /// Repeat daily.
    case daily = 86400
    
    /// Repeat weekly.
    case weekly = 604800
    
    /// Repeat monthly.
    case monthly = 2592000
    
    /// Repeat yearly.
    case yearly = 31536000
    
    /// The display name for the interval.
    public var displayName: String {
        switch self {
        case .minute:
            return "Every Minute"
        case .hour:
            return "Every Hour"
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        }
    }
    
    /// The Calendar.Component corresponding to this interval.
    public var calendarComponent: Calendar.Component {
        switch self {
        case .minute:
            return .minute
        case .hour:
            return .hour
        case .daily:
            return .day
        case .weekly:
            return .weekOfYear
        case .monthly:
            return .month
        case .yearly:
            return .year
        }
    }
} 