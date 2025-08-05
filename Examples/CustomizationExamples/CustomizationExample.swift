import Foundation
import UserNotifications
import NotificationFramework
import UIKit

// MARK: - Customization Examples
// This file demonstrates notification customization capabilities
// using the iOS Notification Framework.

class CustomizationExample {
    
    // MARK: - Properties
    private let notificationManager = NotificationManager.shared
    
    // MARK: - Initialization
    init() {
        setupCustomization()
    }
    
    // MARK: - Setup
    private func setupCustomization() {
        // Request permissions
        notificationManager.requestPermissions { [weak self] granted in
            if granted {
                print("✅ Customization permissions granted")
                self?.runAllCustomizationExamples()
            } else {
                print("❌ Customization permissions denied")
            }
        }
    }
    
    // MARK: - Themed Notifications Examples
    
    /// Example 1: Create themed notification
    func createThemedNotification() {
        // Create notification theme
        let appTheme = NotificationTheme(
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
            theme: appTheme
        )
        
        // Configure theme settings
        themedNotification.theme.font = .systemFont(ofSize: 16, weight: .medium)
        themedNotification.theme.cornerRadius = 12
        themedNotification.theme.shadowEnabled = true
        
        do {
            try notificationManager.schedule(
                themedNotification,
                at: Date().addingTimeInterval(5)
            )
            print("✅ Themed notification scheduled")
        } catch {
            print("❌ Failed to schedule themed notification: \(error)")
        }
    }
    
    /// Example 2: Create brand-specific notification
    func createBrandNotification() {
        // Create brand-specific notification
        let brandNotification = NotificationContent(
            title: "Brand Notification",
            body: "Consistent with your brand identity",
            brand: BrandConfiguration(
                logoURL: "https://example.com/logo.png",
                brandColors: [UIColor.systemBlue, UIColor.systemGreen],
                brandFont: .systemFont(ofSize: 18, weight: .bold)
            )
        )
        
        // Configure brand settings
        brandNotification.brand.logoPosition = .topRight
        brandNotification.brand.colorScheme = .automatic
        brandNotification.brand.animationEnabled = true
        
        do {
            try notificationManager.schedule(
                brandNotification,
                at: Date().addingTimeInterval(10)
            )
            print("✅ Brand notification scheduled")
        } catch {
            print("❌ Failed to schedule brand notification: \(error)")
        }
    }
    
    /// Example 3: Create accessible notification
    func createAccessibleNotification() {
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
        
        do {
            try notificationManager.schedule(
                accessibleNotification,
                at: Date().addingTimeInterval(15)
            )
            print("✅ Accessible notification scheduled")
        } catch {
            print("❌ Failed to schedule accessible notification: \(error)")
        }
    }
    
    // MARK: - Color Scheme Examples
    
    /// Example 4: Light theme notification
    func createLightThemeNotification() {
        let lightTheme = NotificationTheme(
            primaryColor: UIColor.systemBlue,
            secondaryColor: UIColor.systemGray5,
            backgroundColor: UIColor.white,
            textColor: UIColor.black,
            accentColor: UIColor.systemOrange
        )
        
        let lightNotification = NotificationContent(
            title: "Light Theme",
            body: "Notification with light theme",
            theme: lightTheme
        )
        
        do {
            try notificationManager.schedule(
                lightNotification,
                at: Date().addingTimeInterval(20)
            )
            print("✅ Light theme notification scheduled")
        } catch {
            print("❌ Failed to schedule light theme notification: \(error)")
        }
    }
    
    /// Example 5: Dark theme notification
    func createDarkThemeNotification() {
        let darkTheme = NotificationTheme(
            primaryColor: UIColor.systemBlue,
            secondaryColor: UIColor.systemGray6,
            backgroundColor: UIColor.black,
            textColor: UIColor.white,
            accentColor: UIColor.systemOrange
        )
        
        let darkNotification = NotificationContent(
            title: "Dark Theme",
            body: "Notification with dark theme",
            theme: darkTheme
        )
        
        do {
            try notificationManager.schedule(
                darkNotification,
                at: Date().addingTimeInterval(25)
            )
            print("✅ Dark theme notification scheduled")
        } catch {
            print("❌ Failed to schedule dark theme notification: \(error)")
        }
    }
    
    // MARK: - Typography Examples
    
    /// Example 6: Custom font notification
    func createCustomFontNotification() {
        let customFontTheme = NotificationTheme(
            primaryColor: UIColor.systemBlue,
            secondaryColor: UIColor.systemGray,
            backgroundColor: UIColor.systemBackground,
            textColor: UIColor.label,
            accentColor: UIColor.systemOrange
        )
        
        // Configure custom fonts
        customFontTheme.titleFont = .systemFont(ofSize: 20, weight: .bold)
        customFontTheme.bodyFont = .systemFont(ofSize: 16, weight: .regular)
        customFontTheme.actionFont = .systemFont(ofSize: 14, weight: .medium)
        
        let customFontNotification = NotificationContent(
            title: "Custom Font",
            body: "Notification with custom typography",
            theme: customFontTheme
        )
        
        do {
            try notificationManager.schedule(
                customFontNotification,
                at: Date().addingTimeInterval(30)
            )
            print("✅ Custom font notification scheduled")
        } catch {
            print("❌ Failed to schedule custom font notification: \(error)")
        }
    }
    
    // MARK: - Animation Examples
    
    /// Example 7: Animated notification
    func createAnimatedNotification() {
        let animatedTheme = NotificationTheme(
            primaryColor: UIColor.systemBlue,
            secondaryColor: UIColor.systemGray,
            backgroundColor: UIColor.systemBackground,
            textColor: UIColor.label,
            accentColor: UIColor.systemOrange
        )
        
        // Configure animations
        animatedTheme.animationEnabled = true
        animatedTheme.animationDuration = 0.3
        animatedTheme.animationType = .fadeIn
        
        let animatedNotification = NotificationContent(
            title: "Animated Notification",
            body: "Notification with smooth animations",
            theme: animatedTheme
        )
        
        do {
            try notificationManager.schedule(
                animatedNotification,
                at: Date().addingTimeInterval(35)
            )
            print("✅ Animated notification scheduled")
        } catch {
            print("❌ Failed to schedule animated notification: \(error)")
        }
    }
    
    // MARK: - Localization Examples
    
    /// Example 8: Localized notification
    func createLocalizedNotification() {
        let localizedNotification = NotificationContent(
            title: "Localized Title",
            body: "Localized body text",
            localization: LocalizationConfiguration(
                language: "en",
                region: "US",
                fallbackLanguage: "en"
            )
        )
        
        // Add localized strings
        localizedNotification.localization.strings = [
            "en": [
                "title": "Welcome!",
                "body": "Thank you for using our app"
            ],
            "es": [
                "title": "¡Bienvenido!",
                "body": "Gracias por usar nuestra aplicación"
            ],
            "fr": [
                "title": "Bienvenue!",
                "body": "Merci d'utiliser notre application"
            ]
        ]
        
        do {
            try notificationManager.schedule(
                localizedNotification,
                at: Date().addingTimeInterval(40)
            )
            print("✅ Localized notification scheduled")
        } catch {
            print("❌ Failed to schedule localized notification: \(error)")
        }
    }
    
    // MARK: - Template Examples
    
    /// Example 9: Template-based notification
    func createTemplateNotification() {
        // Create notification template
        let template = NotificationTemplate(
            id: "welcome_template",
            title: "Welcome to {{app_name}}!",
            body: "Hello {{user_name}}, welcome to {{app_name}}!",
            theme: NotificationTheme(
                primaryColor: UIColor.systemBlue,
                secondaryColor: UIColor.systemGray,
                backgroundColor: UIColor.systemBackground,
                textColor: UIColor.label,
                accentColor: UIColor.systemOrange
            )
        )
        
        // Create notification from template
        let templateNotification = NotificationContent(
            template: template,
            variables: [
                "app_name": "MyApp",
                "user_name": "John"
            ]
        )
        
        do {
            try notificationManager.schedule(
                templateNotification,
                at: Date().addingTimeInterval(45)
            )
            print("✅ Template notification scheduled")
        } catch {
            print("❌ Failed to schedule template notification: \(error)")
        }
    }
    
    // MARK: - Dynamic Styling Examples
    
    /// Example 10: Context-aware notification
    func createContextAwareNotification() {
        let contextAwareNotification = NotificationContent(
            title: "Context Aware",
            body: "This notification adapts to context",
            dynamicStyling: DynamicStylingConfiguration(
                contextAware: true,
                adaptiveColors: true,
                responsiveLayout: true
            )
        )
        
        // Configure dynamic styling
        contextAwareNotification.dynamicStyling.contextRules = [
            "time_of_day": [
                "morning": NotificationTheme(primaryColor: UIColor.systemOrange),
                "afternoon": NotificationTheme(primaryColor: UIColor.systemBlue),
                "evening": NotificationTheme(primaryColor: UIColor.systemPurple)
            ],
            "user_preference": [
                "minimal": NotificationTheme(cornerRadius: 4),
                "rounded": NotificationTheme(cornerRadius: 12),
                "bordered": NotificationTheme(borderWidth: 2)
            ]
        ]
        
        do {
            try notificationManager.schedule(
                contextAwareNotification,
                at: Date().addingTimeInterval(50)
            )
            print("✅ Context-aware notification scheduled")
        } catch {
            print("❌ Failed to schedule context-aware notification: \(error)")
        }
    }
    
    // MARK: - Usage Example
    
    /// Run all customization examples
    func runAllCustomizationExamples() {
        print("🚀 Running Customization Examples...")
        
        // Themed notifications
        createThemedNotification()
        createBrandNotification()
        createAccessibleNotification()
        
        // Color schemes
        createLightThemeNotification()
        createDarkThemeNotification()
        
        // Typography
        createCustomFontNotification()
        
        // Animations
        createAnimatedNotification()
        
        // Localization
        createLocalizedNotification()
        
        // Templates
        createTemplateNotification()
        
        // Dynamic styling
        createContextAwareNotification()
        
        print("✅ All customization examples completed")
    }
} 