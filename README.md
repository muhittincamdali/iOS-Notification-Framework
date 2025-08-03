# 📱 iOS Notification Framework

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20iPadOS-lightgrey.svg)](https://developer.apple.com/)
[![Documentation](https://img.shields.io/badge/Documentation-Complete-blue.svg)](Documentation/)
[![Tests](https://img.shields.io/badge/Tests-100%25-green.svg)](Tests/)
[![Stars](https://img.shields.io/github/stars/muhittincamdali/iOS-Notification-Framework?style=social)](https://github.com/muhittincamdali/iOS-Notification-Framework)
[![Forks](https://img.shields.io/github/forks/muhittincamdali/iOS-Notification-Framework?style=social)](https://github.com/muhittincamdali/iOS-Notification-Framework)

**Advanced notification system with rich notifications, custom actions, and comprehensive analytics tracking**

A production-ready iOS notification framework built with Clean Architecture, providing advanced notification management, rich media support, custom actions, scheduling capabilities, and comprehensive analytics tracking. Designed for enterprise applications requiring sophisticated notification systems.

## 🚀 Features

### 📱 **Rich Media Notifications**
- **Image Support**: High-quality image attachments
- **Video Notifications**: Video thumbnails with playback
- **GIF Support**: Animated GIF notifications
- **Audio Attachments**: Custom sound notifications
- **Live Photos**: Photo + video combinations
- **Carousel**: Multiple image notifications

### ⚡ **Custom Actions**
- **Interactive Buttons**: Reply, Like, Share, Dismiss
- **Accept/Decline**: Invitation handling
- **Snooze**: Reminder management
- **Deep Linking**: App navigation
- **Custom Handlers**: Flexible action processing

### 📅 **Advanced Scheduling**
- **Time Intervals**: Seconds, minutes, hours
- **Calendar Events**: Date and time scheduling
- **Location-Based**: Geofencing notifications
- **Recurring**: Repeat notifications
- **Expiration**: Auto-cancellation

### 📊 **Analytics & Tracking**
- **User Engagement**: Tap rates, open rates
- **Performance Metrics**: Delivery times, processing times
- **Custom Events**: Business-specific tracking
- **Real-time Monitoring**: Live analytics dashboard
- **A/B Testing**: Notification optimization

### 🔐 **Security & Privacy**
- **Encrypted Storage**: Secure notification data
- **Privacy Compliance**: GDPR, CCPA support
- **Permission Management**: Granular control
- **Data Protection**: At-rest encryption
- **Audit Logging**: Comprehensive tracking

## 🏗️ Architecture

### **Clean Architecture**
```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │   Views     │  │ ViewModels  │  │ Coordinators│      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │  Entities   │  │  Use Cases  │  │  Protocols  │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │Repositories │  │Data Sources │  │    DTOs     │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                  Infrastructure Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │   Network   │  │   Storage   │  │   Utils     │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### **Core Components**
- **NotificationManager**: Main notification orchestrator
- **NotificationRequest**: Comprehensive request model
- **NotificationAction**: Custom action definitions
- **RichNotificationManager**: Media-rich notifications
- **AnalyticsDelegate**: Event tracking system

## 🛠️ Installation

### **Swift Package Manager**

Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Notification-Framework.git", from: "1.0.0")
]
```

### **CocoaPods**

Add to your `Podfile`:

```ruby
pod 'iOSNotificationFramework', '~> 1.0'
```

### **Manual Installation**

1. Download the framework
2. Add to your Xcode project
3. Link the framework
4. Import in your code

## 📖 Quick Start

### **Basic Setup**

```swift
import iOSNotificationFramework

// Configure the notification manager
let config = NotificationManager.Configuration(
    appName: "MyApp",
    enableAnalytics: true,
    enableRichMedia: true,
    enableCustomActions: true
)

NotificationManager.shared.configure(with: config)

// Request permissions
NotificationManager.shared.requestNotificationPermissions { granted, error in
    if granted {
        print("✅ Notification permissions granted")
    } else {
        print("❌ Notification permissions denied")
    }
}
```

### **Simple Notification**

```swift
// Create a simple notification
let request = NotificationRequest.simple(
    title: "Welcome!",
    body: "Thank you for using our app"
)

// Schedule the notification
NotificationManager.shared.scheduleNotification(request) { result in
    switch result {
    case .success(let identifier):
        print("✅ Notification scheduled: \(identifier)")
    case .failure(let error):
        print("❌ Failed to schedule: \(error)")
    }
}
```

### **Rich Media Notification**

```swift
// Create a rich notification with image
let imageURL = URL(string: "https://example.com/image.jpg")!
let request = NotificationRequest.rich(
    title: "New Photo",
    body: "Check out this amazing photo!",
    imageURL: imageURL
)

NotificationManager.shared.scheduleNotification(request) { result in
    // Handle result
}
```

### **Scheduled Notification**

```swift
// Schedule for 5 minutes from now
let request = NotificationRequest.scheduled(
    title: "Reminder",
    body: "Don't forget your meeting!",
    timeInterval: 300 // 5 minutes
)

NotificationManager.shared.scheduleNotification(request) { result in
    // Handle result
}
```

### **Interactive Notification**

```swift
// Create custom actions
let replyAction = NotificationAction.reply { response in
    // Handle reply action
}

let likeAction = NotificationAction.like { response in
    // Handle like action
}

// Create interactive notification
let request = NotificationRequest.builder()
    .title("New Message")
    .body("You have a new message from John")
    .categoryIdentifier("message")
    .build()

// Register actions
NotificationManager.shared.registerCustomAction(replyAction)
NotificationManager.shared.registerCustomAction(likeAction)

// Schedule notification
NotificationManager.shared.scheduleNotification(request) { result in
    // Handle result
}
```

## 🎨 Advanced Usage

### **Rich Media Notifications**

```swift
import RichNotifications

// Video notification
RichNotificationManager.shared.createVideoNotification(
    title: "New Video",
    body: "Watch this amazing video!",
    videoURL: videoURL,
    thumbnailURL: thumbnailURL
) { result in
    switch result {
    case .success(let request):
        NotificationManager.shared.scheduleNotification(request) { _ in }
    case .failure(let error):
        print("❌ Failed to create video notification: \(error)")
    }
}

// GIF notification
RichNotificationManager.shared.createGIFNotification(
    title: "Fun GIF",
    body: "Check out this animated GIF!",
    gifURL: gifURL
) { result in
    // Handle result
}

// Carousel notification
RichNotificationManager.shared.createCarouselNotification(
    title: "Photo Gallery",
    body: "Swipe through these photos!",
    images: imageURLs
) { result in
    // Handle result
}
```

### **Analytics Tracking**

```swift
import NotificationAnalytics

// Custom analytics delegate
class CustomAnalyticsDelegate: NotificationAnalyticsDelegate {
    func trackNotificationReceived(notification: UNNotification) {
        // Track notification received
        print("📊 Notification received: \(notification.request.identifier)")
    }
    
    func trackNotificationTapped(response: UNNotificationResponse) {
        // Track notification tap
        print("📊 Notification tapped: \(response.notification.request.identifier)")
    }
    
    // Implement other tracking methods...
}

// Set custom analytics delegate
let analyticsDelegate = CustomAnalyticsDelegate()
// Set the delegate in your app delegate or scene delegate
```

### **Batch Operations**

```swift
// Schedule multiple notifications
let requests = [
    NotificationRequest.simple(title: "Reminder 1", body: "First reminder"),
    NotificationRequest.simple(title: "Reminder 2", body: "Second reminder"),
    NotificationRequest.simple(title: "Reminder 3", body: "Third reminder")
]

NotificationManager.shared.scheduleMultipleNotifications(requests) { result in
    switch result {
    case .success(let identifiers):
        print("✅ Scheduled \(identifiers.count) notifications")
    case .failure(let error):
        print("❌ Failed to schedule notifications: \(error)")
    }
}
```

### **Notification Management**

```swift
// Cancel specific notification
NotificationManager.shared.cancelNotification(withIdentifier: "notification_id")

// Cancel multiple notifications
NotificationManager.shared.cancelNotifications(withIdentifiers: ["id1", "id2", "id3"])

// Cancel all notifications
NotificationManager.shared.cancelAllNotifications()

// Check pending notifications
UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
    print("📱 Pending notifications: \(requests.count)")
}
```

## 📊 Analytics & Metrics

### **Available Metrics**
- **Delivery Rate**: Percentage of notifications delivered
- **Open Rate**: Percentage of notifications opened
- **Action Rate**: Percentage of notifications with actions taken
- **Engagement Time**: Time between notification and action
- **Conversion Rate**: Business-specific conversions
- **Performance Metrics**: Delivery time, processing time

### **Custom Events**
```swift
// Track custom events
analyticsDelegate.trackCustomActionTriggered(
    actionIdentifier: "purchase",
    notificationIdentifier: "promo_notification"
)

// Track deep link activation
analyticsDelegate.trackDeepLinkActivated(link: "myapp://product/123")
```

## 🔧 Configuration

### **Notification Manager Configuration**

```swift
let config = NotificationManager.Configuration(
    appName: "MyApp",
    defaultSound: .default,
    defaultBadge: 1,
    enableAnalytics: true,
    enableRichMedia: true,
    enableCustomActions: true
)

NotificationManager.shared.configure(with: config)
```

### **Permission Options**

```swift
let options: UNAuthorizationOptions = [
    .alert,      // Show alerts
    .badge,      // Show badge
    .sound,      // Play sound
    .provisional // Provisional authorization
]

NotificationManager.shared.requestNotificationPermissions(options: options) { granted, error in
    // Handle result
}
```

## 🧪 Testing

### **Unit Tests**

```swift
import XCTest
@testable import iOSNotificationFramework

class NotificationManagerTests: XCTestCase {
    func testNotificationScheduling() {
        let request = NotificationRequest.simple(
            title: "Test",
            body: "Test Body"
        )
        
        XCTAssertTrue(request.isValid)
        XCTAssertTrue(request.validationErrors.isEmpty)
    }
}
```

### **Integration Tests**

```swift
class NotificationIntegrationTests: XCTestCase {
    func testNotificationFlow() {
        // Test complete notification flow
        // 1. Request permissions
        // 2. Schedule notification
        // 3. Verify delivery
        // 4. Test actions
    }
}
```

## 📚 Documentation

### **API Reference**
- [NotificationManager](Documentation/API/NotificationManager.md)
- [NotificationRequest](Documentation/API/NotificationRequest.md)
- [NotificationAction](Documentation/API/NotificationAction.md)
- [RichNotificationManager](Documentation/API/RichNotificationManager.md)
- [Analytics](Documentation/API/Analytics.md)

### **Guides**
- [Getting Started](Documentation/Guides/GettingStarted.md)
- [Rich Media](Documentation/Guides/RichMedia.md)
- [Custom Actions](Documentation/Guides/CustomActions.md)
- [Analytics](Documentation/Guides/Analytics.md)
- [Best Practices](Documentation/Guides/BestPractices.md)

### **Examples**
- [Basic Examples](Examples/Basic/)
- [Advanced Examples](Examples/Advanced/)
- [Custom Examples](Examples/Custom/)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### **Development Setup**
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

### **Code Style**
- Follow Swift style guidelines
- Use meaningful variable names
- Add comprehensive documentation
- Write unit tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apple for the UserNotifications framework
- The iOS development community
- All contributors and supporters

## 📞 Support

- **Documentation**: [Full Documentation](Documentation/)
- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/iOS-Notification-Framework/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/iOS-Notification-Framework/discussions)
- **Email**: support@muhittincamdali.com

---

<div align="center">

**⭐ Star this repository if it helped you!**

**🚀 Built with ❤️ for the iOS community**

</div> 