import Foundation
import UserNotifications
import NotificationFramework

// MARK: - Scheduling Examples
// This file demonstrates advanced notification scheduling capabilities
// using the iOS Notification Framework.

class SchedulingExample {
    
    // MARK: - Properties
    private let notificationManager = NotificationManager.shared
    private let scheduler = NotificationScheduler(notificationManager: notificationManager)
    
    // MARK: - Initialization
    init() {
        setupScheduling()
    }
    
    // MARK: - Setup
    private func setupScheduling() {
        // Request permissions
        notificationManager.requestPermissions { [weak self] granted in
            if granted {
                print("✅ Scheduling permissions granted")
                self?.runAllSchedulingExamples()
            } else {
                print("❌ Scheduling permissions denied")
            }
        }
    }
    
    // MARK: - Basic Scheduling Examples
    
    /// Example 1: Simple scheduling
    func scheduleSimpleNotification() {
        let notification = NotificationContent(
            title: "Simple Notification",
            body: "This is a simple scheduled notification",
            category: "simple"
        )
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(10)
            )
            print("✅ Simple notification scheduled")
        } catch {
            print("❌ Failed to schedule simple notification: \(error)")
        }
    }
    
    /// Example 2: Precise timing
    func schedulePreciseNotification() {
        let notification = NotificationContent(
            title: "Precise Notification",
            body: "Scheduled with millisecond precision",
            category: "precise"
        )
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(15),
                withPrecision: .millisecond
            )
            print("✅ Precise notification scheduled")
        } catch {
            print("❌ Failed to schedule precise notification: \(error)")
        }
    }
    
    // MARK: - Recurring Scheduling Examples
    
    /// Example 3: Daily recurring
    func scheduleDailyRecurring() {
        let notification = NotificationContent(
            title: "Daily Reminder",
            body: "Don't forget to check your tasks",
            category: "daily_reminder"
        )
        
        let dailySchedule = RecurringSchedule(
            frequency: .daily,
            time: DateComponents(hour: 9, minute: 0),
            timeZone: TimeZone.current
        )
        
        do {
            try notificationManager.scheduleRecurring(
                notification,
                with: dailySchedule
            )
            print("✅ Daily recurring notification scheduled")
        } catch {
            print("❌ Failed to schedule daily recurring: \(error)")
        }
    }
    
    /// Example 4: Weekly recurring
    func scheduleWeeklyRecurring() {
        let notification = NotificationContent(
            title: "Weekly Summary",
            body: "Here's your weekly summary",
            category: "weekly_summary"
        )
        
        let weeklySchedule = RecurringSchedule(
            frequency: .weekly(weekday: 1), // Monday
            time: DateComponents(hour: 10, minute: 0),
            timeZone: TimeZone.current
        )
        
        do {
            try notificationManager.scheduleRecurring(
                notification,
                with: weeklySchedule
            )
            print("✅ Weekly recurring notification scheduled")
        } catch {
            print("❌ Failed to schedule weekly recurring: \(error)")
        }
    }
    
    /// Example 5: Monthly recurring
    func scheduleMonthlyRecurring() {
        let notification = NotificationContent(
            title: "Monthly Report",
            body: "Your monthly report is ready",
            category: "monthly_report"
        )
        
        let monthlySchedule = RecurringSchedule(
            frequency: .monthly(day: 15),
            time: DateComponents(hour: 14, minute: 0),
            timeZone: TimeZone.current
        )
        
        do {
            try notificationManager.scheduleRecurring(
                notification,
                with: monthlySchedule
            )
            print("✅ Monthly recurring notification scheduled")
        } catch {
            print("❌ Failed to schedule monthly recurring: \(error)")
        }
    }
    
    // MARK: - Conditional Scheduling Examples
    
    /// Example 6: Location-based scheduling
    func scheduleLocationBased() {
        let notification = NotificationContent(
            title: "Location Alert",
            body: "You're near your favorite restaurant",
            category: "location"
        )
        
        let locationCondition = NotificationCondition.location(
            latitude: 40.7128,
            longitude: -74.0060,
            radius: 1000 // 1km
        )
        
        do {
            try notificationManager.scheduleConditional(
                notification,
                conditions: [locationCondition]
            )
            print("✅ Location-based notification scheduled")
        } catch {
            print("❌ Failed to schedule location-based: \(error)")
        }
    }
    
    /// Example 7: Time-based scheduling
    func scheduleTimeBased() {
        let notification = NotificationContent(
            title: "Time Alert",
            body: "It's time for your daily check-in",
            category: "time_alert"
        )
        
        let timeCondition = NotificationCondition.time(
            start: DateComponents(hour: 9, minute: 0),
            end: DateComponents(hour: 18, minute: 0)
        )
        
        do {
            try notificationManager.scheduleConditional(
                notification,
                conditions: [timeCondition]
            )
            print("✅ Time-based notification scheduled")
        } catch {
            print("❌ Failed to schedule time-based: \(error)")
        }
    }
    
    /// Example 8: App state-based scheduling
    func scheduleAppStateBased() {
        let notification = NotificationContent(
            title: "App State Alert",
            body: "You've been away for a while",
            category: "app_state"
        )
        
        let appStateCondition = NotificationCondition.appState(
            when: .background,
            after: 300 // 5 minutes
        )
        
        do {
            try notificationManager.scheduleConditional(
                notification,
                conditions: [appStateCondition]
            )
            print("✅ App state-based notification scheduled")
        } catch {
            print("❌ Failed to schedule app state-based: \(error)")
        }
    }
    
    // MARK: - Batch Scheduling Examples
    
    /// Example 9: Batch scheduling
    func scheduleBatchNotifications() {
        let notifications = [
            NotificationContent(title: "Task 1", body: "Complete task 1", category: "task"),
            NotificationContent(title: "Task 2", body: "Complete task 2", category: "task"),
            NotificationContent(title: "Task 3", body: "Complete task 3", category: "task"),
            NotificationContent(title: "Task 4", body: "Complete task 4", category: "task"),
            NotificationContent(title: "Task 5", body: "Complete task 5", category: "task")
        ]
        
        do {
            try notificationManager.scheduleBatch(
                notifications,
                withInterval: 300 // 5 minutes between each
            )
            print("✅ Batch notifications scheduled")
        } catch {
            print("❌ Failed to schedule batch notifications: \(error)")
        }
    }
    
    /// Example 10: Custom timing batch
    func scheduleCustomTimingBatch() {
        let notifications = [
            NotificationContent(title: "Morning", body: "Good morning!", category: "greeting"),
            NotificationContent(title: "Afternoon", body: "Good afternoon!", category: "greeting"),
            NotificationContent(title: "Evening", body: "Good evening!", category: "greeting")
        ]
        
        let customTiming = [
            DateComponents(hour: 8, minute: 0),  // 8:00 AM
            DateComponents(hour: 12, minute: 0), // 12:00 PM
            DateComponents(hour: 18, minute: 0)  // 6:00 PM
        ]
        
        do {
            try notificationManager.scheduleBatch(
                notifications,
                at: customTiming
            )
            print("✅ Custom timing batch scheduled")
        } catch {
            print("❌ Failed to schedule custom timing batch: \(error)")
        }
    }
    
    // MARK: - Advanced Scheduling Examples
    
    /// Example 11: Time zone handling
    func scheduleTimeZoneSpecific() {
        let notification = NotificationContent(
            title: "Time Zone Alert",
            body: "Time zone specific notification",
            category: "timezone"
        )
        
        let tokyoTimeZone = TimeZone(identifier: "Asia/Tokyo")!
        let tokyoSchedule = RecurringSchedule(
            frequency: .daily,
            time: DateComponents(hour: 9, minute: 0),
            timeZone: tokyoTimeZone
        )
        
        do {
            try notificationManager.scheduleRecurring(
                notification,
                with: tokyoSchedule
            )
            print("✅ Time zone specific notification scheduled")
        } catch {
            print("❌ Failed to schedule time zone specific: \(error)")
        }
    }
    
    /// Example 12: Multiple conditions
    func scheduleMultipleConditions() {
        let notification = NotificationContent(
            title: "Multi-Condition Alert",
            body: "Complex condition notification",
            category: "multi_condition"
        )
        
        let locationCondition = NotificationCondition.location(
            latitude: 40.7128,
            longitude: -74.0060,
            radius: 1000
        )
        
        let timeCondition = NotificationCondition.time(
            start: DateComponents(hour: 9, minute: 0),
            end: DateComponents(hour: 18, minute: 0)
        )
        
        let appStateCondition = NotificationCondition.appState(
            when: .background,
            after: 600 // 10 minutes
        )
        
        do {
            try notificationManager.scheduleConditional(
                notification,
                conditions: [locationCondition, timeCondition, appStateCondition]
            )
            print("✅ Multi-condition notification scheduled")
        } catch {
            print("❌ Failed to schedule multi-condition: \(error)")
        }
    }
    
    // MARK: - Usage Example
    
    /// Run all scheduling examples
    func runAllSchedulingExamples() {
        print("🚀 Running Scheduling Examples...")
        
        // Basic scheduling
        scheduleSimpleNotification()
        schedulePreciseNotification()
        
        // Recurring scheduling
        scheduleDailyRecurring()
        scheduleWeeklyRecurring()
        scheduleMonthlyRecurring()
        
        // Conditional scheduling
        scheduleLocationBased()
        scheduleTimeBased()
        scheduleAppStateBased()
        
        // Batch scheduling
        scheduleBatchNotifications()
        scheduleCustomTimingBatch()
        
        // Advanced scheduling
        scheduleTimeZoneSpecific()
        scheduleMultipleConditions()
        
        print("✅ All scheduling examples completed")
    }
} 