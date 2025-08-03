//
//  NotificationAnalyticsTracker.swift
//  NotificationFramework
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// Tracks analytics data for notification events.
///
/// This class provides comprehensive analytics tracking for notification
/// delivery, user interactions, and performance metrics.
///
/// ## Example Usage
/// ```swift
/// let tracker = NotificationAnalyticsTracker()
/// tracker.trackNotificationScheduled(content, date: Date())
/// let analytics = tracker.getAnalytics()
/// ```
@available(iOS 15.0, *)
public class NotificationAnalyticsTracker {
    
    // MARK: - Properties
    
    /// Analytics data storage.
    private var analyticsData = NotificationAnalytics()
    
    /// Date formatter for analytics.
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    /// Analytics file URL.
    private var analyticsFileURL: URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsPath.appendingPathComponent("notification_analytics.json")
    }
    
    // MARK: - Initialization
    
    public init() {
        loadAnalyticsData()
    }
    
    // MARK: - Public Methods
    
    /// Tracks when permissions are granted.
    public func trackPermissionGranted() {
        let event = AnalyticsEvent(
            type: .permissionGranted,
            timestamp: Date(),
            metadata: [:]
        )
        addEvent(event)
    }
    
    /// Tracks when permissions are denied.
    public func trackPermissionDenied() {
        let event = AnalyticsEvent(
            type: .permissionDenied,
            timestamp: Date(),
            metadata: [:]
        )
        addEvent(event)
    }
    
    /// Tracks permission request errors.
    public func trackPermissionError(_ error: Error) {
        let event = AnalyticsEvent(
            type: .permissionError,
            timestamp: Date(),
            metadata: ["error": error.localizedDescription]
        )
        addEvent(event)
    }
    
    /// Tracks when a notification is scheduled.
    public func trackNotificationScheduled(_ content: NotificationContent, date: Date) {
        let event = AnalyticsEvent(
            type: .notificationScheduled,
            timestamp: Date(),
            metadata: [
                "title": content.title,
                "category": content.category,
                "scheduledDate": dateFormatter.string(from: date),
                "priority": content.priority.rawValue
            ]
        )
        addEvent(event)
    }
    
    /// Tracks when a rich notification is scheduled.
    public func trackRichNotificationScheduled(_ content: RichNotificationContent, date: Date) {
        let event = AnalyticsEvent(
            type: .richNotificationScheduled,
            timestamp: Date(),
            metadata: [
                "title": content.content.title,
                "category": content.content.category,
                "scheduledDate": dateFormatter.string(from: date),
                "mediaType": content.mediaType.rawValue,
                "hasMedia": content.mediaURL != nil
            ]
        )
        addEvent(event)
    }
    
    /// Tracks when a recurring notification is scheduled.
    public func trackRecurringNotificationScheduled(_ content: NotificationContent, schedule: RecurringSchedule) {
        let event = AnalyticsEvent(
            type: .recurringNotificationScheduled,
            timestamp: Date(),
            metadata: [
                "title": content.title,
                "category": content.category,
                "interval": schedule.interval.rawValue,
                "startDate": dateFormatter.string(from: schedule.startDate),
                "endDate": schedule.endDate.map { dateFormatter.string(from: $0) } ?? "none"
            ]
        )
        addEvent(event)
    }
    
    /// Tracks when a notification is received.
    public func trackNotificationReceived(_ notification: UNNotification) {
        let event = AnalyticsEvent(
            type: .notificationReceived,
            timestamp: Date(),
            metadata: [
                "identifier": notification.request.identifier,
                "title": notification.request.content.title,
                "category": notification.request.content.categoryIdentifier
            ]
        )
        addEvent(event)
    }
    
    /// Tracks when a user responds to a notification.
    public func trackNotificationResponse(_ response: UNNotificationResponse) {
        let event = AnalyticsEvent(
            type: .notificationResponse,
            timestamp: Date(),
            metadata: [
                "identifier": response.notification.request.identifier,
                "actionIdentifier": response.actionIdentifier,
                "title": response.notification.request.content.title
            ]
        )
        addEvent(event)
    }
    
    /// Tracks default notification actions.
    public func trackDefaultAction(_ notification: UNNotification) {
        let event = AnalyticsEvent(
            type: .defaultAction,
            timestamp: Date(),
            metadata: [
                "identifier": notification.request.identifier,
                "title": notification.request.content.title
            ]
        )
        addEvent(event)
    }
    
    /// Tracks dismiss actions.
    public func trackDismissAction(_ notification: UNNotification) {
        let event = AnalyticsEvent(
            type: .dismissAction,
            timestamp: Date(),
            metadata: [
                "identifier": notification.request.identifier,
                "title": notification.request.content.title
            ]
        )
        addEvent(event)
    }
    
    /// Tracks custom notification actions.
    public func trackCustomAction(_ actionIdentifier: String, notification: UNNotification) {
        let event = AnalyticsEvent(
            type: .customAction,
            timestamp: Date(),
            metadata: [
                "identifier": notification.request.identifier,
                "actionIdentifier": actionIdentifier,
                "title": notification.request.content.title
            ]
        )
        addEvent(event)
    }
    
    /// Tracks when notifications are removed.
    public func trackNotificationRemoved(identifier: String) {
        let event = AnalyticsEvent(
            type: .notificationRemoved,
            timestamp: Date(),
            metadata: ["identifier": identifier]
        )
        addEvent(event)
    }
    
    /// Tracks when all notifications are removed.
    public func trackAllNotificationsRemoved() {
        let event = AnalyticsEvent(
            type: .allNotificationsRemoved,
            timestamp: Date(),
            metadata: [:]
        )
        addEvent(event)
    }
    
    /// Tracks when delivered notifications are removed.
    public func trackDeliveredNotificationsRemoved(identifiers: [String]) {
        let event = AnalyticsEvent(
            type: .deliveredNotificationsRemoved,
            timestamp: Date(),
            metadata: ["identifiers": identifiers]
        )
        addEvent(event)
    }
    
    /// Tracks when all delivered notifications are removed.
    public func trackAllDeliveredNotificationsRemoved() {
        let event = AnalyticsEvent(
            type: .allDeliveredNotificationsRemoved,
            timestamp: Date(),
            metadata: [:]
        )
        addEvent(event)
    }
    
    /// Tracks scheduling errors.
    public func trackSchedulingError(_ error: Error) {
        let event = AnalyticsEvent(
            type: .schedulingError,
            timestamp: Date(),
            metadata: ["error": error.localizedDescription]
        )
        addEvent(event)
    }
    
    /// Gets analytics data.
    public func getAnalytics() -> NotificationAnalytics {
        return analyticsData
    }
    
    /// Exports analytics data to a file.
    public func exportAnalytics(to fileURL: URL) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        let data = try encoder.encode(analyticsData)
        try data.write(to: fileURL)
    }
    
    /// Clears analytics data.
    public func clearAnalytics() {
        analyticsData = NotificationAnalytics()
        saveAnalyticsData()
    }
    
    // MARK: - Private Methods
    
    /// Adds an analytics event.
    private func addEvent(_ event: AnalyticsEvent) {
        analyticsData.events.append(event)
        updateMetrics(for: event)
        saveAnalyticsData()
    }
    
    /// Updates metrics based on an event.
    private func updateMetrics(for event: AnalyticsEvent) {
        analyticsData.totalEvents += 1
        
        switch event.type {
        case .permissionGranted:
            analyticsData.permissionsGranted += 1
        case .permissionDenied:
            analyticsData.permissionsDenied += 1
        case .notificationScheduled:
            analyticsData.notificationsScheduled += 1
        case .richNotificationScheduled:
            analyticsData.richNotificationsScheduled += 1
        case .recurringNotificationScheduled:
            analyticsData.recurringNotificationsScheduled += 1
        case .notificationReceived:
            analyticsData.notificationsReceived += 1
        case .notificationResponse:
            analyticsData.notificationResponses += 1
        case .defaultAction:
            analyticsData.defaultActions += 1
        case .dismissAction:
            analyticsData.dismissActions += 1
        case .customAction:
            analyticsData.customActions += 1
        case .notificationRemoved:
            analyticsData.notificationsRemoved += 1
        case .allNotificationsRemoved:
            analyticsData.allNotificationsRemoved += 1
        case .deliveredNotificationsRemoved:
            analyticsData.deliveredNotificationsRemoved += 1
        case .allDeliveredNotificationsRemoved:
            analyticsData.allDeliveredNotificationsRemoved += 1
        case .schedulingError:
            analyticsData.schedulingErrors += 1
        case .permissionError:
            analyticsData.permissionErrors += 1
        }
        
        // Update delivery rate
        if analyticsData.notificationsScheduled > 0 {
            analyticsData.deliveryRate = Double(analyticsData.notificationsReceived) / Double(analyticsData.notificationsScheduled)
        }
        
        // Update response rate
        if analyticsData.notificationsReceived > 0 {
            analyticsData.responseRate = Double(analyticsData.notificationResponses) / Double(analyticsData.notificationsReceived)
        }
    }
    
    /// Saves analytics data to file.
    private func saveAnalyticsData() {
        do {
            try exportAnalytics(to: analyticsFileURL)
        } catch {
            print("Failed to save analytics data: \(error)")
        }
    }
    
    /// Loads analytics data from file.
    private func loadAnalyticsData() {
        guard FileManager.default.fileExists(atPath: analyticsFileURL.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: analyticsFileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            analyticsData = try decoder.decode(NotificationAnalytics.self, from: data)
        } catch {
            print("Failed to load analytics data: \(error)")
        }
    }
}

// MARK: - Analytics Models

/// Represents analytics data for notifications.
@available(iOS 15.0, *)
public struct NotificationAnalytics: Codable {
    
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
}

/// Represents an analytics event.
@available(iOS 15.0, *)
public struct AnalyticsEvent: Codable {
    
    /// The type of event.
    public let type: AnalyticsEventType
    
    /// When the event occurred.
    public let timestamp: Date
    
    /// Additional metadata for the event.
    public let metadata: [String: String]
    
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
} 