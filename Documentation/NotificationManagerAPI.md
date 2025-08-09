# NotificationManager API

<!-- TOC START -->
## Table of Contents
- [NotificationManager API](#notificationmanager-api)
- [Overview](#overview)
- [Class Definition](#class-definition)
- [Core Methods](#core-methods)
  - [Authorization](#authorization)
  - [Notification Scheduling](#notification-scheduling)
  - [Notification Management](#notification-management)
  - [Rich Media Support](#rich-media-support)
  - [Analytics Integration](#analytics-integration)
- [Configuration](#configuration)
  - [NotificationConfiguration](#notificationconfiguration)
  - [NotificationSettings](#notificationsettings)
- [Usage Examples](#usage-examples)
  - [Basic Setup](#basic-setup)
  - [Schedule Simple Notification](#schedule-simple-notification)
  - [Schedule Rich Media Notification](#schedule-rich-media-notification)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)
- [Performance Considerations](#performance-considerations)
- [Security Notes](#security-notes)
<!-- TOC END -->


## Overview

The `NotificationManager` class is the core component of the iOS Notification Framework, providing comprehensive notification management capabilities for iOS applications.

## Class Definition

```swift
public class NotificationManager: NSObject {
    public static let shared = NotificationManager()
    
    // MARK: - Properties
    public var configuration: NotificationConfiguration
    public var isAuthorized: Bool { get }
    public var authorizationStatus: UNAuthorizationStatus { get }
    
    // MARK: - Initialization
    public override init()
    public init(configuration: NotificationConfiguration)
}
```

## Core Methods

### Authorization

```swift
// Request notification permissions
public func requestPermissions(completion: @escaping (Bool) -> Void)

// Check current authorization status
public func checkAuthorizationStatus() -> UNAuthorizationStatus

// Request specific permission types
public func requestPermissions(
    types: UNAuthorizationOptions,
    completion: @escaping (Bool) -> Void
)
```

### Notification Scheduling

```swift
// Schedule a single notification
public func schedule(
    _ notification: NotificationContent,
    at date: Date,
    withPrecision precision: NotificationPrecision = .second
) throws

// Schedule recurring notification
public func scheduleRecurring(
    _ notification: NotificationContent,
    with schedule: RecurringSchedule
) throws

// Schedule conditional notification
public func scheduleConditional(
    _ notification: NotificationContent,
    conditions: [NotificationCondition]
) throws

// Schedule batch notifications
public func scheduleBatch(
    _ notifications: [NotificationContent],
    withInterval interval: TimeInterval
) throws
```

### Notification Management

```swift
// Cancel specific notification
public func cancel(notificationID: String)

// Cancel all notifications
public func cancelAll()

// Cancel notifications by category
public func cancelNotifications(in category: String)

// Get pending notifications
public func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void)

// Get delivered notifications
public func getDeliveredNotifications(completion: @escaping ([UNNotification]) -> Void)
```

### Rich Media Support

```swift
// Schedule rich media notification
public func schedule(
    _ notification: RichNotificationContent,
    at date: Date
) throws

// Configure rich media settings
public func configureRichMedia(_ settings: RichMediaSettings)
```

### Analytics Integration

```swift
// Track notification delivery
public func trackDelivery(
    notificationID: String,
    deliveryTime: Date,
    deliveryChannel: DeliveryChannel
)

// Track user engagement
public func trackEngagement(
    notificationID: String,
    action: String,
    timestamp: Date
)

// Get analytics data
public func getAnalytics(completion: @escaping (NotificationAnalytics) -> Void)
```

## Configuration

### NotificationConfiguration

```swift
public struct NotificationConfiguration {
    public var enableRichMedia: Bool
    public var enableCustomActions: Bool
    public var enableAnalytics: Bool
    public var enableAccessibility: Bool
    public var enableLocalization: Bool
    public var defaultSound: UNNotificationSound?
    public var defaultBadge: Int
    public var defaultCategory: String?
}
```

### NotificationSettings

```swift
public struct NotificationSettings {
    public var soundEnabled: Bool
    public var badgeEnabled: Bool
    public var alertEnabled: Bool
    public var criticalAlertsEnabled: Bool
    public var provisionalAuthorizationEnabled: Bool
    public var announcementEnabled: Bool
    public var carPlayEnabled: Bool
}
```

## Usage Examples

### Basic Setup

```swift
import NotificationFramework

// Initialize notification manager
let notificationManager = NotificationManager.shared

// Configure settings
let config = NotificationConfiguration()
config.enableRichMedia = true
config.enableCustomActions = true
config.enableAnalytics = true

// Request permissions
notificationManager.requestPermissions { granted in
    if granted {
        print("✅ Notification permissions granted")
    } else {
        print("❌ Notification permissions denied")
    }
}
```

### Schedule Simple Notification

```swift
// Create notification content
let notification = NotificationContent(
    title: "Welcome!",
    body: "Thank you for using our app",
    category: "welcome"
)

// Schedule notification
do {
    try notificationManager.schedule(
        notification,
        at: Date().addingTimeInterval(60)
    )
    print("✅ Notification scheduled successfully")
} catch {
    print("❌ Failed to schedule notification: \(error)")
}
```

### Schedule Rich Media Notification

```swift
// Create rich media notification
let richNotification = RichNotificationContent(
    title: "New Product Available",
    body: "Check out our latest collection",
    mediaURL: "https://example.com/image.jpg",
    actions: [
        NotificationAction(title: "View", identifier: "view_action"),
        NotificationAction(title: "Share", identifier: "share_action")
    ]
)

// Schedule rich media notification
do {
    try notificationManager.schedule(
        richNotification,
        at: Date().addingTimeInterval(120)
    )
} catch {
    print("❌ Failed to schedule rich media notification: \(error)")
}
```

## Error Handling

The NotificationManager throws specific errors for different failure scenarios:

```swift
public enum NotificationError: Error {
    case permissionDenied
    case invalidConfiguration
    case schedulingFailed
    case mediaDownloadFailed
    case analyticsError
    case accessibilityError
    case localizationError
}
```

## Best Practices

1. **Always check permissions** before scheduling notifications
2. **Use meaningful notification IDs** for better management
3. **Handle errors appropriately** in production code
4. **Test on real devices** for accurate behavior
5. **Follow Apple's guidelines** for notification content
6. **Implement proper analytics** for user engagement tracking
7. **Consider accessibility** for all notification types
8. **Use localization** for global applications

## Performance Considerations

- **Batch operations** for multiple notifications
- **Efficient media handling** for rich notifications
- **Memory management** for large notification sets
- **Background processing** for analytics
- **Caching strategies** for media content

## Security Notes

- **Validate all inputs** before scheduling
- **Sanitize user content** in notifications
- **Handle sensitive data** appropriately
- **Follow privacy guidelines** for user data
- **Implement proper error handling** for security
