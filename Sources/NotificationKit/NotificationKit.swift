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

/// NotificationKit - A modern, type-safe notification framework for iOS
///
/// NotificationKit provides a declarative API for managing local and push notifications
/// with full support for iOS 15+ features including Time Sensitive, Focus modes, and rich media.
///
/// ## Features
/// - 🔔 Type-safe notification scheduling
/// - 📱 Rich notification content (images, videos, buttons)
/// - ⏰ Smart scheduling with calendar/time interval triggers
/// - 🎯 Action handling with async/await support
/// - 📊 Analytics and delivery tracking
///
/// ## Quick Start
/// ```swift
/// import NotificationKit
///
/// let notification = NotificationKit.shared
///
/// // Request permission
/// try await notification.requestAuthorization()
///
/// // Schedule a notification
/// notification.schedule {
///     Notification(id: "reminder")
///         .title("Meeting in 5 minutes")
///         .body("Team standup starting soon")
///         .sound(.default)
///         .trigger(after: .minutes(5))
/// }
/// ```
@MainActor
public final class NotificationKit: Sendable {
    
    // MARK: - Singleton
    
    /// Shared instance for convenient access
    public static let shared = NotificationKit()
    
    // MARK: - Properties
    
    /// The underlying notification center
    private let center: UNUserNotificationCenter
    
    /// Current authorization status
    public private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    /// Registered notification categories
    private var categories: Set<UNNotificationCategory> = []
    
    /// Delegate for handling notification events
    public weak var delegate: NotificationKitDelegate?
    
    // MARK: - Initialization
    
    /// Creates a new NotificationKit instance
    /// - Parameter center: The notification center to use (defaults to `.current()`)
    public init(center: UNUserNotificationCenter = .current()) {
        self.center = center
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
        return granted
    }
    
    /// Updates the current authorization status
    public func updateAuthorizationStatus() async {
        let settings = await center.notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }
    
    // MARK: - Scheduling
    
    /// Schedules a notification using the builder pattern
    /// - Parameter builder: A closure that builds the notification
    public func schedule(@NotificationBuilder builder: () -> Notification) async throws {
        let notification = builder()
        let request = notification.toRequest()
        try await center.add(request)
    }
    
    /// Schedules multiple notifications at once
    /// - Parameter notifications: The notifications to schedule
    public func schedule(_ notifications: [Notification]) async throws {
        for notification in notifications {
            let request = notification.toRequest()
            try await center.add(request)
        }
    }
    
    // MARK: - Management
    
    /// Cancels a notification by its identifier
    /// - Parameter identifier: The notification identifier
    public func cancel(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    /// Cancels multiple notifications
    /// - Parameter identifiers: The notification identifiers
    public func cancel(identifiers: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    /// Cancels all pending notifications
    public func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
    
    /// Returns all pending notification requests
    public func pendingNotifications() async -> [UNNotificationRequest] {
        await center.pendingNotificationRequests()
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
    #endif
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
}

// MARK: - Default Implementation

extension NotificationKitDelegate {
    public func notificationKit(
        _ kit: NotificationKit,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .badge]
    }
    
    public func notificationKit(
        _ kit: NotificationKit,
        didReceive response: UNNotificationResponse
    ) async {
        // Default: no action
    }
}
