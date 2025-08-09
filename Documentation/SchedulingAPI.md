# Scheduling API

<!-- TOC START -->
## Table of Contents
- [Scheduling API](#scheduling-api)
- [Overview](#overview)
- [Core Classes](#core-classes)
  - [NotificationScheduler](#notificationscheduler)
  - [RecurringSchedule](#recurringschedule)
  - [RecurringFrequency](#recurringfrequency)
  - [NotificationCondition](#notificationcondition)
- [Basic Scheduling](#basic-scheduling)
  - [Simple Scheduling](#simple-scheduling)
  - [Immediate Scheduling](#immediate-scheduling)
  - [Delayed Scheduling](#delayed-scheduling)
- [Recurring Scheduling](#recurring-scheduling)
  - [Daily Recurring](#daily-recurring)
  - [Weekly Recurring](#weekly-recurring)
  - [Monthly Recurring](#monthly-recurring)
  - [Custom Interval Recurring](#custom-interval-recurring)
- [Conditional Scheduling](#conditional-scheduling)
  - [Location-Based Scheduling](#location-based-scheduling)
  - [Time-Based Scheduling](#time-based-scheduling)
  - [App State-Based Scheduling](#app-state-based-scheduling)
  - [Multiple Conditions](#multiple-conditions)
- [Batch Operations](#batch-operations)
  - [Batch Scheduling](#batch-scheduling)
  - [Batch with Custom Timing](#batch-with-custom-timing)
- [Advanced Features](#advanced-features)
  - [Precise Timing](#precise-timing)
  - [Time Zone Handling](#time-zone-handling)
  - [Calendar Integration](#calendar-integration)
- [Error Handling](#error-handling)
  - [Scheduling Errors](#scheduling-errors)
- [Best Practices](#best-practices)
  - [Scheduling Guidelines](#scheduling-guidelines)
  - [Performance Considerations](#performance-considerations)
<!-- TOC END -->


## Overview

The Scheduling API provides advanced notification scheduling capabilities with precise timing, recurring patterns, conditional scheduling, and batch operations for iOS applications.

## Core Classes

### NotificationScheduler

```swift
public class NotificationScheduler {
    // MARK: - Properties
    public let notificationManager: NotificationManager
    public let calendar: Calendar
    public let timeZone: TimeZone
    
    // MARK: - Initialization
    public init(notificationManager: NotificationManager, calendar: Calendar = .current, timeZone: TimeZone = .current)
}
```

### RecurringSchedule

```swift
public struct RecurringSchedule {
    // MARK: - Properties
    public let frequency: RecurringFrequency
    public let time: DateComponents
    public let timeZone: TimeZone
    public let startDate: Date?
    public let endDate: Date?
    public let maxOccurrences: Int?
    
    // MARK: - Initialization
    public init(
        frequency: RecurringFrequency,
        time: DateComponents,
        timeZone: TimeZone = .current,
        startDate: Date? = nil,
        endDate: Date? = nil,
        maxOccurrences: Int? = nil
    )
}
```

### RecurringFrequency

```swift
public enum RecurringFrequency {
    case daily
    case weekly(weekday: Int)
    case monthly(day: Int)
    case yearly(month: Int, day: Int)
    case custom(interval: TimeInterval)
}
```

### NotificationCondition

```swift
public enum NotificationCondition {
    case location(latitude: Double, longitude: Double, radius: Double)
    case time(start: DateComponents, end: DateComponents)
    case appState(when: AppState, after: TimeInterval)
    case network(connectionType: NetworkConnectionType)
    case battery(level: Float, isCharging: Bool?)
    case custom(predicate: (NotificationContent) -> Bool)
}
```

## Basic Scheduling

### Simple Scheduling

```swift
// Schedule notification for specific time
let notification = NotificationContent(
    title: "Meeting Reminder",
    body: "Your meeting starts in 5 minutes",
    category: "meeting"
)

let meetingDate = Calendar.current.date(
    byAdding: .minute,
    value: 5,
    to: Date()
)!

do {
    try notificationManager.schedule(
        notification,
        at: meetingDate,
        withPrecision: .second
    )
    print("✅ Meeting notification scheduled successfully")
} catch {
    print("❌ Failed to schedule meeting notification: \(error)")
}
```

### Immediate Scheduling

```swift
// Schedule notification for immediate delivery
let immediateNotification = NotificationContent(
    title: "Welcome!",
    body: "Thank you for using our app",
    category: "welcome"
)

do {
    try notificationManager.schedule(
        immediateNotification,
        at: Date().addingTimeInterval(1) // 1 second from now
    )
    print("✅ Immediate notification scheduled")
} catch {
    print("❌ Failed to schedule immediate notification: \(error)")
}
```

### Delayed Scheduling

```swift
// Schedule notification with delay
let delayedNotification = NotificationContent(
    title: "Delayed Notification",
    body: "This notification was scheduled with a delay",
    category: "delayed"
)

let delay: TimeInterval = 3600 // 1 hour
let scheduledDate = Date().addingTimeInterval(delay)

do {
    try notificationManager.schedule(
        delayedNotification,
        at: scheduledDate
    )
    print("✅ Delayed notification scheduled for \(scheduledDate)")
} catch {
    print("❌ Failed to schedule delayed notification: \(error)")
}
```

## Recurring Scheduling

### Daily Recurring

```swift
// Create daily recurring notification
let dailyReminder = NotificationContent(
    title: "Daily Reminder",
    body: "Don't forget to check your tasks",
    category: "daily_reminder"
)

// Schedule daily at 9:00 AM
let dailySchedule = RecurringSchedule(
    frequency: .daily,
    time: DateComponents(hour: 9, minute: 0),
    timeZone: TimeZone.current
)

do {
    try notificationManager.scheduleRecurring(
        dailyReminder,
        with: dailySchedule
    )
    print("✅ Daily recurring notification scheduled")
} catch {
    print("❌ Failed to schedule daily recurring notification: \(error)")
}
```

### Weekly Recurring

```swift
// Create weekly recurring notification
let weeklyReminder = NotificationContent(
    title: "Weekly Summary",
    body: "Here's your weekly summary",
    category: "weekly_summary"
)

// Schedule weekly on Monday at 10:00 AM
let weeklySchedule = RecurringSchedule(
    frequency: .weekly(weekday: 1), // Monday
    time: DateComponents(hour: 10, minute: 0),
    timeZone: TimeZone.current
)

do {
    try notificationManager.scheduleRecurring(
        weeklyReminder,
        with: weeklySchedule
    )
    print("✅ Weekly recurring notification scheduled")
} catch {
    print("❌ Failed to schedule weekly recurring notification: \(error)")
}
```

### Monthly Recurring

```swift
// Create monthly recurring notification
let monthlyReminder = NotificationContent(
    title: "Monthly Report",
    body: "Your monthly report is ready",
    category: "monthly_report"
)

// Schedule monthly on the 15th at 2:00 PM
let monthlySchedule = RecurringSchedule(
    frequency: .monthly(day: 15),
    time: DateComponents(hour: 14, minute: 0),
    timeZone: TimeZone.current
)

do {
    try notificationManager.scheduleRecurring(
        monthlyReminder,
        with: monthlySchedule
    )
    print("✅ Monthly recurring notification scheduled")
} catch {
    print("❌ Failed to schedule monthly recurring notification: \(error)")
}
```

### Custom Interval Recurring

```swift
// Create custom interval recurring notification
let customReminder = NotificationContent(
    title: "Custom Interval",
    body: "Custom interval notification",
    category: "custom_interval"
)

// Schedule every 6 hours
let customSchedule = RecurringSchedule(
    frequency: .custom(interval: 6 * 3600), // 6 hours
    time: DateComponents(),
    timeZone: TimeZone.current
)

do {
    try notificationManager.scheduleRecurring(
        customReminder,
        with: customSchedule
    )
    print("✅ Custom interval recurring notification scheduled")
} catch {
    print("❌ Failed to schedule custom interval notification: \(error)")
}
```

## Conditional Scheduling

### Location-Based Scheduling

```swift
// Create location-based notification
let locationNotification = NotificationContent(
    title: "Location Alert",
    body: "You're near your favorite restaurant",
    category: "location"
)

// Define location condition
let locationCondition = NotificationCondition.location(
    latitude: 40.7128,
    longitude: -74.0060,
    radius: 1000 // 1km
)

do {
    try notificationManager.scheduleConditional(
        locationNotification,
        conditions: [locationCondition]
    )
    print("✅ Location-based notification scheduled")
} catch {
    print("❌ Failed to schedule location-based notification: \(error)")
}
```

### Time-Based Scheduling

```swift
// Create time-based notification
let timeNotification = NotificationContent(
    title: "Time Alert",
    body: "It's time for your daily check-in",
    category: "time_alert"
)

// Define time condition (9 AM to 6 PM)
let timeCondition = NotificationCondition.time(
    start: DateComponents(hour: 9, minute: 0),
    end: DateComponents(hour: 18, minute: 0)
)

do {
    try notificationManager.scheduleConditional(
        timeNotification,
        conditions: [timeCondition]
    )
    print("✅ Time-based notification scheduled")
} catch {
    print("❌ Failed to schedule time-based notification: \(error)")
}
```

### App State-Based Scheduling

```swift
// Create app state-based notification
let appStateNotification = NotificationContent(
    title: "App State Alert",
    body: "You've been away for a while",
    category: "app_state"
)

// Define app state condition
let appStateCondition = NotificationCondition.appState(
    when: .background,
    after: 300 // 5 minutes
)

do {
    try notificationManager.scheduleConditional(
        appStateNotification,
        conditions: [appStateCondition]
    )
    print("✅ App state-based notification scheduled")
} catch {
    print("❌ Failed to schedule app state-based notification: \(error)")
}
```

### Multiple Conditions

```swift
// Create notification with multiple conditions
let multiConditionNotification = NotificationContent(
    title: "Multi-Condition Alert",
    body: "Complex condition notification",
    category: "multi_condition"
)

// Define multiple conditions
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
        multiConditionNotification,
        conditions: [locationCondition, timeCondition, appStateCondition]
    )
    print("✅ Multi-condition notification scheduled")
} catch {
    print("❌ Failed to schedule multi-condition notification: \(error)")
}
```

## Batch Operations

### Batch Scheduling

```swift
// Create batch of notifications
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
    print("✅ Batch notifications scheduled successfully")
} catch {
    print("❌ Failed to schedule batch notifications: \(error)")
}
```

### Batch with Custom Timing

```swift
// Create batch with custom timing
let customBatchNotifications = [
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
        customBatchNotifications,
        at: customTiming
    )
    print("✅ Custom timing batch notifications scheduled")
} catch {
    print("❌ Failed to schedule custom timing batch: \(error)")
}
```

## Advanced Features

### Precise Timing

```swift
// Schedule with millisecond precision
let preciseNotification = NotificationContent(
    title: "Precise Timing",
    body: "Scheduled with millisecond precision",
    category: "precise"
)

let preciseDate = Date().addingTimeInterval(1.5) // 1.5 seconds

do {
    try notificationManager.schedule(
        preciseNotification,
        at: preciseDate,
        withPrecision: .millisecond
    )
    print("✅ Precise timing notification scheduled")
} catch {
    print("❌ Failed to schedule precise timing notification: \(error)")
}
```

### Time Zone Handling

```swift
// Schedule with specific time zone
let timeZoneNotification = NotificationContent(
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
        timeZoneNotification,
        with: tokyoSchedule
    )
    print("✅ Time zone specific notification scheduled")
} catch {
    print("❌ Failed to schedule time zone notification: \(error)")
}
```

### Calendar Integration

```swift
// Schedule based on calendar events
func scheduleCalendarBasedNotification() {
    let eventStore = EKEventStore()
    
    eventStore.requestAccess(to: .event) { granted, error in
        if granted {
            let calendar = Calendar.current
            let now = Date()
            let endDate = calendar.date(byAdding: .day, value: 7, to: now)!
            
            let predicate = eventStore.predicateForEvents(
                withStart: now,
                end: endDate,
                calendars: nil
            )
            
            let events = eventStore.events(matching: predicate)
            
            for event in events {
                let notification = NotificationContent(
                    title: "Calendar Event",
                    body: "Upcoming: \(event.title ?? "Event")",
                    category: "calendar"
                )
                
                do {
                    try self.notificationManager.schedule(
                        notification,
                        at: event.startDate.addingTimeInterval(-1800) // 30 minutes before
                    )
                } catch {
                    print("❌ Failed to schedule calendar notification: \(error)")
                }
            }
        }
    }
}
```

## Error Handling

### Scheduling Errors

```swift
public enum SchedulingError: Error {
    case invalidDate
    case pastDate
    case invalidRecurringPattern
    case conditionNotMet
    case batchSchedulingFailed
    case timeZoneError
    case calendarError
}

// Handle scheduling errors
func handleSchedulingError(_ error: Error, for notification: NotificationContent) {
    switch error {
    case SchedulingError.invalidDate:
        print("❌ Invalid date provided for scheduling")
    case SchedulingError.pastDate:
        print("❌ Cannot schedule notification in the past")
    case SchedulingError.invalidRecurringPattern:
        print("❌ Invalid recurring pattern")
    case SchedulingError.conditionNotMet:
        print("❌ Scheduling condition not met")
    case SchedulingError.batchSchedulingFailed:
        print("❌ Batch scheduling failed")
    case SchedulingError.timeZoneError:
        print("❌ Time zone error")
    case SchedulingError.calendarError:
        print("❌ Calendar error")
    default:
        print("❌ Unknown scheduling error: \(error)")
    }
}
```

## Best Practices

### Scheduling Guidelines

1. **Use appropriate timing**
   - Avoid scheduling too frequently
   - Respect user preferences
   - Consider time zones

2. **Handle errors gracefully**
   - Validate dates before scheduling
   - Provide fallback options
   - Log scheduling errors

3. **Optimize for performance**
   - Use batch operations when possible
   - Limit concurrent scheduling
   - Monitor scheduling performance

4. **Test thoroughly**
   - Test all scheduling scenarios
   - Verify time zone handling
   - Test on different devices

### Performance Considerations

- **Use batch operations** for multiple notifications
- **Limit concurrent scheduling** to avoid performance issues
- **Cache scheduling results** when appropriate
- **Monitor scheduling metrics** for optimization
- **Implement proper error handling** for reliability
