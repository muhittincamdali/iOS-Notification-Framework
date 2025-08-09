# Customization API Reference

<!-- TOC START -->
## Table of Contents
- [Customization API Reference](#customization-api-reference)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [NotificationTheme](#notificationtheme)
  - [Class Definition](#class-definition)
  - [Properties](#properties)
    - [primaryColor](#primarycolor)
    - [secondaryColor](#secondarycolor)
    - [backgroundColor](#backgroundcolor)
    - [textColor](#textcolor)
    - [accentColor](#accentcolor)
    - [font](#font)
    - [cornerRadius](#cornerradius)
    - [shadowEnabled](#shadowenabled)
    - [gradientEnabled](#gradientenabled)
    - [darkModeEnabled](#darkmodeenabled)
  - [Methods](#methods)
    - [init(primaryColor:secondaryColor:backgroundColor:textColor:accentColor:)](#initprimarycolorsecondarycolorbackgroundcolortextcoloraccentcolor)
    - [apply(to:) -> NotificationContent](#applyto-notificationcontent)
    - [validate() -> Bool](#validate-bool)
- [BrandConfiguration](#brandconfiguration)
  - [Class Definition](#class-definition)
  - [Properties](#properties)
    - [logoURL](#logourl)
    - [brandColors](#brandcolors)
    - [brandFont](#brandfont)
    - [logoPosition](#logoposition)
    - [colorScheme](#colorscheme)
    - [animationEnabled](#animationenabled)
  - [Enums](#enums)
    - [LogoPosition](#logoposition)
    - [ColorScheme](#colorscheme)
  - [Methods](#methods)
    - [init(logoURL:brandColors:brandFont:)](#initlogourlbrandcolorsbrandfont)
    - [applyBranding(to:) -> NotificationContent](#applybrandingto-notificationcontent)
- [AccessibilityConfiguration](#accessibilityconfiguration)
  - [Class Definition](#class-definition)
  - [Properties](#properties)
    - [voiceOverEnabled](#voiceoverenabled)
    - [largeTextEnabled](#largetextenabled)
    - [highContrastEnabled](#highcontrastenabled)
    - [reduceMotionEnabled](#reducemotionenabled)
    - [voiceOverLabel](#voiceoverlabel)
    - [voiceOverHint](#voiceoverhint)
    - [largeTextScale](#largetextscale)
    - [contrastRatio](#contrastratio)
  - [Methods](#methods)
    - [init(voiceOverEnabled:largeTextEnabled:highContrastEnabled:reduceMotionEnabled:)](#initvoiceoverenabledlargetextenabledhighcontrastenabledreducemotionenabled)
    - [validateAccessibility() -> Bool](#validateaccessibility-bool)
- [AnimationConfiguration](#animationconfiguration)
  - [Class Definition](#class-definition)
  - [Properties](#properties)
    - [entranceAnimation](#entranceanimation)
    - [interactionAnimation](#interactionanimation)
    - [duration](#duration)
    - [easing](#easing)
    - [interactionEnabled](#interactionenabled)
    - [hapticFeedback](#hapticfeedback)
    - [visualFeedback](#visualfeedback)
  - [Enums](#enums)
    - [AnimationType](#animationtype)
    - [EasingType](#easingtype)
  - [Methods](#methods)
    - [init(entranceAnimation:duration:easing:)](#initentranceanimationdurationeasing)
    - [setCustomAnimation(_:)](#setcustomanimation)
- [CustomizationManager](#customizationmanager)
  - [Class Definition](#class-definition)
  - [Properties](#properties)
    - [currentTheme](#currenttheme)
    - [brandConfiguration](#brandconfiguration)
    - [accessibilityConfiguration](#accessibilityconfiguration)
    - [animationConfiguration](#animationconfiguration)
  - [Methods](#methods)
    - [setTheme(_:)](#settheme)
    - [getTheme() -> NotificationTheme?](#gettheme-notificationtheme)
    - [setBrandConfiguration(_:)](#setbrandconfiguration)
    - [customizeNotification(_:) -> NotificationContent](#customizenotification-notificationcontent)
    - [validateCustomization() -> Bool](#validatecustomization-bool)
- [ThemeTemplates](#themetemplates)
  - [Class Definition](#class-definition)
  - [Static Properties](#static-properties)
    - [light](#light)
    - [dark](#dark)
    - [highContrast](#highcontrast)
  - [Methods](#methods)
    - [createCustomTheme(primaryColor:accentColor:) -> NotificationTheme](#createcustomthemeprimarycoloraccentcolor-notificationtheme)
- [Error Types](#error-types)
  - [CustomizationError](#customizationerror)
- [Usage Examples](#usage-examples)
  - [Basic Theme Application](#basic-theme-application)
  - [Brand Integration](#brand-integration)
  - [Accessibility Configuration](#accessibility-configuration)
  - [Animation Configuration](#animation-configuration)
  - [Complete Customization](#complete-customization)
<!-- TOC END -->


## Overview

The Customization API provides comprehensive theming and branding capabilities for iOS notifications. This document covers all public interfaces, methods, and properties for customizing the appearance and behavior of your notifications.

## Table of Contents

- [NotificationTheme](#notificationtheme)
- [BrandConfiguration](#brandconfiguration)
- [AccessibilityConfiguration](#accessibilityconfiguration)
- [AnimationConfiguration](#animationconfiguration)
- [CustomizationManager](#customizationmanager)
- [ThemeTemplates](#themetemplates)

## NotificationTheme

### Class Definition

```swift
public class NotificationTheme {
    public var primaryColor: UIColor
    public var secondaryColor: UIColor
    public var backgroundColor: UIColor
    public var textColor: UIColor
    public var accentColor: UIColor
    public var font: UIFont
    public var cornerRadius: CGFloat
    public var shadowEnabled: Bool
    public var gradientEnabled: Bool
    public var darkModeEnabled: Bool
}
```

### Properties

#### primaryColor
The primary color for the notification theme.

```swift
public var primaryColor: UIColor
```

#### secondaryColor
The secondary color for the notification theme.

```swift
public var secondaryColor: UIColor
```

#### backgroundColor
The background color for the notification theme.

```swift
public var backgroundColor: UIColor
```

#### textColor
The text color for the notification theme.

```swift
public var textColor: UIColor
```

#### accentColor
The accent color for the notification theme.

```swift
public var accentColor: UIColor
```

#### font
The font for the notification text.

```swift
public var font: UIFont
```

#### cornerRadius
The corner radius for the notification.

```swift
public var cornerRadius: CGFloat
```

#### shadowEnabled
Whether shadows are enabled for the notification.

```swift
public var shadowEnabled: Bool
```

#### gradientEnabled
Whether gradients are enabled for the notification.

```swift
public var gradientEnabled: Bool
```

#### darkModeEnabled
Whether dark mode support is enabled.

```swift
public var darkModeEnabled: Bool
```

### Methods

#### init(primaryColor:secondaryColor:backgroundColor:textColor:accentColor:)

Creates a notification theme with custom colors.

```swift
public init(
    primaryColor: UIColor,
    secondaryColor: UIColor,
    backgroundColor: UIColor,
    textColor: UIColor,
    accentColor: UIColor
)
```

**Parameters:**
- `primaryColor`: The primary color
- `secondaryColor`: The secondary color
- `backgroundColor`: The background color
- `textColor`: The text color
- `accentColor`: The accent color

#### apply(to:) -> NotificationContent

Applies the theme to a notification content.

```swift
public func apply(to notification: NotificationContent) -> NotificationContent
```

**Parameters:**
- `notification`: The notification content to theme

**Returns:** The themed notification content

#### validate() -> Bool

Validates the theme configuration.

```swift
public func validate() -> Bool
```

**Returns:** True if the theme is valid

## BrandConfiguration

### Class Definition

```swift
public class BrandConfiguration {
    public var logoURL: String?
    public var brandColors: [UIColor]
    public var brandFont: UIFont
    public var logoPosition: LogoPosition
    public var colorScheme: ColorScheme
    public var animationEnabled: Bool
}
```

### Properties

#### logoURL
The URL for the brand logo.

```swift
public var logoURL: String?
```

#### brandColors
Array of brand colors.

```swift
public var brandColors: [UIColor]
```

#### brandFont
The brand font.

```swift
public var brandFont: UIFont
```

#### logoPosition
The position of the logo in the notification.

```swift
public var logoPosition: LogoPosition
```

#### colorScheme
The color scheme for the brand.

```swift
public var colorScheme: ColorScheme
```

#### animationEnabled
Whether brand animations are enabled.

```swift
public var animationEnabled: Bool
```

### Enums

#### LogoPosition

```swift
public enum LogoPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center
}
```

#### ColorScheme

```swift
public enum ColorScheme {
    case light
    case dark
    case automatic
}
```

### Methods

#### init(logoURL:brandColors:brandFont:)

Creates a brand configuration.

```swift
public init(
    logoURL: String?,
    brandColors: [UIColor],
    brandFont: UIFont
)
```

**Parameters:**
- `logoURL`: Optional URL for the brand logo
- `brandColors`: Array of brand colors
- `brandFont`: The brand font

#### applyBranding(to:) -> NotificationContent

Applies branding to a notification content.

```swift
public func applyBranding(to notification: NotificationContent) -> NotificationContent
```

**Parameters:**
- `notification`: The notification content to brand

**Returns:** The branded notification content

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
    public var largeTextScale: CGFloat
    public var contrastRatio: Double
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

## AnimationConfiguration

### Class Definition

```swift
public class AnimationConfiguration {
    public var entranceAnimation: AnimationType
    public var interactionAnimation: AnimationType
    public var duration: TimeInterval
    public var easing: EasingType
    public var interactionEnabled: Bool
    public var hapticFeedback: Bool
    public var visualFeedback: Bool
}
```

### Properties

#### entranceAnimation
The type of entrance animation.

```swift
public var entranceAnimation: AnimationType
```

#### interactionAnimation
The type of interaction animation.

```swift
public var interactionAnimation: AnimationType
```

#### duration
The duration of animations.

```swift
public var duration: TimeInterval
```

#### easing
The easing type for animations.

```swift
public var easing: EasingType
```

#### interactionEnabled
Whether interaction animations are enabled.

```swift
public var interactionEnabled: Bool
```

#### hapticFeedback
Whether haptic feedback is enabled.

```swift
public var hapticFeedback: Bool
```

#### visualFeedback
Whether visual feedback is enabled.

```swift
public var visualFeedback: Bool
```

### Enums

#### AnimationType

```swift
public enum AnimationType {
    case none
    case fadeIn
    case slideIn
    case scaleIn
    case bounceIn
    case custom
}
```

#### EasingType

```swift
public enum EasingType {
    case linear
    case easeIn
    case easeOut
    case easeInOut
    case spring
}
```

### Methods

#### init(entranceAnimation:duration:easing:)

Creates an animation configuration.

```swift
public init(
    entranceAnimation: AnimationType,
    duration: TimeInterval,
    easing: EasingType
)
```

**Parameters:**
- `entranceAnimation`: The entrance animation type
- `duration`: The animation duration
- `easing`: The easing type

#### setCustomAnimation(_:)

Sets a custom animation block.

```swift
public func setCustomAnimation(_ animation: @escaping (UIView) -> Void)
```

**Parameters:**
- `animation`: The custom animation block

## CustomizationManager

### Class Definition

```swift
public class CustomizationManager {
    public static let shared = CustomizationManager()
    
    public var currentTheme: NotificationTheme?
    public var brandConfiguration: BrandConfiguration?
    public var accessibilityConfiguration: AccessibilityConfiguration?
    public var animationConfiguration: AnimationConfiguration?
}
```

### Properties

#### currentTheme
The currently active theme.

```swift
public var currentTheme: NotificationTheme?
```

#### brandConfiguration
The current brand configuration.

```swift
public var brandConfiguration: BrandConfiguration?
```

#### accessibilityConfiguration
The current accessibility configuration.

```swift
public var accessibilityConfiguration: AccessibilityConfiguration?
```

#### animationConfiguration
The current animation configuration.

```swift
public var animationConfiguration: AnimationConfiguration?
```

### Methods

#### setTheme(_:)

Sets the current theme.

```swift
public func setTheme(_ theme: NotificationTheme)
```

**Parameters:**
- `theme`: The theme to set

#### getTheme() -> NotificationTheme?

Gets the current theme.

```swift
public func getTheme() -> NotificationTheme?
```

**Returns:** The current theme or nil if none is set

#### setBrandConfiguration(_:)

Sets the brand configuration.

```swift
public func setBrandConfiguration(_ config: BrandConfiguration)
```

**Parameters:**
- `config`: The brand configuration to set

#### customizeNotification(_:) -> NotificationContent

Customizes a notification with all current configurations.

```swift
public func customizeNotification(_ notification: NotificationContent) -> NotificationContent
```

**Parameters:**
- `notification`: The notification to customize

**Returns:** The customized notification

#### validateCustomization() -> Bool

Validates all customization configurations.

```swift
public func validateCustomization() -> Bool
```

**Returns:** True if all configurations are valid

## ThemeTemplates

### Class Definition

```swift
public class ThemeTemplates {
    public static let light = NotificationTheme(
        primaryColor: UIColor.systemBlue,
        secondaryColor: UIColor.systemGray,
        backgroundColor: UIColor.systemBackground,
        textColor: UIColor.label,
        accentColor: UIColor.systemOrange
    )
    
    public static let dark = NotificationTheme(
        primaryColor: UIColor.systemBlue,
        secondaryColor: UIColor.systemGray2,
        backgroundColor: UIColor.systemGray6,
        textColor: UIColor.label,
        accentColor: UIColor.systemOrange
    )
    
    public static let highContrast = NotificationTheme(
        primaryColor: UIColor.black,
        secondaryColor: UIColor.white,
        backgroundColor: UIColor.white,
        textColor: UIColor.black,
        accentColor: UIColor.systemBlue
    )
}
```

### Static Properties

#### light
A light theme template.

```swift
public static let light: NotificationTheme
```

#### dark
A dark theme template.

```swift
public static let dark: NotificationTheme
```

#### highContrast
A high contrast theme template.

```swift
public static let highContrast: NotificationTheme
```

### Methods

#### createCustomTheme(primaryColor:accentColor:) -> NotificationTheme

Creates a custom theme with specified colors.

```swift
public static func createCustomTheme(
    primaryColor: UIColor,
    accentColor: UIColor
) -> NotificationTheme
```

**Parameters:**
- `primaryColor`: The primary color
- `accentColor`: The accent color

**Returns:** A custom theme with the specified colors

## Error Types

### CustomizationError

```swift
public enum CustomizationError: Error {
    case invalidTheme(NotificationTheme)
    case invalidBrandConfiguration(BrandConfiguration)
    case invalidAccessibilityConfiguration(AccessibilityConfiguration)
    case invalidAnimationConfiguration(AnimationConfiguration)
    case themeApplicationFailed(String)
    case brandApplicationFailed(String)
}
```

## Usage Examples

### Basic Theme Application

```swift
// Create a custom theme
let customTheme = NotificationTheme(
    primaryColor: UIColor.systemBlue,
    secondaryColor: UIColor.systemGray,
    backgroundColor: UIColor.systemBackground,
    textColor: UIColor.label,
    accentColor: UIColor.systemOrange
)

// Apply theme to notification
let themedNotification = customTheme.apply(to: notification)

// Schedule themed notification
try await notificationManager.schedule(
    themedNotification,
    at: Date().addingTimeInterval(60)
)
```

### Brand Integration

```swift
// Create brand configuration
let brandConfig = BrandConfiguration(
    logoURL: "https://example.com/logo.png",
    brandColors: [UIColor.systemBlue, UIColor.systemGreen],
    brandFont: .systemFont(ofSize: 18, weight: .bold)
)

// Apply branding to notification
let brandedNotification = brandConfig.applyBranding(to: notification)

// Schedule branded notification
try await notificationManager.schedule(
    brandedNotification,
    at: Date().addingTimeInterval(60)
)
```

### Accessibility Configuration

```swift
// Create accessibility configuration
let accessibilityConfig = AccessibilityConfiguration(
    voiceOverEnabled: true,
    largeTextEnabled: true,
    highContrastEnabled: true,
    reduceMotionEnabled: true
)

// Configure accessibility settings
accessibilityConfig.voiceOverLabel = "Important notification"
accessibilityConfig.voiceOverHint = "Double tap to open"
accessibilityConfig.largeTextScale = 1.2

// Apply accessibility to notification
let accessibleNotification = notification.withAccessibility(accessibilityConfig)
```

### Animation Configuration

```swift
// Create animation configuration
let animationConfig = AnimationConfiguration(
    entranceAnimation: .slideIn,
    duration: 0.5,
    easing: .easeOut
)

// Configure animation settings
animationConfig.interactionEnabled = true
animationConfig.hapticFeedback = true
animationConfig.visualFeedback = true

// Apply animation to notification
let animatedNotification = notification.withAnimation(animationConfig)
```

### Complete Customization

```swift
// Set up customization manager
let customizationManager = CustomizationManager.shared

// Set theme
customizationManager.setTheme(ThemeTemplates.light)

// Set brand configuration
let brandConfig = BrandConfiguration(
    logoURL: "https://example.com/logo.png",
    brandColors: [UIColor.systemBlue],
    brandFont: .systemFont(ofSize: 16, weight: .medium)
)
customizationManager.setBrandConfiguration(brandConfig)

// Set accessibility configuration
let accessibilityConfig = AccessibilityConfiguration(
    voiceOverEnabled: true,
    largeTextEnabled: true,
    highContrastEnabled: true,
    reduceMotionEnabled: true
)
customizationManager.setAccessibilityConfiguration(accessibilityConfig)

// Customize notification
let customizedNotification = customizationManager.customizeNotification(notification)

// Schedule customized notification
try await notificationManager.schedule(
    customizedNotification,
    at: Date().addingTimeInterval(60)
)
```

This comprehensive API reference covers all aspects of customization in the iOS Notification Framework. Use these interfaces to create visually appealing, brand-consistent, and accessible notification experiences.
