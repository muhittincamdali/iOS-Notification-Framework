# API Reference

This document provides comprehensive API reference for the iOS Notification Framework.

## Table of Contents

- [NotificationManager](#notificationmanager)
- [NotificationContent](#notificationcontent)
- [RichNotificationContent](#richnotificationcontent)
- [NotificationAction](#notificationaction)
- [NotificationPriority](#notificationpriority)
- [MediaType](#mediatype)
- [RecurringSchedule](#recurringschedule)
- [NotificationAnalytics](#notificationanalytics)
- [NotificationError](#notificationerror)

## NotificationManager

The main class for managing notifications in your iOS application.

### Properties

```swift
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared: NotificationManager
    var delegate: NotificationManagerDelegate?
}
```

### Methods

#### Permission Management

```swift
func requestPermissions() async throws -> Bool
```
Requests notification permissions from the user.

**Returns:** `true` if permissions are granted, `false` otherwise.

**Throws:** `NotificationError.permissionDenied` if permissions are denied.

---

```swift
func getAuthorizationStatus() async throws -> UNAuthorizationStatus
```
Gets the current authorization status for notifications.

**Returns:** Current authorization status.

**Throws:** `NotificationError.systemError` if unable to get status.

#### Notification Scheduling

```swift
func schedule(_ notification: NotificationContent, at date: Date, sound: String? = nil, badge: Int? = nil) async throws
```
Schedules a basic notification.

**Parameters:**
- `notification`: The notification content to schedule
- `date`: When to deliver the notification
- `sound`: Optional custom sound file name
- `badge`: Optional badge number

**Throws:** `NotificationError.schedulingFailed` if scheduling fails.

---

```swift
func scheduleRichNotification(_ notification: RichNotificationContent, at date: Date) async throws
```
Schedules a rich media notification.

**Parameters:**
- `notification`: The rich notification content
- `date`: When to deliver the notification

**Throws:** `NotificationError.schedulingFailed` if scheduling fails.

---

```swift
func scheduleRecurringNotification(_ notification: NotificationContent, with schedule: RecurringSchedule) async throws
```
Schedules a recurring notification.

**Parameters:**
- `notification`: The notification content
- `schedule`: The recurring schedule configuration

**Throws:** `NotificationError.schedulingFailed` if scheduling fails.

#### Notification Management

```swift
func getPendingNotifications() async throws -> [UNNotificationRequest]
```
Gets all pending notifications.

**Returns:** Array of pending notification requests.

**Throws:** `NotificationError.systemError` if unable to retrieve notifications.

---

```swift
func getDeliveredNotifications() async throws -> [UNNotification]
```
Gets all delivered notifications.

**Returns:** Array of delivered notifications.

**Throws:** `NotificationError.systemError` if unable to retrieve notifications.

---

```swift
func removePendingNotification(with identifier: String) async throws
```
Removes a specific pending notification.

**Parameters:**
- `identifier`: The notification identifier to remove

**Throws:** `NotificationError.notificationNotFound` if notification not found.

---

```swift
func removeAllPendingNotifications() async throws
```
Removes all pending notifications.

**Throws:** `NotificationError.systemError` if removal fails.

---

```swift
func removeAllDeliveredNotifications() async throws
```
Removes all delivered notifications.

**Throws:** `NotificationError.systemError` if removal fails.

#### Action Handling

```swift
func registerActionHandler(for identifier: String, handler: @escaping (UNNotificationAction) -> Void)
```
Registers a custom action handler.

**Parameters:**
- `identifier`: The action identifier
- `handler`: The handler closure to execute

---

```swift
func removeActionHandler(for identifier: String)
```
Removes a custom action handler.

**Parameters:**
- `identifier`: The action identifier to remove

#### Analytics

```swift
func getAnalytics() async throws -> NotificationAnalytics
```
Gets comprehensive analytics data.

**Returns:** Analytics data structure.

**Throws:** `NotificationError.analyticsError` if unable to retrieve analytics.

---

```swift
func trackEvent(_ event: AnalyticsEventType, metadata: [String: Any]? = nil)
```
Tracks a custom analytics event.

**Parameters:**
- `event`: The event type to track
- `metadata`: Optional metadata for the event

## NotificationContent

Represents the content of a basic notification.

### Properties

```swift
struct NotificationContent {
    let title: String
    let body: String
    let category: String
    let priority: NotificationPriority
    let userInfo: [String: Any]?
}
```

### Initialization

```swift
init(title: String, body: String, category: String = "default", priority: NotificationPriority = .normal, userInfo: [String: Any]? = nil)
```

**Parameters:**
- `title`: The notification title
- `body`: The notification body text
- `category`: The notification category (default: "default")
- `priority`: The notification priority (default: .normal)
- `userInfo`: Optional user info dictionary

## RichNotificationContent

Represents the content of a rich media notification.

### Properties

```swift
struct RichNotificationContent: NotificationContent {
    let mediaURL: String?
    let mediaType: MediaType?
    let actions: [NotificationAction]?
}
```

### Initialization

```swift
init(title: String, body: String, category: String = "default", priority: NotificationPriority = .normal, userInfo: [String: Any]? = nil, mediaURL: String? = nil, mediaType: MediaType? = nil, actions: [NotificationAction]? = nil)
```

**Parameters:**
- `title`: The notification title
- `body`: The notification body text
- `category`: The notification category
- `priority`: The notification priority
- `userInfo`: Optional user info dictionary
- `mediaURL`: Optional media URL
- `mediaType`: Optional media type
- `actions`: Optional array of notification actions

## NotificationAction

Represents a custom notification action.

### Properties

```swift
struct NotificationAction {
    let title: String
    let identifier: String
    let options: UNNotificationActionOptions
}
```

### Initialization

```swift
init(title: String, identifier: String, options: UNNotificationActionOptions = [])
```

**Parameters:**
- `title`: The action title
- `identifier`: The action identifier
- `options`: The action options

## NotificationPriority

Enumeration for notification priority levels.

```swift
enum NotificationPriority: String, CaseIterable {
    case low = "low"
    case normal = "normal"
    case high = "high"
    case critical = "critical"
}
```

### Properties

```swift
var displayName: String
```
Returns the human-readable name for the priority.

```swift
var authorizationOptions: UNAuthorizationOptions
```
Returns the authorization options for the priority level.

## MediaType

Enumeration for supported media types.

```swift
enum MediaType: String, CaseIterable {
    case image = "image"
    case video = "video"
    case audio = "audio"
    case gif = "gif"
}
```

### Properties

```swift
var displayName: String
```
Returns the human-readable name for the media type.

```swift
var fileExtension: String
```
Returns the file extension for the media type.

```swift
var mimeType: String
```
Returns the MIME type for the media type.

## RecurringSchedule

Represents a recurring notification schedule.

### Properties

```swift
struct RecurringSchedule {
    let interval: RecurringInterval
    let startDate: Date
    let endDate: Date?
    let timeComponents: DateComponents
    let customInterval: TimeInterval?
}
```

### Initialization

```swift
init(interval: RecurringInterval, startDate: Date, endDate: Date? = nil, timeComponents: DateComponents, customInterval: TimeInterval? = nil)
```

**Parameters:**
- `interval`: The recurring interval type
- `startDate`: When to start the recurring schedule
- `endDate`: Optional end date for the schedule
- `timeComponents`: The time components for delivery
- `customInterval`: Optional custom interval in seconds

## RecurringInterval

Enumeration for recurring interval types.

```swift
enum RecurringInterval: String, CaseIterable {
    case minute = "minute"
    case hourly = "hourly"
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
    case custom = "custom"
}
```

### Properties

```swift
var displayName: String
```
Returns the human-readable name for the interval.

```swift
var seconds: TimeInterval
```
Returns the interval duration in seconds.

## NotificationAnalytics

Represents analytics data for notifications.

### Properties

```swift
struct NotificationAnalytics: Codable {
    let totalEvents: Int
    let scheduledCount: Int
    let receivedCount: Int
    let responseCount: Int
    let errorCount: Int
    let deliveryRate: Double
    let responseRate: Double
    let averageResponseTime: TimeInterval
    let customEvents: Int
}
```

### Methods

```swift
func getSummary() -> String
```
Returns a human-readable summary of the analytics.

```swift
func exportToJSON() throws -> Data
```
Exports analytics data to JSON format.

**Returns:** JSON data representation.

**Throws:** `NotificationError.exportFailed` if export fails.

## NotificationError

Enumeration for notification-related errors.

```swift
enum NotificationError: LocalizedError, CustomStringConvertible {
    case permissionDenied
    case schedulingFailed
    case notificationNotFound
    case contentInvalid
    case actionInvalid
    case analyticsError
    case systemError
    case networkError
    case securityError
}
```

### Properties

```swift
var errorDescription: String?
```
Returns a localized error description.

```swift
var failureReason: String?
```
Returns the reason for the failure.

```swift
var recoverySuggestion: String?
```
Returns a suggestion for recovery.

```swift
var errorCode: Int
```
Returns the unique error code.

### Methods

```swift
static func isRecoverable(_ error: NotificationError) -> Bool
```
Checks if the error is recoverable.

```swift
static func getErrorType(_ error: NotificationError) -> String
```
Gets the error type as a string.

## AnalyticsEventType

Enumeration for analytics event types.

```swift
enum AnalyticsEventType: String, CaseIterable {
    case notificationScheduled = "notification_scheduled"
    case notificationReceived = "notification_received"
    case notificationResponded = "notification_responded"
    case notificationRemoved = "notification_removed"
    case permissionRequested = "permission_requested"
    case permissionGranted = "permission_granted"
    case permissionDenied = "permission_denied"
    case errorOccurred = "error_occurred"
}
```

### Properties

```swift
var displayName: String
```
Returns the human-readable name for the event type.

```swift
var isTrackable: Bool
```
Returns whether the event type should be tracked.

## Usage Examples

### Basic Notification

```swift
let notification = NotificationContent(
    title: "Hello World",
    body: "This is a test notification",
    category: "test",
    priority: .normal
)

try await NotificationManager.shared.schedule(notification, at: Date().addingTimeInterval(5))
```

### Rich Media Notification

```swift
let richNotification = RichNotificationContent(
    title: "New Product",
    body: "Check out our latest product",
    mediaURL: "https://example.com/image.jpg",
    mediaType: .image,
    actions: [
        NotificationAction(title: "View", identifier: "view"),
        NotificationAction(title: "Share", identifier: "share")
    ]
)

try await NotificationManager.shared.scheduleRichNotification(richNotification, at: Date().addingTimeInterval(10))
```

### Recurring Notification

```swift
let schedule = RecurringSchedule(
    interval: .daily,
    startDate: Date(),
    timeComponents: DateComponents(hour: 9, minute: 0)
)

let notification = NotificationContent(
    title: "Daily Reminder",
    body: "Don't forget your daily tasks",
    category: "reminder"
)

try await NotificationManager.shared.scheduleRecurringNotification(notification, with: schedule)
```

### Custom Actions

```swift
NotificationManager.shared.registerActionHandler(for: "view") { action in
    print("User tapped view action")
    // Navigate to product page
}

NotificationManager.shared.registerActionHandler(for: "share") { action in
    print("User tapped share action")
    // Share product
}
```

### Analytics

```swift
let analytics = try await NotificationManager.shared.getAnalytics()
print("Delivery Rate: \(analytics.deliveryRate * 100)%")
print("Response Rate: \(analytics.responseRate * 100)%")

// Track custom event
NotificationManager.shared.trackEvent(.notificationScheduled, metadata: [
    "category": "custom",
    "priority": "high"
])
```
