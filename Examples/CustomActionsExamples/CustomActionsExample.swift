import Foundation
import UserNotifications
import NotificationFramework

// MARK: - Custom Actions Examples
// This file demonstrates how to create and handle custom notification actions
// using the iOS Notification Framework.

class CustomActionsExample {
    
    // MARK: - Properties
    private let notificationManager = NotificationManager.shared
    private let actionHandler = NotificationActionHandler()
    
    // MARK: - Initialization
    init() {
        setupCustomActions()
    }
    
    // MARK: - Setup
    private func setupCustomActions() {
        // Register action handler
        UNUserNotificationCenter.current().delegate = actionHandler
        
        // Request permissions
        notificationManager.requestPermissions { [weak self] granted in
            if granted {
                print("✅ Custom actions permissions granted")
                self?.registerCustomActionCategories()
            } else {
                print("❌ Custom actions permissions denied")
            }
        }
    }
    
    // MARK: - Action Categories
    private func registerCustomActionCategories() {
        // Create custom action categories
        let messageCategory = createMessageCategory()
        let socialCategory = createSocialCategory()
        let reminderCategory = createReminderCategory()
        let customCategory = createCustomCategory()
        
        // Register categories
        UNUserNotificationCenter.current().setNotificationCategories([
            messageCategory,
            socialCategory,
            reminderCategory,
            customCategory
        ])
        
        print("✅ Custom action categories registered")
    }
    
    // MARK: - Message Category
    private func createMessageCategory() -> UNNotificationCategory {
        let viewAction = UNNotificationAction(
            identifier: "VIEW_MESSAGE",
            title: "View",
            options: [.foreground]
        )
        
        let replyAction = UNNotificationAction(
            identifier: "REPLY_MESSAGE",
            title: "Reply",
            options: [.foreground],
            textInput: UNTextInputNotificationAction(
                title: "Reply",
                identifier: "REPLY_TEXT_INPUT",
                options: [.foreground],
                textInputButtonTitle: "Send",
                textInputPlaceholder: "Type your reply..."
            )
        )
        
        let shareAction = UNNotificationAction(
            identifier: "SHARE_MESSAGE",
            title: "Share",
            options: [.foreground]
        )
        
        let deleteAction = UNNotificationAction(
            identifier: "DELETE_MESSAGE",
            title: "Delete",
            options: [.destructive]
        )
        
        return UNNotificationCategory(
            identifier: "MESSAGE_CATEGORY",
            actions: [viewAction, replyAction, shareAction, deleteAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
    }
    
    // MARK: - Social Category
    private func createSocialCategory() -> UNNotificationCategory {
        let likeAction = UNNotificationAction(
            identifier: "LIKE_POST",
            title: "👍 Like",
            options: [.authenticationRequired]
        )
        
        let commentAction = UNNotificationAction(
            identifier: "COMMENT_POST",
            title: "💬 Comment",
            options: [.foreground],
            textInput: UNTextInputNotificationAction(
                title: "Comment",
                identifier: "COMMENT_TEXT_INPUT",
                options: [.foreground],
                textInputButtonTitle: "Post",
                textInputPlaceholder: "Write a comment..."
            )
        )
        
        let bookmarkAction = UNNotificationAction(
            identifier: "BOOKMARK_POST",
            title: "🔖 Bookmark",
            options: [.authenticationRequired]
        )
        
        let shareAction = UNNotificationAction(
            identifier: "SHARE_POST",
            title: "📤 Share",
            options: [.foreground]
        )
        
        return UNNotificationCategory(
            identifier: "SOCIAL_CATEGORY",
            actions: [likeAction, commentAction, bookmarkAction, shareAction],
            intentIdentifiers: [],
            options: [.allowInCarPlay]
        )
    }
    
    // MARK: - Reminder Category
    private func createReminderCategory() -> UNNotificationCategory {
        let completeAction = UNNotificationAction(
            identifier: "COMPLETE_REMINDER",
            title: "✅ Complete",
            options: [.foreground]
        )
        
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_REMINDER",
            title: "⏰ Snooze",
            options: [.foreground]
        )
        
        let rescheduleAction = UNNotificationAction(
            identifier: "RESCHEDULE_REMINDER",
            title: "📅 Reschedule",
            options: [.foreground]
        )
        
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_REMINDER",
            title: "❌ Dismiss",
            options: [.destructive]
        )
        
        return UNNotificationCategory(
            identifier: "REMINDER_CATEGORY",
            actions: [completeAction, snoozeAction, rescheduleAction, dismissAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
    }
    
    // MARK: - Custom Category
    private func createCustomCategory() -> UNNotificationCategory {
        let customAction1 = UNNotificationAction(
            identifier: "CUSTOM_ACTION_1",
            title: "Custom Action 1",
            options: [.foreground]
        )
        
        let customAction2 = UNNotificationAction(
            identifier: "CUSTOM_ACTION_2",
            title: "Custom Action 2",
            options: [.foreground]
        )
        
        let customAction3 = UNNotificationAction(
            identifier: "CUSTOM_ACTION_3",
            title: "Custom Action 3",
            options: [.destructive]
        )
        
        return UNNotificationCategory(
            identifier: "CUSTOM_CATEGORY",
            actions: [customAction1, customAction2, customAction3],
            intentIdentifiers: [],
            options: []
        )
    }
    
    // MARK: - Example Notifications
    
    /// Example 1: Message notification with custom actions
    func createMessageNotification() {
        let notification = NotificationContent(
            title: "New Message",
            body: "You have a new message from John",
            category: "MESSAGE_CATEGORY"
        )
        
        // Add custom user info
        notification.userInfo = [
            "message_id": "msg_123",
            "sender_id": "user_456",
            "message_type": "text"
        ]
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(5)
            )
            print("✅ Message notification with custom actions scheduled")
        } catch {
            print("❌ Failed to schedule message notification: \(error)")
        }
    }
    
    /// Example 2: Social notification with custom actions
    func createSocialNotification() {
        let notification = NotificationContent(
            title: "New Post",
            body: "Check out this amazing post from Sarah",
            category: "SOCIAL_CATEGORY"
        )
        
        // Add custom user info
        notification.userInfo = [
            "post_id": "post_789",
            "author_id": "user_101",
            "post_type": "image"
        ]
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(10)
            )
            print("✅ Social notification with custom actions scheduled")
        } catch {
            print("❌ Failed to schedule social notification: \(error)")
        }
    }
    
    /// Example 3: Reminder notification with custom actions
    func createReminderNotification() {
        let notification = NotificationContent(
            title: "Task Reminder",
            body: "Don't forget to complete your task",
            category: "REMINDER_CATEGORY"
        )
        
        // Add custom user info
        notification.userInfo = [
            "task_id": "task_202",
            "priority": "high",
            "due_date": Date().addingTimeInterval(3600).timeIntervalSince1970
        ]
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(15)
            )
            print("✅ Reminder notification with custom actions scheduled")
        } catch {
            print("❌ Failed to schedule reminder notification: \(error)")
        }
    }
    
    /// Example 4: Custom notification with custom actions
    func createCustomNotification() {
        let notification = NotificationContent(
            title: "Custom Notification",
            body: "This is a custom notification with custom actions",
            category: "CUSTOM_CATEGORY"
        )
        
        // Add custom user info
        notification.userInfo = [
            "custom_id": "custom_303",
            "custom_type": "example",
            "custom_data": "sample_data"
        ]
        
        do {
            try notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(20)
            )
            print("✅ Custom notification with custom actions scheduled")
        } catch {
            print("❌ Failed to schedule custom notification: \(error)")
        }
    }
    
    // MARK: - Usage Example
    
    /// Run all custom actions examples
    func runAllExamples() {
        print("🚀 Running Custom Actions Examples...")
        
        createMessageNotification()
        createSocialNotification()
        createReminderNotification()
        createCustomNotification()
        
        print("✅ All custom actions examples completed")
    }
}

// MARK: - Action Handler
class NotificationActionHandler: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let actionIdentifier = response.actionIdentifier
        let notification = response.notification
        let userInfo = notification.request.content.userInfo
        
        print("📱 Action received: \(actionIdentifier)")
        
        switch actionIdentifier {
        case "VIEW_MESSAGE":
            handleViewMessage(userInfo)
        case "REPLY_MESSAGE":
            handleReplyMessage(response)
        case "SHARE_MESSAGE":
            handleShareMessage(userInfo)
        case "DELETE_MESSAGE":
            handleDeleteMessage(userInfo)
        case "LIKE_POST":
            handleLikePost(userInfo)
        case "COMMENT_POST":
            handleCommentPost(response)
        case "BOOKMARK_POST":
            handleBookmarkPost(userInfo)
        case "SHARE_POST":
            handleSharePost(userInfo)
        case "COMPLETE_REMINDER":
            handleCompleteReminder(userInfo)
        case "SNOOZE_REMINDER":
            handleSnoozeReminder(userInfo)
        case "RESCHEDULE_REMINDER":
            handleRescheduleReminder(userInfo)
        case "DISMISS_REMINDER":
            handleDismissReminder(userInfo)
        case "CUSTOM_ACTION_1":
            handleCustomAction1(userInfo)
        case "CUSTOM_ACTION_2":
            handleCustomAction2(userInfo)
        case "CUSTOM_ACTION_3":
            handleCustomAction3(userInfo)
        default:
            print("❌ Unknown action: \(actionIdentifier)")
        }
        
        completionHandler()
    }
    
    // MARK: - Message Actions
    private func handleViewMessage(_ userInfo: [AnyHashable: Any]) {
        let messageID = userInfo["message_id"] as? String
        print("📱 Viewing message: \(messageID ?? "unknown")")
        // Navigate to message detail
    }
    
    private func handleReplyMessage(_ response: UNNotificationResponse) {
        if let textResponse = response as? UNTextInputNotificationResponse {
            let replyText = textResponse.userText
            let messageID = response.notification.request.content.userInfo["message_id"] as? String
            print("📱 Replying to message \(messageID ?? "unknown"): \(replyText)")
            // Send reply
        }
    }
    
    private func handleShareMessage(_ userInfo: [AnyHashable: Any]) {
        let messageID = userInfo["message_id"] as? String
        print("📱 Sharing message: \(messageID ?? "unknown")")
        // Present share sheet
    }
    
    private func handleDeleteMessage(_ userInfo: [AnyHashable: Any]) {
        let messageID = userInfo["message_id"] as? String
        print("📱 Deleting message: \(messageID ?? "unknown")")
        // Delete message
    }
    
    // MARK: - Social Actions
    private func handleLikePost(_ userInfo: [AnyHashable: Any]) {
        let postID = userInfo["post_id"] as? String
        print("📱 Liking post: \(postID ?? "unknown")")
        // Like the post
    }
    
    private func handleCommentPost(_ response: UNNotificationResponse) {
        if let textResponse = response as? UNTextInputNotificationResponse {
            let commentText = textResponse.userText
            let postID = response.notification.request.content.userInfo["post_id"] as? String
            print("📱 Commenting on post \(postID ?? "unknown"): \(commentText)")
            // Post comment
        }
    }
    
    private func handleBookmarkPost(_ userInfo: [AnyHashable: Any]) {
        let postID = userInfo["post_id"] as? String
        print("📱 Bookmarking post: \(postID ?? "unknown")")
        // Bookmark the post
    }
    
    private func handleSharePost(_ userInfo: [AnyHashable: Any]) {
        let postID = userInfo["post_id"] as? String
        print("📱 Sharing post: \(postID ?? "unknown")")
        // Present share sheet
    }
    
    // MARK: - Reminder Actions
    private func handleCompleteReminder(_ userInfo: [AnyHashable: Any]) {
        let taskID = userInfo["task_id"] as? String
        print("📱 Completing task: \(taskID ?? "unknown")")
        // Mark task as complete
    }
    
    private func handleSnoozeReminder(_ userInfo: [AnyHashable: Any]) {
        let taskID = userInfo["task_id"] as? String
        print("📱 Snoozing task: \(taskID ?? "unknown")")
        // Snooze the reminder
    }
    
    private func handleRescheduleReminder(_ userInfo: [AnyHashable: Any]) {
        let taskID = userInfo["task_id"] as? String
        print("📱 Rescheduling task: \(taskID ?? "unknown")")
        // Reschedule the reminder
    }
    
    private func handleDismissReminder(_ userInfo: [AnyHashable: Any]) {
        let taskID = userInfo["task_id"] as? String
        print("📱 Dismissing task: \(taskID ?? "unknown")")
        // Dismiss the reminder
    }
    
    // MARK: - Custom Actions
    private func handleCustomAction1(_ userInfo: [AnyHashable: Any]) {
        let customID = userInfo["custom_id"] as? String
        print("📱 Custom action 1 for: \(customID ?? "unknown")")
        // Handle custom action 1
    }
    
    private func handleCustomAction2(_ userInfo: [AnyHashable: Any]) {
        let customID = userInfo["custom_id"] as? String
        print("📱 Custom action 2 for: \(customID ?? "unknown")")
        // Handle custom action 2
    }
    
    private func handleCustomAction3(_ userInfo: [AnyHashable: Any]) {
        let customID = userInfo["custom_id"] as? String
        print("📱 Custom action 3 for: \(customID ?? "unknown")")
        // Handle custom action 3
    }
} 