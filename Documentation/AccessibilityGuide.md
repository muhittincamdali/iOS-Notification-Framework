# Accessibility Guide

## Overview

The Accessibility module provides comprehensive support for making iOS notifications accessible to all users, including those with disabilities. This guide covers everything you need to know about implementing accessibility features that ensure your notifications are usable by everyone.

## Table of Contents

- [Getting Started](#getting-started)
- [Basic Accessibility](#basic-accessibility)
- [Advanced Accessibility](#advanced-accessibility)
- [VoiceOver Support](#voiceover-support)
- [Visual Accessibility](#visual-accessibility)
- [Motor Accessibility](#motor-accessibility)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
- Notification permissions granted
- Understanding of accessibility principles

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

// Enable accessibility
let config = NotificationConfiguration()
config.enableAccessibility = true
config.enableVoiceOver = true
config.enableLargeText = true
config.enableHighContrast = true

notificationManager.configure(config)
```

## Basic Accessibility

### Simple Accessible Notification

```swift
// Create accessible notification
let accessibleNotification = NotificationContent(
    title: "Accessible Notification",
    body: "This notification is fully accessible",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Schedule accessible notification
try await notificationManager.schedule(
    accessibleNotification,
    at: Date().addingTimeInterval(60)
)
```

### VoiceOver Labels

```swift
// Create notification with VoiceOver labels
let voiceOverNotification = NotificationContent(
    title: "VoiceOver Example",
    body: "This notification has VoiceOver labels",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure VoiceOver labels
voiceOverNotification.accessibility.voiceOverLabel = "Important notification from your app"
voiceOverNotification.accessibility.voiceOverHint = "Double tap to open the notification"
voiceOverNotification.accessibility.voiceOverValue = "New message received"

try await notificationManager.schedule(
    voiceOverNotification,
    at: Date().addingTimeInterval(60)
)
```

### Large Text Support

```swift
// Create notification with large text support
let largeTextNotification = NotificationContent(
    title: "Large Text Support",
    body: "This notification supports large text",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure large text settings
largeTextNotification.accessibility.largeTextScale = 1.2
largeTextNotification.accessibility.dynamicTypeEnabled = true
largeTextNotification.accessibility.textSizeCategory = .accessibilityExtraExtraExtraLarge

try await notificationManager.schedule(
    largeTextNotification,
    at: Date().addingTimeInterval(60)
)
```

## Advanced Accessibility

### High Contrast Mode

```swift
// Create high contrast notification
let highContrastNotification = NotificationContent(
    title: "High Contrast Mode",
    body: "This notification supports high contrast",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure high contrast settings
highContrastNotification.accessibility.highContrastMode = true
highContrastNotification.accessibility.contrastRatio = 4.5 // WCAG AA compliant
highContrastNotification.accessibility.boldTextEnabled = true
highContrastNotification.accessibility.increaseContrastEnabled = true

try await notificationManager.schedule(
    highContrastNotification,
    at: Date().addingTimeInterval(60)
)
```

### Reduce Motion

```swift
// Create motion-reduced notification
let motionReducedNotification = NotificationContent(
    title: "Reduce Motion",
    body: "This notification respects motion preferences",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure motion settings
motionReducedNotification.accessibility.reduceMotion = true
motionReducedNotification.accessibility.animationDuration = 0.0
motionReducedNotification.accessibility.transitionStyle = .none
motionReducedNotification.accessibility.autoPlayEnabled = false

try await notificationManager.schedule(
    motionReducedNotification,
    at: Date().addingTimeInterval(60)
)
```

### Accessibility Traits

```swift
// Create notification with accessibility traits
let traitsNotification = NotificationContent(
    title: "Accessibility Traits",
    body: "This notification has specific accessibility traits",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure accessibility traits
traitsNotification.accessibility.accessibilityTraits = [
    .button,
    .allowsDirectInteraction,
    .updatesFrequently
]
traitsNotification.accessibility.accessibilityHint = "Swipe to dismiss or tap to open"
traitsNotification.accessibility.accessibilityValue = "New notification available"

try await notificationManager.schedule(
    traitsNotification,
    at: Date().addingTimeInterval(60)
)
```

## VoiceOver Support

### VoiceOver Navigation

```swift
// Create VoiceOver-friendly notification
let voiceOverNavigationNotification = NotificationContent(
    title: "VoiceOver Navigation",
    body: "This notification is optimized for VoiceOver navigation",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure VoiceOver navigation
voiceOverNavigationNotification.accessibility.voiceOverNavigation = true
voiceOverNavigationNotification.accessibility.voiceOverOrder = [
    "title",
    "body",
    "actions"
]
voiceOverNavigationNotification.accessibility.voiceOverGrouping = true

try await notificationManager.schedule(
    voiceOverNavigationNotification,
    at: Date().addingTimeInterval(60)
)
```

### VoiceOver Actions

```swift
// Create notification with VoiceOver actions
let voiceOverActionsNotification = NotificationContent(
    title: "VoiceOver Actions",
    body: "This notification has VoiceOver-specific actions",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure VoiceOver actions
voiceOverActionsNotification.accessibility.voiceOverActions = [
    "read": "Read full notification content",
    "dismiss": "Dismiss this notification",
    "respond": "Respond to this notification"
]
voiceOverActionsNotification.accessibility.voiceOverCustomActions = [
    UIAccessibilityCustomAction(
        name: "Mark as Read",
        target: self,
        selector: #selector(markAsRead)
    )
]

try await notificationManager.schedule(
    voiceOverActionsNotification,
    at: Date().addingTimeInterval(60)
)
```

### VoiceOver Announcements

```swift
// Create notification with VoiceOver announcements
let voiceOverAnnouncementNotification = NotificationContent(
    title: "VoiceOver Announcement",
    body: "This notification makes VoiceOver announcements",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure VoiceOver announcements
voiceOverAnnouncementNotification.accessibility.voiceOverAnnouncement = "New notification received"
voiceOverAnnouncementNotification.accessibility.voiceOverPriority = .high
voiceOverAnnouncementNotification.accessibility.voiceOverDelay = 0.5

try await notificationManager.schedule(
    voiceOverAnnouncementNotification,
    at: Date().addingTimeInterval(60)
)
```

## Visual Accessibility

### Color Blindness Support

```swift
// Create color-blind friendly notification
let colorBlindNotification = NotificationContent(
    title: "Color Blind Support",
    body: "This notification is designed for color blindness",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure color blindness support
colorBlindNotification.accessibility.colorBlindFriendly = true
colorBlindNotification.accessibility.usePatterns = true
colorBlindNotification.accessibility.useShapes = true
colorBlindNotification.accessibility.colorBlindType = .deuteranopia

try await notificationManager.schedule(
    colorBlindNotification,
    at: Date().addingTimeInterval(60)
)
```

### Visual Focus Indicators

```swift
// Create notification with visual focus indicators
let focusIndicatorNotification = NotificationContent(
    title: "Focus Indicators",
    body: "This notification has clear focus indicators",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure focus indicators
focusIndicatorNotification.accessibility.focusIndicatorEnabled = true
focusIndicatorNotification.accessibility.focusIndicatorColor = UIColor.systemBlue
focusIndicatorNotification.accessibility.focusIndicatorWidth = 2.0
focusIndicatorNotification.accessibility.focusIndicatorStyle = .solid

try await notificationManager.schedule(
    focusIndicatorNotification,
    at: Date().addingTimeInterval(60)
)
```

### Visual Hierarchy

```swift
// Create notification with clear visual hierarchy
let visualHierarchyNotification = NotificationContent(
    title: "Visual Hierarchy",
    body: "This notification has clear visual hierarchy",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure visual hierarchy
visualHierarchyNotification.accessibility.visualHierarchy = true
visualHierarchyNotification.accessibility.headingLevel = 1
visualHierarchyNotification.accessibility.semanticContentAttribute = .button
visualHierarchyNotification.accessibility.accessibilityElementsHidden = false

try await notificationManager.schedule(
    visualHierarchyNotification,
    at: Date().addingTimeInterval(60)
)
```

## Motor Accessibility

### Touch Targets

```swift
// Create notification with appropriate touch targets
let touchTargetNotification = NotificationContent(
    title: "Touch Targets",
    body: "This notification has appropriately sized touch targets",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure touch targets
touchTargetNotification.accessibility.minimumTouchTargetSize = CGSize(width: 44, height: 44)
touchTargetNotification.accessibility.touchTargetSpacing = 8.0
touchTargetNotification.accessibility.touchTargetPadding = 4.0
touchTargetNotification.accessibility.touchTargetAccessibility = true

try await notificationManager.schedule(
    touchTargetNotification,
    at: Date().addingTimeInterval(60)
)
```

### Switch Control Support

```swift
// Create notification with Switch Control support
let switchControlNotification = NotificationContent(
    title: "Switch Control",
    body: "This notification supports Switch Control",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure Switch Control support
switchControlNotification.accessibility.switchControlEnabled = true
switchControlNotification.accessibility.switchControlOrder = [
    "title",
    "body",
    "primary_action",
    "secondary_action"
]
switchControlNotification.accessibility.switchControlGrouping = true

try await notificationManager.schedule(
    switchControlNotification,
    at: Date().addingTimeInterval(60)
)
```

### Assistive Touch

```swift
// Create notification with Assistive Touch support
let assistiveTouchNotification = NotificationContent(
    title: "Assistive Touch",
    body: "This notification supports Assistive Touch",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure Assistive Touch support
assistiveTouchNotification.accessibility.assistiveTouchEnabled = true
assistiveTouchNotification.accessibility.assistiveTouchActions = [
    "single_tap": "Open notification",
    "double_tap": "Mark as read",
    "long_press": "Show options"
]

try await notificationManager.schedule(
    assistiveTouchNotification,
    at: Date().addingTimeInterval(60)
)
```

## Best Practices

### 1. WCAG Compliance

```swift
// Ensure WCAG 2.1 AA compliance
let wcagCompliantNotification = NotificationContent(
    title: "WCAG Compliant",
    body: "This notification meets WCAG 2.1 AA standards",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure WCAG compliance
wcagCompliantNotification.accessibility.wcagCompliant = true
wcagCompliantNotification.accessibility.contrastRatio = 4.5
wcagCompliantNotification.accessibility.colorBlindFriendly = true
wcagCompliantNotification.accessibility.keyboardAccessible = true
```

### 2. Semantic Content

```swift
// Use semantic content attributes
let semanticNotification = NotificationContent(
    title: "Semantic Content",
    body: "This notification uses semantic content",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure semantic content
semanticNotification.accessibility.semanticContentAttribute = .button
semanticNotification.accessibility.accessibilityLanguage = "en-US"
semanticNotification.accessibility.accessibilityTextualContext = .notification
```

### 3. Progressive Enhancement

```swift
// Implement progressive enhancement
let progressiveNotification = NotificationContent(
    title: "Progressive Enhancement",
    body: "This notification works with or without accessibility features",
    accessibility: AccessibilityConfiguration(
        voiceOverEnabled: true,
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true
    )
)

// Configure progressive enhancement
progressiveNotification.accessibility.progressiveEnhancement = true
progressiveNotification.accessibility.fallbackContent = "Basic notification content"
progressiveNotification.accessibility.gracefulDegradation = true
```

### 4. Testing Accessibility

```swift
// Test accessibility features
let accessibilityTester = AccessibilityTester()
accessibilityTester.testNotification(notification) { result in
    if result.isAccessible {
        print("✅ Notification is accessible")
    } else {
        print("❌ Accessibility issues found:")
        for issue in result.issues {
            print("- \(issue)")
        }
    }
}
```

### 5. User Feedback

```swift
// Collect accessibility user feedback
let accessibilityFeedback = AccessibilityFeedback()
accessibilityFeedback.collectFeedback(for: notification) { feedback in
    print("📊 Accessibility Feedback:")
    print("VoiceOver usage: \(feedback.voiceOverUsage)")
    print("Large text usage: \(feedback.largeTextUsage)")
    print("High contrast usage: \(feedback.highContrastUsage)")
    print("User satisfaction: \(feedback.satisfactionScore)")
}
```

## Troubleshooting

### Common Issues

#### 1. VoiceOver Not Working

```swift
// Check VoiceOver configuration
let accessibility = notification.accessibility
print("VoiceOver enabled: \(accessibility.voiceOverEnabled)")
print("VoiceOver label: \(accessibility.voiceOverLabel)")
print("VoiceOver hint: \(accessibility.voiceOverHint)")

// Test VoiceOver functionality
accessibility.testVoiceOver { success in
    print("VoiceOver test: \(success ? "✅ Passed" : "❌ Failed")")
}
```

#### 2. Large Text Not Scaling

```swift
// Check large text configuration
let largeText = notification.accessibility
print("Large text enabled: \(largeText.largeTextEnabled)")
print("Text scale: \(largeText.largeTextScale)")
print("Dynamic type: \(largeText.dynamicTypeEnabled)")

// Verify text scaling
if largeText.largeTextEnabled {
    print("✅ Large text is properly configured")
} else {
    print("❌ Large text is not enabled")
}
```

#### 3. High Contrast Not Applying

```swift
// Check high contrast configuration
let highContrast = notification.accessibility
print("High contrast enabled: \(highContrast.highContrastEnabled)")
print("Contrast ratio: \(highContrast.contrastRatio)")
print("Bold text: \(highContrast.boldTextEnabled)")

// Verify contrast compliance
if highContrast.contrastRatio >= 4.5 {
    print("✅ WCAG AA compliant contrast ratio")
} else {
    print("❌ Insufficient contrast ratio")
}
```

### Debug Mode

```swift
// Enable accessibility debug mode
notificationManager.enableAccessibilityDebugMode()

// Get accessibility debug logs
notificationManager.getAccessibilityDebugLogs { logs in
    for log in logs {
        print("🔍 Accessibility Debug: \(log)")
    }
}
```

### Performance Monitoring

```swift
// Monitor accessibility performance
notificationManager.startAccessibilityPerformanceMonitoring()

// Get performance metrics
notificationManager.getAccessibilityPerformanceMetrics { metrics in
    print("📊 Accessibility Performance:")
    print("VoiceOver response time: \(metrics.voiceOverResponseTime)ms")
    print("Large text rendering time: \(metrics.largeTextRenderingTime)ms")
    print("High contrast application time: \(metrics.highContrastApplicationTime)ms")
    print("Accessibility feature usage: \(metrics.featureUsage)")
}
```

## Advanced Features

### Custom Accessibility Actions

```swift
// Create custom accessibility actions
class CustomAccessibilityActions {
    func createCustomActions(for notification: NotificationContent) -> [UIAccessibilityCustomAction] {
        return [
            UIAccessibilityCustomAction(
                name: "Mark as Important",
                target: self,
                selector: #selector(markAsImportant)
            ),
            UIAccessibilityCustomAction(
                name: "Share Notification",
                target: self,
                selector: #selector(shareNotification)
            ),
            UIAccessibilityCustomAction(
                name: "Snooze Notification",
                target: self,
                selector: #selector(snoozeNotification)
            )
        ]
    }
}
```

### Accessibility Analytics

```swift
// Track accessibility usage
class AccessibilityAnalytics {
    func trackAccessibilityUsage(
        feature: String,
        userID: String
    ) {
        analyticsManager.trackEvent("accessibility_feature_used", properties: [
            "feature": feature,
            "user_id": userID,
            "timestamp": Date().timeIntervalSince1970
        ])
    }
    
    func getAccessibilityMetrics() -> AccessibilityMetrics {
        return AccessibilityMetrics(
            voiceOverUsage: 0.15,
            largeTextUsage: 0.08,
            highContrastUsage: 0.12,
            reduceMotionUsage: 0.05
        )
    }
}
```

This comprehensive guide covers all aspects of accessibility in the iOS Notification Framework. Follow these patterns to create inclusive notification experiences that work for all users, regardless of their abilities.
