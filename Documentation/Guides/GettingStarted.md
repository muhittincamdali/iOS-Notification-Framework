# Getting Started

Welcome to the iOS Notification Framework! This guide will help you get started with implementing rich, interactive notifications in your iOS application.

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Basic Usage](#basic-usage)
- [Rich Media Notifications](#rich-media-notifications)
- [Custom Actions](#custom-actions)
- [Advanced Features](#advanced-features)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Installation

### Swift Package Manager (Recommended)

1. **Add the dependency** to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Notification-Framework.git", from: "1.0.0")
]
```

2. **Add the target** to your app target:

```swift
targets: [
    .target(
        name: "YourApp",
        dependencies: ["NotificationFramework"]
    )
]
```

### Manual Installation

1. **Download the framework** source code
2. **Add the `Sources` folder** to your Xcode project
3. **Import the framework** in your target

## Quick Start

### 1. Import the Framework

```swift
import NotificationFramework
```

### 2. Request Permissions

```swift
let notificationManager = NotificationManager.shared

do {
    let granted = try await notificationManager.requestPermissions()
    if granted {
        print("Notification permissions granted!")
    } else {
        print("Notification permissions denied")
    }
} catch {
    print("Error requesting permissions: \(error)")
}
```

### 3. Schedule Your First Notification

```swift
let notification = NotificationContent(
    title: "Welcome!",
    body: "Thank you for using our app",
    category: "welcome"
)

do {
    try await notificationManager.schedule(
        notification,
        at: Date().addingTimeInterval(5) // 5 seconds from now
    )
    print("Notification scheduled successfully!")
} catch {
    print("Error scheduling notification: \(error)")
}
```

## Basic Usage

### Creating Notifications

```swift
// Basic notification
let basicNotification = NotificationContent(
    title: "Task Reminder",
    body: "Don't forget to complete your daily tasks",
    category: "reminder",
    priority: .normal
)

// High priority notification
let urgentNotification = NotificationContent(
    title: "Important Alert",
    body: "This requires your immediate attention",
    category: "alert",
    priority: .high
)

// Notification with custom data
let customNotification = NotificationContent(
    title: "Personalized Message",
    body: "Hello, this is your personalized notification",
    category: "personal",
    priority: .normal,
    userInfo: [
        "user_id": "12345",
        "message_type": "personal"
    ]
)
```

### Scheduling Notifications

```swift
// Schedule for specific time
let futureDate = Date().addingTimeInterval(60 * 60) // 1 hour from now
try await notificationManager.schedule(basicNotification, at: futureDate)

// Schedule with custom sound
try await notificationManager.schedule(
    urgentNotification,
    at: Date().addingTimeInterval(30),
    sound: "alert_sound.wav"
)

// Schedule with badge
try await notificationManager.schedule(
    customNotification,
    at: Date().addingTimeInterval(120),
    badge: 5
)
```

### Managing Notifications

```swift
// Get pending notifications
let pendingNotifications = try await notificationManager.getPendingNotifications()
print("Pending notifications: \(pendingNotifications.count)")

// Get delivered notifications
let deliveredNotifications = try await notificationManager.getDeliveredNotifications()
print("Delivered notifications: \(deliveredNotifications.count)")

// Remove specific notification
if let firstNotification = pendingNotifications.first {
    try await notificationManager.removePendingNotification(
        with: firstNotification.request.identifier
    )
}

// Remove all notifications
try await notificationManager.removeAllPendingNotifications()
try await notificationManager.removeAllDeliveredNotifications()
```

## Rich Media Notifications

### Creating Rich Media Notifications

```swift
let richNotification = RichNotificationContent(
    title: "New Product Available",
    body: "Check out our latest collection with amazing features",
    category: "product_launch",
    priority: .high,
    mediaURL: "https://example.com/product-image.jpg",
    mediaType: .image,
    actions: [
        NotificationAction(
            title: "View Details",
            identifier: "view_details",
            options: [.foreground]
        ),
        NotificationAction(
            title: "Add to Wishlist",
            identifier: "add_wishlist",
            options: [.authenticationRequired]
        ),
        NotificationAction(
            title: "Share",
            identifier: "share_product",
            options: [.destructive]
        )
    ]
)

try await notificationManager.scheduleRichNotification(
    richNotification,
    at: Date().addingTimeInterval(10)
)
```

### Supported Media Types

```swift
// Image notification
let imageNotification = RichNotificationContent(
    title: "Photo Update",
    body: "New photo uploaded",
    mediaURL: "https://example.com/photo.jpg",
    mediaType: .image
)

// Video notification
let videoNotification = RichNotificationContent(
    title: "Video Message",
    body: "New video message received",
    mediaURL: "https://example.com/video.mp4",
    mediaType: .video
)

// Audio notification
let audioNotification = RichNotificationContent(
    title: "Voice Message",
    body: "New voice message received",
    mediaURL: "https://example.com/audio.m4a",
    mediaType: .audio
)

// GIF notification
let gifNotification = RichNotificationContent(
    title: "Animated Content",
    body: "Check out this animated content",
    mediaURL: "https://example.com/animation.gif",
    mediaType: .gif
)
```

## Custom Actions

### Registering Action Handlers

```swift
// Register action handlers
notificationManager.registerActionHandler(for: "view_details") { action in
    print("User tapped 'View Details'")
    // Navigate to product details page
    self.navigateToProductDetails()
}

notificationManager.registerActionHandler(for: "add_wishlist") { action in
    print("User tapped 'Add to Wishlist'")
    // Add product to user's wishlist
    self.addToWishlist()
}

notificationManager.registerActionHandler(for: "share_product") { action in
    print("User tapped 'Share'")
    // Share product with friends
    self.shareProduct()
}
```

### Action Options

```swift
// Foreground action (opens app)
let foregroundAction = NotificationAction(
    title: "Open App",
    identifier: "open_app",
    options: [.foreground]
)

// Authentication required action
let secureAction = NotificationAction(
    title: "Purchase",
    identifier: "purchase",
    options: [.authenticationRequired]
)

// Destructive action (red text)
let destructiveAction = NotificationAction(
    title: "Delete",
    identifier: "delete",
    options: [.destructive]
)

// Multiple options
let complexAction = NotificationAction(
    title: "Secure Purchase",
    identifier: "secure_purchase",
    options: [.foreground, .authenticationRequired, .destructive]
)
```

## Advanced Features

### Recurring Notifications

```swift
// Daily reminder
let dailySchedule = RecurringSchedule(
    interval: .daily,
    startDate: Date(),
    timeComponents: DateComponents(hour: 9, minute: 0) // 9:00 AM
)

let dailyNotification = NotificationContent(
    title: "Daily Reminder",
    body: "Don't forget to check your daily tasks",
    category: "daily_reminder"
)

try await notificationManager.scheduleRecurringNotification(
    dailyNotification,
    with: dailySchedule
)

// Weekly reminder
let weeklySchedule = RecurringSchedule(
    interval: .weekly,
    startDate: Date(),
    timeComponents: DateComponents(weekday: 1, hour: 10, minute: 0) // Monday 10:00 AM
)

let weeklyNotification = NotificationContent(
    title: "Weekly Summary",
    body: "Here's your weekly activity summary",
    category: "weekly_summary"
)

try await notificationManager.scheduleRecurringNotification(
    weeklyNotification,
    with: weeklySchedule
)
```

### Analytics and Tracking

```swift
// Get analytics data
let analytics = try await notificationManager.getAnalytics()

print("Notification Analytics:")
print("- Total Events: \(analytics.totalEvents)")
print("- Scheduled: \(analytics.scheduledCount)")
print("- Received: \(analytics.receivedCount)")
print("- Responses: \(analytics.responseCount)")
print("- Delivery Rate: \(analytics.deliveryRate * 100)%")
print("- Response Rate: \(analytics.responseRate * 100)%")

// Track custom events
notificationManager.trackEvent(.notificationScheduled, metadata: [
    "category": "custom",
    "priority": "high",
    "user_type": "premium"
])

// Export analytics
let jsonData = try analytics.exportToJSON()
print("Analytics exported: \(jsonData.count) bytes")
```

### Error Handling

```swift
do {
    let granted = try await notificationManager.requestPermissions()
    if granted {
        try await notificationManager.schedule(notification, at: Date().addingTimeInterval(5))
    }
} catch NotificationError.permissionDenied {
    print("User denied notification permissions")
    // Handle permission denial
} catch NotificationError.schedulingFailed {
    print("Failed to schedule notification")
    // Handle scheduling failure
} catch NotificationError.contentInvalid {
    print("Invalid notification content")
    // Handle invalid content
} catch {
    print("Unexpected error: \(error)")
    // Handle other errors
}
```

## Best Practices

### 1. Permission Management

```swift
// Always check permissions before scheduling
let status = try await notificationManager.getAuthorizationStatus()
switch status {
case .authorized:
    // Schedule notifications
    break
case .denied:
    // Show settings prompt
    showSettingsPrompt()
case .notDetermined:
    // Request permissions
    try await notificationManager.requestPermissions()
default:
    break
}
```

### 2. Content Guidelines

```swift
// Keep titles short and clear
let goodTitle = "New Message"
let badTitle = "You have received a new message from your friend John Doe"

// Use descriptive but concise body text
let goodBody = "John sent you a message"
let badBody = "Your friend John Doe has sent you a new message that you should read"

// Use appropriate categories
let notification = NotificationContent(
    title: "New Message",
    body: "John sent you a message",
    category: "messages" // Consistent category
)
```

### 3. Timing Considerations

```swift
// Avoid sending notifications during quiet hours
let currentHour = Calendar.current.component(.hour, from: Date())
if currentHour >= 22 || currentHour <= 8 {
    // Don't schedule notifications during quiet hours
    return
}

// Use appropriate delays
let immediateNotification = Date().addingTimeInterval(5) // 5 seconds
let shortDelay = Date().addingTimeInterval(60) // 1 minute
let longDelay = Date().addingTimeInterval(3600) // 1 hour
```

### 4. Performance Optimization

```swift
// Batch multiple notifications
let notifications = [notification1, notification2, notification3]
for (index, notification) in notifications.enumerated() {
    let delay = TimeInterval(index) * 10 // 10 seconds apart
    try await notificationManager.schedule(notification, at: Date().addingTimeInterval(delay))
}

// Clean up old notifications
try await notificationManager.removeAllDeliveredNotifications()
```

## Troubleshooting

### Common Issues

#### 1. Permissions Not Granted

```swift
// Check if permissions are granted
let status = try await notificationManager.getAuthorizationStatus()
if status != .authorized {
    // Show settings prompt
    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsUrl)
    }
}
```

#### 2. Notifications Not Appearing

```swift
// Check if app is in foreground
if UIApplication.shared.applicationState == .active {
    // Show in-app notification instead
    showInAppNotification()
} else {
    // Schedule system notification
    try await notificationManager.schedule(notification, at: Date().addingTimeInterval(5))
}
```

#### 3. Rich Media Not Loading

```swift
// Ensure media URL is accessible
guard let url = URL(string: mediaURL),
      let data = try? Data(contentsOf: url) else {
    // Fallback to basic notification
    let basicNotification = NotificationContent(
        title: richNotification.title,
        body: richNotification.body,
        category: richNotification.category
    )
    try await notificationManager.schedule(basicNotification, at: date)
    return
}
```

#### 4. Actions Not Working

```swift
// Ensure action handlers are registered before scheduling
notificationManager.registerActionHandler(for: "action_id") { action in
    // Handle action
}

// Then schedule notification with actions
let notification = RichNotificationContent(
    title: "Test",
    body: "Test notification",
    actions: [NotificationAction(title: "Test", identifier: "action_id")]
)
```

### Debug Information

```swift
// Enable debug logging
NotificationManager.shared.enableDebugLogging = true

// Check notification center
let center = UNUserNotificationCenter.current()
center.getPendingNotificationRequests { requests in
    print("Pending requests: \(requests.count)")
    for request in requests {
        print("- \(request.identifier): \(request.content.title)")
    }
}
```

## Next Steps

Now that you have the basics, explore these advanced topics:

- [API Reference](../API/APIReference.md) - Complete API documentation
- [Best Practices](../Guides/BestPractices.md) - Advanced usage patterns
- [Examples](../../Examples/) - Complete code examples

## Support

If you encounter any issues:

1. **Check the documentation** - Most issues are covered in the guides
2. **Review examples** - See how others have implemented similar features
3. **Search issues** - Check if your issue has been reported
4. **Create an issue** - Report bugs or request features

Happy coding! 🚀
