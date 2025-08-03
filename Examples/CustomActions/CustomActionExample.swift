import Foundation
import NotificationFramework
import UserNotifications

/// Custom action examples demonstrating various action types and handling
class CustomActionExample {
    
    private let notificationManager = NotificationManager.shared
    
    /// Demonstrates basic custom actions
    func demonstrateBasicActions() async throws {
        let notification = RichNotificationContent(
            title: "Basic Actions",
            body: "Try the custom actions below",
            actions: [
                NotificationAction(
                    title: "Accept",
                    identifier: "accept_action",
                    options: [.foreground]
                ),
                NotificationAction(
                    title: "Decline",
                    identifier: "decline_action",
                    options: [.destructive]
                ),
                NotificationAction(
                    title: "Remind Later",
                    identifier: "remind_later_action",
                    options: []
                )
            ]
        )
        
        // Register action handlers
        notificationManager.registerActionHandler(for: "accept_action") { action in
            print("User accepted the notification")
            self.handleAcceptAction()
        }
        
        notificationManager.registerActionHandler(for: "decline_action") { action in
            print("User declined the notification")
            self.handleDeclineAction()
        }
        
        notificationManager.registerActionHandler(for: "remind_later_action") { action in
            print("User chose to be reminded later")
            self.handleRemindLaterAction()
        }
        
        try await notificationManager.scheduleRichNotification(
            notification,
            at: Date().addingTimeInterval(5)
        )
        
        print("Scheduled notification with basic actions")
    }
    
    /// Demonstrates authentication required actions
    func demonstrateAuthenticationActions() async throws {
        let secureNotification = RichNotificationContent(
            title: "Secure Action",
            body: "This action requires authentication",
            actions: [
                NotificationAction(
                    title: "Purchase",
                    identifier: "purchase_action",
                    options: [.authenticationRequired, .foreground]
                ),
                NotificationAction(
                    title: "Delete Account",
                    identifier: "delete_account_action",
                    options: [.authenticationRequired, .destructive]
                ),
                NotificationAction(
                    title: "View Profile",
                    identifier: "view_profile_action",
                    options: [.foreground]
                )
            ]
        )
        
        // Register secure action handlers
        notificationManager.registerActionHandler(for: "purchase_action") { action in
            print("User attempted purchase")
            self.handleSecurePurchase()
        }
        
        notificationManager.registerActionHandler(for: "delete_account_action") { action in
            print("User attempted account deletion")
            self.handleSecureDelete()
        }
        
        notificationManager.registerActionHandler(for: "view_profile_action") { action in
            print("User wants to view profile")
            self.handleViewProfile()
        }
        
        try await notificationManager.scheduleRichNotification(
            secureNotification,
            at: Date().addingTimeInterval(10)
        )
        
        print("Scheduled notification with authentication actions")
    }
    
    /// Demonstrates destructive actions
    func demonstrateDestructiveActions() async throws {
        let destructiveNotification = RichNotificationContent(
            title: "Destructive Actions",
            body: "Be careful with these actions",
            actions: [
                NotificationAction(
                    title: "Delete",
                    identifier: "delete_action",
                    options: [.destructive]
                ),
                NotificationAction(
                    title: "Block User",
                    identifier: "block_user_action",
                    options: [.destructive, .authenticationRequired]
                ),
                NotificationAction(
                    title: "Cancel",
                    identifier: "cancel_action",
                    options: []
                )
            ]
        )
        
        // Register destructive action handlers
        notificationManager.registerActionHandler(for: "delete_action") { action in
            print("User chose to delete")
            self.handleDeleteAction()
        }
        
        notificationManager.registerActionHandler(for: "block_user_action") { action in
            print("User chose to block user")
            self.handleBlockUserAction()
        }
        
        notificationManager.registerActionHandler(for: "cancel_action") { action in
            print("User cancelled the action")
            self.handleCancelAction()
        }
        
        try await notificationManager.scheduleRichNotification(
            destructiveNotification,
            at: Date().addingTimeInterval(15)
        )
        
        print("Scheduled notification with destructive actions")
    }
    
    /// Demonstrates contextual actions
    func demonstrateContextualActions() async throws {
        let contextualNotifications = [
            RichNotificationContent(
                title: "Social Media Post",
                body: "New post from your friend",
                actions: [
                    NotificationAction(title: "Like", identifier: "like_action", options: []),
                    NotificationAction(title: "Comment", identifier: "comment_action", options: [.foreground]),
                    NotificationAction(title: "Share", identifier: "share_action", options: [.foreground])
                ]
            ),
            RichNotificationContent(
                title: "E-commerce Offer",
                body: "Special offer on your wishlist item",
                actions: [
                    NotificationAction(title: "View Product", identifier: "view_product_action", options: [.foreground]),
                    NotificationAction(title: "Add to Cart", identifier: "add_to_cart_action", options: [.authenticationRequired]),
                    NotificationAction(title: "Buy Now", identifier: "buy_now_action", options: [.destructive, .authenticationRequired])
                ]
            ),
            RichNotificationContent(
                title: "Message Received",
                body: "New message from John",
                actions: [
                    NotificationAction(title: "Reply", identifier: "reply_action", options: [.foreground]),
                    NotificationAction(title: "Mark as Read", identifier: "mark_read_action", options: []),
                    NotificationAction(title: "Delete", identifier: "delete_message_action", options: [.destructive])
                ]
            )
        ]
        
        // Register contextual action handlers
        setupContextualActionHandlers()
        
        // Schedule contextual notifications
        for (index, notification) in contextualNotifications.enumerated() {
            let delay = TimeInterval(index + 1) * 20
            try await notificationManager.scheduleRichNotification(
                notification,
                at: Date().addingTimeInterval(delay)
            )
            print("Scheduled contextual notification \(index + 1)")
        }
    }
    
    /// Demonstrates action analytics
    func demonstrateActionAnalytics() async throws {
        let analyticsNotification = RichNotificationContent(
            title: "Analytics Test",
            body: "This notification tracks action analytics",
            actions: [
                NotificationAction(title: "Action A", identifier: "action_a", options: []),
                NotificationAction(title: "Action B", identifier: "action_b", options: [.foreground]),
                NotificationAction(title: "Action C", identifier: "action_c", options: [.destructive])
            ]
        )
        
        // Register action handlers with analytics
        notificationManager.registerActionHandler(for: "action_a") { action in
            self.trackActionAnalytics("action_a", responseTime: 1.5)
            self.handleActionA()
        }
        
        notificationManager.registerActionHandler(for: "action_b") { action in
            self.trackActionAnalytics("action_b", responseTime: 2.3)
            self.handleActionB()
        }
        
        notificationManager.registerActionHandler(for: "action_c") { action in
            self.trackActionAnalytics("action_c", responseTime: 0.8)
            self.handleActionC()
        }
        
        try await notificationManager.scheduleRichNotification(
            analyticsNotification,
            at: Date().addingTimeInterval(25)
        )
        
        print("Scheduled notification with action analytics")
    }
    
    /// Demonstrates action removal
    func demonstrateActionRemoval() async throws {
        // Register an action handler
        notificationManager.registerActionHandler(for: "temporary_action") { action in
            print("Temporary action triggered")
        }
        
        // Schedule notification with the action
        let notification = RichNotificationContent(
            title: "Temporary Action",
            body: "This action will be removed",
            actions: [
                NotificationAction(title: "Temporary", identifier: "temporary_action", options: [])
            ]
        )
        
        try await notificationManager.scheduleRichNotification(
            notification,
            at: Date().addingTimeInterval(30)
        )
        
        print("Scheduled notification with temporary action")
        
        // Remove the action handler after some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 35) {
            self.notificationManager.removeActionHandler(for: "temporary_action")
            print("Removed temporary action handler")
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupContextualActionHandlers() {
        // Social media actions
        notificationManager.registerActionHandler(for: "like_action") { action in
            self.handleLikeAction()
        }
        
        notificationManager.registerActionHandler(for: "comment_action") { action in
            self.handleCommentAction()
        }
        
        notificationManager.registerActionHandler(for: "share_action") { action in
            self.handleShareAction()
        }
        
        // E-commerce actions
        notificationManager.registerActionHandler(for: "view_product_action") { action in
            self.handleViewProductAction()
        }
        
        notificationManager.registerActionHandler(for: "add_to_cart_action") { action in
            self.handleAddToCartAction()
        }
        
        notificationManager.registerActionHandler(for: "buy_now_action") { action in
            self.handleBuyNowAction()
        }
        
        // Messaging actions
        notificationManager.registerActionHandler(for: "reply_action") { action in
            self.handleReplyAction()
        }
        
        notificationManager.registerActionHandler(for: "mark_read_action") { action in
            self.handleMarkReadAction()
        }
        
        notificationManager.registerActionHandler(for: "delete_message_action") { action in
            self.handleDeleteMessageAction()
        }
    }
    
    private func trackActionAnalytics(_ actionId: String, responseTime: TimeInterval) {
        notificationManager.trackEvent(.notificationResponded, metadata: [
            "action_id": actionId,
            "response_time": responseTime,
            "timestamp": Date().timeIntervalSince1970
        ])
    }
    
    // MARK: - Action Handlers
    
    private func handleAcceptAction() {
        print("Processing accept action...")
        // Implement accept logic
    }
    
    private func handleDeclineAction() {
        print("Processing decline action...")
        // Implement decline logic
    }
    
    private func handleRemindLaterAction() {
        print("Processing remind later action...")
        // Schedule reminder for later
    }
    
    private func handleSecurePurchase() {
        print("Processing secure purchase...")
        // Implement secure purchase logic
    }
    
    private func handleSecureDelete() {
        print("Processing secure delete...")
        // Implement secure delete logic
    }
    
    private func handleViewProfile() {
        print("Processing view profile...")
        // Navigate to profile
    }
    
    private func handleDeleteAction() {
        print("Processing delete action...")
        // Implement delete logic
    }
    
    private func handleBlockUserAction() {
        print("Processing block user action...")
        // Implement block user logic
    }
    
    private func handleCancelAction() {
        print("Processing cancel action...")
        // Implement cancel logic
    }
    
    private func handleLikeAction() {
        print("Processing like action...")
        // Implement like logic
    }
    
    private func handleCommentAction() {
        print("Processing comment action...")
        // Navigate to comment screen
    }
    
    private func handleShareAction() {
        print("Processing share action...")
        // Show share sheet
    }
    
    private func handleViewProductAction() {
        print("Processing view product action...")
        // Navigate to product page
    }
    
    private func handleAddToCartAction() {
        print("Processing add to cart action...")
        // Add item to cart
    }
    
    private func handleBuyNowAction() {
        print("Processing buy now action...")
        // Proceed to checkout
    }
    
    private func handleReplyAction() {
        print("Processing reply action...")
        // Open reply interface
    }
    
    private func handleMarkReadAction() {
        print("Processing mark as read action...")
        // Mark message as read
    }
    
    private func handleDeleteMessageAction() {
        print("Processing delete message action...")
        // Delete message
    }
    
    private func handleActionA() {
        print("Processing action A...")
        // Implement action A logic
    }
    
    private func handleActionB() {
        print("Processing action B...")
        // Implement action B logic
    }
    
    private func handleActionC() {
        print("Processing action C...")
        // Implement action C logic
    }
}

// MARK: - Usage Example

@main
struct CustomActionExampleApp {
    static func main() async throws {
        let example = CustomActionExample()
        
        print("Starting custom action examples...")
        
        // Request permissions first
        let granted = try await NotificationManager.shared.requestPermissions()
        guard granted else {
            print("Notification permissions not granted")
            return
        }
        
        // Demonstrate various custom actions
        try await example.demonstrateBasicActions()
        try await example.demonstrateAuthenticationActions()
        try await example.demonstrateDestructiveActions()
        try await example.demonstrateContextualActions()
        try await example.demonstrateActionAnalytics()
        try await example.demonstrateActionRemoval()
        
        print("Custom action examples completed successfully!")
    }
} 