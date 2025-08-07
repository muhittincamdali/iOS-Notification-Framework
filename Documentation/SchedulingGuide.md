# Advanced Scheduling Guide

## Overview

The Advanced Scheduling module provides comprehensive notification scheduling capabilities for iOS applications, including precise timing, recurring notifications, conditional scheduling, and batch operations. This guide covers everything you need to know about implementing advanced notification scheduling in your iOS app.

## Table of Contents

- [Getting Started](#getting-started)
- [Basic Scheduling](#basic-scheduling)
- [Precise Timing](#precise-timing)
- [Recurring Notifications](#recurring-notifications)
- [Conditional Scheduling](#conditional-scheduling)
- [Batch Operations](#batch-operations)
- [Time Zone Support](#time-zone-support)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
- Notification permissions granted

### Installation

Add the framework to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Notification-Framework.git", from: "1.0.0")
]
```

### Basic Setup

```swift
import NotificationFramework

// Initialize notification manager
let notificationManager = NotificationManager.shared

// Request permissions
let granted = try await notificationManager.requestPermissions()
if granted {
    print("✅ Notification permissions granted")
} else {
    print("❌ Notification permissions denied")
}
```

## Basic Scheduling

### Simple Notification

```swift
// Create simple notification
let notification = NotificationContent(
    title: "Welcome!",
    body: "Thank you for using our app",
    category: "welcome"
)

// Schedule for 5 seconds from now
try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(5)
)
```

### Scheduled Notification

```swift
// Create notification for specific date
let meetingNotification = NotificationContent(
    title: "Meeting Reminder",
    body: "Your meeting starts in 30 minutes",
    category: "meeting"
)

// Schedule for specific date and time
let meetingDate = Calendar.current.date(
    byAdding: .minute,
    value: 30,
    to: Date()
)!

try await notificationManager.schedule(
    meetingNotification,
    at: meetingDate
)
```

## Precise Timing

### Millisecond Precision

```swift
// Schedule with millisecond precision
let preciseNotification = NotificationContent(
    title: "Precise Timing",
    body: "This notification is scheduled with millisecond precision",
    category: "precise"
)

try await notificationManager.schedule(
    preciseNotification,
    at: Date().addingTimeInterval(1.5),
    withPrecision: .millisecond
)
```

### Custom Precision Levels

```swift
// Different precision levels
enum NotificationPrecision {
    case second      // 1 second precision
    case millisecond // 1 millisecond precision
    case microsecond // 1 microsecond precision
}

// Schedule with custom precision
try await notificationManager.schedule(
    notification,
    at: targetDate,
    withPrecision: .millisecond
)
```

## Recurring Notifications

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

try await notificationManager.scheduleRecurring(
    dailyReminder,
    with: dailySchedule
)
```

### Weekly Recurring

```swift
// Create weekly recurring notification
let weeklyReminder = NotificationContent(
    title: "Weekly Report",
    body: "Time to review your weekly progress",
    category: "weekly_report"
)

// Schedule every Monday at 10:00 AM
let weeklySchedule = RecurringSchedule(
    frequency: .weekly,
    weekday: 1, // Monday
    time: DateComponents(hour: 10, minute: 0)
)

try await notificationManager.scheduleRecurring(
    weeklyReminder,
    with: weeklySchedule
)
```

### Monthly Recurring

```swift
// Create monthly recurring notification
let monthlyReminder = NotificationContent(
    title: "Monthly Review",
    body: "Time for your monthly performance review",
    category: "monthly_review"
)

// Schedule on the 1st of every month at 9:00 AM
let monthlySchedule = RecurringSchedule(
    frequency: .monthly,
    day: 1,
    time: DateComponents(hour: 9, minute: 0)
)

try await notificationManager.scheduleRecurring(
    monthlyReminder,
    with: monthlySchedule
)
```

### Custom Recurring Patterns

```swift
// Create custom recurring pattern
let customReminder = NotificationContent(
    title: "Custom Pattern",
    body: "This follows a custom recurring pattern",
    category: "custom_pattern"
)

// Schedule every 3 days at 2:00 PM
let customSchedule = RecurringSchedule(
    frequency: .custom,
    interval: 3, // Every 3 days
    time: DateComponents(hour: 14, minute: 0)
)

try await notificationManager.scheduleRecurring(
    customReminder,
    with: customSchedule
)
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
    radius: 1000 // 1km radius
)

// Schedule with location condition
try await notificationManager.scheduleConditional(
    locationNotification,
    conditions: [locationCondition]
)
```

### Time-Based Conditions

```swift
// Create time-based notification
let timeNotification = NotificationContent(
    title: "Time Alert",
    body: "This notification only appears during business hours",
    category: "time_based"
)

// Define time condition (9 AM to 6 PM)
let timeCondition = NotificationCondition.time(
    start: DateComponents(hour: 9, minute: 0),
    end: DateComponents(hour: 18, minute: 0)
)

// Schedule with time condition
try await notificationManager.scheduleConditional(
    timeNotification,
    conditions: [timeCondition]
)
```

### App State Conditions

```swift
// Create app state-based notification
let appStateNotification = NotificationContent(
    title: "App State Alert",
    body: "This notification appears when app is in background",
    category: "app_state"
)

// Define app state condition
let appStateCondition = NotificationCondition.appState(
    when: .background,
    after: 300 // 5 minutes
)

// Schedule with app state condition
try await notificationManager.scheduleConditional(
    appStateNotification,
    conditions: [appStateCondition]
)
```

### Multiple Conditions

```swift
// Create notification with multiple conditions
let multiConditionNotification = NotificationContent(
    title: "Multi-Condition Alert",
    body: "This notification meets multiple conditions",
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
    after: 300
)

// Schedule with multiple conditions (ALL must be met)
try await notificationManager.scheduleConditional(
    multiConditionNotification,
    conditions: [locationCondition, timeCondition, appStateCondition]
)
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

// Schedule batch with 5-minute intervals
try await notificationManager.scheduleBatch(
    notifications,
    withInterval: 300 // 5 minutes between each
)
```

### Progressive Batch Scheduling

```swift
// Create progressive batch
let progressiveNotifications = [
    NotificationContent(title: "Step 1", body: "First step", category: "progressive"),
    NotificationContent(title: "Step 2", body: "Second step", category: "progressive"),
    NotificationContent(title: "Step 3", body: "Third step", category: "progressive")
]

// Schedule with increasing intervals (1min, 2min, 3min)
try await notificationManager.scheduleProgressiveBatch(
    progressiveNotifications,
    startInterval: 60,
    intervalMultiplier: 2.0
)
```

## Time Zone Support

### Automatic Time Zone Conversion

```swift
// Create notification with time zone support
let timeZoneNotification = NotificationContent(
    title: "Time Zone Alert",
    body: "This notification respects time zones",
    category: "timezone"
)

// Schedule with specific time zone
let timeZoneSchedule = RecurringSchedule(
    frequency: .daily,
    time: DateComponents(hour: 9, minute: 0),
    timeZone: TimeZone(identifier: "America/New_York")!
)

try await notificationManager.scheduleRecurring(
    timeZoneNotification,
    with: timeZoneSchedule
)
```

### User Time Zone Detection

```swift
// Automatically detect user's time zone
let userTimeZone = TimeZone.current

// Create notification for user's time zone
let userTimeZoneNotification = NotificationContent(
    title: "Your Time Zone",
    body: "This notification uses your local time zone",
    category: "user_timezone"
)

let userSchedule = RecurringSchedule(
    frequency: .daily,
    time: DateComponents(hour: 9, minute: 0),
    timeZone: userTimeZone
)

try await notificationManager.scheduleRecurring(
    userTimeZoneNotification,
    with: userSchedule
)
```

## Best Practices

### 1. Permission Management

```swift
// Always check permissions before scheduling
let status = try await notificationManager.getAuthorizationStatus()
guard status == .authorized else {
    print("❌ Notifications not authorized")
    return
}
```

### 2. Error Handling

```swift
// Proper error handling for scheduling
do {
    try await notificationManager.schedule(notification, at: targetDate)
    print("✅ Notification scheduled successfully")
} catch NotificationError.schedulingFailed {
    print("❌ Failed to schedule notification")
} catch NotificationError.permissionDenied {
    print("❌ Notification permissions denied")
} catch {
    print("❌ Unexpected error: \(error)")
}
```

### 3. Memory Management

```swift
// Cancel old notifications before scheduling new ones
notificationManager.cancelAll()

// Or cancel specific categories
notificationManager.cancelNotifications(withCategory: "old_category")
```

### 4. Performance Optimization

```swift
// Use batch operations for multiple notifications
let notifications = createNotificationBatch()
try await notificationManager.scheduleBatch(notifications, withInterval: 60)

// Instead of individual scheduling
for notification in notifications {
    try await notificationManager.schedule(notification, at: targetDate)
}
```

### 5. User Experience

```swift
// Provide user feedback
notificationManager.schedule(notification, at: targetDate) { result in
    switch result {
    case .success:
        showSuccessMessage("Notification scheduled!")
    case .failure(let error):
        showErrorMessage("Failed to schedule: \(error.localizedDescription)")
    }
}
```

## Troubleshooting

### Common Issues

#### 1. Notifications Not Appearing

```swift
// Check notification settings
let settings = await notificationManager.getNotificationSettings()
print("Alert setting: \(settings.alertSetting)")
print("Sound setting: \(settings.soundSetting)")
print("Badge setting: \(settings.badgeSetting)")
```

#### 2. Recurring Notifications Stopping

```swift
// Check if notifications are being cancelled
let pendingRequests = await notificationManager.getPendingNotificationRequests()
print("Pending notifications: \(pendingRequests.count)")

// Re-register if needed
try await notificationManager.scheduleRecurring(notification, with: schedule)
```

#### 3. Time Zone Issues

```swift
// Verify time zone settings
let currentTimeZone = TimeZone.current
print("Current time zone: \(currentTimeZone.identifier)")

// Test with specific time zone
let testTimeZone = TimeZone(identifier: "America/New_York")!
print("Test time zone: \(testTimeZone.identifier)")
```

### Debug Mode

```swift
// Enable debug logging
notificationManager.enableDebugMode()

// Check debug logs
notificationManager.getDebugLogs { logs in
    for log in logs {
        print("🔍 Debug: \(log)")
    }
}
```

### Performance Monitoring

```swift
// Monitor scheduling performance
notificationManager.startPerformanceMonitoring()

// Get performance metrics
notificationManager.getPerformanceMetrics { metrics in
    print("📊 Average scheduling time: \(metrics.averageSchedulingTime)ms")
    print("📊 Success rate: \(metrics.successRate)%")
    print("📊 Failed schedules: \(metrics.failedSchedules)")
}
```

## Advanced Features

### Custom Scheduling Algorithms

```swift
// Implement custom scheduling algorithm
class CustomScheduler {
    func scheduleWithCustomAlgorithm(
        _ notification: NotificationContent,
        algorithm: SchedulingAlgorithm
    ) async throws {
        switch algorithm {
        case .exponentialBackoff:
            try await scheduleWithExponentialBackoff(notification)
        case .adaptiveTiming:
            try await scheduleWithAdaptiveTiming(notification)
        case .userBehaviorBased:
            try await scheduleBasedOnUserBehavior(notification)
        }
    }
}
```

### Machine Learning Integration

```swift
// Use ML for optimal scheduling
class MLScheduler {
    func scheduleWithML(
        _ notification: NotificationContent,
        userBehavior: UserBehaviorData
    ) async throws {
        let optimalTime = predictOptimalTime(userBehavior)
        try await notificationManager.schedule(notification, at: optimalTime)
    }
}
```

This comprehensive guide covers all aspects of advanced notification scheduling in the iOS Notification Framework. Follow these patterns to create engaging, well-timed notifications that enhance user experience.
