# Customization Guide

## Overview

The Customization module provides comprehensive theming and branding capabilities for iOS notifications, enabling you to create visually appealing and brand-consistent notification experiences. This guide covers everything you need to know about customizing the appearance and behavior of your notifications.

## Table of Contents

- [Getting Started](#getting-started)
- [Basic Theming](#basic-theming)
- [Advanced Theming](#advanced-theming)
- [Brand Integration](#brand-integration)
- [Accessibility](#accessibility)
- [Animation](#animation)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
- Notification permissions granted
- Brand assets (logos, colors, fonts)

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

// Enable customization
let config = NotificationConfiguration()
config.enableCustomization = true
config.enableBranding = true
config.enableAccessibility = true

notificationManager.configure(config)
```

## Basic Theming

### Simple Theme

```swift
// Create simple theme
let simpleTheme = NotificationTheme(
    primaryColor: UIColor.systemBlue,
    secondaryColor: UIColor.systemGray,
    backgroundColor: UIColor.systemBackground,
    textColor: UIColor.label,
    accentColor: UIColor.systemOrange
)

// Apply theme to notification
let themedNotification = NotificationContent(
    title: "Themed Notification",
    body: "This notification uses custom theming",
    theme: simpleTheme
)

// Schedule themed notification
try await notificationManager.schedule(
    themedNotification,
    at: Date().addingTimeInterval(60)
)
```

### Custom Colors

```swift
// Create custom color theme
let customTheme = NotificationTheme(
    primaryColor: UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0),
    secondaryColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0),
    backgroundColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0),
    textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0),
    accentColor: UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
)

// Apply custom theme
let customNotification = NotificationContent(
    title: "Custom Colors",
    body: "This notification uses custom colors",
    theme: customTheme
)

try await notificationManager.schedule(
    customNotification,
    at: Date().addingTimeInterval(60)
)
```

### Typography

```swift
// Create theme with custom typography
let typographyTheme = NotificationTheme(
    primaryColor: UIColor.systemBlue,
    secondaryColor: UIColor.systemGray,
    backgroundColor: UIColor.systemBackground,
    textColor: UIColor.label,
    accentColor: UIColor.systemOrange
)

// Configure typography
typographyTheme.font = .systemFont(ofSize: 16, weight: .medium)
typographyTheme.titleFont = .systemFont(ofSize: 18, weight: .bold)
typographyTheme.bodyFont = .systemFont(ofSize: 14, weight: .regular)
typographyTheme.lineSpacing = 1.2
typographyTheme.letterSpacing = 0.5

// Apply typography theme
let typographyNotification = NotificationContent(
    title: "Typography Example",
    body: "This notification uses custom typography",
    theme: typographyTheme
)

try await notificationManager.schedule(
    typographyNotification,
    at: Date().addingTimeInterval(60)
)
```

## Advanced Theming

### Gradient Themes

```swift
// Create gradient theme
let gradientTheme = NotificationTheme(
    primaryColor: UIColor.systemBlue,
    secondaryColor: UIColor.systemGray,
    backgroundColor: UIColor.systemBackground,
    textColor: UIColor.label,
    accentColor: UIColor.systemOrange
)

// Configure gradient
gradientTheme.gradientEnabled = true
gradientTheme.gradientColors = [
    UIColor.systemBlue,
    UIColor.systemPurple
]
gradientTheme.gradientDirection = .horizontal
gradientTheme.gradientOpacity = 0.8

// Apply gradient theme
let gradientNotification = NotificationContent(
    title: "Gradient Theme",
    body: "This notification uses a gradient background",
    theme: gradientTheme
)

try await notificationManager.schedule(
    gradientNotification,
    at: Date().addingTimeInterval(60)
)
```

### Shadow and Effects

```swift
// Create theme with shadows
let shadowTheme = NotificationTheme(
    primaryColor: UIColor.systemBlue,
    secondaryColor: UIColor.systemGray,
    backgroundColor: UIColor.systemBackground,
    textColor: UIColor.label,
    accentColor: UIColor.systemOrange
)

// Configure shadows
shadowTheme.shadowEnabled = true
shadowTheme.shadowColor = UIColor.black
shadowTheme.shadowOpacity = 0.3
shadowTheme.shadowRadius = 8.0
shadowTheme.shadowOffset = CGSize(width: 0, height: 4)

// Configure corner radius
shadowTheme.cornerRadius = 12.0
shadowTheme.borderWidth = 1.0
shadowTheme.borderColor = UIColor.systemGray4

// Apply shadow theme
let shadowNotification = NotificationContent(
    title: "Shadow Effects",
    body: "This notification uses shadow effects",
    theme: shadowTheme
)

try await notificationManager.schedule(
    shadowNotification,
    at: Date().addingTimeInterval(60)
)
```

### Dark Mode Support

```swift
// Create dark mode compatible theme
let darkModeTheme = NotificationTheme(
    primaryColor: UIColor.systemBlue,
    secondaryColor: UIColor.systemGray,
    backgroundColor: UIColor.systemBackground,
    textColor: UIColor.label,
    accentColor: UIColor.systemOrange
)

// Configure dark mode support
darkModeTheme.darkModeEnabled = true
darkModeTheme.darkModeColors = [
    .primaryColor: UIColor.systemBlue,
    .secondaryColor: UIColor.systemGray2,
    .backgroundColor: UIColor.systemGray6,
    .textColor: UIColor.label,
    .accentColor: UIColor.systemOrange
]

// Apply dark mode theme
let darkModeNotification = NotificationContent(
    title: "Dark Mode Support",
    body: "This notification adapts to dark mode",
    theme: darkModeTheme
)

try await notificationManager.schedule(
    darkModeNotification,
    at: Date().addingTimeInterval(60)
)
```

## Brand Integration

### Brand Colors

```swift
// Create brand-specific theme
let brandTheme = NotificationTheme(
    primaryColor: UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0), // Brand blue
    secondaryColor: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0), // Light gray
    backgroundColor: UIColor.white,
    textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), // Dark text
    accentColor: UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0) // Brand orange
)

// Apply brand theme
let brandNotification = NotificationContent(
    title: "Brand Notification",
    body: "This notification uses your brand colors",
    theme: brandTheme
)

try await notificationManager.schedule(
    brandNotification,
    at: Date().addingTimeInterval(60)
)
```

### Brand Logo

```swift
// Create notification with brand logo
let brandLogoNotification = NotificationContent(
    title: "Brand Logo",
    body: "This notification includes your brand logo",
    brand: BrandConfiguration(
        logoURL: "https://example.com/logo.png",
        brandColors: [UIColor.systemBlue, UIColor.systemGreen],
        brandFont: .systemFont(ofSize: 18, weight: .bold)
    )
)

// Configure brand settings
brandLogoNotification.brand.logoPosition = .topRight
brandLogoNotification.brand.logoSize = CGSize(width: 40, height: 40)
brandLogoNotification.brand.logoCornerRadius = 8.0
brandLogoNotification.brand.logoShadowEnabled = true

try await notificationManager.schedule(
    brandLogoNotification,
    at: Date().addingTimeInterval(60)
)
```

### Brand Consistency

```swift
// Create consistent brand theme
let consistentBrandTheme = NotificationTheme(
    primaryColor: UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0),
    secondaryColor: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0),
    backgroundColor: UIColor.white,
    textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0),
    accentColor: UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
)

// Configure brand consistency
consistentBrandTheme.brandConsistency = true
consistentBrandTheme.brandGuidelines = [
    "primary_color": UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0),
    "secondary_color": UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0),
    "accent_color": UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0),
    "font_family": "Helvetica Neue",
    "font_weight": "Medium"
]

// Apply consistent brand theme
let consistentNotification = NotificationContent(
    title: "Brand Consistent",
    body: "This notification follows brand guidelines",
    theme: consistentBrandTheme
)

try await notificationManager.schedule(
    consistentNotification,
    at: Date().addingTimeInterval(60)
)
```

## Accessibility

### VoiceOver Support

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

// Configure accessibility settings
accessibleNotification.accessibility.voiceOverLabel = "Important notification"
accessibleNotification.accessibility.voiceOverHint = "Double tap to open"
accessibleNotification.accessibility.largeTextScale = 1.2
accessibleNotification.accessibility.highContrastMode = true

try await notificationManager.schedule(
    accessibleNotification,
    at: Date().addingTimeInterval(60)
)
```

### High Contrast Mode

```swift
// Create high contrast theme
let highContrastTheme = NotificationTheme(
    primaryColor: UIColor.black,
    secondaryColor: UIColor.white,
    backgroundColor: UIColor.white,
    textColor: UIColor.black,
    accentColor: UIColor.systemBlue
)

// Configure high contrast
highContrastTheme.highContrastEnabled = true
highContrastTheme.contrastRatio = 4.5 // WCAG AA compliant
highContrastTheme.boldTextEnabled = true
highContrastTheme.largeTextEnabled = true

// Apply high contrast theme
let highContrastNotification = NotificationContent(
    title: "High Contrast",
    body: "This notification supports high contrast mode",
    theme: highContrastTheme
)

try await notificationManager.schedule(
    highContrastNotification,
    at: Date().addingTimeInterval(60)
)
```

### Reduce Motion

```swift
// Create motion-reduced notification
let motionReducedNotification = NotificationContent(
    title: "Motion Reduced",
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

try await notificationManager.schedule(
    motionReducedNotification,
    at: Date().addingTimeInterval(60)
)
```

## Animation

### Entrance Animations

```swift
// Create animated notification
let animatedNotification = NotificationContent(
    title: "Animated Notification",
    body: "This notification has entrance animations",
    animation: AnimationConfiguration(
        entranceAnimation: .slideIn,
        duration: 0.5,
        easing: .easeOut
    )
)

// Configure entrance animation
animatedNotification.animation.entranceDirection = .fromTop
animatedNotification.animation.entranceDelay = 0.1
animatedNotification.animation.entranceSpring = true

try await notificationManager.schedule(
    animatedNotification,
    at: Date().addingTimeInterval(60)
)
```

### Interactive Animations

```swift
// Create interactive animated notification
let interactiveNotification = NotificationContent(
    title: "Interactive Animation",
    body: "Tap to see interactive animations",
    animation: AnimationConfiguration(
        entranceAnimation: .fadeIn,
        interactionAnimation: .scale,
        duration: 0.3,
        easing: .easeInOut
    )
)

// Configure interactive animations
interactiveNotification.animation.interactionEnabled = true
interactiveNotification.animation.hapticFeedback = true
interactiveNotification.animation.visualFeedback = true

try await notificationManager.schedule(
    interactiveNotification,
    at: Date().addingTimeInterval(60)
)
```

### Custom Animations

```swift
// Create custom animated notification
let customAnimatedNotification = NotificationContent(
    title: "Custom Animation",
    body: "This notification uses custom animations",
    animation: AnimationConfiguration(
        entranceAnimation: .custom,
        duration: 0.8,
        easing: .easeInOut
    )
)

// Configure custom animation
customAnimatedNotification.animation.customEntrance = { view in
    // Custom entrance animation
    view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    view.alpha = 0.0
    
    UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseInOut) {
        view.transform = .identity
        view.alpha = 1.0
    }
}

try await notificationManager.schedule(
    customAnimatedNotification,
    at: Date().addingTimeInterval(60)
)
```

## Best Practices

### 1. Color Contrast

```swift
// Ensure proper color contrast
let highContrastTheme = NotificationTheme(
    primaryColor: UIColor.black,
    secondaryColor: UIColor.white,
    backgroundColor: UIColor.white,
    textColor: UIColor.black,
    accentColor: UIColor.systemBlue
)

// Verify contrast ratio
let contrastRatio = highContrastTheme.calculateContrastRatio()
if contrastRatio >= 4.5 {
    print("✅ WCAG AA compliant contrast ratio: \(contrastRatio)")
} else {
    print("❌ Insufficient contrast ratio: \(contrastRatio)")
}
```

### 2. Typography Hierarchy

```swift
// Create proper typography hierarchy
let hierarchyTheme = NotificationTheme(
    primaryColor: UIColor.systemBlue,
    secondaryColor: UIColor.systemGray,
    backgroundColor: UIColor.systemBackground,
    textColor: UIColor.label,
    accentColor: UIColor.systemOrange
)

// Configure typography hierarchy
hierarchyTheme.titleFont = .systemFont(ofSize: 18, weight: .bold)
hierarchyTheme.bodyFont = .systemFont(ofSize: 14, weight: .regular)
hierarchyTheme.captionFont = .systemFont(ofSize: 12, weight: .medium)
hierarchyTheme.lineSpacing = 1.2
hierarchyTheme.letterSpacing = 0.5
```

### 3. Brand Consistency

```swift
// Maintain brand consistency
let brandConsistencyChecker = BrandConsistencyChecker()
brandConsistencyChecker.verifyTheme(theme) { result in
    if result.isConsistent {
        print("✅ Theme is brand consistent")
    } else {
        print("❌ Theme violates brand guidelines:")
        for violation in result.violations {
            print("- \(violation)")
        }
    }
}
```

### 4. Performance Optimization

```swift
// Optimize theme performance
let performanceTheme = NotificationTheme(
    primaryColor: UIColor.systemBlue,
    secondaryColor: UIColor.systemGray,
    backgroundColor: UIColor.systemBackground,
    textColor: UIColor.label,
    accentColor: UIColor.systemOrange
)

// Configure performance settings
performanceTheme.cacheEnabled = true
performanceTheme.preloadAssets = true
performanceTheme.optimizeRendering = true
```

### 5. Accessibility Compliance

```swift
// Ensure accessibility compliance
let accessibilityChecker = AccessibilityComplianceChecker()
accessibilityChecker.verifyNotification(notification) { result in
    if result.isCompliant {
        print("✅ Notification is accessibility compliant")
    } else {
        print("❌ Accessibility issues found:")
        for issue in result.issues {
            print("- \(issue)")
        }
    }
}
```

## Troubleshooting

### Common Issues

#### 1. Theme Not Applying

```swift
// Check theme configuration
let theme = notification.theme
print("Theme enabled: \(theme.isEnabled)")
print("Primary color: \(theme.primaryColor)")
print("Background color: \(theme.backgroundColor)")

// Verify theme application
if theme.isEnabled {
    print("✅ Theme is properly configured")
} else {
    print("❌ Theme is not enabled")
}
```

#### 2. Brand Assets Not Loading

```swift
// Check brand asset loading
let brandConfig = notification.brand
print("Logo URL: \(brandConfig.logoURL)")
print("Logo loaded: \(brandConfig.isLogoLoaded)")

// Verify asset availability
if brandConfig.isLogoLoaded {
    print("✅ Brand logo loaded successfully")
} else {
    print("❌ Brand logo failed to load")
}
```

#### 3. Accessibility Issues

```swift
// Check accessibility configuration
let accessibility = notification.accessibility
print("VoiceOver enabled: \(accessibility.voiceOverEnabled)")
print("Large text enabled: \(accessibility.largeTextEnabled)")
print("High contrast enabled: \(accessibility.highContrastEnabled)")

// Test accessibility features
accessibility.testVoiceOver { success in
    print("VoiceOver test: \(success ? "✅ Passed" : "❌ Failed")")
}
```

### Debug Mode

```swift
// Enable customization debug mode
notificationManager.enableCustomizationDebugMode()

// Get customization debug logs
notificationManager.getCustomizationDebugLogs { logs in
    for log in logs {
        print("🔍 Customization Debug: \(log)")
    }
}
```

### Performance Monitoring

```swift
// Monitor customization performance
notificationManager.startCustomizationPerformanceMonitoring()

// Get performance metrics
notificationManager.getCustomizationPerformanceMetrics { metrics in
    print("📊 Customization Performance:")
    print("Theme application time: \(metrics.themeApplicationTime)ms")
    print("Asset loading time: \(metrics.assetLoadingTime)ms")
    print("Animation frame rate: \(metrics.animationFrameRate)fps")
    print("Memory usage: \(metrics.memoryUsage)MB")
}
```

## Advanced Features

### Dynamic Theming

```swift
// Create dynamic theme that adapts to content
class DynamicThemeGenerator {
    func generateTheme(for content: String) -> NotificationTheme {
        // Analyze content sentiment
        let sentiment = analyzeSentiment(content)
        
        // Generate appropriate theme
        switch sentiment {
        case .positive:
            return createPositiveTheme()
        case .negative:
            return createNegativeTheme()
        case .neutral:
            return createNeutralTheme()
        }
    }
}
```

### Theme Templates

```swift
// Create theme templates for different use cases
let themeTemplates = [
    "welcome": NotificationTheme(
        primaryColor: UIColor.systemBlue,
        secondaryColor: UIColor.systemGray,
        backgroundColor: UIColor.systemBackground,
        textColor: UIColor.label,
        accentColor: UIColor.systemGreen
    ),
    "alert": NotificationTheme(
        primaryColor: UIColor.systemRed,
        secondaryColor: UIColor.systemGray,
        backgroundColor: UIColor.systemBackground,
        textColor: UIColor.label,
        accentColor: UIColor.systemOrange
    ),
    "success": NotificationTheme(
        primaryColor: UIColor.systemGreen,
        secondaryColor: UIColor.systemGray,
        backgroundColor: UIColor.systemBackground,
        textColor: UIColor.label,
        accentColor: UIColor.systemBlue
    )
]

// Apply template
let templateTheme = themeTemplates["welcome"]
let templatedNotification = NotificationContent(
    title: "Welcome!",
    body: "Thank you for using our app",
    theme: templateTheme
)
```

This comprehensive guide covers all aspects of customization in the iOS Notification Framework. Follow these patterns to create visually appealing, brand-consistent, and accessible notification experiences.
