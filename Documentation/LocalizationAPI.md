# Localization API Reference

## Overview

The Localization API provides comprehensive multi-language support for iOS notifications. This document covers all public interfaces, methods, and properties for implementing internationalization and localization in your notification system.

## Table of Contents

- [LocalizedNotificationContent](#localizednotificationcontent)
- [LanguageConfiguration](#languageconfiguration)
- [TranslationProvider](#translationprovider)
- [LocalizationManager](#localizationmanager)
- [CulturalAdaptation](#culturaladaptation)
- [RTLSupport](#rtlsupport)

## LocalizedNotificationContent

### Class Definition

```swift
public struct LocalizedNotificationContent {
    public let titleKey: String
    public let bodyKey: String
    public let category: String
    public let language: String?
    public let autoDetectLanguage: Bool
    public let fallbackLanguage: String
    public let pluralizationRules: [String: [String: String]]
    public let contextRules: [String: String]
}
```

### Properties

#### titleKey
The localization key for the notification title.

```swift
public let titleKey: String
```

#### bodyKey
The localization key for the notification body.

```swift
public let bodyKey: String
```

#### category
The notification category identifier.

```swift
public let category: String
```

#### language
The specific language to use for this notification. If nil, auto-detection is used.

```swift
public let language: String?
```

#### autoDetectLanguage
Whether to automatically detect the user's preferred language.

```swift
public let autoDetectLanguage: Bool
```

#### fallbackLanguage
The fallback language to use if the preferred language is not available.

```swift
public let fallbackLanguage: String
```

#### pluralizationRules
Rules for pluralization in different languages.

```swift
public let pluralizationRules: [String: [String: String]]
```

#### contextRules
Context-aware localization rules.

```swift
public let contextRules: [String: String]
```

### Methods

#### init(titleKey:bodyKey:category:language:)

Creates a localized notification content.

```swift
public init(
    titleKey: String,
    bodyKey: String,
    category: String,
    language: String? = nil
)
```

**Parameters:**
- `titleKey`: The localization key for the title
- `bodyKey`: The localization key for the body
- `category`: The notification category
- `language`: Optional specific language to use

#### init(titleKey:bodyKey:category:autoDetectLanguage:fallbackLanguage:)

Creates a localized notification content with auto-detection.

```swift
public init(
    titleKey: String,
    bodyKey: String,
    category: String,
    autoDetectLanguage: Bool,
    fallbackLanguage: String
)
```

**Parameters:**
- `titleKey`: The localization key for the title
- `bodyKey`: The localization key for the body
- `category`: The notification category
- `autoDetectLanguage`: Whether to auto-detect language
- `fallbackLanguage`: The fallback language

## LanguageConfiguration

### Class Definition

```swift
public class LanguageConfiguration {
    public var primaryLanguage: String
    public var supportedLanguages: [String]
    public var regionalVariants: [String: String]
    public var fallbackChain: [String]
    public var autoSwitch: Bool
    public var qualityThreshold: Double
}
```

### Properties

#### primaryLanguage
The primary language for the application.

```swift
public var primaryLanguage: String
```

#### supportedLanguages
Array of supported language codes.

```swift
public var supportedLanguages: [String]
```

#### regionalVariants
Mapping of language codes to regional variant names.

```swift
public var regionalVariants: [String: String]
```

#### fallbackChain
Ordered list of fallback languages.

```swift
public var fallbackChain: [String]
```

#### autoSwitch
Whether to automatically switch languages based on user preferences.

```swift
public var autoSwitch: Bool
```

#### qualityThreshold
Minimum quality threshold for translations.

```swift
public var qualityThreshold: Double
```

### Methods

#### init(primaryLanguage:supportedLanguages:)

Creates a language configuration.

```swift
public init(
    primaryLanguage: String,
    supportedLanguages: [String]
)
```

**Parameters:**
- `primaryLanguage`: The primary language code
- `supportedLanguages`: Array of supported language codes

#### addRegionalVariant(languageCode:variantName:)

Adds a regional variant for a language.

```swift
public func addRegionalVariant(
    languageCode: String,
    variantName: String
)
```

**Parameters:**
- `languageCode`: The language code
- `variantName`: The regional variant name

#### setFallbackChain(_:)

Sets the fallback language chain.

```swift
public func setFallbackChain(_ chain: [String])
```

**Parameters:**
- `chain`: Ordered array of fallback language codes

## TranslationProvider

### Protocol Definition

```swift
public protocol TranslationProvider {
    func translate(
        _ text: String,
        from sourceLanguage: String,
        to targetLanguage: String
    ) async throws -> String
    
    func getSupportedLanguages() async throws -> [String]
    
    func getTranslationQuality(
        _ text: String,
        from sourceLanguage: String,
        to targetLanguage: String
    ) async throws -> Double
}
```

### Methods

#### translate(_:from:to:)

Translates text from one language to another.

```swift
func translate(
    _ text: String,
    from sourceLanguage: String,
    to targetLanguage: String
) async throws -> String
```

**Parameters:**
- `text`: The text to translate
- `sourceLanguage`: The source language code
- `targetLanguage`: The target language code

**Returns:** The translated text

**Throws:** `TranslationError` if translation fails

#### getSupportedLanguages()

Gets the list of supported languages.

```swift
func getSupportedLanguages() async throws -> [String]
```

**Returns:** Array of supported language codes

**Throws:** `TranslationError` if unable to get languages

#### getTranslationQuality(_:from:to:)

Gets the quality score for a translation.

```swift
func getTranslationQuality(
    _ text: String,
    from sourceLanguage: String,
    to targetLanguage: String
) async throws -> Double
```

**Parameters:**
- `text`: The text to evaluate
- `sourceLanguage`: The source language code
- `targetLanguage`: The target language code

**Returns:** Quality score between 0.0 and 1.0

**Throws:** `TranslationError` if unable to get quality

## LocalizationManager

### Class Definition

```swift
public class LocalizationManager {
    public static let shared = LocalizationManager()
    
    public var currentLanguage: String
    public var supportedLanguages: [String]
    public var fallbackLanguage: String
    public var translationProvider: TranslationProvider?
}
```

### Properties

#### currentLanguage
The currently active language.

```swift
public var currentLanguage: String
```

#### supportedLanguages
Array of supported language codes.

```swift
public var supportedLanguages: [String]
```

#### fallbackLanguage
The fallback language to use.

```swift
public var fallbackLanguage: String
```

#### translationProvider
The translation provider for dynamic translations.

```swift
public var translationProvider: TranslationProvider?
```

### Methods

#### setCurrentLanguage(_:)

Sets the current language.

```swift
public func setCurrentLanguage(_ language: String) throws
```

**Parameters:**
- `language`: The language code to set

**Throws:** `LocalizationError` if language is not supported

#### getCurrentLanguage() -> String

Gets the current language.

```swift
public func getCurrentLanguage() -> String
```

**Returns:** The current language code

#### detectUserLanguage() -> String

Automatically detects the user's preferred language.

```swift
public func detectUserLanguage() -> String
```

**Returns:** The detected language code

#### translate(_:to:) async throws -> String

Translates text to the specified language.

```swift
public func translate(
    _ text: String,
    to language: String
) async throws -> String
```

**Parameters:**
- `text`: The text to translate
- `language`: The target language

**Returns:** The translated text

**Throws:** `TranslationError` if translation fails

#### getLocalizedString(_:language:) -> String

Gets a localized string for the specified key and language.

```swift
public func getLocalizedString(
    _ key: String,
    language: String? = nil
) -> String
```

**Parameters:**
- `key`: The localization key
- `language`: Optional specific language (uses current if nil)

**Returns:** The localized string

#### formatString(_:arguments:language:) -> String

Formats a localized string with arguments.

```swift
public func formatString(
    _ key: String,
    arguments: [String: Any],
    language: String? = nil
) -> String
```

**Parameters:**
- `key`: The localization key
- `arguments`: Dictionary of format arguments
- `language`: Optional specific language

**Returns:** The formatted localized string

## CulturalAdaptation

### Class Definition

```swift
public class CulturalAdaptation {
    public var dateFormat: DateFormatter
    public var timeFormat: DateFormatter
    public var numberFormat: NumberFormatter
    public var currencyFormat: NumberFormatter
    public var culturalSensitivity: CulturalSensitivityLevel
}
```

### Properties

#### dateFormat
The localized date formatter.

```swift
public var dateFormat: DateFormatter
```

#### timeFormat
The localized time formatter.

```swift
public var timeFormat: DateFormatter
```

#### numberFormat
The localized number formatter.

```swift
public var numberFormat: NumberFormatter
```

#### currencyFormat
The localized currency formatter.

```swift
public var currencyFormat: NumberFormatter
```

#### culturalSensitivity
The level of cultural sensitivity to apply.

```swift
public var culturalSensitivity: CulturalSensitivityLevel
```

### Methods

#### adaptDate(_:for:) -> String

Adapts a date for the specified culture.

```swift
public func adaptDate(
    _ date: Date,
    for culture: Culture
) -> String
```

**Parameters:**
- `date`: The date to adapt
- `culture`: The target culture

**Returns:** The culturally adapted date string

#### adaptNumber(_:for:) -> String

Adapts a number for the specified culture.

```swift
public func adaptNumber(
    _ number: Double,
    for culture: Culture
) -> String
```

**Parameters:**
- `number`: The number to adapt
- `culture`: The target culture

**Returns:** The culturally adapted number string

#### adaptCurrency(_:for:) -> String

Adapts a currency amount for the specified culture.

```swift
public func adaptCurrency(
    _ amount: Double,
    for culture: Culture
) -> String
```

**Parameters:**
- `amount`: The currency amount
- `culture`: The target culture

**Returns:** The culturally adapted currency string

## RTLSupport

### Class Definition

```swift
public class RTLSupport {
    public var isRTLEnabled: Bool
    public var textAlignment: NSTextAlignment
    public var layoutDirection: UIUserInterfaceLayoutDirection
    public var mixedTextSupport: Bool
}
```

### Properties

#### isRTLEnabled
Whether RTL support is enabled.

```swift
public var isRTLEnabled: Bool
```

#### textAlignment
The text alignment for RTL languages.

```swift
public var textAlignment: NSTextAlignment
```

#### layoutDirection
The layout direction for RTL languages.

```swift
public var layoutDirection: UIUserInterfaceLayoutDirection
```

#### mixedTextSupport
Whether mixed RTL/LTR text is supported.

```swift
public var mixedTextSupport: Bool
```

### Methods

#### isRTLLanguage(_:) -> Bool

Checks if a language is RTL.

```swift
public func isRTLLanguage(_ language: String) -> Bool
```

**Parameters:**
- `language`: The language code to check

**Returns:** True if the language is RTL

#### adaptTextForRTL(_:) -> String

Adapts text for RTL layout.

```swift
public func adaptTextForRTL(_ text: String) -> String
```

**Parameters:**
- `text`: The text to adapt

**Returns:** The RTL-adapted text

#### getRTLTextDirection(_:) -> NSTextAlignment

Gets the appropriate text alignment for RTL.

```swift
public func getRTLTextDirection(_ language: String) -> NSTextAlignment
```

**Parameters:**
- `language`: The language code

**Returns:** The appropriate text alignment

## Error Types

### LocalizationError

```swift
public enum LocalizationError: Error {
    case unsupportedLanguage(String)
    case missingTranslationKey(String)
    case invalidLanguageCode(String)
    case translationFailed(String)
    case culturalAdaptationFailed(String)
}
```

### TranslationError

```swift
public enum TranslationError: Error {
    case providerNotAvailable
    case unsupportedLanguagePair(String, String)
    case translationTimeout
    case qualityBelowThreshold(Double)
    case networkError(Error)
}
```

## Usage Examples

### Basic Localization

```swift
// Create localized notification
let localizedNotification = LocalizedNotificationContent(
    titleKey: "welcome_title",
    bodyKey: "welcome_message",
    category: "welcome"
)

// Schedule with auto-detection
try await notificationManager.schedule(
    localizedNotification,
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

### Dynamic Translation

```swift
// Set up translation provider
let translationProvider = MachineTranslationProvider()
localizationManager.translationProvider = translationProvider

// Translate content dynamically
let translatedText = try await localizationManager.translate(
    "Hello, world!",
    to: "es"
)

// Create notification with translated content
let translatedNotification = NotificationContent(
    title: translatedText,
    body: "Translated content",
    category: "translated"
)
```

### Cultural Adaptation

```swift
// Create culturally adapted notification
let culturalAdaptation = CulturalAdaptation()
culturalAdaptation.culturalSensitivity = .high

// Adapt date for culture
let adaptedDate = culturalAdaptation.adaptDate(
    Date(),
    for: Culture.spanish
)

// Create notification with culturally adapted content
let culturalNotification = NotificationContent(
    title: "Meeting Reminder",
    body: "Your meeting is scheduled for \(adaptedDate)",
    category: "meeting"
)
```

This comprehensive API reference covers all aspects of localization in the iOS Notification Framework. Use these interfaces to create truly global notification experiences that respect cultural differences and language preferences.
