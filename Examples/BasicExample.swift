//
//  BasicExample.swift
//  NotificationKit Examples
//
//  Created by Muhittin Camdali
//

import NotificationKit
import UserNotifications

// MARK: - Basic Notification

/// Schedule a simple notification
func scheduleBasicNotification() async throws {
    try await NotificationKit.shared.schedule {
        Notification(id: "basic-reminder")
            .title("Reminder")
            .body("Don't forget to drink water!")
            .sound(.default)
            .trigger(after: .hours(1))
    }
}

// MARK: - Rich Notification

/// Schedule a notification with image attachment
func scheduleRichNotification(imageURL: URL) async throws {
    try await NotificationKit.shared.schedule {
        Notification(id: "promo-notification")
            .title("New Sale!")
            .subtitle("Limited Time Offer")
            .body("Get 50% off all items today only")
            .attachment(imageURL)
            .sound(.default)
            .relevanceScore(0.9)
    }
}

// MARK: - Daily Reminder

/// Schedule a daily recurring notification
func scheduleDailyReminder() async throws {
    try await NotificationKit.shared.schedule {
        Notification(id: "daily-standup")
            .title("Team Standup")
            .body("Daily standup meeting in 5 minutes")
            .sound(.default)
            .trigger(.daily(at: 9, minute: 55, repeats: true))
    }
}

// MARK: - Interactive Notification

/// Set up interactive notification with actions
func setupInteractiveNotifications() {
    // Register category
    NotificationKit.shared.register(
        category: NotificationCategory(identifier: "MESSAGE_CATEGORY")
            .action(.reply)
            .action(.view)
            .action(
                NotificationAction(identifier: "MARK_READ", title: "Mark as Read")
            )
            .options([.customDismissAction])
    )
}

/// Schedule an interactive notification
func scheduleInteractiveNotification() async throws {
    try await NotificationKit.shared.schedule {
        Notification(id: "new-message")
            .title("John Doe")
            .body("Hey, are you free for lunch?")
            .category("MESSAGE_CATEGORY")
            .thread("conversation-john")
            .sound(.default)
    }
}

// MARK: - Time Sensitive Notification

/// Schedule a time-sensitive notification (iOS 15+)
func scheduleTimeSensitiveNotification() async throws {
    try await NotificationKit.shared.schedule {
        Notification(id: "security-alert")
            .title("Security Alert")
            .body("Unusual login attempt detected")
            .timeSensitive()
            .sound(.defaultCritical)
    }
}

// MARK: - Notification Management

/// Cancel a specific notification
func cancelReminder() {
    NotificationKit.shared.cancel(identifier: "basic-reminder")
}

/// Get all pending notifications
func listPendingNotifications() async {
    let pending = await NotificationKit.shared.pendingNotifications()
    for request in pending {
        print("Pending: \(request.identifier) - \(request.content.title)")
    }
}
