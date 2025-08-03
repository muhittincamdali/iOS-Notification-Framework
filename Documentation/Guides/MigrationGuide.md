# Migration Guide

This guide helps you migrate from other notification systems to the iOS Notification Framework.

## Table of Contents

- [From UserNotifications Framework](#from-usernotifications-framework)
- [From Third-Party Libraries](#from-third-party-libraries)
- [From Custom Implementations](#from-custom-implementations)
- [Breaking Changes](#breaking-changes)
- [Deprecated Features](#deprecated-features)

## From UserNotifications Framework

### Basic Migration

**Before (UserNotifications):**
```swift
import UserNotifications

// Request permissions
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
    if granted {
        print("Permissions granted")
    }
}

// Create notification
let content = UNMutableNotificationContent()
content.title = "Hello"
content.body = "World"
content.sound = .default

let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)

UNUserNotificationCenter.current().add(request)
```

**After (iOS Notification Framework):**
```swift
import NotificationFramework

// Request permissions
let granted = try await NotificationManager.shared.requestPermissions()

// Create and schedule notification
let notification = NotificationContent(
    title: "Hello",
    body: "World",
    category: "test"
)

try await NotificationManager.shared.schedule(
    notification,
    at: Date().addingTimeInterval(5)
)
```

### Rich Media Migration

**Before (UserNotifications):**
```swift
let content = UNMutableNotificationContent()
content.title = "Rich Notification"
content.body = "With image"
content.attachments = [
    UNNotificationAttachment(
        identifier: "image",
        url: imageURL,
        options: [UNNotificationAttachmentOptionsTypeHintKey: "image/jpeg"]
    )
]

let request = UNNotificationRequest(identifier: "rich", content: content, trigger: trigger)
UNUserNotificationCenter.current().add(request)
```

**After (iOS Notification Framework):**
```swift
let richNotification = RichNotificationContent(
    title: "Rich Notification",
    body: "With image",
    mediaURL: "https://example.com/image.jpg",
    mediaType: .image
)

try await NotificationManager.shared.scheduleRichNotification(
    richNotification,
    at: Date().addingTimeInterval(5)
)
```

### Action Handling Migration

**Before (UserNotifications):**
```swift
// Create category with actions
let category = UNNotificationCategory(
    identifier: "test_category",
    actions: [
        UNNotificationAction(identifier: "action1", title: "Action 1", options: [])
    ],
    intentIdentifiers: [],
    options: []
)

UNUserNotificationCenter.current().setNotificationCategories([category])

// Handle actions in AppDelegate
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    switch response.actionIdentifier {
    case "action1":
        handleAction1()
    default:
        break
    }
    completionHandler()
}
```

**After (iOS Notification Framework):**
```swift
// Register action handlers
NotificationManager.shared.registerActionHandler(for: "action1") { action in
    self.handleAction1()
}

// Create notification with actions
let notification = RichNotificationContent(
    title: "Test",
    body: "With actions",
    actions: [
        NotificationAction(title: "Action 1", identifier: "action1")
    ]
)

try await NotificationManager.shared.scheduleRichNotification(notification, at: Date().addingTimeInterval(5))
```

## From Third-Party Libraries

### From OneSignal

**Before (OneSignal):**
```swift
import OneSignal

// Initialize
OneSignal.initialize("your-app-id", withLaunchOptions: launchOptions)

// Send notification
OneSignal.postNotification([
    "contents": ["en": "Message"],
    "headings": ["en": "Title"],
    "include_player_ids": ["player-id"]
])
```

**After (iOS Notification Framework):**
```swift
import NotificationFramework

// Initialize
let notificationManager = NotificationManager.shared

// Send notification
let notification = NotificationContent(
    title: "Title",
    body: "Message",
    category: "push"
)

try await notificationManager.schedule(notification, at: Date().addingTimeInterval(5))
```

### From Firebase Cloud Messaging

**Before (Firebase):**
```swift
import Firebase
import FirebaseMessaging

// Configure
FirebaseApp.configure()

// Handle messages
func messaging(_ messaging: Messaging, didReceiveMessage remoteMessage: MessagingRemoteMessage) {
    let notification = remoteMessage.notification
    // Handle notification
}
```

**After (iOS Notification Framework):**
```swift
import NotificationFramework

// Handle Firebase messages and convert to framework
func handleFirebaseMessage(_ remoteMessage: MessagingRemoteMessage) {
    let notification = NotificationContent(
        title: remoteMessage.notification?.title ?? "",
        body: remoteMessage.notification?.body ?? "",
        category: "firebase"
    )
    
    try await NotificationManager.shared.schedule(notification, at: Date())
}
```

## From Custom Implementations

### From Custom Notification Manager

**Before (Custom):**
```swift
class CustomNotificationManager {
    static let shared = CustomNotificationManager()
    
    func scheduleNotification(title: String, body: String, delay: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

// Usage
CustomNotificationManager.shared.scheduleNotification(
    title: "Hello",
    body: "World",
    delay: 5
)
```

**After (iOS Notification Framework):**
```swift
import NotificationFramework

// Direct replacement
let notification = NotificationContent(
    title: "Hello",
    body: "World",
    category: "custom"
)

try await NotificationManager.shared.schedule(
    notification,
    at: Date().addingTimeInterval(5)
)
```

### From Custom Analytics

**Before (Custom):**
```swift
class CustomNotificationAnalytics {
    static func trackNotificationScheduled() {
        Analytics.logEvent("notification_scheduled", parameters: [
            "timestamp": Date().timeIntervalSince1970
        ])
    }
    
    static func trackNotificationReceived() {
        Analytics.logEvent("notification_received", parameters: [
            "timestamp": Date().timeIntervalSince1970
        ])
    }
}
```

**After (iOS Notification Framework):**
```swift
import NotificationFramework

// Built-in analytics
NotificationManager.shared.trackEvent(.notificationScheduled, metadata: [
    "timestamp": Date().timeIntervalSince1970
])

NotificationManager.shared.trackEvent(.notificationReceived, metadata: [
    "timestamp": Date().timeIntervalSince1970
])

// Get analytics data
let analytics = try await NotificationManager.shared.getAnalytics()
print("Delivery rate: \(analytics.deliveryRate)")
```

## Breaking Changes

### Version 1.0.0

#### Removed Features

- `NotificationManager.requestPermissions(completion:)` - Use async version instead
- `NotificationManager.schedule(completion:)` - Use async version instead
- `NotificationManager.getPendingNotifications(completion:)` - Use async version instead

#### Changed Method Signatures

**Before:**
```swift
func requestPermissions(completion: @escaping (Bool) -> Void)
func schedule(_ notification: NotificationContent, at date: Date, completion: @escaping (Error?) -> Void)
```

**After:**
```swift
func requestPermissions() async throws -> Bool
func schedule(_ notification: NotificationContent, at date: Date) async throws
```

#### Migration Strategy

```swift
// Old code
NotificationManager.shared.requestPermissions { granted in
    if granted {
        // Handle success
    }
}

// New code
do {
    let granted = try await NotificationManager.shared.requestPermissions()
    if granted {
        // Handle success
    }
} catch {
    // Handle error
}
```

### Version 0.9.0

#### API Changes

- `NotificationContent.priority` is now required
- `RichNotificationContent.mediaType` is now optional
- `NotificationAction.options` now defaults to empty array

#### Migration Strategy

```swift
// Old code
let notification = NotificationContent(
    title: "Hello",
    body: "World"
)

// New code
let notification = NotificationContent(
    title: "Hello",
    body: "World",
    priority: .normal // Required
)
```

## Deprecated Features

### Deprecated in Version 1.0.0

#### `NotificationManager.scheduleWithCompletion`

**Deprecated:**
```swift
func scheduleWithCompletion(_ notification: NotificationContent, at date: Date, completion: @escaping (Error?) -> Void)
```

**Replacement:**
```swift
func schedule(_ notification: NotificationContent, at date: Date) async throws
```

#### `NotificationManager.getAnalyticsWithCompletion`

**Deprecated:**
```swift
func getAnalyticsWithCompletion(_ completion: @escaping (NotificationAnalytics?, Error?) -> Void)
```

**Replacement:**
```swift
func getAnalytics() async throws -> NotificationAnalytics
```

### Deprecated in Version 0.9.0

#### `NotificationContent.init(title:body:)`

**Deprecated:**
```swift
init(title: String, body: String)
```

**Replacement:**
```swift
init(title: String, body: String, category: String = "default", priority: NotificationPriority = .normal, userInfo: [String: Any]? = nil)
```

## Migration Checklist

### Before Migration

- [ ] Backup your current notification implementation
- [ ] Review all notification-related code
- [ ] Identify custom notification logic
- [ ] Document current notification flows
- [ ] Test current notification functionality

### During Migration

- [ ] Update import statements
- [ ] Replace notification creation code
- [ ] Update permission requests
- [ ] Migrate action handlers
- [ ] Update analytics tracking
- [ ] Test each notification type

### After Migration

- [ ] Verify all notifications work correctly
- [ ] Test permission flows
- [ ] Validate action handling
- [ ] Check analytics data
- [ ] Performance testing
- [ ] User acceptance testing

## Troubleshooting Migration Issues

### Common Issues

#### 1. Permission Denied Errors

```swift
// Check if permissions are properly requested
do {
    let granted = try await NotificationManager.shared.requestPermissions()
    if !granted {
        // Show settings prompt
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
} catch {
    print("Permission error: \(error)")
}
```

#### 2. Notification Not Appearing

```swift
// Check notification center
let center = UNUserNotificationCenter.current()
center.getPendingNotificationRequests { requests in
    print("Pending requests: \(requests.count)")
    for request in requests {
        print("- \(request.identifier): \(request.content.title)")
    }
}
```

#### 3. Action Handlers Not Working

```swift
// Ensure handlers are registered before scheduling
NotificationManager.shared.registerActionHandler(for: "action_id") { action in
    // Handle action
}

// Then schedule notification
let notification = RichNotificationContent(
    title: "Test",
    body: "With action",
    actions: [NotificationAction(title: "Test", identifier: "action_id")]
)

try await NotificationManager.shared.scheduleRichNotification(notification, at: Date().addingTimeInterval(5))
```

### Getting Help

If you encounter issues during migration:

1. **Check the documentation** - Most issues are covered in the guides
2. **Review examples** - See how others have migrated
3. **Search issues** - Check if your issue has been reported
4. **Create an issue** - Report migration problems

## Conclusion

The iOS Notification Framework provides a modern, async-first API that simplifies notification management while maintaining full compatibility with Apple's UserNotifications framework. The migration process is straightforward and the benefits include:

- Cleaner, more readable code
- Better error handling
- Built-in analytics
- Rich media support
- Advanced scheduling capabilities

For more information, see the [API Reference](../API/APIReference.md) and [Examples](../../Examples/). 