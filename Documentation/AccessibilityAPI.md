# Accessibility API Reference

## Overview

The Accessibility API provides comprehensive support for making iOS notifications accessible to all users, including those with disabilities. This document covers all public interfaces, methods, and properties for implementing accessibility features.

## Table of Contents

- [AccessibilityConfiguration](#accessibilityconfiguration)
- [VoiceOverSupport](#voiceoversupport)
- [VisualAccessibility](#visualaccessibility)
- [MotorAccessibility](#motoraccessibility)
- [AccessibilityManager](#accessibilitymanager)
- [AccessibilityTester](#accessibilitytester)

## AccessibilityConfiguration

### Class Definition

```swift
public class AccessibilityConfiguration {
    public var voiceOverEnabled: Bool
    public var largeTextEnabled: Bool
    public var highContrastEnabled: Bool
    public var reduceMotionEnabled: Bool
    public var voiceOverLabel: String?
    public var voiceOverHint: String?
    public var voiceOverValue: String?
    public var largeTextScale: CGFloat
    public var contrastRatio: Double
    public var accessibilityTraits: UIAccessibilityTraits
}
```

### Properties

#### voiceOverEnabled
Whether VoiceOver support is enabled.

```swift
public var voiceOverEnabled: Bool
```

#### largeTextEnabled
Whether large text support is enabled.

```swift
public var largeTextEnabled: Bool
```

#### highContrastEnabled
Whether high contrast support is enabled.

```swift
public var highContrastEnabled: Bool
```

#### reduceMotionEnabled
Whether reduce motion support is enabled.

```swift
public var reduceMotionEnabled: Bool
```

#### voiceOverLabel
The VoiceOver label for the notification.

```swift
public var voiceOverLabel: String?
```

#### voiceOverHint
The VoiceOver hint for the notification.

```swift
public var voiceOverHint: String?
```

#### voiceOverValue
The VoiceOver value for the notification.

```swift
public var voiceOverValue: String?
```

#### largeTextScale
The scale factor for large text.

```swift
public var largeTextScale: CGFloat
```

#### contrastRatio
The contrast ratio for high contrast mode.

```swift
public var contrastRatio: Double
```

#### accessibilityTraits
The accessibility traits for the notification.

```swift
public var accessibilityTraits: UIAccessibilityTraits
```

### Methods

#### init(voiceOverEnabled:largeTextEnabled:highContrastEnabled:reduceMotionEnabled:)

Creates an accessibility configuration.

```swift
public init(
    voiceOverEnabled: Bool,
    largeTextEnabled: Bool,
    highContrastEnabled: Bool,
    reduceMotionEnabled: Bool
)
```

**Parameters:**
- `voiceOverEnabled`: Whether VoiceOver is enabled
- `largeTextEnabled`: Whether large text is enabled
- `highContrastEnabled`: Whether high contrast is enabled
- `reduceMotionEnabled`: Whether reduce motion is enabled

#### validateAccessibility() -> Bool

Validates the accessibility configuration.

```swift
public func validateAccessibility() -> Bool
```

**Returns:** True if the accessibility configuration is valid

#### getAccessibilityScore() -> Double

Gets the accessibility score for the configuration.

```swift
public func getAccessibilityScore() -> Double
```

**Returns:** Accessibility score between 0.0 and 1.0

## VoiceOverSupport

### Class Definition

```swift
public class VoiceOverSupport {
    public var isVoiceOverRunning: Bool
    public var voiceOverAnnouncements: [String]
    public var voiceOverActions: [UIAccessibilityCustomAction]
    public var voiceOverNavigation: Bool
    public var voiceOverGrouping: Bool
}
```

### Properties

#### isVoiceOverRunning
Whether VoiceOver is currently running.

```swift
public var isVoiceOverRunning: Bool
```

#### voiceOverAnnouncements
Array of VoiceOver announcements.

```swift
public var voiceOverAnnouncements: [String]
```

#### voiceOverActions
Array of custom VoiceOver actions.

```swift
public var voiceOverActions: [UIAccessibilityCustomAction]
```

#### voiceOverNavigation
Whether VoiceOver navigation is enabled.

```swift
public var voiceOverNavigation: Bool
```

#### voiceOverGrouping
Whether VoiceOver grouping is enabled.

```swift
public var voiceOverGrouping: Bool
```

### Methods

#### announce(_:priority:)

Announces text to VoiceOver users.

```swift
public func announce(
    _ text: String,
    priority: UIAccessibilityAnnouncementPriority = .default
)
```

**Parameters:**
- `text`: The text to announce
- `priority`: The announcement priority

#### addCustomAction(name:target:selector:)

Adds a custom VoiceOver action.

```swift
public func addCustomAction(
    name: String,
    target: Any,
    selector: Selector
)
```

**Parameters:**
- `name`: The name of the action
- `target`: The target object
- `selector`: The selector to call

#### testVoiceOver(completion:)

Tests VoiceOver functionality.

```swift
public func testVoiceOver(completion: @escaping (Bool) -> Void)
```

**Parameters:**
- `completion`: Completion handler with test result

## VisualAccessibility

### Class Definition

```swift
public class VisualAccessibility {
    public var colorBlindFriendly: Bool
    public var usePatterns: Bool
    public var useShapes: Bool
    public var colorBlindType: ColorBlindType
    public var focusIndicatorEnabled: Bool
    public var focusIndicatorColor: UIColor
    public var focusIndicatorWidth: CGFloat
}
```

### Properties

#### colorBlindFriendly
Whether the notification is color-blind friendly.

```swift
public var colorBlindFriendly: Bool
```

#### usePatterns
Whether to use patterns instead of colors.

```swift
public var usePatterns: Bool
```

#### useShapes
Whether to use shapes for identification.

```swift
public var useShapes: Bool
```

#### colorBlindType
The type of color blindness to support.

```swift
public var colorBlindType: ColorBlindType
```

#### focusIndicatorEnabled
Whether focus indicators are enabled.

```swift
public var focusIndicatorEnabled: Bool
```

#### focusIndicatorColor
The color of the focus indicator.

```swift
public var focusIndicatorColor: UIColor
```

#### focusIndicatorWidth
The width of the focus indicator.

```swift
public var focusIndicatorWidth: CGFloat
```

### Enums

#### ColorBlindType

```swift
public enum ColorBlindType {
    case deuteranopia
    case protanopia
    case tritanopia
    case achromatopsia
}
```

### Methods

#### isColorBlindFriendly() -> Bool

Checks if the notification is color-blind friendly.

```swift
public func isColorBlindFriendly() -> Bool
```

**Returns:** True if the notification is color-blind friendly

#### getFocusIndicator() -> UIView

Gets the focus indicator view.

```swift
public func getFocusIndicator() -> UIView
```

**Returns:** The focus indicator view

## MotorAccessibility

### Class Definition

```swift
public class MotorAccessibility {
    public var minimumTouchTargetSize: CGSize
    public var touchTargetSpacing: CGFloat
    public var touchTargetPadding: CGFloat
    public var switchControlEnabled: Bool
    public var assistiveTouchEnabled: Bool
    public var switchControlOrder: [String]
    public var assistiveTouchActions: [String: String]
}
```

### Properties

#### minimumTouchTargetSize
The minimum size for touch targets.

```swift
public var minimumTouchTargetSize: CGSize
```

#### touchTargetSpacing
The spacing between touch targets.

```swift
public var touchTargetSpacing: CGFloat
```

#### touchTargetPadding
The padding around touch targets.

```swift
public var touchTargetPadding: CGFloat
```

#### switchControlEnabled
Whether Switch Control support is enabled.

```swift
public var switchControlEnabled: Bool
```

#### assistiveTouchEnabled
Whether Assistive Touch support is enabled.

```swift
public var assistiveTouchEnabled: Bool
```

#### switchControlOrder
The order of elements for Switch Control.

```swift
public var switchControlOrder: [String]
```

#### assistiveTouchActions
The actions available for Assistive Touch.

```swift
public var assistiveTouchActions: [String: String]
```

### Methods

#### validateTouchTargets() -> Bool

Validates touch target sizes.

```swift
public func validateTouchTargets() -> Bool
```

**Returns:** True if all touch targets meet minimum size requirements

#### getTouchTargets() -> [UIView]

Gets all touch target views.

```swift
public func getTouchTargets() -> [UIView]
```

**Returns:** Array of touch target views

## AccessibilityManager

### Class Definition

```swift
public class AccessibilityManager {
    public static let shared = AccessibilityManager()
    
    public var currentConfiguration: AccessibilityConfiguration?
    public var voiceOverSupport: VoiceOverSupport
    public var visualAccessibility: VisualAccessibility
    public var motorAccessibility: MotorAccessibility
}
```

### Properties

#### currentConfiguration
The current accessibility configuration.

```swift
public var currentConfiguration: AccessibilityConfiguration?
```

#### voiceOverSupport
The VoiceOver support instance.

```swift
public var voiceOverSupport: VoiceOverSupport
```

#### visualAccessibility
The visual accessibility instance.

```swift
public var visualAccessibility: VisualAccessibility
```

#### motorAccessibility
The motor accessibility instance.

```swift
public var motorAccessibility: MotorAccessibility
```

### Methods

#### setConfiguration(_:)

Sets the accessibility configuration.

```swift
public func setConfiguration(_ config: AccessibilityConfiguration)
```

**Parameters:**
- `config`: The accessibility configuration to set

#### getConfiguration() -> AccessibilityConfiguration?

Gets the current accessibility configuration.

```swift
public func getConfiguration() -> AccessibilityConfiguration?
```

**Returns:** The current accessibility configuration or nil

#### applyAccessibility(to:) -> NotificationContent

Applies accessibility features to a notification.

```swift
public func applyAccessibility(to notification: NotificationContent) -> NotificationContent
```

**Parameters:**
- `notification`: The notification to make accessible

**Returns:** The accessible notification

#### validateAccessibility() -> Bool

Validates all accessibility configurations.

```swift
public func validateAccessibility() -> Bool
```

**Returns:** True if all accessibility configurations are valid

#### getAccessibilityReport() -> AccessibilityReport

Gets a comprehensive accessibility report.

```swift
public func getAccessibilityReport() -> AccessibilityReport
```

**Returns:** Detailed accessibility report

## AccessibilityTester

### Class Definition

```swift
public class AccessibilityTester {
    public var testResults: [AccessibilityTestResult]
    public var wcagCompliance: WCAGCompliance
    public var accessibilityScore: Double
}
```

### Properties

#### testResults
Array of accessibility test results.

```swift
public var testResults: [AccessibilityTestResult]
```

#### wcagCompliance
WCAG compliance status.

```swift
public var wcagCompliance: WCAGCompliance
```

#### accessibilityScore
Overall accessibility score.

```swift
public var accessibilityScore: Double
```

### Methods

#### testNotification(_:completion:)

Tests a notification for accessibility compliance.

```swift
public func testNotification(
    _ notification: NotificationContent,
    completion: @escaping (AccessibilityTestResult) -> Void
)
```

**Parameters:**
- `notification`: The notification to test
- `completion`: Completion handler with test result

#### testVoiceOver() -> Bool

Tests VoiceOver functionality.

```swift
public func testVoiceOver() -> Bool
```

**Returns:** True if VoiceOver test passes

#### testLargeText() -> Bool

Tests large text support.

```swift
public func testLargeText() -> Bool
```

**Returns:** True if large text test passes

#### testHighContrast() -> Bool

Tests high contrast support.

```swift
public func testHighContrast() -> Bool
```

**Returns:** True if high contrast test passes

#### testTouchTargets() -> Bool

Tests touch target sizes.

```swift
public func testTouchTargets() -> Bool
```

**Returns:** True if touch target test passes

## Supporting Types

### AccessibilityTestResult

```swift
public struct AccessibilityTestResult {
    public let testName: String
    public let passed: Bool
    public let score: Double
    public let issues: [String]
    public let recommendations: [String]
}
```

### WCAGCompliance

```swift
public enum WCAGCompliance {
    case compliant
    case partiallyCompliant
    case nonCompliant
    case unknown
}
```

### AccessibilityReport

```swift
public struct AccessibilityReport {
    public let overallScore: Double
    public let wcagCompliance: WCAGCompliance
    public let voiceOverScore: Double
    public let largeTextScore: Double
    public let highContrastScore: Double
    public let touchTargetScore: Double
    public let issues: [String]
    public let recommendations: [String]
}
```

## Error Types

### AccessibilityError

```swift
public enum AccessibilityError: Error {
    case invalidConfiguration(AccessibilityConfiguration)
    case voiceOverTestFailed(String)
    case largeTextTestFailed(String)
    case highContrastTestFailed(String)
    case touchTargetTestFailed(String)
    case wcagComplianceFailed(String)
}
```

## Usage Examples

### Basic Accessibility Configuration

```swift
// Create accessibility configuration
let accessibilityConfig = AccessibilityConfiguration(
    voiceOverEnabled: true,
    largeTextEnabled: true,
    highContrastEnabled: true,
    reduceMotionEnabled: true
)

// Configure VoiceOver settings
accessibilityConfig.voiceOverLabel = "Important notification"
accessibilityConfig.voiceOverHint = "Double tap to open"
accessibilityConfig.voiceOverValue = "New message received"

// Apply accessibility to notification
let accessibleNotification = notification.withAccessibility(accessibilityConfig)

// Schedule accessible notification
try await notificationManager.schedule(
    accessibleNotification,
    at: Date().addingTimeInterval(60)
)
```

### VoiceOver Support

```swift
// Set up VoiceOver support
let voiceOverSupport = VoiceOverSupport()

// Add custom VoiceOver action
voiceOverSupport.addCustomAction(
    name: "Mark as Read",
    target: self,
    selector: #selector(markAsRead)
)

// Announce important information
voiceOverSupport.announce("New notification received", priority: .high)

// Test VoiceOver functionality
voiceOverSupport.testVoiceOver { success in
    print("VoiceOver test: \(success ? "✅ Passed" : "❌ Failed")")
}
```

### Visual Accessibility

```swift
// Set up visual accessibility
let visualAccessibility = VisualAccessibility()

// Configure color-blind friendly settings
visualAccessibility.colorBlindFriendly = true
visualAccessibility.usePatterns = true
visualAccessibility.useShapes = true
visualAccessibility.colorBlindType = .deuteranopia

// Configure focus indicators
visualAccessibility.focusIndicatorEnabled = true
visualAccessibility.focusIndicatorColor = UIColor.systemBlue
visualAccessibility.focusIndicatorWidth = 2.0

// Check color-blind friendliness
if visualAccessibility.isColorBlindFriendly() {
    print("✅ Notification is color-blind friendly")
} else {
    print("❌ Notification needs color-blind improvements")
}
```

### Motor Accessibility

```swift
// Set up motor accessibility
let motorAccessibility = MotorAccessibility()

// Configure touch targets
motorAccessibility.minimumTouchTargetSize = CGSize(width: 44, height: 44)
motorAccessibility.touchTargetSpacing = 8.0
motorAccessibility.touchTargetPadding = 4.0

// Configure Switch Control
motorAccessibility.switchControlEnabled = true
motorAccessibility.switchControlOrder = ["title", "body", "actions"]

// Configure Assistive Touch
motorAccessibility.assistiveTouchEnabled = true
motorAccessibility.assistiveTouchActions = [
    "single_tap": "Open notification",
    "double_tap": "Mark as read",
    "long_press": "Show options"
]

// Validate touch targets
if motorAccessibility.validateTouchTargets() {
    print("✅ All touch targets meet minimum size requirements")
} else {
    print("❌ Some touch targets are too small")
}
```

### Complete Accessibility Testing

```swift
// Set up accessibility tester
let accessibilityTester = AccessibilityTester()

// Test notification for accessibility
accessibilityTester.testNotification(notification) { result in
    print("📊 Accessibility Test Results:")
    print("Test: \(result.testName)")
    print("Passed: \(result.passed)")
    print("Score: \(result.score)")
    
    if !result.issues.isEmpty {
        print("Issues:")
        for issue in result.issues {
            print("- \(issue)")
        }
    }
    
    if !result.recommendations.isEmpty {
        print("Recommendations:")
        for recommendation in result.recommendations {
            print("- \(recommendation)")
        }
    }
}

// Test specific accessibility features
let voiceOverPassed = accessibilityTester.testVoiceOver()
let largeTextPassed = accessibilityTester.testLargeText()
let highContrastPassed = accessibilityTester.testHighContrast()
let touchTargetsPassed = accessibilityTester.testTouchTargets()

print("VoiceOver: \(voiceOverPassed ? "✅" : "❌")")
print("Large Text: \(largeTextPassed ? "✅" : "❌")")
print("High Contrast: \(highContrastPassed ? "✅" : "❌")")
print("Touch Targets: \(touchTargetsPassed ? "✅" : "❌")")
```

### Accessibility Manager Usage

```swift
// Set up accessibility manager
let accessibilityManager = AccessibilityManager.shared

// Set accessibility configuration
let config = AccessibilityConfiguration(
    voiceOverEnabled: true,
    largeTextEnabled: true,
    highContrastEnabled: true,
    reduceMotionEnabled: true
)
accessibilityManager.setConfiguration(config)

// Apply accessibility to notification
let accessibleNotification = accessibilityManager.applyAccessibility(to: notification)

// Validate accessibility
if accessibilityManager.validateAccessibility() {
    print("✅ All accessibility configurations are valid")
} else {
    print("❌ Some accessibility configurations are invalid")
}

// Get accessibility report
let report = accessibilityManager.getAccessibilityReport()
print("📊 Accessibility Report:")
print("Overall Score: \(report.overallScore)")
print("WCAG Compliance: \(report.wcagCompliance)")
print("VoiceOver Score: \(report.voiceOverScore)")
print("Large Text Score: \(report.largeTextScore)")
print("High Contrast Score: \(report.highContrastScore)")
print("Touch Target Score: \(report.touchTargetScore)")
```

This comprehensive API reference covers all aspects of accessibility in the iOS Notification Framework. Use these interfaces to create inclusive notification experiences that work for all users, regardless of their abilities.
