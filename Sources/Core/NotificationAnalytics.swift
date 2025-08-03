//
//  NotificationAnalytics.swift
//  NotificationFramework
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

/// Represents analytics data for notifications.
///
/// This struct contains comprehensive analytics data including
/// delivery rates, engagement metrics, and performance statistics.
///
/// ## Example Usage
/// ```swift
/// let analytics = notificationManager.getAnalytics()
/// print("Delivery rate: \(analytics.deliveryRate * 100)%")
/// print("Response rate: \(analytics.responseRate * 100)%")
/// ```
@available(iOS 15.0, *)
public struct NotificationAnalytics: Codable {
    
    // MARK: - Properties
    
    /// All analytics events.
    public var events: [AnalyticsEvent] = []
    
    /// Total number of events.
    public var totalEvents: Int = 0
    
    /// Number of permissions granted.
    public var permissionsGranted: Int = 0
    
    /// Number of permissions denied.
    public var permissionsDenied: Int = 0
    
    /// Number of notifications scheduled.
    public var notificationsScheduled: Int = 0
    
    /// Number of rich notifications scheduled.
    public var richNotificationsScheduled: Int = 0
    
    /// Number of recurring notifications scheduled.
    public var recurringNotificationsScheduled: Int = 0
    
    /// Number of notifications received.
    public var notificationsReceived: Int = 0
    
    /// Number of notification responses.
    public var notificationResponses: Int = 0
    
    /// Number of default actions.
    public var defaultActions: Int = 0
    
    /// Number of dismiss actions.
    public var dismissActions: Int = 0
    
    /// Number of custom actions.
    public var customActions: Int = 0
    
    /// Number of notifications removed.
    public var notificationsRemoved: Int = 0
    
    /// Number of times all notifications were removed.
    public var allNotificationsRemoved: Int = 0
    
    /// Number of delivered notifications removed.
    public var deliveredNotificationsRemoved: Int = 0
    
    /// Number of times all delivered notifications were removed.
    public var allDeliveredNotificationsRemoved: Int = 0
    
    /// Number of scheduling errors.
    public var schedulingErrors: Int = 0
    
    /// Number of permission errors.
    public var permissionErrors: Int = 0
    
    /// Delivery rate (0.0 to 1.0).
    public var deliveryRate: Double = 0.0
    
    /// Response rate (0.0 to 1.0).
    public var responseRate: Double = 0.0
    
    /// Date when analytics was created.
    public var createdAt: Date = Date()
    
    /// Date when analytics was last updated.
    public var lastUpdated: Date = Date()
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Computed Properties
    
    /// Total number of notifications processed.
    public var totalNotifications: Int {
        return notificationsScheduled + richNotificationsScheduled + recurringNotificationsScheduled
    }
    
    /// Total number of user interactions.
    public var totalInteractions: Int {
        return notificationResponses + defaultActions + dismissActions + customActions
    }
    
    /// Total number of errors.
    public var totalErrors: Int {
        return schedulingErrors + permissionErrors
    }
    
    /// Error rate (0.0 to 1.0).
    public var errorRate: Double {
        guard totalNotifications > 0 else { return 0.0 }
        return Double(totalErrors) / Double(totalNotifications)
    }
    
    /// Interaction rate (0.0 to 1.0).
    public var interactionRate: Double {
        guard notificationsReceived > 0 else { return 0.0 }
        return Double(totalInteractions) / Double(notificationsReceived)
    }
    
    /// Rich notification percentage.
    public var richNotificationPercentage: Double {
        guard totalNotifications > 0 else { return 0.0 }
        return Double(richNotificationsScheduled) / Double(totalNotifications)
    }
    
    /// Recurring notification percentage.
    public var recurringNotificationPercentage: Double {
        guard totalNotifications > 0 else { return 0.0 }
        return Double(recurringNotificationsScheduled) / Double(totalNotifications)
    }
    
    // MARK: - Public Methods
    
    /// Gets analytics summary as a dictionary.
    public func getSummary() -> [String: Any] {
        return [
            "total_events": totalEvents,
            "total_notifications": totalNotifications,
            "notifications_scheduled": notificationsScheduled,
            "rich_notifications_scheduled": richNotificationsScheduled,
            "recurring_notifications_scheduled": recurringNotificationsScheduled,
            "notifications_received": notificationsReceived,
            "notifications_removed": notificationsRemoved,
            "total_interactions": totalInteractions,
            "notification_responses": notificationResponses,
            "default_actions": defaultActions,
            "dismiss_actions": dismissActions,
            "custom_actions": customActions,
            "total_errors": totalErrors,
            "scheduling_errors": schedulingErrors,
            "permission_errors": permissionErrors,
            "delivery_rate": deliveryRate,
            "response_rate": responseRate,
            "error_rate": errorRate,
            "interaction_rate": interactionRate,
            "rich_notification_percentage": richNotificationPercentage,
            "recurring_notification_percentage": recurringNotificationPercentage,
            "permissions_granted": permissionsGranted,
            "permissions_denied": permissionsDenied,
            "created_at": createdAt.timeIntervalSince1970,
            "last_updated": lastUpdated.timeIntervalSince1970
        ]
    }
    
    /// Exports analytics to JSON format.
    public func exportToJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
    
    /// Creates analytics from JSON data.
    public static func fromJSON(_ data: Data) throws -> NotificationAnalytics {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(NotificationAnalytics.self, from: data)
    }
}

/// Represents an analytics event.
@available(iOS 15.0, *)
public struct AnalyticsEvent: Codable {
    
    // MARK: - Properties
    
    /// The type of event.
    public let type: AnalyticsEventType
    
    /// When the event occurred.
    public let timestamp: Date
    
    /// Additional metadata for the event.
    public let metadata: [String: String]
    
    // MARK: - Initialization
    
    public init(type: AnalyticsEventType, timestamp: Date, metadata: [String: String]) {
        self.type = type
        self.timestamp = timestamp
        self.metadata = metadata
    }
}

/// Types of analytics events.
@available(iOS 15.0, *)
public enum AnalyticsEventType: String, Codable, CaseIterable {
    
    case permissionGranted = "permission_granted"
    case permissionDenied = "permission_denied"
    case permissionError = "permission_error"
    case notificationScheduled = "notification_scheduled"
    case richNotificationScheduled = "rich_notification_scheduled"
    case recurringNotificationScheduled = "recurring_notification_scheduled"
    case notificationReceived = "notification_received"
    case notificationResponse = "notification_response"
    case defaultAction = "default_action"
    case dismissAction = "dismiss_action"
    case customAction = "custom_action"
    case notificationRemoved = "notification_removed"
    case allNotificationsRemoved = "all_notifications_removed"
    case deliveredNotificationsRemoved = "delivered_notifications_removed"
    case allDeliveredNotificationsRemoved = "all_delivered_notifications_removed"
    case schedulingError = "scheduling_error"
    
    /// The display name for the event type.
    public var displayName: String {
        switch self {
        case .permissionGranted:
            return "Permission Granted"
        case .permissionDenied:
            return "Permission Denied"
        case .permissionError:
            return "Permission Error"
        case .notificationScheduled:
            return "Notification Scheduled"
        case .richNotificationScheduled:
            return "Rich Notification Scheduled"
        case .recurringNotificationScheduled:
            return "Recurring Notification Scheduled"
        case .notificationReceived:
            return "Notification Received"
        case .notificationResponse:
            return "Notification Response"
        case .defaultAction:
            return "Default Action"
        case .dismissAction:
            return "Dismiss Action"
        case .customAction:
            return "Custom Action"
        case .notificationRemoved:
            return "Notification Removed"
        case .allNotificationsRemoved:
            return "All Notifications Removed"
        case .deliveredNotificationsRemoved:
            return "Delivered Notifications Removed"
        case .allDeliveredNotificationsRemoved:
            return "All Delivered Notifications Removed"
        case .schedulingError:
            return "Scheduling Error"
        }
    }
    
    /// The category for the event type.
    public var category: String {
        switch self {
        case .permissionGranted, .permissionDenied, .permissionError:
            return "permissions"
        case .notificationScheduled, .richNotificationScheduled, .recurringNotificationScheduled:
            return "scheduling"
        case .notificationReceived, .notificationResponse:
            return "delivery"
        case .defaultAction, .dismissAction, .customAction:
            return "interactions"
        case .notificationRemoved, .allNotificationsRemoved, .deliveredNotificationsRemoved, .allDeliveredNotificationsRemoved:
            return "management"
        case .schedulingError:
            return "errors"
        }
    }
    
    /// Whether this event type represents an error.
    public var isError: Bool {
        switch self {
        case .permissionError, .schedulingError:
            return true
        default:
            return false
        }
    }
    
    /// Whether this event type represents a user interaction.
    public var isUserInteraction: Bool {
        switch self {
        case .notificationResponse, .defaultAction, .dismissAction, .customAction:
            return true
        default:
            return false
        }
    }
} 