import Foundation
import iOS-Notification-Framework

/// Basic example demonstrating the core functionality of iOS-Notification-Framework
@main
struct BasicExample {
    static func main() {
        print("🚀 iOS-Notification-Framework Basic Example")
        
        // Initialize the framework
        let framework = iOS-Notification-Framework()
        
        // Configure with default settings
        framework.configure()
        
        print("✅ Framework configured successfully")
        
        // Demonstrate basic functionality
        demonstrateBasicFeatures(framework)
    }
    
    static func demonstrateBasicFeatures(_ framework: iOS-Notification-Framework) {
        print("\n📱 Demonstrating basic features...")
        
        // Add your example code here
        print("🎯 Feature 1: Core functionality")
        print("🎯 Feature 2: Configuration")
        print("🎯 Feature 3: Error handling")
        
        print("\n✨ Basic example completed successfully!")
    }
}
