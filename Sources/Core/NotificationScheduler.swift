//
//  NotificationScheduler.swift
//  NotificationFramework
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// Handles scheduling of recurring notifications.
///
/// This class provides functionality for creating and managing recurring
/// notifications with various intervals and conditions.
///
/// ## Example Usage
/// ```swift
/// let scheduler = NotificationScheduler()
/// let requests = try await scheduler.scheduleRecurring(content, schedule: schedule)
/// ```
@available(iOS 15.0, *)
public class NotificationScheduler {
    
    // MARK: - Properties
    
    /// Maximum number of notifications that can be scheduled.
    private let maxNotifications = 64
    
    /// Calendar for date calculations.
    private let calendar = Calendar.current
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Methods
    
    /// Schedules recurring notifications based on a schedule.
    ///
    /// - Parameters:
    ///   - content: The notification content to schedule.
    ///   - schedule: The recurring schedule configuration.
    /// - Returns: Array of scheduled notification requests.
    /// - Throws: `NotificationError` if scheduling fails.
    public func scheduleRecurring(
        _ content: NotificationContent,
        schedule: RecurringSchedule
    ) async throws -> [UNNotificationRequest] {
        
        // Validate schedule
        try validateSchedule(schedule)
        
        // Calculate notification dates
        let dates = try calculateNotificationDates(for: schedule)
        
        // Create notification requests
        var requests: [UNNotificationRequest] = []
        
        for (index, date) in dates.enumerated() {
            let identifier = "\(content.category)_recurring_\(index)"
            
            let request = try await createRecurringRequest(
                content: content,
                date: date,
                identifier: identifier
            )
            
            requests.append(request)
        }
        
        return requests
    }
    
    /// Schedules notifications for specific dates.
    ///
    /// - Parameters:
    ///   - content: The notification content to schedule.
    ///   - dates: Array of dates when notifications should be delivered.
    /// - Returns: Array of scheduled notification requests.
    /// - Throws: `NotificationError` if scheduling fails.
    public func scheduleForDates(
        _ content: NotificationContent,
        dates: [Date]
    ) async throws -> [UNNotificationRequest] {
        
        guard !dates.isEmpty else {
            throw NotificationError.invalidContent("No dates provided for scheduling")
        }
        
        var requests: [UNNotificationRequest] = []
        
        for (index, date) in dates.enumerated() {
            let identifier = "\(content.category)_date_\(index)"
            
            let request = try await createRecurringRequest(
                content: content,
                date: date,
                identifier: identifier
            )
            
            requests.append(request)
        }
        
        return requests
    }
    
    /// Schedules notifications for specific times on given days.
    ///
    /// - Parameters:
    ///   - content: The notification content to schedule.
    ///   - timeComponents: The time components for notifications.
    ///   - days: Array of days when notifications should be delivered.
    /// - Returns: Array of scheduled notification requests.
    /// - Throws: `NotificationError` if scheduling fails.
    public func scheduleForDays(
        _ content: NotificationContent,
        timeComponents: DateComponents,
        days: [Date]
    ) async throws -> [UNNotificationRequest] {
        
        guard !days.isEmpty else {
            throw NotificationError.invalidContent("No days provided for scheduling")
        }
        
        var requests: [UNNotificationRequest] = []
        
        for (index, day) in days.enumerated() {
            let notificationDate = calendar.date(
                bySettingHour: timeComponents.hour ?? 0,
                minute: timeComponents.minute ?? 0,
                second: timeComponents.second ?? 0,
                of: day
            ) ?? day
            
            let identifier = "\(content.category)_day_\(index)"
            
            let request = try await createRecurringRequest(
                content: content,
                date: notificationDate,
                identifier: identifier
            )
            
            requests.append(request)
        }
        
        return requests
    }
    
    // MARK: - Private Methods
    
    /// Validates a recurring schedule.
    private func validateSchedule(_ schedule: RecurringSchedule) throws {
        if schedule.startDate <= Date() {
            throw NotificationError.invalidDate(schedule.startDate)
        }
        
        if let endDate = schedule.endDate, endDate <= schedule.startDate {
            throw NotificationError.invalidContent("End date must be after start date")
        }
        
        if let maxNotifications = schedule.maxNotifications, maxNotifications > self.maxNotifications {
            throw NotificationError.tooManyNotifications(maxNotifications)
        }
    }
    
    /// Calculates notification dates for a recurring schedule.
    private func calculateNotificationDates(for schedule: RecurringSchedule) throws -> [Date] {
        var dates: [Date] = []
        var currentDate = schedule.startDate
        
        let maxCount = schedule.maxNotifications ?? maxNotifications
        
        while dates.count < maxCount {
            // Check if we've reached the end date
            if let endDate = schedule.endDate, currentDate > endDate {
                break
            }
            
            // Create notification date with time components
            let notificationDate = calendar.date(
                bySettingHour: schedule.timeComponents.hour ?? 0,
                minute: schedule.timeComponents.minute ?? 0,
                second: schedule.timeComponents.second ?? 0,
                of: currentDate
            ) ?? currentDate
            
            // Only add future dates
            if notificationDate > Date() {
                dates.append(notificationDate)
            }
            
            // Calculate next date based on interval
            currentDate = calculateNextDate(currentDate, interval: schedule.interval)
            
            // If not repeating indefinitely and we've reached the limit, stop
            if !schedule.repeatsIndefinitely && dates.count >= maxCount {
                break
            }
        }
        
        return dates
    }
    
    /// Calculates the next date based on the interval.
    private func calculateNextDate(_ date: Date, interval: RecurringInterval) -> Date {
        switch interval {
        case .minute:
            return calendar.date(byAdding: .minute, value: 1, to: date) ?? date
        case .hour:
            return calendar.date(byAdding: .hour, value: 1, to: date) ?? date
        case .daily:
            return calendar.date(byAdding: .day, value: 1, to: date) ?? date
        case .weekly:
            return calendar.date(byAdding: .weekOfYear, value: 1, to: date) ?? date
        case .monthly:
            return calendar.date(byAdding: .month, value: 1, to: date) ?? date
        case .yearly:
            return calendar.date(byAdding: .year, value: 1, to: date) ?? date
        }
    }
    
    /// Creates a recurring notification request.
    private func createRecurringRequest(
        content: NotificationContent,
        date: Date,
        identifier: String
    ) async throws -> UNNotificationRequest {
        
        // Create trigger
        let trigger = createRecurringTrigger(for: date)
        
        // Create content
        let unContent = try await createUNNotificationContent(from: content)
        
        // Create request
        let request = UNNotificationRequest(
            identifier: identifier,
            content: unContent,
            trigger: trigger
        )
        
        return request
    }
    
    /// Creates a recurring notification trigger.
    private func createRecurringTrigger(for date: Date) -> UNNotificationTrigger {
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
    
    /// Creates UNNotificationContent from NotificationContent.
    private func createUNNotificationContent(from content: NotificationContent) async throws -> UNNotificationContent {
        let unContent = UNMutableNotificationContent()
        
        unContent.title = content.title
        unContent.body = content.body
        unContent.categoryIdentifier = content.category
        unContent.sound = content.sound
        unContent.badge = content.badge
        unContent.userInfo = content.userInfo
        unContent.threadIdentifier = content.threadIdentifier
        unContent.targetContentIdentifier = content.targetContentIdentifier
        unContent.interruptionLevel = content.interruptionLevel
        unContent.relevanceScore = content.relevanceScore
        unContent.isSilent = content.isSilent
        
        return unContent
    }
}

// MARK: - Extensions

@available(iOS 15.0, *)
extension NotificationScheduler {
    
    /// Creates a daily notification schedule.
    public static func createDailySchedule(
        startDate: Date,
        timeComponents: DateComponents,
        endDate: Date? = nil,
        maxNotifications: Int? = nil
    ) -> RecurringSchedule {
        return RecurringSchedule(
            interval: .daily,
            startDate: startDate,
            endDate: endDate,
            timeComponents: timeComponents,
            maxNotifications: maxNotifications
        )
    }
    
    /// Creates a weekly notification schedule.
    public static func createWeeklySchedule(
        startDate: Date,
        timeComponents: DateComponents,
        endDate: Date? = nil,
        maxNotifications: Int? = nil
    ) -> RecurringSchedule {
        return RecurringSchedule(
            interval: .weekly,
            startDate: startDate,
            endDate: endDate,
            timeComponents: timeComponents,
            maxNotifications: maxNotifications
        )
    }
    
    /// Creates a monthly notification schedule.
    public static func createMonthlySchedule(
        startDate: Date,
        timeComponents: DateComponents,
        endDate: Date? = nil,
        maxNotifications: Int? = nil
    ) -> RecurringSchedule {
        return RecurringSchedule(
            interval: .monthly,
            startDate: startDate,
            endDate: endDate,
            timeComponents: timeComponents,
            maxNotifications: maxNotifications
        )
    }
    
    /// Creates a yearly notification schedule.
    public static func createYearlySchedule(
        startDate: Date,
        timeComponents: DateComponents,
        endDate: Date? = nil,
        maxNotifications: Int? = nil
    ) -> RecurringSchedule {
        return RecurringSchedule(
            interval: .yearly,
            startDate: startDate,
            endDate: endDate,
            timeComponents: timeComponents,
            maxNotifications: maxNotifications
        )
    }
} 