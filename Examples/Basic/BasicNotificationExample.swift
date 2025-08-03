import Foundation
import NotificationFramework
import UserNotifications

/// Basic notification example demonstrating simple notification usage
class BasicNotificationExample {
    
    private let notificationManager = NotificationManager.shared
    
    /// Demonstrates basic notification scheduling
    func demonstrateBasicNotifications() async throws {
        // Request permissions first
        let granted = try await notificationManager.requestPermissions()
        guard granted else {
            print("Notification permissions not granted")
            return
        }
        
        // Create a simple notification
        let notification = NotificationContent(
            title: "Welcome!",
            body: "Thank you for using our app",
            category: "welcome",
            priority: .normal
        )
        
        // Schedule the notification for 5 seconds from now
        try await notificationManager.schedule(
            notification,
            at: Date().addingTimeInterval(5)
        )
        
        print("Basic notification scheduled successfully")
    }
    
    /// Demonstrates multiple notifications
    func demonstrateMultipleNotifications() async throws {
        // Create multiple notifications
        let notifications = [
            NotificationContent(
                title: "Task Reminder",
                body: "You have a meeting in 30 minutes",
                category: "reminder",
                priority: .high
            ),
            NotificationContent(
                title: "Daily Update",
                body: "Here's your daily summary",
                category: "daily",
                priority: .normal
            ),
            NotificationContent(
                title: "System Message",
                body: "Your app has been updated",
                category: "system",
                priority: .low
            )
        ]
        
        // Schedule notifications with different delays
        for (index, notification) in notifications.enumerated() {
            let delay = TimeInterval(index + 1) * 10 // 10, 20, 30 seconds
            try await notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(delay)
            )
            print("Scheduled notification \(index + 1) for \(delay) seconds from now")
        }
    }
    
    /// Demonstrates notification with custom sound
    func demonstrateNotificationWithSound() async throws {
        let notification = NotificationContent(
            title: "Important Alert",
            body: "This is an important message",
            category: "alert",
            priority: .high
        )
        
        // Schedule with custom sound
        try await notificationManager.schedule(
            notification,
            at: Date().addingTimeInterval(15),
            sound: "alert_sound.wav"
        )
        
        print("Notification with custom sound scheduled")
    }
    
    /// Demonstrates notification with custom data
    func demonstrateNotificationWithData() async throws {
        let notification = NotificationContent(
            title: "Personalized Message",
            body: "Hello, this is your personalized notification",
            category: "personal",
            priority: .normal,
            userInfo: [
                "user_id": "12345",
                "message_type": "personal",
                "timestamp": Date().timeIntervalSince1970
            ]
        )
        
        // Schedule the notification
        try await notificationManager.schedule(
            notification,
            at: Date().addingTimeInterval(20)
        )
        
        print("Personalized notification scheduled")
    }
    
    /// Demonstrates checking notification status
    func demonstrateStatusCheck() async throws {
        // Check if notifications are authorized
        let status = try await notificationManager.getAuthorizationStatus()
        
        switch status {
        case .authorized:
            print("Notifications are authorized")
        case .denied:
            print("Notifications are denied")
        case .notDetermined:
            print("Notification permission not determined")
        case .provisional:
            print("Notifications are provisionally authorized")
        case .ephemeral:
            print("Notifications are ephemerally authorized")
        @unknown default:
            print("Unknown authorization status")
        }
        
        // Get pending notifications count
        let pendingCount = try await notificationManager.getPendingNotifications().count
        print("Pending notifications: \(pendingCount)")
        
        // Get delivered notifications count
        let deliveredCount = try await notificationManager.getDeliveredNotifications().count
        print("Delivered notifications: \(deliveredCount)")
    }
    
    /// Demonstrates notification removal
    func demonstrateNotificationRemoval() async throws {
        // Get all pending notifications
        let pendingNotifications = try await notificationManager.getPendingNotifications()
        
        print("Found \(pendingNotifications.count) pending notifications")
        
        // Remove all pending notifications
        try await notificationManager.removeAllPendingNotifications()
        print("Removed all pending notifications")
        
        // Remove all delivered notifications
        try await notificationManager.removeAllDeliveredNotifications()
        print("Removed all delivered notifications")
    }
}

// MARK: - Usage Example

@main
struct BasicNotificationExampleApp {
    static func main() async throws {
        let example = BasicNotificationExample()
        
        print("Starting basic notification examples...")
        
        // Demonstrate various basic features
        try await example.demonstrateBasicNotifications()
        try await example.demonstrateMultipleNotifications()
        try await example.demonstrateNotificationWithSound()
        try await example.demonstrateNotificationWithData()
        try await example.demonstrateStatusCheck()
        
        // Wait a bit to see notifications
        print("Waiting 30 seconds to see notifications...")
        try await Task.sleep(nanoseconds: 30_000_000_000) // 30 seconds
        
        // Clean up
        try await example.demonstrateNotificationRemoval()
        
        print("Basic notification example completed successfully!")
    }
} 