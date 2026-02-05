//
//  NotificationKit.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications
#if canImport(UIKit)
import UIKit
#endif

/// NotificationKit - The most comprehensive notification framework for iOS
///
/// NotificationKit provides a complete solution for local and remote notifications
/// with advanced features like analytics, A/B testing, quiet hours, rate limiting,
/// and deep linking support.
///
/// ## Features
/// - 🔔 Type-safe notification scheduling with builder pattern
/// - 📱 Rich notifications (images, video, audio, GIFs)
/// - 🚀 Remote push notification handling
/// - 📊 Built-in analytics and delivery tracking
/// - 🧪 A/B testing for notification optimization
/// - 🌙 Quiet hours and rate limiting
/// - 📍 Location-based geofence notifications
/// - 🔗 Deep linking with custom URL schemes
/// - 🎯 Notification channels for granular control
/// - 👤 User preference management
///
/// ## Quick Start
/// ```swift
/// import NotificationKit
///
/// // Configure on app launch
/// NotificationKit.configure { config in
///     config.enableAnalytics = true
///     config.quietHours = QuietHours(from: "22:00", to: "08:00")
///     config.rateLimiting = RateLimiting(maxPerHour: 5)
/// }
///
/// // Request permission
/// try await NotificationKit.shared.requestAuthorization()
///
/// // Schedule a notification
/// try await NotificationKit.shared.schedule {
///     Notification(id: "reminder")
///         .title("Meeting in 5 minutes")
///         .body("Team standup starting soon")
///         .sound(.default)
///         .trigger(after: .minutes(5))
/// }
/// ```
@MainActor
public final class NotificationKit: NSObject, Sendable {
    
    // MARK: - Singleton
    
    /// Shared instance for convenient access
    public static let shared = NotificationKit()
    
    // MARK: - Properties
    
    /// The underlying notification center
    private let center: UNUserNotificationCenter
    
    /// Current configuration
    public private(set) var configuration: NotificationConfiguration
    
    /// Current authorization status
    public private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    /// Registered notification categories
    private var categories: Set<UNNotificationCategory> = []
    
    /// Delegate for handling notification events
    public weak var delegate: NotificationKitDelegate?
    
    /// Analytics engine
    public let analytics: NotificationAnalytics
    
    /// Rate limiter
    private let rateLimiter: RateLimiter
    
    /// Quiet hours manager
    private let quietHoursManager: QuietHoursManager
    
    /// Channel manager
    public let channels: ChannelManager
    
    /// A/B testing engine
    public let abTesting: ABTestingEngine
    
    /// Deep link handler
    public let deepLinks: DeepLinkHandler
    
    /// User preferences
    public let preferences: UserPreferenceManager
    
    /// Device token for remote notifications
    public private(set) var deviceToken: Data?
    
    // MARK: - Initialization
    
    /// Creates a new NotificationKit instance
    /// - Parameter center: The notification center to use (defaults to `.current()`)
    public override init() {
        self.center = UNUserNotificationCenter.current()
        self.configuration = NotificationConfiguration()
        self.analytics = NotificationAnalytics()
        self.rateLimiter = RateLimiter()
        self.quietHoursManager = QuietHoursManager()
        self.channels = ChannelManager()
        self.abTesting = ABTestingEngine()
        self.deepLinks = DeepLinkHandler()
        self.preferences = UserPreferenceManager()
        super.init()
        center.delegate = self
    }
    
    // MARK: - Configuration
    
    /// Configures NotificationKit with custom settings
    /// - Parameter builder: A closure to configure settings
    public static func configure(_ builder: (inout NotificationConfiguration) -> Void) {
        var config = NotificationConfiguration()
        builder(&config)
        shared.configuration = config
        shared.applyConfiguration()
    }
    
    private func applyConfiguration() {
        if let quietHours = configuration.quietHours {
            quietHoursManager.configure(quietHours)
        }
        if let rateLimiting = configuration.rateLimiting {
            rateLimiter.configure(rateLimiting)
        }
        analytics.isEnabled = configuration.enableAnalytics
    }
    
    // MARK: - Authorization
    
    /// Requests notification authorization from the user
    /// - Parameter options: The authorization options to request
    /// - Returns: Whether authorization was granted
    @discardableResult
    public func requestAuthorization(
        options: UNAuthorizationOptions = [.alert, .sound, .badge]
    ) async throws -> Bool {
        let granted = try await center.requestAuthorization(options: options)
        await updateAuthorizationStatus()
        
        analytics.trackEvent(.permissionRequested(granted: granted))
        
        return granted
    }
    
    /// Requests provisional authorization (quiet notifications, iOS 12+)
    @discardableResult
    public func requestProvisionalAuthorization() async throws -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge, .provisional]
        return try await requestAuthorization(options: options)
    }
    
    /// Updates the current authorization status
    public func updateAuthorizationStatus() async {
        let settings = await center.notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }
    
    /// Gets detailed notification settings
    public func getNotificationSettings() async -> UNNotificationSettings {
        await center.notificationSettings()
    }
    
    // MARK: - Remote Notifications
    
    /// Registers for remote notifications
    #if canImport(UIKit) && !os(watchOS)
    public func registerForRemoteNotifications() {
        Task { @MainActor in
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    /// Unregisters from remote notifications
    public func unregisterForRemoteNotifications() {
        Task { @MainActor in
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    #endif
    
    /// Called when device token is received
    public func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken
        
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        analytics.trackEvent(.deviceTokenReceived(token: tokenString))
        
        delegate?.notificationKit(self, didRegisterDeviceToken: deviceToken)
    }
    
    /// Called when remote notification registration fails
    public func didFailToRegisterForRemoteNotifications(withError error: Error) {
        analytics.trackEvent(.deviceTokenFailed(error: error))
        delegate?.notificationKit(self, didFailToRegisterWithError: error)
    }
    
    // MARK: - Scheduling
    
    /// Schedules a notification using the builder pattern
    /// - Parameter builder: A closure that builds the notification
    public func schedule(@NotificationBuilder builder: () -> Notification) async throws {
        let notification = builder()
        try await scheduleInternal(notification)
    }
    
    /// Schedules a notification directly
    public func schedule(_ notification: Notification) async throws {
        try await scheduleInternal(notification)
    }
    
    /// Schedules multiple notifications at once
    /// - Parameter notifications: The notifications to schedule
    public func schedule(_ notifications: [Notification]) async throws {
        for notification in notifications {
            try await scheduleInternal(notification)
        }
    }
    
    private func scheduleInternal(_ notification: Notification) async throws {
        // Check quiet hours
        if quietHoursManager.isInQuietHours() && !notification.bypassQuietHours {
            quietHoursManager.defer(notification)
            analytics.trackEvent(.notificationDeferred(id: notification.id, reason: .quietHours))
            return
        }
        
        // Check rate limiting
        if !rateLimiter.canSchedule() && !notification.bypassRateLimiting {
            throw NotificationKitError.rateLimitExceeded
        }
        
        // Check channel settings
        if let channelId = notification.channelId {
            guard channels.isChannelEnabled(channelId) else {
                analytics.trackEvent(.notificationSuppressed(id: notification.id, reason: .channelDisabled))
                return
            }
        }
        
        // Check user preferences
        guard preferences.shouldDeliver(notification) else {
            analytics.trackEvent(.notificationSuppressed(id: notification.id, reason: .userPreference))
            return
        }
        
        // Apply A/B testing variant if applicable
        let finalNotification = abTesting.applyVariant(to: notification)
        
        let request = finalNotification.toRequest()
        try await center.add(request)
        
        rateLimiter.recordScheduled()
        analytics.trackEvent(.notificationScheduled(notification: finalNotification))
    }
    
    // MARK: - Management
    
    /// Cancels a notification by its identifier
    /// - Parameter identifier: The notification identifier
    public func cancel(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
        analytics.trackEvent(.notificationCancelled(id: identifier))
    }
    
    /// Cancels multiple notifications
    /// - Parameter identifiers: The notification identifiers
    public func cancel(identifiers: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
        center.removeDeliveredNotifications(withIdentifiers: identifiers)
        identifiers.forEach { analytics.trackEvent(.notificationCancelled(id: $0)) }
    }
    
    /// Cancels all pending notifications
    public func cancelAll() {
        center.removeAllPendingNotificationRequests()
        analytics.trackEvent(.allNotificationsCancelled)
    }
    
    /// Removes all delivered notifications
    public func removeAllDelivered() {
        center.removeAllDeliveredNotifications()
    }
    
    /// Returns all pending notification requests
    public func pendingNotifications() async -> [UNNotificationRequest] {
        await center.pendingNotificationRequests()
    }
    
    /// Returns all delivered notifications
    public func deliveredNotifications() async -> [UNNotification] {
        await center.deliveredNotifications()
    }
    
    // MARK: - Categories & Actions
    
    /// Registers a notification category for interactive notifications
    /// - Parameter category: The category to register
    public func register(category: NotificationCategory) {
        let unCategory = category.toUNCategory()
        categories.insert(unCategory)
        center.setNotificationCategories(categories)
    }
    
    /// Registers multiple notification categories
    /// - Parameter categories: The categories to register
    public func register(categories: [NotificationCategory]) {
        for category in categories {
            let unCategory = category.toUNCategory()
            self.categories.insert(unCategory)
        }
        center.setNotificationCategories(self.categories)
    }
    
    // MARK: - Badge Management
    
    #if canImport(UIKit) && !os(watchOS)
    /// Sets the app's badge number
    /// - Parameter count: The badge count (0 to clear)
    public func setBadge(_ count: Int) async {
        await MainActor.run {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
    
    /// Clears the app's badge
    public func clearBadge() async {
        await setBadge(0)
    }
    
    /// Increments the badge count
    public func incrementBadge(by amount: Int = 1) async {
        let current = await MainActor.run {
            UIApplication.shared.applicationIconBadgeNumber
        }
        await setBadge(current + amount)
    }
    
    /// Decrements the badge count
    public func decrementBadge(by amount: Int = 1) async {
        let current = await MainActor.run {
            UIApplication.shared.applicationIconBadgeNumber
        }
        await setBadge(max(0, current - amount))
    }
    #endif
    
    // MARK: - Utility
    
    /// Checks if notifications are enabled
    public var isAuthorized: Bool {
        authorizationStatus == .authorized
    }
    
    /// Checks if provisional authorization is granted
    public var isProvisional: Bool {
        authorizationStatus == .provisional
    }
    
    /// Opens system notification settings
    #if canImport(UIKit) && !os(watchOS)
    @MainActor
    public func openSettings() async {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        await UIApplication.shared.open(url)
    }
    #endif
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationKit: UNUserNotificationCenterDelegate {
    
    public nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        
        let notificationId = notification.request.identifier
        
        await MainActor.run {
            analytics.trackEvent(.notificationPresented(id: notificationId))
        }
        
        if let delegate = await delegate {
            return await delegate.notificationKit(MainActor.assumeIsolated { self }, willPresent: notification)
        }
        
        return [.banner, .sound, .badge, .list]
    }
    
    public nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        
        let notificationId = response.notification.request.identifier
        let actionId = response.actionIdentifier
        
        await MainActor.run {
            analytics.trackEvent(.notificationInteracted(id: notificationId, action: actionId))
        }
        
        // Handle deep links
        let userInfo = response.notification.request.content.userInfo
        if let deepLink = userInfo["deepLink"] as? String {
            await MainActor.run {
                deepLinks.handle(url: deepLink, from: notificationId)
            }
        }
        
        if let delegate = await delegate {
            await delegate.notificationKit(MainActor.assumeIsolated { self }, didReceive: response)
        }
    }
}

// MARK: - Notification Builder

/// A result builder for creating notifications
@resultBuilder
public struct NotificationBuilder {
    public static func buildBlock(_ notification: Notification) -> Notification {
        notification
    }
}

// MARK: - NotificationKit Delegate

/// Delegate protocol for handling notification events
@MainActor
public protocol NotificationKitDelegate: AnyObject {
    /// Called when a notification is about to be presented
    func notificationKit(
        _ kit: NotificationKit,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions
    
    /// Called when the user responds to a notification
    func notificationKit(
        _ kit: NotificationKit,
        didReceive response: UNNotificationResponse
    ) async
    
    /// Called when device token is received
    func notificationKit(
        _ kit: NotificationKit,
        didRegisterDeviceToken token: Data
    )
    
    /// Called when remote notification registration fails
    func notificationKit(
        _ kit: NotificationKit,
        didFailToRegisterWithError error: Error
    )
    
    #if os(iOS)
    /// Called when a remote notification is received
    func notificationKit(
        _ kit: NotificationKit,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult
    #endif
}

// MARK: - Default Implementation

extension NotificationKitDelegate {
    public func notificationKit(
        _ kit: NotificationKit,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .badge, .list]
    }
    
    public func notificationKit(
        _ kit: NotificationKit,
        didReceive response: UNNotificationResponse
    ) async {
        // Default: no action
    }
    
    public func notificationKit(
        _ kit: NotificationKit,
        didRegisterDeviceToken token: Data
    ) {
        // Default: no action
    }
    
    public func notificationKit(
        _ kit: NotificationKit,
        didFailToRegisterWithError error: Error
    ) {
        // Default: no action
    }
    
    #if os(iOS)
    public func notificationKit(
        _ kit: NotificationKit,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        .noData
    }
    #endif
}

// MARK: - Errors

/// Errors that can be thrown by NotificationKit
public enum NotificationKitError: Error, LocalizedError {
    case notAuthorized
    case rateLimitExceeded
    case invalidConfiguration
    case channelNotFound(String)
    case attachmentFailed(URL)
    case deepLinkInvalid(String)
    
    public var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Notification authorization not granted"
        case .rateLimitExceeded:
            return "Rate limit exceeded for notifications"
        case .invalidConfiguration:
            return "Invalid NotificationKit configuration"
        case .channelNotFound(let id):
            return "Notification channel '\(id)' not found"
        case .attachmentFailed(let url):
            return "Failed to create attachment from \(url)"
        case .deepLinkInvalid(let url):
            return "Invalid deep link URL: \(url)"
        }
    }
}
