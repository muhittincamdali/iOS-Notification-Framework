# ``NotificationKit``

Local and remote notifications for iOS, macOS, watchOS and visionOS: scheduling past the
64-notification limit, quiet hours, a frequency cap, actions, deep links and push payloads.

## Overview

NotificationKit sits on top of `UserNotifications`. You describe notifications as values,
``NotificationScheduler`` hands them to the system, and ``NotificationEventHandler`` turns the
system's delegate callbacks back into values your app can read.

```swift
import NotificationKit

let scheduler = NotificationScheduler()

try await scheduler.requestAuthorization()
try await scheduler.schedule(LocalNotification(
    id: "water",
    title: "Time for a glass of water",
    trigger: .after(minutes: 30)
))
```

What it adds to `UNUserNotificationCenter`:

- **No silently lost notifications.** The system keeps only the 64 soonest pending notifications
  of an app. The scheduler keeps the rest in its own queue and moves them up as slots free.
- **Quiet hours and a frequency cap**, applied to the date a notification fires, not the date
  it was scheduled.
- **Checks before the system sees a value.** A repeating interval under 60 seconds, a NaN
  relevance score or an out-of-range date component throws a
  ``NotificationValidationError`` instead of raising an Objective-C exception or being dropped.
- **Typed push payloads** shared by the app and the server (``PushPayload``), a redacting
  ``DeviceToken``, and a Notification Service Extension that downloads media within Apple's
  limits (``MediaAttachmentService``).
- **A test double** (``InMemoryNotificationCenter``) that behaves like the system's center,
  including its 64-notification limit.

To send pushes from a server or a script, see the `NotificationKitAPNs` module in the same
package.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:SchedulingBeyondTheLimit>
- <doc:RespondingToNotifications>
- <doc:RemoteNotifications>
- <doc:TestingNotifications>

### Describing notifications

- ``LocalNotification``
- ``NotificationTrigger``
- ``LocationRegion``
- ``NotificationSound``
- ``InterruptionLevel``
- ``NotificationAttachment``
- ``JSONValue``
- ``NotificationValidationError``

### Scheduling

- ``NotificationScheduler``
- ``SchedulingPolicy``
- ``ScheduledNotification``
- ``RefreshReport``
- ``SchedulerError``

### Quiet hours and frequency cap

- ``QuietHours``
- ``TimeOfDay``
- ``FrequencyCap``

### Storing the queue

- ``NotificationStore``
- ``SchedulerState``
- ``FileNotificationStore``
- ``InMemoryNotificationStore``

### Permission and the notification center

- ``NotificationCenterClient``
- ``UserNotificationCenterClient``
- ``InMemoryNotificationCenter``
- ``AuthorizationOptions``
- ``AuthorizationStatus``
- ``NotificationSettings``

### Actions and responses

- ``NotificationCategory``
- ``NotificationAction``
- ``NotificationEventHandler``
- ``ReceivedNotification``
- ``NotificationResponse``
- ``PresentationOptions``
- ``DeepLinkRouter``

### Remote notifications

- ``DeviceToken``
- ``PushPayload``
- ``APS``
- ``PushType``
- ``LiveActivityEvent``
- ``PushPayloadError``

### Notification Service Extension

- ``MediaAttachmentService``
- ``AttachmentDownloader``
