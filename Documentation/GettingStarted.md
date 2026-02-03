# Getting Started with NotificationKit

This guide will help you get started with NotificationKit in your iOS project.

## Installation

Add NotificationKit to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Notification-Framework.git", from: "1.0.0")
]
```

## Basic Setup

### 1. Import the Framework

```swift
import NotificationKit
```

### 2. Request Authorization

```swift
Task {
    do {
        let granted = try await NotificationKit.shared.requestAuthorization()
        print("Permission granted: \(granted)")
    } catch {
        print("Authorization failed: \(error)")
    }
}
```

### 3. Schedule Your First Notification

```swift
try await NotificationKit.shared.schedule {
    Notification(id: "my-first-notification")
        .title("Hello!")
        .body("This is your first notification")
        .sound(.default)
        .trigger(after: .minutes(1))
}
```

## Next Steps

- Read the [API Reference](API.md)
- Explore [Examples](../Examples/)
- Learn about [Interactive Notifications](InteractiveNotifications.md)
