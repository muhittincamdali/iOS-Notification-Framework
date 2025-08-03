import Foundation
import NotificationFramework
import UserNotifications

/// Custom notification example demonstrating advanced customization features
class CustomNotificationExample {
    
    private let notificationManager = NotificationManager.shared
    
    /// Demonstrates custom notification categories
    func demonstrateCustomCategories() async throws {
        // Define custom notification categories
        let categories = [
            UNNotificationCategory(
                identifier: "social_media",
                actions: [
                    UNNotificationAction(
                        identifier: "like",
                        title: "Like",
                        options: [.foreground]
                    ),
                    UNNotificationAction(
                        identifier: "comment",
                        title: "Comment",
                        options: [.foreground]
                    ),
                    UNNotificationAction(
                        identifier: "share",
                        title: "Share",
                        options: [.foreground]
                    )
                ],
                intentIdentifiers: [],
                options: [.customDismissAction]
            ),
            UNNotificationCategory(
                identifier: "ecommerce",
                actions: [
                    UNNotificationAction(
                        identifier: "view_product",
                        title: "View Product",
                        options: [.foreground]
                    ),
                    UNNotificationAction(
                        identifier: "add_to_cart",
                        title: "Add to Cart",
                        options: [.authenticationRequired]
                    ),
                    UNNotificationAction(
                        identifier: "buy_now",
                        title: "Buy Now",
                        options: [.destructive, .authenticationRequired]
                    )
                ],
                intentIdentifiers: [],
                options: [.customDismissAction]
            )
        ]
        
        // Register custom categories
        try await notificationManager.registerNotificationCategories(categories)
        print("Custom notification categories registered")
    }
    
    /// Demonstrates custom notification sounds
    func demonstrateCustomSounds() async throws {
        let notifications = [
            NotificationContent(
                title: "Success!",
                body: "Your action was completed successfully",
                category: "success",
                priority: .normal
            ),
            NotificationContent(
                title: "Warning",
                body: "Please check your settings",
                category: "warning",
                priority: .high
            ),
            NotificationContent(
                title: "Error",
                body: "Something went wrong",
                category: "error",
                priority: .high
            )
        ]
        
        // Schedule notifications with different sounds
        let sounds = ["success.wav", "warning.wav", "error.wav"]
        
        for (index, notification) in notifications.enumerated() {
            let delay = TimeInterval(index + 1) * 5
            try await notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(delay),
                sound: sounds[index]
            )
            print("Scheduled \(notification.category) notification with \(sounds[index]) sound")
        }
    }
    
    /// Demonstrates custom notification badges
    func demonstrateCustomBadges() async throws {
        let notification = NotificationContent(
            title: "New Messages",
            body: "You have 5 new messages",
            category: "messages",
            priority: .normal,
            userInfo: ["badge_count": 5]
        )
        
        // Schedule with custom badge
        try await notificationManager.schedule(
            notification,
            at: Date().addingTimeInterval(10),
            badge: 5
        )
        
        print("Notification with custom badge scheduled")
    }
    
    /// Demonstrates custom notification threading
    func demonstrateCustomThreading() async throws {
        let threadNotifications = [
            NotificationContent(
                title: "John Doe",
                body: "Hey, how are you?",
                category: "chat",
                priority: .normal,
                userInfo: ["thread_id": "chat_123", "sender": "john_doe"]
            ),
            NotificationContent(
                title: "John Doe",
                body: "Are you free tomorrow?",
                category: "chat",
                priority: .normal,
                userInfo: ["thread_id": "chat_123", "sender": "john_doe"]
            ),
            NotificationContent(
                title: "Jane Smith",
                body: "Meeting at 3 PM",
                category: "chat",
                priority: .high,
                userInfo: ["thread_id": "chat_456", "sender": "jane_smith"]
            )
        ]
        
        // Schedule threaded notifications
        for (index, notification) in threadNotifications.enumerated() {
            let delay = TimeInterval(index + 1) * 8
            try await notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(delay),
                threadIdentifier: notification.userInfo?["thread_id"] as? String
            )
            print("Scheduled threaded notification \(index + 1)")
        }
    }
    
    /// Demonstrates custom notification actions with responses
    func demonstrateCustomActions() async throws {
        // Register custom action handlers
        notificationManager.registerActionHandler(for: "like") { action in
            print("User liked the post")
            // Handle like action
        }
        
        notificationManager.registerActionHandler(for: "comment") { action in
            print("User wants to comment")
            // Handle comment action
        }
        
        notificationManager.registerActionHandler(for: "share") { action in
            print("User wants to share")
            // Handle share action
        }
        
        notificationManager.registerActionHandler(for: "view_product") { action in
            print("User wants to view product")
            // Navigate to product page
        }
        
        notificationManager.registerActionHandler(for: "add_to_cart") { action in
            print("User wants to add to cart")
            // Add item to cart
        }
        
        notificationManager.registerActionHandler(for: "buy_now") { action in
            print("User wants to buy now")
            // Proceed to checkout
        }
        
        print("Custom action handlers registered")
    }
    
    /// Demonstrates custom notification analytics
    func demonstrateCustomAnalytics() async throws {
        // Track custom events
        notificationManager.trackEvent(.notificationScheduled, metadata: [
            "category": "custom_example",
            "priority": "high",
            "user_type": "premium"
        ])
        
        notificationManager.trackEvent(.notificationReceived, metadata: [
            "category": "custom_example",
            "delivery_time": Date().timeIntervalSince1970
        ])
        
        notificationManager.trackEvent(.notificationResponded, metadata: [
            "action": "like",
            "response_time": 2.5
        ])
        
        // Get custom analytics
        let analytics = try await notificationManager.getAnalytics()
        
        print("Custom Analytics Summary:")
        print("- Total Events: \(analytics.totalEvents)")
        print("- Custom Events: \(analytics.customEvents)")
        print("- Response Rate: \(analytics.responseRate * 100)%")
        
        // Export custom analytics
        let jsonData = try analytics.exportToJSON()
        print("Custom analytics exported: \(jsonData.count) bytes")
    }
}

// MARK: - Usage Example

@main
struct CustomNotificationExampleApp {
    static func main() async throws {
        let example = CustomNotificationExample()
        
        print("Starting custom notification examples...")
        
        // Setup custom features
        try await example.demonstrateCustomCategories()
        example.demonstrateCustomActions()
        
        // Demonstrate various custom features
        try await example.demonstrateCustomSounds()
        try await example.demonstrateCustomBadges()
        try await example.demonstrateCustomThreading()
        try await example.demonstrateCustomAnalytics()
        
        print("Custom notification example completed successfully!")
    }
} 