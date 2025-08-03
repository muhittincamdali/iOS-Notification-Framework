//
//  NotificationManager.swift
//  NotificationFramework
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications
import Combine

/// A comprehensive notification management system for iOS applications.
///
/// The `NotificationManager` provides a high-level interface for working with
/// local and remote notifications. It handles permission requests, notification
/// scheduling, user interaction responses, and analytics tracking.
///
/// ## Example Usage
/// ```swift
/// let manager = NotificationManager.shared
/// let granted = try await manager.requestPermissions()
/// if granted {
///     let notification = NotificationContent(
///         title: "Welcome!",
///         body: "Thank you for using our app",
///         category: "welcome"
///     )
///     manager.schedule(notification, at: Date().addingTimeInterval(60))
/// }
/// ```
@available(iOS 15.0, *)
public class NotificationManager: NSObject, ObservableObject {
    
    // MARK: - Singleton
    
    /// Shared instance of the notification manager.
    public static let shared = NotificationManager()
    
    // MARK: - Properties
    
    /// The underlying notification center.
    private let notificationCenter = UNUserNotificationCenter.current()
    
    /// Current notification settings.
    @Published public private(set) var settings: UNNotificationSettings?
    
    /// Pending notification requests.
    @Published public private(set) var pendingRequests: [UNNotificationRequest] = []
    
    /// Delivered notifications.
    @Published public private(set) var deliveredNotifications: [UNNotification] = []
    
    /// Notification categories for organizing notifications.
    private var categories: Set<UNNotificationCategory> = []
    
    /// Action handlers for custom notification actions.
    private var actionHandlers: [String: NotificationActionHandler] = [:]
    
    /// Analytics tracker for notification events.
    private let analyticsTracker = NotificationAnalyticsTracker()
    
    /// Notification content builder for creating rich notifications.
    private let contentBuilder = NotificationContentBuilder()
    
    /// Scheduler for managing notification timing.
    private let scheduler = NotificationScheduler()
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        setupNotificationCenter()
        setupNotificationCategories()
    }
    
    // MARK: - Setup
    
    /// Sets up the notification center delegate and initial configuration.
    private func setupNotificationCenter() {
        notificationCenter.delegate = self
        loadNotificationSettings()
        loadPendingRequests()
        loadDeliveredNotifications()
    }
    
    /// Sets up default notification categories.
    private func setupNotificationCategories() {
        let defaultCategories: [UNNotificationCategory] = [
            createWelcomeCategory(),
            createReminderCategory(),
            createActionCategory(),
            createRichMediaCategory()
        ]
        
        categories = Set(defaultCategories)
        notificationCenter.setNotificationCategories(categories)
    }
    
    // MARK: - Permission Management
    
    /// Requests notification permissions from the user.
    ///
    /// - Returns: `true` if permissions were granted, `false` otherwise.
    /// - Throws: `NotificationError.permissionDenied` if permissions are denied.
    @MainActor
    public func requestPermissions() async throws -> Bool {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .provisional]
        
        do {
            let granted = try await notificationCenter.requestAuthorization(options: options)
            
            if granted {
                await loadNotificationSettings()
                analyticsTracker.trackPermissionGranted()
            } else {
                analyticsTracker.trackPermissionDenied()
                throw NotificationError.permissionDenied
            }
            
            return granted
        } catch {
            analyticsTracker.trackPermissionError(error)
            throw NotificationError.permissionRequestFailed(error)
        }
    }
    
    /// Checks current notification authorization status.
    ///
    /// - Returns: The current authorization status.
    @MainActor
    public func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Notification Scheduling
    
    /// Schedules a notification for delivery.
    ///
    /// - Parameters:
    ///   - content: The notification content to schedule.
    ///   - date: The date when the notification should be delivered.
    ///   - identifier: Optional identifier for the notification request.
    /// - Returns: The scheduled notification request.
    /// - Throws: `NotificationError.schedulingFailed` if scheduling fails.
    @MainActor
    public func schedule(_ content: NotificationContent, at date: Date, identifier: String? = nil) async throws -> UNNotificationRequest {
        let request = try await contentBuilder.buildRequest(from: content, scheduledFor: date, identifier: identifier)
        
        do {
            try await notificationCenter.add(request)
            await loadPendingRequests()
            analyticsTracker.trackNotificationScheduled(content, date: date)
            return request
        } catch {
            analyticsTracker.trackSchedulingError(error)
            throw NotificationError.schedulingFailed(error)
        }
    }
    
    /// Schedules a rich media notification.
    ///
    /// - Parameters:
    ///   - content: The rich notification content.
    ///   - date: The date when the notification should be delivered.
    ///   - identifier: Optional identifier for the notification request.
    /// - Returns: The scheduled notification request.
    /// - Throws: `NotificationError.schedulingFailed` if scheduling fails.
    @MainActor
    public func scheduleRichNotification(_ content: RichNotificationContent, at date: Date, identifier: String? = nil) async throws -> UNNotificationRequest {
        let request = try await contentBuilder.buildRichRequest(from: content, scheduledFor: date, identifier: identifier)
        
        do {
            try await notificationCenter.add(request)
            await loadPendingRequests()
            analyticsTracker.trackRichNotificationScheduled(content, date: date)
            return request
        } catch {
            analyticsTracker.trackSchedulingError(error)
            throw NotificationError.schedulingFailed(error)
        }
    }
    
    /// Schedules a recurring notification.
    ///
    /// - Parameters:
    ///   - content: The notification content.
    ///   - schedule: The recurring schedule configuration.
    /// - Returns: Array of scheduled notification requests.
    /// - Throws: `NotificationError.schedulingFailed` if scheduling fails.
    @MainActor
    public func scheduleRecurring(_ content: NotificationContent, schedule: RecurringSchedule) async throws -> [UNNotificationRequest] {
        let requests = try await scheduler.scheduleRecurring(content, schedule: schedule)
        
        for request in requests {
            try await notificationCenter.add(request)
        }
        
        await loadPendingRequests()
        analyticsTracker.trackRecurringNotificationScheduled(content, schedule: schedule)
        return requests
    }
    
    // MARK: - Notification Management
    
    /// Removes a pending notification request.
    ///
    /// - Parameter identifier: The identifier of the notification to remove.
    @MainActor
    public func removePendingNotification(withIdentifier identifier: String) async {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        await loadPendingRequests()
        analyticsTracker.trackNotificationRemoved(identifier: identifier)
    }
    
    /// Removes all pending notification requests.
    @MainActor
    public func removeAllPendingNotifications() async {
        notificationCenter.removeAllPendingNotificationRequests()
        await loadPendingRequests()
        analyticsTracker.trackAllNotificationsRemoved()
    }
    
    /// Removes delivered notifications.
    ///
    /// - Parameter identifiers: Array of notification identifiers to remove.
    @MainActor
    public func removeDeliveredNotifications(withIdentifiers identifiers: [String]) async {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
        await loadDeliveredNotifications()
        analyticsTracker.trackDeliveredNotificationsRemoved(identifiers: identifiers)
    }
    
    /// Removes all delivered notifications.
    @MainActor
    public func removeAllDeliveredNotifications() async {
        notificationCenter.removeAllDeliveredNotifications()
        await loadDeliveredNotifications()
        analyticsTracker.trackAllDeliveredNotificationsRemoved()
    }
    
    // MARK: - Action Handling
    
    /// Registers a handler for a custom notification action.
    ///
    /// - Parameters:
    ///   - actionIdentifier: The identifier of the action to handle.
    ///   - handler: The closure to execute when the action is triggered.
    public func registerActionHandler(for actionIdentifier: String, handler: @escaping NotificationActionHandler) {
        actionHandlers[actionIdentifier] = handler
    }
    
    /// Removes an action handler.
    ///
    /// - Parameter actionIdentifier: The identifier of the action handler to remove.
    public func removeActionHandler(for actionIdentifier: String) {
        actionHandlers.removeValue(forKey: actionIdentifier)
    }
    
    // MARK: - Analytics
    
    /// Gets analytics data for notifications.
    ///
    /// - Returns: Analytics data containing delivery rates, engagement metrics, etc.
    public func getAnalytics() -> NotificationAnalytics {
        return analyticsTracker.getAnalytics()
    }
    
    /// Exports analytics data to a file.
    ///
    /// - Parameter fileURL: The URL where the analytics data should be saved.
    /// - Throws: `NotificationError.exportFailed` if export fails.
    public func exportAnalytics(to fileURL: URL) throws {
        try analyticsTracker.exportAnalytics(to: fileURL)
    }
    
    // MARK: - Private Methods
    
    /// Loads current notification settings.
    @MainActor
    private func loadNotificationSettings() async {
        settings = await notificationCenter.notificationSettings()
    }
    
    /// Loads pending notification requests.
    @MainActor
    private func loadPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
    }
    
    /// Loads delivered notifications.
    @MainActor
    private func loadDeliveredNotifications() async {
        deliveredNotifications = await notificationCenter.deliveredNotifications()
    }
    
    /// Creates a welcome notification category.
    private func createWelcomeCategory() -> UNNotificationCategory {
        let viewAction = UNNotificationAction(
            identifier: "VIEW_WELCOME",
            title: "View",
            options: [.foreground]
        )
        
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_WELCOME",
            title: "Dismiss",
            options: [.destructive]
        )
        
        return UNNotificationCategory(
            identifier: "welcome",
            actions: [viewAction, dismissAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
    }
    
    /// Creates a reminder notification category.
    private func createReminderCategory() -> UNNotificationCategory {
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_REMINDER",
            title: "Snooze",
            options: []
        )
        
        let completeAction = UNNotificationAction(
            identifier: "COMPLETE_REMINDER",
            title: "Complete",
            options: [.destructive]
        )
        
        return UNNotificationCategory(
            identifier: "reminder",
            actions: [snoozeAction, completeAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
    }
    
    /// Creates an action notification category.
    private func createActionCategory() -> UNNotificationCategory {
        let primaryAction = UNNotificationAction(
            identifier: "PRIMARY_ACTION",
            title: "Primary Action",
            options: [.foreground]
        )
        
        let secondaryAction = UNNotificationAction(
            identifier: "SECONDARY_ACTION",
            title: "Secondary Action",
            options: []
        )
        
        return UNNotificationCategory(
            identifier: "action",
            actions: [primaryAction, secondaryAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
    }
    
    /// Creates a rich media notification category.
    private func createRichMediaCategory() -> UNNotificationCategory {
        let viewAction = UNNotificationAction(
            identifier: "VIEW_MEDIA",
            title: "View",
            options: [.foreground]
        )
        
        let shareAction = UNNotificationAction(
            identifier: "SHARE_MEDIA",
            title: "Share",
            options: []
        )
        
        return UNNotificationCategory(
            identifier: "rich_media",
            actions: [viewAction, shareAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
    }
}

// MARK: - UNUserNotificationCenterDelegate

@available(iOS 15.0, *)
extension NotificationManager: UNUserNotificationCenterDelegate {
    
    /// Called when a notification is delivered while the app is in the foreground.
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        analyticsTracker.trackNotificationReceived(notification)
        completionHandler([.banner, .sound, .badge])
    }
    
    /// Called when the user responds to a notification.
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let actionIdentifier = response.actionIdentifier
        let notification = response.notification
        
        analyticsTracker.trackNotificationResponse(response)
        
        // Handle custom actions
        if let handler = actionHandlers[actionIdentifier] {
            handler(actionIdentifier, notification)
        }
        
        // Handle default actions
        switch actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            handleDefaultAction(for: notification)
        case UNNotificationDismissActionIdentifier:
            handleDismissAction(for: notification)
        default:
            handleCustomAction(actionIdentifier, for: notification)
        }
        
        completionHandler()
    }
    
    /// Handles the default action when a notification is tapped.
    private func handleDefaultAction(for notification: UNNotification) {
        // Override in subclasses or use delegate pattern
        analyticsTracker.trackDefaultAction(notification)
    }
    
    /// Handles the dismiss action when a notification is dismissed.
    private func handleDismissAction(for notification: UNNotification) {
        analyticsTracker.trackDismissAction(notification)
    }
    
    /// Handles custom actions.
    private func handleCustomAction(_ actionIdentifier: String, for notification: UNNotification) {
        analyticsTracker.trackCustomAction(actionIdentifier, notification: notification)
    }
}

// MARK: - Type Aliases

/// Closure type for notification action handlers.
public typealias NotificationActionHandler = (String, UNNotification) -> Void 