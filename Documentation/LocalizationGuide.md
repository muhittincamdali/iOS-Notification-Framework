# Localization Guide

<!-- TOC START -->
## Table of Contents
- [Localization Guide](#localization-guide)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Basic Setup](#basic-setup)
- [Basic Localization](#basic-localization)
  - [Simple Localized Notification](#simple-localized-notification)
  - [Localization Files](#localization-files)
  - [Language Detection](#language-detection)
  - [Manual Language Selection](#manual-language-selection)
- [Advanced Localization](#advanced-localization)
  - [Pluralization Support](#pluralization-support)
  - [String Formatting](#string-formatting)
  - [Localization Files with Formatting](#localization-files-with-formatting)
  - [Context-Aware Localization](#context-aware-localization)
- [Dynamic Localization](#dynamic-localization)
  - [Runtime Language Switching](#runtime-language-switching)
  - [Language Preferences](#language-preferences)
  - [Dynamic Content Loading](#dynamic-content-loading)
- [Cultural Adaptation](#cultural-adaptation)
  - [Date and Time Formatting](#date-and-time-formatting)
  - [Number Formatting](#number-formatting)
  - [Cultural Sensitivity](#cultural-sensitivity)
- [RTL Support](#rtl-support)
  - [Right-to-Left Languages](#right-to-left-languages)
  - [RTL Localization Files](#rtl-localization-files)
  - [Mixed RTL and LTR](#mixed-rtl-and-ltr)
- [Best Practices](#best-practices)
  - [1. Language Organization](#1-language-organization)
  - [2. Translation Quality](#2-translation-quality)
  - [3. Performance Optimization](#3-performance-optimization)
  - [4. Accessibility](#4-accessibility)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
    - [1. Missing Translations](#1-missing-translations)
    - [2. Incorrect Language Detection](#2-incorrect-language-detection)
    - [3. Formatting Issues](#3-formatting-issues)
  - [Debug Mode](#debug-mode)
  - [Performance Monitoring](#performance-monitoring)
- [Advanced Features](#advanced-features)
  - [Machine Translation Integration](#machine-translation-integration)
  - [Cultural Intelligence](#cultural-intelligence)
<!-- TOC END -->


## Overview

The Localization module provides comprehensive multi-language support for iOS notifications, enabling your app to reach global audiences with properly localized content. This guide covers everything you need to know about implementing internationalization and localization in your notification system.

## Table of Contents

- [Getting Started](#getting-started)
- [Basic Localization](#basic-localization)
- [Advanced Localization](#advanced-localization)
- [Dynamic Localization](#dynamic-localization)
- [Cultural Adaptation](#cultural-adaptation)
- [RTL Support](#rtl-support)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
- Localization files (.strings)
- Language codes (ISO 639-1)

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

// Enable localization
let config = NotificationConfiguration()
config.enableLocalization = true
config.defaultLanguage = "en"
config.supportedLanguages = ["en", "es", "fr", "de", "ja", "zh"]

notificationManager.configure(config)
```

## Basic Localization

### Simple Localized Notification

```swift
// Create localized notification
let localizedNotification = LocalizedNotificationContent(
    titleKey: "welcome_title",
    bodyKey: "welcome_message",
    category: "welcome"
)

// Schedule localized notification
try await notificationManager.schedule(
    localizedNotification,
    at: Date().addingTimeInterval(60)
)
```

### Localization Files

Create `Localizable.strings` files for each language:

**en.lproj/Localizable.strings:**
```
"welcome_title" = "Welcome!";
"welcome_message" = "Thank you for using our app";
"reminder_title" = "Daily Reminder";
"reminder_message" = "Don't forget to check your tasks";
```

**es.lproj/Localizable.strings:**
```
"welcome_title" = "¡Bienvenido!";
"welcome_message" = "Gracias por usar nuestra aplicación";
"reminder_title" = "Recordatorio Diario";
"reminder_message" = "No olvides revisar tus tareas";
```

**fr.lproj/Localizable.strings:**
```
"welcome_title" = "Bienvenue !";
"welcome_message" = "Merci d'utiliser notre application";
"reminder_title" = "Rappel Quotidien";
"reminder_message" = "N'oubliez pas de vérifier vos tâches";
```

### Language Detection

```swift
// Auto-detect user's preferred language
let autoLocalizedNotification = LocalizedNotificationContent(
    titleKey: "welcome_title",
    bodyKey: "welcome_message",
    category: "welcome"
)

// Configure auto-detection
autoLocalizedNotification.autoDetectLanguage = true
autoLocalizedNotification.fallbackLanguage = "en"

try await notificationManager.schedule(
    autoLocalizedNotification,
    at: Date().addingTimeInterval(60)
)
```

### Manual Language Selection

```swift
// Create notification with specific language
let spanishNotification = LocalizedNotificationContent(
    titleKey: "welcome_title",
    bodyKey: "welcome_message",
    category: "welcome",
    language: "es"
)

// Schedule with Spanish language
try await notificationManager.schedule(
    spanishNotification,
    at: Date().addingTimeInterval(60)
)
```

## Advanced Localization

### Pluralization Support

```swift
// Create notification with pluralization
let pluralNotification = LocalizedNotificationContent(
    titleKey: "message_count_title",
    bodyKey: "message_count_message",
    category: "messages"
)

// Configure pluralization
pluralNotification.pluralizationRules = [
    "message_count_title": [
        "one": "You have 1 new message",
        "other": "You have %d new messages"
    ],
    "message_count_message": [
        "one": "Check your inbox",
        "other": "Check your inbox for %d messages"
    ]
]

// Schedule with count parameter
try await notificationManager.schedule(
    pluralNotification,
    at: Date().addingTimeInterval(60),
    parameters: ["count": 5]
)
```

### String Formatting

```swift
// Create notification with string formatting
let formattedNotification = LocalizedNotificationContent(
    titleKey: "greeting_title",
    bodyKey: "greeting_message",
    category: "greeting"
)

// Schedule with format parameters
try await notificationManager.schedule(
    formattedNotification,
    at: Date().addingTimeInterval(60),
    parameters: [
        "name": "John",
        "time": "morning",
        "count": 3
    ]
)
```

### Localization Files with Formatting

**en.lproj/Localizable.strings:**
```
"greeting_title" = "Good %@, %@!";
"greeting_message" = "You have %d new notifications";
"time_morning" = "morning";
"time_afternoon" = "afternoon";
"time_evening" = "evening";
```

**es.lproj/Localizable.strings:**
```
"greeting_title" = "¡Buenos %@, %@!";
"greeting_message" = "Tienes %d notificaciones nuevas";
"time_morning" = "días";
"time_afternoon" = "tardes";
"time_evening" = "noches";
```

### Context-Aware Localization

```swift
// Create context-aware notification
let contextNotification = LocalizedNotificationContent(
    titleKey: "context_title",
    bodyKey: "context_message",
    category: "context"
)

// Configure context awareness
contextNotification.contextRules = [
    "time_of_day": "morning",
    "user_preference": "formal",
    "app_state": "active"
]

try await notificationManager.schedule(
    contextNotification,
    at: Date().addingTimeInterval(60)
)
```

## Dynamic Localization

### Runtime Language Switching

```swift
// Switch language at runtime
notificationManager.setCurrentLanguage("fr")

// Create notification in new language
let frenchNotification = LocalizedNotificationContent(
    titleKey: "welcome_title",
    bodyKey: "welcome_message",
    category: "welcome"
)

try await notificationManager.schedule(
    frenchNotification,
    at: Date().addingTimeInterval(60)
)
```

### Language Preferences

```swift
// Set user language preferences
let languagePreferences = LanguagePreferences()
languagePreferences.primaryLanguage = "en"
languagePreferences.secondaryLanguages = ["es", "fr"]
languagePreferences.autoSwitch = true

notificationManager.setLanguagePreferences(languagePreferences)
```

### Dynamic Content Loading

```swift
// Load localization content dynamically
let dynamicNotification = LocalizedNotificationContent(
    titleKey: "dynamic_title",
    bodyKey: "dynamic_message",
    category: "dynamic"
)

// Configure dynamic loading
dynamicNotification.loadFromServer = true
dynamicNotification.serverEndpoint = "https://api.example.com/localization"
dynamicNotification.cacheTimeout = 3600 // 1 hour

try await notificationManager.schedule(
    dynamicNotification,
    at: Date().addingTimeInterval(60)
)
```

## Cultural Adaptation

### Date and Time Formatting

```swift
// Create notification with localized date/time
let dateNotification = LocalizedNotificationContent(
    titleKey: "meeting_reminder_title",
    bodyKey: "meeting_reminder_message",
    category: "meeting"
)

// Configure date/time localization
dateNotification.dateFormat = .localized
dateNotification.timeFormat = .localized
dateNotification.timeZone = TimeZone.current

try await notificationManager.schedule(
    dateNotification,
    at: Date().addingTimeInterval(60),
    parameters: [
        "meeting_time": Date().addingTimeInterval(3600),
        "meeting_date": Date()
    ]
)
```

### Number Formatting

```swift
// Create notification with localized numbers
let numberNotification = LocalizedNotificationContent(
    titleKey: "price_alert_title",
    bodyKey: "price_alert_message",
    category: "price"
)

// Configure number localization
numberNotification.numberFormat = .localized
numberNotification.currencyFormat = .localized

try await notificationManager.schedule(
    numberNotification,
    at: Date().addingTimeInterval(60),
    parameters: [
        "price": 29.99,
        "currency": "USD"
    ]
)
```

### Cultural Sensitivity

```swift
// Create culturally sensitive notification
let culturalNotification = LocalizedNotificationContent(
    titleKey: "cultural_title",
    bodyKey: "cultural_message",
    category: "cultural"
)

// Configure cultural adaptation
culturalNotification.culturalAdaptation = true
culturalNotification.respectHolidays = true
culturalNotification.avoidSensitiveTopics = true

try await notificationManager.schedule(
    culturalNotification,
    at: Date().addingTimeInterval(60)
)
```

## RTL Support

### Right-to-Left Languages

```swift
// Create RTL notification
let rtlNotification = LocalizedNotificationContent(
    titleKey: "rtl_title",
    bodyKey: "rtl_message",
    category: "rtl"
)

// Configure RTL support
rtlNotification.rtlSupport = true
rtlNotification.textAlignment = .natural
rtlNotification.layoutDirection = .natural

try await notificationManager.schedule(
    rtlNotification,
    at: Date().addingTimeInterval(60)
)
```

### RTL Localization Files

**ar.lproj/Localizable.strings:**
```
"rtl_title" = "مرحباً بك!";
"rtl_message" = "شكراً لاستخدام تطبيقنا";
"welcome_title" = "أهلاً وسهلاً";
"welcome_message" = "نشكرك على استخدام تطبيقنا";
```

### Mixed RTL and LTR

```swift
// Create mixed RTL/LTR notification
let mixedNotification = LocalizedNotificationContent(
    titleKey: "mixed_title",
    bodyKey: "mixed_message",
    category: "mixed"
)

// Configure mixed text support
mixedNotification.mixedTextSupport = true
mixedNotification.autoDetectTextDirection = true

try await notificationManager.schedule(
    mixedNotification,
    at: Date().addingTimeInterval(60)
)
```

## Best Practices

### 1. Language Organization

```swift
// Organize languages by region
let languageConfig = LanguageConfiguration()
languageConfig.primaryLanguage = "en"
languageConfig.regionalVariants = [
    "en-US": "English (US)",
    "en-GB": "English (UK)",
    "en-AU": "English (Australia)"
]
languageConfig.fallbackChain = ["en-US", "en", "en-GB"]

notificationManager.configureLanguages(languageConfig)
```

### 2. Translation Quality

```swift
// Ensure translation quality
let qualityConfig = TranslationQualityConfiguration()
qualityConfig.requireProfessionalTranslation = true
qualityConfig.qualityThreshold = 0.9
qualityConfig.reviewProcess = .automated
qualityConfig.fallbackToMachineTranslation = false

notificationManager.configureTranslationQuality(qualityConfig)
```

### 3. Performance Optimization

```swift
// Optimize localization performance
let performanceConfig = LocalizationPerformanceConfiguration()
performanceConfig.enableCaching = true
performanceConfig.cacheSize = 100 * 1024 * 1024 // 100MB
performanceConfig.preloadLanguages = ["en", "es", "fr"]
performanceConfig.lazyLoading = true

notificationManager.configureLocalizationPerformance(performanceConfig)
```

### 4. Accessibility

```swift
// Ensure accessibility in localization
let accessibilityConfig = LocalizationAccessibilityConfiguration()
accessibilityConfig.voiceOverSupport = true
accessibilityConfig.largeTextSupport = true
accessibilityConfig.highContrastSupport = true
accessibilityConfig.reduceMotionSupport = true

notificationManager.configureLocalizationAccessibility(accessibilityConfig)
```

## Troubleshooting

### Common Issues

#### 1. Missing Translations

```swift
// Check for missing translations
let missingKeys = notificationManager.getMissingTranslationKeys()
print("Missing translation keys: \(missingKeys)")

// Use fallback language
notificationManager.setFallbackLanguage("en")
```

#### 2. Incorrect Language Detection

```swift
// Debug language detection
let detectedLanguage = notificationManager.getDetectedLanguage()
print("Detected language: \(detectedLanguage)")

// Manual language override
notificationManager.overrideLanguage("es")
```

#### 3. Formatting Issues

```swift
// Check formatting issues
let formattingErrors = notificationManager.getFormattingErrors()
print("Formatting errors: \(formattingErrors)")

// Validate formatting
notificationManager.validateFormatting { isValid in
    print("Formatting valid: \(isValid)")
}
```

### Debug Mode

```swift
// Enable localization debug mode
notificationManager.enableLocalizationDebugMode()

// Get localization debug logs
notificationManager.getLocalizationDebugLogs { logs in
    for log in logs {
        print("🔍 Localization Debug: \(log)")
    }
}
```

### Performance Monitoring

```swift
// Monitor localization performance
notificationManager.startLocalizationPerformanceMonitoring()

// Get performance metrics
notificationManager.getLocalizationPerformanceMetrics { metrics in
    print("📊 Translation cache hit rate: \(metrics.cacheHitRate)%")
    print("📊 Average translation time: \(metrics.averageTranslationTime)ms")
    print("📊 Supported languages: \(metrics.supportedLanguages)")
    print("📊 Active languages: \(metrics.activeLanguages)")
}
```

## Advanced Features

### Machine Translation Integration

```swift
// Integrate with machine translation
class MachineTranslationProvider: TranslationProvider {
    func translate(
        _ text: String,
        from sourceLanguage: String,
        to targetLanguage: String
    ) async throws -> String {
        // Integrate with Google Translate, DeepL, etc.
        return await translateWithAPI(text, sourceLanguage, targetLanguage)
    }
}

// Use machine translation
notificationManager.setTranslationProvider(MachineTranslationProvider())
```

### Cultural Intelligence

```swift
// Implement cultural intelligence
class CulturalIntelligenceEngine {
    func adaptContent(
        _ content: String,
        for culture: Culture
    ) -> String {
        // Adapt content based on cultural norms
        return adaptForCulture(content, culture)
    }
    
    func detectCulturalSensitivity(
        _ content: String
    ) -> CulturalSensitivityLevel {
        // Detect potentially sensitive content
        return analyzeCulturalSensitivity(content)
    }
}
```

This comprehensive guide covers all aspects of localization in the iOS Notification Framework. Follow these patterns to create truly global notification experiences that respect cultural differences and language preferences.
