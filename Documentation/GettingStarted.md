# Getting Started Guide

<!-- TOC START -->
## Table of Contents
- [Getting Started Guide](#getting-started-guide)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
  - [System Requirements](#system-requirements)
  - [Development Environment](#development-environment)
  - [Knowledge Requirements](#knowledge-requirements)
- [Installation](#installation)
  - [Swift Package Manager (Recommended)](#swift-package-manager-recommended)
  - [Manual Installation](#manual-installation)
  - [CocoaPods Installation](#cocoapods-installation)
- [Quick Start](#quick-start)
  - [1. Import the Framework](#1-import-the-framework)
  - [2. Initialize the Manager](#2-initialize-the-manager)
  - [3. Request Permissions](#3-request-permissions)
  - [4. Create Your First Notification](#4-create-your-first-notification)
- [Basic Configuration](#basic-configuration)
  - [Notification Categories](#notification-categories)
  - [Notification Settings](#notification-settings)
  - [Rich Media Configuration](#rich-media-configuration)
- [First Notification](#first-notification)
  - [Simple Text Notification](#simple-text-notification)
  - [Rich Media Notification](#rich-media-notification)
  - [Interactive Notification](#interactive-notification)
- [Advanced Features](#advanced-features)
  - [Scheduled Notifications](#scheduled-notifications)
  - [Recurring Notifications](#recurring-notifications)
  - [Batch Notifications](#batch-notifications)
  - [Analytics Integration](#analytics-integration)
- [Best Practices](#best-practices)
  - [1. Permission Management](#1-permission-management)
  - [2. Error Handling](#2-error-handling)
  - [3. Memory Management](#3-memory-management)
  - [4. Performance Optimization](#4-performance-optimization)
  - [5. User Experience](#5-user-experience)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
    - [1. Notifications Not Appearing](#1-notifications-not-appearing)
    - [2. Permissions Denied](#2-permissions-denied)
    - [3. Rich Media Not Loading](#3-rich-media-not-loading)
  - [Debug Mode](#debug-mode)
  - [Performance Monitoring](#performance-monitoring)
- [Next Steps](#next-steps)
  - [Explore Advanced Features](#explore-advanced-features)
  - [Read Additional Guides](#read-additional-guides)
  - [Join the Community](#join-the-community)
<!-- TOC END -->


## Overview

Welcome to the iOS Notification Framework! This comprehensive guide will help you get started with implementing advanced notifications in your iOS application. Whether you're a beginner or an experienced developer, this guide covers everything you need to know to create engaging, interactive notifications.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Basic Configuration](#basic-configuration)
- [First Notification](#first-notification)
- [Advanced Features](#advanced-features)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements

- **macOS**: 12.0+ (Monterey or later)
- **iOS**: 15.0+ (Minimum deployment target)
- **Xcode**: 15.0+ (Latest stable version)
- **Swift**: 5.9+ (Latest Swift version)
- **CocoaPods**: Optional (For dependency management)

### Development Environment

1. **Install Xcode** from the Mac App Store
2. **Update to latest version** for best compatibility
3. **Install iOS Simulator** for testing
4. **Set up Apple Developer Account** (for production)

### Knowledge Requirements

- Basic Swift programming knowledge
- Understanding of iOS development concepts
- Familiarity with Xcode IDE
- Knowledge of iOS app lifecycle

## Installation

### Swift Package Manager (Recommended)

1. **Open your Xcode project**
2. **Go to File → Add Package Dependencies**
3. **Enter the repository URL**:
   ```
   https://github.com/muhittincamdali/iOS-Notification-Framework.git
   ```
4. **Select version**: Choose the latest stable version
5. **Add to your target**: Select your app target

### Manual Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/muhittincamdali/iOS-Notification-Framework.git
   ```
2. **Add Sources folder** to your Xcode project
3. **Import the framework** in your target

### CocoaPods Installation

1. **Add to Podfile**:
   ```ruby
   pod 'iOS-Notification-Framework', :git => 'https://github.com/muhittincamdali/iOS-Notification-Framework.git'
   ```
2. **Install dependencies**:
   ```bash
   pod install
   ```

## Quick Start

### 1. Import the Framework

```swift
import NotificationFramework
```

### 2. Initialize the Manager

```swift
// Get the shared instance
let notificationManager = NotificationManager.shared

// Configure basic settings
let config = NotificationConfiguration()
config.enableRichMedia = true
config.enableCustomActions = true
config.enableAnalytics = true

notificationManager.configure(config)
```

### 3. Request Permissions

```swift
// Request notification permissions
do {
    let granted = try await notificationManager.requestPermissions()
    if granted {
        print("✅ Notification permissions granted")
    } else {
        print("❌ Notification permissions denied")
    }
} catch {
    print("❌ Error requesting permissions: \(error)")
}
```

### 4. Create Your First Notification

```swift
// Create a simple notification
let notification = NotificationContent(
    title: "Welcome!",
    body: "Thank you for using our app",
    category: "welcome"
)

// Schedule the notification
try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(5) // 5 seconds from now
)
```

## Basic Configuration

### Notification Categories

```swift
// Define notification categories
let messageCategory = NotificationCategory(
    identifier: "message",
    actions: [
        NotificationAction(title: "View", identifier: "view_action"),
        NotificationAction(title: "Reply", identifier: "reply_action"),
        NotificationAction(title: "Delete", identifier: "delete_action")
    ],
    options: [.customDismissAction]
)

let reminderCategory = NotificationCategory(
    identifier: "reminder",
    actions: [
        NotificationAction(title: "Snooze", identifier: "snooze_action"),
        NotificationAction(title: "Complete", identifier: "complete_action")
    ],
    options: [.allowInCarPlay]
)

// Register categories
notificationManager.registerCategories([messageCategory, reminderCategory])
```

### Notification Settings

```swift
// Configure notification settings
let settings = NotificationSettings()
settings.soundEnabled = true
settings.badgeEnabled = true
settings.alertEnabled = true
settings.criticalAlertsEnabled = false
settings.provisionalAuthorizationEnabled = true

// Apply settings
notificationManager.configure(settings: settings)
```

### Rich Media Configuration

```swift
// Enable rich media features
let richMediaConfig = RichMediaConfiguration()
richMediaConfig.enableImages = true
richMediaConfig.enableVideos = true
richMediaConfig.enableAudio = true
richMediaConfig.maxImageSize = CGSize(width: 400, height: 300)
richMediaConfig.maxVideoDuration = 30.0
richMediaConfig.enableProgressiveLoading = true

notificationManager.configureRichMedia(richMediaConfig)
```

## First Notification

### Simple Text Notification

```swift
// Create basic notification
let simpleNotification = NotificationContent(
    title: "Hello World!",
    body: "This is your first notification",
    category: "welcome"
)

// Schedule for immediate delivery
try await notificationManager.schedule(
    simpleNotification,
    at: Date().addingTimeInterval(3)
)
```

### Rich Media Notification

```swift
// Create rich media notification
let richNotification = RichNotificationContent(
    title: "New Product Available",
    body: "Check out our latest collection",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/product.jpg")
)

// Configure rich media settings
richNotification.imageCompression = .high
richNotification.cachePolicy = .memoryAndDisk
richNotification.progressiveLoading = true

// Schedule rich media notification
try await notificationManager.schedule(
    richNotification,
    at: Date().addingTimeInterval(10)
)
```

### Interactive Notification

```swift
// Create interactive notification
let interactiveNotification = NotificationContent(
    title: "New Message",
    body: "You have a new message from John",
    category: "message",
    actions: [
        NotificationAction(title: "View", identifier: "view_action"),
        NotificationAction(title: "Reply", identifier: "reply_action")
    ]
)

// Schedule interactive notification
try await notificationManager.schedule(
    interactiveNotification,
    at: Date().addingTimeInterval(15)
)
```

## Advanced Features

### Scheduled Notifications

```swift
// Schedule notification for specific time
let scheduledNotification = NotificationContent(
    title: "Meeting Reminder",
    body: "Your meeting starts in 30 minutes",
    category: "reminder"
)

// Schedule for specific date and time
let meetingDate = Calendar.current.date(
    byAdding: .minute,
    value: 30,
    to: Date()
)!

try await notificationManager.schedule(
    scheduledNotification,
    at: meetingDate
)
```

### Recurring Notifications

```swift
// Create recurring notification
let recurringNotification = NotificationContent(
    title: "Daily Reminder",
    body: "Don't forget to check your tasks",
    category: "daily_reminder"
)

// Schedule daily at 9:00 AM
let recurringSchedule = RecurringSchedule(
    frequency: .daily,
    time: DateComponents(hour: 9, minute: 0),
    timeZone: TimeZone.current
)

try await notificationManager.scheduleRecurring(
    recurringNotification,
    with: recurringSchedule
)
```

### Batch Notifications

```swift
// Create batch of notifications
let notifications = [
    NotificationContent(title: "Task 1", body: "Complete task 1", category: "task"),
    NotificationContent(title: "Task 2", body: "Complete task 2", category: "task"),
    NotificationContent(title: "Task 3", body: "Complete task 3", category: "task")
]

// Schedule batch with intervals
try await notificationManager.scheduleBatch(
    notifications,
    withInterval: 300 // 5 minutes between each
)
```

### Analytics Integration

```swift
// Initialize analytics
let analyticsManager = NotificationAnalyticsManager()

// Track notification delivery
analyticsManager.trackDelivery(
    notificationID: "notification_123",
    deliveryTime: Date(),
    deliveryChannel: .local
)

// Track user engagement
analyticsManager.trackEngagement(
    notificationID: "notification_123",
    action: "view",
    timestamp: Date()
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

// Request permissions if needed
if status == .notDetermined {
    let granted = try await notificationManager.requestPermissions()
    if !granted {
        print("❌ User denied notification permissions")
        return
    }
}
```

### 2. Error Handling

```swift
// Proper error handling for all operations
do {
    try await notificationManager.schedule(notification, at: targetDate)
    print("✅ Notification scheduled successfully")
} catch NotificationError.schedulingFailed {
    print("❌ Failed to schedule notification")
} catch NotificationError.permissionDenied {
    print("❌ Notification permissions denied")
} catch NotificationError.invalidContent {
    print("❌ Invalid notification content")
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

// Clear delivered notifications
notificationManager.clearDeliveredNotifications()
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

// Respect user preferences
let userPreferences = notificationManager.getUserPreferences()
if userPreferences.quietHoursEnabled {
    // Don't send notifications during quiet hours
    return
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

// Check if notifications are enabled in system settings
if settings.authorizationStatus != .authorized {
    print("❌ Notifications not authorized")
}
```

#### 2. Permissions Denied

```swift
// Handle permission denial
if status == .denied {
    // Show alert to user
    showPermissionAlert()
    
    // Provide instructions to enable in Settings
    showSettingsInstructions()
}
```

#### 3. Rich Media Not Loading

```swift
// Check network connectivity
let networkStatus = notificationManager.getNetworkStatus()
print("Network status: \(networkStatus)")

// Check media URL validity
let isValidURL = notificationManager.validateMediaURL(mediaURL)
print("URL valid: \(isValidURL)")

// Use fallback content
if !isValidURL {
    notification.fallbackContent = "Content unavailable"
}
```

### Debug Mode

```swift
// Enable debug logging
notificationManager.enableDebugMode()

// Get debug logs
notificationManager.getDebugLogs { logs in
    for log in logs {
        print("🔍 Debug: \(log)")
    }
}
```

### Performance Monitoring

```swift
// Monitor notification performance
notificationManager.startPerformanceMonitoring()

// Get performance metrics
notificationManager.getPerformanceMetrics { metrics in
    print("📊 Average scheduling time: \(metrics.averageSchedulingTime)ms")
    print("📊 Success rate: \(metrics.successRate)%")
    print("📊 Failed schedules: \(metrics.failedSchedules)")
}
```

## Next Steps

### Explore Advanced Features

1. **Rich Media Notifications**: Add images, videos, and audio
2. **Custom Actions**: Create interactive notification buttons
3. **Advanced Scheduling**: Implement recurring and conditional notifications
4. **Analytics**: Track notification performance and user engagement
5. **Localization**: Support multiple languages
6. **Accessibility**: Ensure notifications are accessible to all users

### Read Additional Guides

- [Rich Media Guide](RichMediaGuide.md) - Learn about images, videos, and audio
- [Scheduling Guide](SchedulingGuide.md) - Master advanced scheduling techniques
- [Custom Actions Guide](CustomActionsGuide.md) - Create interactive notifications
- [Analytics Guide](AnalyticsGuide.md) - Track and analyze notification performance
- [Localization Guide](LocalizationGuide.md) - Support multiple languages

### Join the Community

- **GitHub Issues**: Report bugs and request features
- **Discussions**: Ask questions and share experiences
- **Contributing**: Help improve the framework
- **Documentation**: Read comprehensive API documentation

This getting started guide provides a solid foundation for using the iOS Notification Framework. Follow these patterns to create engaging, effective notifications that enhance your app's user experience.
