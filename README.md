```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗    ║
║   ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║    ║
║   ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║    ║
║   ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║    ║
║   ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║    ║
║   ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝    ║
║                                                                              ║
║                          ██╗  ██╗██╗████████╗                                ║
║                          ██║ ██╔╝██║╚══██╔══╝                                ║
║                          █████╔╝ ██║   ██║                                   ║
║                          ██╔═██╗ ██║   ██║                                   ║
║                          ██║  ██╗██║   ██║                                   ║
║                          ╚═╝  ╚═╝╚═╝   ╚═╝                                   ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

<div align="center">

**Type-safe, declarative local & push notifications for iOS. Schedule smarter.**

[![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![CI](https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg)](https://github.com/muhittincamdali/iOS-Notification-Framework/actions)

[Features](#-features) • [Quick Start](#-quick-start) • [Installation](#-installation) • [Usage](#-usage) • [API](#-api-reference) • [Docs](Documentation/)

</div>

---

## ✨ Features

- 🔔 **Type-Safe Scheduling** — Builder pattern with compile-time safety
- 📱 **Rich Content** — Images, videos, GIFs, and custom attachments
- ⏰ **Smart Triggers** — Time interval, calendar, location-based
- 🎯 **Interactive Actions** — Buttons, text input, quick replies
- 🚨 **iOS 15+ Focus Modes** — Time Sensitive, Critical alerts
- 🧵 **Thread Grouping** — Organize related notifications
- 📊 **Delivery Analytics** — Track opens and interactions
- 🔄 **Async/Await** — Modern concurrency support

---

## 🚀 Quick Start

```swift
import NotificationKit

// 1. Initialize
let notifications = NotificationKit.shared

// 2. Request permission
try await notifications.requestAuthorization()

// 3. Schedule a notification
try await notifications.schedule {
    Notification(id: "meeting-reminder")
        .title("Meeting in 5 minutes")
        .body("Team standup starting soon")
        .sound(.default)
        .trigger(after: .minutes(5))
}
```

**That's it!** 🎉 Your first notification is scheduled.

---

## 📦 Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Notification-Framework.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Packages** → Enter the repository URL.

### Requirements

| Platform | Minimum Version |
|----------|-----------------|
| iOS      | 15.0+           |
| macOS    | 13.0+           |
| tvOS     | 15.0+           |
| watchOS  | 8.0+            |
| Swift    | 5.9+            |

---

## 📖 Usage

### Basic Notification

```swift
try await NotificationKit.shared.schedule {
    Notification(id: "welcome")
        .title("Welcome!")
        .body("Thanks for using our app")
        .sound(.default)
}
```

### Rich Notification with Image

```swift
try await NotificationKit.shared.schedule {
    Notification(id: "promo")
        .title("New Sale!")
        .body("50% off all items today")
        .attachment(imageURL)
        .category("PROMO")
        .relevanceScore(0.9)
}
```

### Scheduled Notifications

```swift
// After 30 minutes
.trigger(after: .minutes(30))

// Daily at 9 AM
.trigger(.daily(at: 9, minute: 0))

// Every Monday at 10:30
.trigger(.weekly(on: 2, at: 10, minute: 30))

// Specific date
.trigger(.on(date: targetDate))
```

### Time Sensitive (iOS 15+)

```swift
Notification(id: "urgent")
    .title("Security Alert")
    .body("Unusual login detected")
    .timeSensitive()  // Breaks through Focus modes
```

### Critical Alerts (Requires Entitlement)

```swift
Notification(id: "emergency")
    .title("Emergency")
    .body("Action required immediately")
    .critical()  // Bypasses silent mode
```

### Interactive Categories

```swift
// Register category with actions
NotificationKit.shared.register(
    category: NotificationCategory(identifier: "MESSAGE")
        .action(.reply)
        .action(.view)
        .action(
            NotificationAction(identifier: "MARK_READ", title: "Mark as Read")
        )
)

// Use in notification
Notification(id: "new-message")
    .title("New Message")
    .body("Hey, are you free tonight?")
    .category("MESSAGE")
    .thread("conversation-123")
```

### Cancel Notifications

```swift
// Cancel specific notification
NotificationKit.shared.cancel(identifier: "reminder-1")

// Cancel multiple
NotificationKit.shared.cancel(identifiers: ["a", "b", "c"])

// Cancel all
NotificationKit.shared.cancelAll()
```

### Get Pending Notifications

```swift
let pending = await NotificationKit.shared.pendingNotifications()
print("Pending count: \(pending.count)")
```

---

## 🔔 Trigger Types

| Trigger | Description | Example |
|---------|-------------|---------|
| `.immediate` | Fire now | Default |
| `.timeInterval(60)` | After 60 seconds | Reminders |
| `.after(minutes: 5)` | After 5 minutes | Countdown |
| `.after(hours: 2)` | After 2 hours | Delayed |
| `.daily(at: 9)` | Every day at 9 AM | Daily reminder |
| `.weekly(on: 2, at: 10)` | Monday at 10 AM | Weekly |
| `.on(date: Date())` | Specific date | One-time |
| `.location(region)` | Enter/exit region | Geofence |

---

## 🎯 Pre-built Actions

```swift
// Common actions ready to use
NotificationAction.view        // Opens app
NotificationAction.dismiss     // Dismisses notification
NotificationAction.reply       // Text input reply
NotificationAction.delete      // Destructive delete

// Custom action
NotificationAction(identifier: "SNOOZE", title: "Snooze")
    .foreground()  // Opens app when tapped
```

---

## 📡 Handling Responses

```swift
class AppDelegate: UIResponder, UIApplicationDelegate, NotificationKitDelegate {
    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationKit.shared.delegate = self
        return true
    }
    
    func notificationKit(_ kit: NotificationKit, didReceive response: UNNotificationResponse) async {
        switch response.actionIdentifier {
        case "REPLY":
            if let textResponse = response as? UNTextInputNotificationResponse {
                print("User replied: \(textResponse.userText)")
            }
        case "VIEW":
            // Navigate to content
            break
        default:
            break
        }
    }
}
```

---

## 📊 API Reference

### NotificationKit

| Method | Description |
|--------|-------------|
| `requestAuthorization()` | Request notification permissions |
| `schedule(builder:)` | Schedule using builder pattern |
| `schedule([Notification])` | Schedule multiple notifications |
| `cancel(identifier:)` | Cancel by ID |
| `cancelAll()` | Cancel all pending |
| `pendingNotifications()` | Get pending requests |
| `register(category:)` | Register interactive category |
| `setBadge(_:)` | Set badge number |
| `clearBadge()` | Clear badge |

### Notification Builder

| Method | Description |
|--------|-------------|
| `.title(_:)` | Set title |
| `.subtitle(_:)` | Set subtitle |
| `.body(_:)` | Set body text |
| `.sound(_:)` | Set sound |
| `.badge(_:)` | Set badge number |
| `.category(_:)` | Set category ID |
| `.thread(_:)` | Set thread ID |
| `.trigger(_:)` | Set trigger |
| `.attachment(_:)` | Add attachment |
| `.timeSensitive()` | Mark time sensitive |
| `.critical()` | Mark critical |
| `.relevanceScore(_:)` | Set relevance (0-1) |
| `.userInfo(_:)` | Custom payload |

---

## 🧪 Testing

```bash
swift test
```

Run with verbose output:

```bash
swift test --verbose
```

---

## 📁 Project Structure

```
iOS-Notification-Framework/
├── Sources/
│   └── NotificationKit/
│       ├── NotificationKit.swift       # Main API
│       └── Models/
│           ├── Notification.swift      # Notification model
│           ├── NotificationTrigger.swift
│           └── NotificationCategory.swift
├── Tests/
│   └── NotificationKitTests/
├── Documentation/
├── Examples/
└── Package.swift
```

---

## 🤝 Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push (`git push origin feature/amazing`)
5. Open Pull Request

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

Built with inspiration from:
- Apple's UserNotifications framework
- The Swift community's best practices

---

<div align="center">

**[⬆ Back to Top](#-features)**

Made with ❤️ by [Muhittin Camdali](https://github.com/muhittincamdali)

</div>
