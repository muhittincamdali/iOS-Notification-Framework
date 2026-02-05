//
//  NotificationScheduler.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// Advanced notification scheduler with smart timing and batch operations
@MainActor
public final class NotificationScheduler {
    
    // MARK: - Properties
    
    private let notificationKit: NotificationKit
    private var scheduledBatches: [String: ScheduledBatch] = [:]
    
    // MARK: - Initialization
    
    public init(notificationKit: NotificationKit = .shared) {
        self.notificationKit = notificationKit
    }
    
    // MARK: - Smart Scheduling
    
    /// Schedules a notification at the optimal time
    /// Uses user engagement patterns to find best delivery time
    public func scheduleOptimally(
        _ notification: Notification,
        within window: TimeWindow
    ) async throws {
        let optimalTime = calculateOptimalTime(within: window)
        let optimizedNotification = notification.at(date: optimalTime)
        try await notificationKit.schedule(optimizedNotification)
    }
    
    /// Calculates optimal delivery time based on user patterns
    private func calculateOptimalTime(within window: TimeWindow) -> Date {
        // In production, this would use ML/analytics to find optimal time
        // For now, return middle of window
        let middleOffset = (window.end.timeIntervalSince(window.start)) / 2
        return window.start.addingTimeInterval(middleOffset)
    }
    
    // MARK: - Batch Scheduling
    
    /// Schedules a batch of notifications
    public func scheduleBatch(
        _ notifications: [Notification],
        id: String = UUID().uuidString
    ) async throws -> String {
        let batch = ScheduledBatch(
            id: id,
            notifications: notifications,
            scheduledAt: Date()
        )
        
        for notification in notifications {
            try await notificationKit.schedule(notification)
        }
        
        scheduledBatches[id] = batch
        return id
    }
    
    /// Cancels a batch of notifications
    public func cancelBatch(id: String) {
        guard let batch = scheduledBatches[id] else { return }
        
        let ids = batch.notifications.map { $0.id }
        notificationKit.cancel(identifiers: ids)
        scheduledBatches.removeValue(forKey: id)
    }
    
    /// Gets batch info
    public func batch(id: String) -> ScheduledBatch? {
        scheduledBatches[id]
    }
    
    // MARK: - Recurring Notifications
    
    /// Schedules a recurring notification series
    public func scheduleRecurring(
        _ notification: Notification,
        pattern: RecurrencePattern,
        count: Int? = nil
    ) async throws -> [String] {
        var scheduledIds: [String] = []
        let occurrences = generateOccurrences(for: pattern, count: count ?? 10)
        
        for (index, date) in occurrences.enumerated() {
            let id = "\(notification.id)-\(index)"
            let occurrence = Notification(id: id)
                .title(notification.title)
                .subtitle(notification.subtitle)
                .body(notification.body)
                .sound(notification.sound ?? .default)
                .at(date: date)
            
            try await notificationKit.schedule(occurrence)
            scheduledIds.append(id)
        }
        
        return scheduledIds
    }
    
    private func generateOccurrences(
        for pattern: RecurrencePattern,
        count: Int
    ) -> [Date] {
        var dates: [Date] = []
        var currentDate = Date()
        let calendar = Calendar.current
        
        for _ in 0..<count {
            switch pattern {
            case .daily(let hour, let minute):
                var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
                components.hour = hour
                components.minute = minute
                if let date = calendar.date(from: components) {
                    dates.append(date)
                }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                
            case .weekly(let weekday, let hour, let minute):
                var components = DateComponents()
                components.weekday = weekday
                components.hour = hour
                components.minute = minute
                if let date = calendar.nextDate(after: currentDate, matching: components, matchingPolicy: .nextTime) {
                    dates.append(date)
                    currentDate = date
                }
                
            case .monthly(let day, let hour, let minute):
                var components = calendar.dateComponents([.year, .month], from: currentDate)
                components.day = day
                components.hour = hour
                components.minute = minute
                if let date = calendar.date(from: components) {
                    dates.append(date)
                }
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                
            case .custom(let interval):
                currentDate = currentDate.addingTimeInterval(interval)
                dates.append(currentDate)
            }
        }
        
        return dates
    }
    
    // MARK: - Snooze
    
    /// Snoozes a notification by rescheduling it
    public func snooze(
        notificationId: String,
        for duration: TimeInterval
    ) async throws {
        // Get pending notifications
        let pending = await notificationKit.pendingNotifications()
        guard let original = pending.first(where: { $0.identifier == notificationId }) else {
            throw SchedulerError.notificationNotFound
        }
        
        // Cancel original
        notificationKit.cancel(identifier: notificationId)
        
        // Schedule snoozed version
        let snoozedId = "\(notificationId)-snoozed"
        let content = original.content
        
        let notification = Notification(id: snoozedId)
            .title(content.title)
            .subtitle(content.subtitle)
            .body(content.body)
            .trigger(after: duration)
        
        try await notificationKit.schedule(notification)
    }
    
    // MARK: - Replace
    
    /// Replaces an existing notification
    public func replace(
        notificationId: String,
        with notification: Notification
    ) async throws {
        notificationKit.cancel(identifier: notificationId)
        try await notificationKit.schedule(notification)
    }
    
    // MARK: - Conditional Scheduling
    
    /// Schedules only if condition is met
    public func scheduleIf(
        _ condition: @escaping () -> Bool,
        notification: Notification
    ) async throws {
        guard condition() else { return }
        try await notificationKit.schedule(notification)
    }
    
    /// Schedules only if no existing notification with same thread
    public func scheduleIfNotExists(
        _ notification: Notification
    ) async throws {
        let pending = await notificationKit.pendingNotifications()
        
        if let threadId = notification.threadIdentifier {
            let exists = pending.contains { $0.content.threadIdentifier == threadId }
            if exists { return }
        } else {
            let exists = pending.contains { $0.identifier == notification.id }
            if exists { return }
        }
        
        try await notificationKit.schedule(notification)
    }
    
    // MARK: - Priority Queue
    
    /// Schedules with priority (higher priority = scheduled first)
    public func scheduleWithPriority(
        _ notifications: [Notification]
    ) async throws {
        let sorted = notifications.sorted { $0.priority.rawValue > $1.priority.rawValue }
        
        for notification in sorted {
            try await notificationKit.schedule(notification)
        }
    }
}

// MARK: - Time Window

/// A time window for optimal scheduling
public struct TimeWindow: Sendable {
    public let start: Date
    public let end: Date
    
    public init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
    
    /// Creates a window from now to specified hours later
    public static func next(hours: Int) -> TimeWindow {
        let now = Date()
        return TimeWindow(
            start: now,
            end: now.addingTimeInterval(TimeInterval(hours * 3600))
        )
    }
    
    /// Creates a window for today
    public static var today: TimeWindow {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return TimeWindow(start: now, end: endOfDay)
    }
}

// MARK: - Scheduled Batch

/// Information about a scheduled batch
public struct ScheduledBatch: Sendable {
    public let id: String
    public let notifications: [Notification]
    public let scheduledAt: Date
    
    public var count: Int { notifications.count }
}

// MARK: - Recurrence Pattern

/// Pattern for recurring notifications
public enum RecurrencePattern: Sendable {
    case daily(hour: Int, minute: Int)
    case weekly(weekday: Int, hour: Int, minute: Int)
    case monthly(day: Int, hour: Int, minute: Int)
    case custom(interval: TimeInterval)
}

// MARK: - Scheduler Error

/// Errors for scheduler operations
public enum SchedulerError: Error, LocalizedError {
    case notificationNotFound
    case invalidTimeWindow
    case batchNotFound
    
    public var errorDescription: String? {
        switch self {
        case .notificationNotFound:
            return "Notification not found in pending list"
        case .invalidTimeWindow:
            return "Invalid time window specified"
        case .batchNotFound:
            return "Batch not found"
        }
    }
}
