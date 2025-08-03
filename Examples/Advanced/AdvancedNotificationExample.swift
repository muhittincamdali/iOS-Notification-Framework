import Foundation
import NotificationFramework
import UserNotifications

/// Advanced notification example demonstrating rich media, custom actions, and analytics
class AdvancedNotificationExample {
    
    private let notificationManager = NotificationManager.shared
    
    /// Demonstrates rich media notifications with custom actions
    func demonstrateRichMediaNotifications() async throws {
        // Request permissions first
        let granted = try await notificationManager.requestPermissions()
        guard granted else {
            print("Notification permissions not granted")
            return
        }
        
        // Create rich media notification with image
        let richNotification = RichNotificationContent(
            title: "New Product Launch",
            body: "Check out our latest collection with amazing features",
            category: "product_launch",
            priority: .high,
            mediaURL: "https://example.com/product-image.jpg",
            mediaType: .image,
            actions: [
                NotificationAction(
                    title: "View Details",
                    identifier: "view_details",
                    options: [.foreground]
                ),
                NotificationAction(
                    title: "Add to Wishlist",
                    identifier: "add_wishlist",
                    options: [.authenticationRequired]
                ),
                NotificationAction(
                    title: "Share",
                    identifier: "share_product",
                    options: [.destructive]
                )
            ]
        )
        
        // Schedule the notification
        try await notificationManager.scheduleRichNotification(
            richNotification,
            at: Date().addingTimeInterval(5)
        )
        
        print("Rich media notification scheduled successfully")
    }
    
    /// Demonstrates recurring notifications with custom scheduling
    func demonstrateRecurringNotifications() async throws {
        // Create recurring schedule
        let recurringSchedule = RecurringSchedule(
            interval: .daily,
            startDate: Date(),
            endDate: Date().addingTimeInterval(7 * 24 * 60 * 60), // 7 days
            timeComponents: DateComponents(hour: 9, minute: 0), // 9:00 AM
            customInterval: nil
        )
        
        // Create notification content
        let notification = NotificationContent(
            title: "Daily Reminder",
            body: "Don't forget to check your daily tasks",
            category: "daily_reminder",
            priority: .medium
        )
        
        // Schedule recurring notification
        try await notificationManager.scheduleRecurringNotification(
            notification,
            with: recurringSchedule
        )
        
        print("Recurring notification scheduled successfully")
    }
    
    /// Demonstrates notification analytics and tracking
    func demonstrateAnalytics() async throws {
        // Get analytics data
        let analytics = try await notificationManager.getAnalytics()
        
        print("Notification Analytics:")
        print("- Total Events: \(analytics.totalEvents)")
        print("- Scheduled: \(analytics.scheduledCount)")
        print("- Received: \(analytics.receivedCount)")
        print("- Responses: \(analytics.responseCount)")
        print("- Delivery Rate: \(analytics.deliveryRate * 100)%")
        print("- Response Rate: \(analytics.responseRate * 100)%")
        
        // Export analytics to JSON
        let jsonData = try analytics.exportToJSON()
        print("Analytics exported to JSON: \(jsonData.count) bytes")
    }
    
    /// Demonstrates custom action handlers
    func setupCustomActionHandlers() {
        // Register action handlers
        notificationManager.registerActionHandler(for: "view_details") { action in
            print("User tapped 'View Details' for notification: \(action.identifier)")
            // Navigate to product details
            self.navigateToProductDetails()
        }
        
        notificationManager.registerActionHandler(for: "add_wishlist") { action in
            print("User tapped 'Add to Wishlist' for notification: \(action.identifier)")
            // Add product to wishlist
            self.addToWishlist()
        }
        
        notificationManager.registerActionHandler(for: "share_product") { action in
            print("User tapped 'Share' for notification: \(action.identifier)")
            // Share product
            self.shareProduct()
        }
    }
    
    /// Demonstrates notification management
    func demonstrateNotificationManagement() async throws {
        // Get pending notifications
        let pendingNotifications = try await notificationManager.getPendingNotifications()
        print("Pending notifications: \(pendingNotifications.count)")
        
        // Get delivered notifications
        let deliveredNotifications = try await notificationManager.getDeliveredNotifications()
        print("Delivered notifications: \(deliveredNotifications.count)")
        
        // Remove specific notification
        if let firstNotification = pendingNotifications.first {
            try await notificationManager.removePendingNotification(with: firstNotification.request.identifier)
            print("Removed notification: \(firstNotification.request.identifier)")
        }
        
        // Remove all delivered notifications
        try await notificationManager.removeAllDeliveredNotifications()
        print("Removed all delivered notifications")
    }
    
    // MARK: - Helper Methods
    
    private func navigateToProductDetails() {
        // Implementation for navigating to product details
        print("Navigating to product details...")
    }
    
    private func addToWishlist() {
        // Implementation for adding to wishlist
        print("Adding product to wishlist...")
    }
    
    private func shareProduct() {
        // Implementation for sharing product
        print("Sharing product...")
    }
}

// MARK: - Usage Example

@main
struct AdvancedNotificationExampleApp {
    static func main() async throws {
        let example = AdvancedNotificationExample()
        
        // Setup action handlers
        example.setupCustomActionHandlers()
        
        // Demonstrate various features
        try await example.demonstrateRichMediaNotifications()
        try await example.demonstrateRecurringNotifications()
        try await example.demonstrateAnalytics()
        try await example.demonstrateNotificationManagement()
        
        print("Advanced notification example completed successfully!")
    }
} 