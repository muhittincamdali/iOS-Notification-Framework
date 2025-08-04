import Foundation
import UserNotifications
import NotificationFramework

// MARK: - Basic Notification Examples
// This file demonstrates how to create and schedule basic notifications
// using the iOS Notification Framework.

class BasicNotificationExample {
    
    // MARK: - Properties
    private let notificationManager = NotificationManager.shared
    
    // MARK: - Initialization
    init() {
        setupNotificationManager()
    }
    
    // MARK: - Setup
    private func setupNotificationManager() {
        // Configure notification manager
        let config = NotificationConfiguration()
        config.enableRichMedia = false
        config.enableCustomActions = true
        config.enableAnalytics = true
        config.defaultSound = UNNotificationSound.default
        
        // Request permissions
        notificationManager.requestPermissions { [weak self] granted in
            if granted {
                print("✅ Notification permissions granted")
                self?.registerNotificationCategories()
            } else {
                print("❌ Notification permissions denied")
            }
        }
    }
    
    // MARK: - Notification Categories
    private func registerNotificationCategories() {
        // Create basic notification actions
        let viewAction = UNNotificationAction(
            identifier: "VIEW_ACTION",
            title: "View",
            options: [.foreground]
        )
        
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: "Dismiss",
            options: [.destructive]
        )
        
        // Create notification category
        let basicCategory = UNNotificationCategory(
            identifier: "BASIC_CATEGORY",
            actions: [viewAction, dismissAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        // Register category
        UNUserNotificationCenter.current().setNotificationCategories([basicCategory])
    }
    
    // MARK: - Basic Notification Examples
    
    /// Example 1: Simple notification with title and body
    func createSimpleNotification() {
        let notification = NotificationContent(
            title: "Welcome!",
            body: "Thank you for using our app",
            category: "BASIC_CATEGORY"
        )
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(5) // 5 seconds from now
            )
            print("✅ Simple notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule simple notification: \(error)")
        }
    }
    
    /// Example 2: Notification with custom sound
    func createNotificationWithCustomSound() {
        let notification = NotificationContent(
            title: "Custom Sound",
            body: "This notification has a custom sound",
            category: "BASIC_CATEGORY"
        )
        
        // Set custom sound
        notification.sound = UNNotificationSound(named: UNNotificationSoundName("custom_sound.wav"))
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(10)
            )
            print("✅ Custom sound notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule custom sound notification: \(error)")
        }
    }
    
    /// Example 3: Notification with badge
    func createNotificationWithBadge() {
        let notification = NotificationContent(
            title: "New Message",
            body: "You have a new message from John",
            category: "BASIC_CATEGORY"
        )
        
        // Set badge number
        notification.badge = 1
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(15)
            )
            print("✅ Badge notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule badge notification: \(error)")
        }
    }
    
    /// Example 4: Notification with user info
    func createNotificationWithUserInfo() {
        let notification = NotificationContent(
            title: "User Info",
            body: "This notification contains custom user info",
            category: "BASIC_CATEGORY"
        )
        
        // Add custom user info
        notification.userInfo = [
            "user_id": "12345",
            "message_type": "welcome",
            "timestamp": Date().timeIntervalSince1970
        ]
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(20)
            )
            print("✅ User info notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule user info notification: \(error)")
        }
    }
    
    /// Example 5: Notification with thread identifier
    func createNotificationWithThread() {
        let notification = NotificationContent(
            title: "Thread Notification",
            body: "This notification belongs to a specific thread",
            category: "BASIC_CATEGORY"
        )
        
        // Set thread identifier for grouping
        notification.threadIdentifier = "conversation_123"
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(25)
            )
            print("✅ Thread notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule thread notification: \(error)")
        }
    }
    
    /// Example 6: Critical notification
    func createCriticalNotification() {
        let notification = NotificationContent(
            title: "Critical Alert",
            body: "This is a critical notification",
            category: "BASIC_CATEGORY"
        )
        
        // Set critical alert properties
        notification.isCritical = true
        notification.criticalSoundVolume = 1.0
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(30)
            )
            print("✅ Critical notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule critical notification: \(error)")
        }
    }
    
    /// Example 7: Notification with attachment
    func createNotificationWithAttachment() {
        let notification = NotificationContent(
            title: "Attachment",
            body: "This notification has an attachment",
            category: "BASIC_CATEGORY"
        )
        
        // Create attachment
        if let attachmentURL = Bundle.main.url(forResource: "attachment", withExtension: "txt") {
            do {
                let attachment = try UNNotificationAttachment(
                    identifier: "attachment",
                    url: attachmentURL,
                    options: nil
                )
                notification.attachments = [attachment]
            } catch {
                print("❌ Failed to create attachment: \(error)")
            }
        }
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(35)
            )
            print("✅ Attachment notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule attachment notification: \(error)")
        }
    }
    
    /// Example 8: Batch notifications
    func createBatchNotifications() {
        let notifications = [
            NotificationContent(title: "Batch 1", body: "First notification in batch"),
            NotificationContent(title: "Batch 2", body: "Second notification in batch"),
            NotificationContent(title: "Batch 3", body: "Third notification in batch")
        ]
        
        do {
            try notificationManager.scheduleBatch(
                notifications,
                withInterval: 5 // 5 seconds between each
            )
            print("✅ Batch notifications scheduled successfully")
        } catch {
            print("❌ Failed to schedule batch notifications: \(error)")
        }
    }
    
    // MARK: - Notification Management
    
    /// Cancel all pending notifications
    func cancelAllNotifications() {
        notificationManager.cancelAll()
        print("✅ All notifications cancelled")
    }
    
    /// Cancel notifications by category
    func cancelNotificationsByCategory() {
        notificationManager.cancelNotifications(in: "BASIC_CATEGORY")
        print("✅ Notifications in BASIC_CATEGORY cancelled")
    }
    
    /// Get pending notifications
    func getPendingNotifications() {
        notificationManager.getPendingNotifications { requests in
            print("📋 Pending notifications: \(requests.count)")
            for request in requests {
                print("- \(request.identifier): \(request.content.title)")
            }
        }
    }
    
    /// Get delivered notifications
    func getDeliveredNotifications() {
        notificationManager.getDeliveredNotifications { notifications in
            print("📋 Delivered notifications: \(notifications.count)")
            for notification in notifications {
                print("- \(notification.request.identifier): \(notification.request.content.title)")
            }
        }
    }
}

// MARK: - Usage Example
extension BasicNotificationExample {
    
    /// Run all basic notification examples
    func runAllExamples() {
        print("🚀 Running Basic Notification Examples...")
        
        // Create various types of notifications
        createSimpleNotification()
        createNotificationWithCustomSound()
        createNotificationWithBadge()
        createNotificationWithUserInfo()
        createNotificationWithThread()
        createCriticalNotification()
        createNotificationWithAttachment()
        createBatchNotifications()
        
        print("✅ All basic notification examples completed")
    }
}

// MARK: - Error Handling
extension BasicNotificationExample {
    
    /// Handle notification errors
    func handleNotificationError(_ error: Error) {
        switch error {
        case NotificationError.permissionDenied:
            print("❌ Notification permission denied")
        case NotificationError.invalidConfiguration:
            print("❌ Invalid notification configuration")
        case NotificationError.schedulingFailed:
            print("❌ Failed to schedule notification")
        default:
            print("❌ Unknown notification error: \(error)")
        }
    }
}

// MARK: - Best Practices
extension BasicNotificationExample {
    
    /// Validate notification content before scheduling
    func validateNotification(_ notification: NotificationContent) -> Bool {
        // Check title length
        guard notification.title.count <= 50 else {
            print("❌ Title too long (max 50 characters)")
            return false
        }
        
        // Check body length
        guard notification.body.count <= 200 else {
            print("❌ Body too long (max 200 characters)")
            return false
        }
        
        // Check for required fields
        guard !notification.title.isEmpty else {
            print("❌ Title cannot be empty")
            return false
        }
        
        return true
    }
    
    /// Create notification with validation
    func createValidatedNotification(title: String, body: String) {
        let notification = NotificationContent(
            title: title,
            body: body,
            category: "BASIC_CATEGORY"
        )
        
        guard validateNotification(notification) else {
            print("❌ Notification validation failed")
            return
        }
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(5)
            )
            print("✅ Validated notification scheduled successfully")
        } catch {
            handleNotificationError(error)
        }
    }
} 