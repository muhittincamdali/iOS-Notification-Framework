# Custom Actions API

## Overview

The Custom Actions API provides comprehensive support for creating interactive notification actions, including buttons, text input, and custom UI components that enhance user engagement with notifications.

## Core Classes

### NotificationAction

```swift
public class NotificationAction {
    // MARK: - Properties
    public let title: String
    public let identifier: String
    public let options: UNNotificationActionOptions
    public let textInput: TextInputAction?
    public let icon: String?
    public let backgroundColor: UIColor?
    public let textColor: UIColor?
    
    // MARK: - Initialization
    public init(
        title: String,
        identifier: String,
        options: UNNotificationActionOptions = [],
        textInput: TextInputAction? = nil,
        icon: String? = nil,
        backgroundColor: UIColor? = nil,
        textColor: UIColor? = nil
    )
}
```

### TextInputAction

```swift
public class TextInputAction {
    // MARK: - Properties
    public let placeholder: String
    public let submitButtonTitle: String
    public let maxLength: Int?
    public let keyboardType: UIKeyboardType
    public let autocapitalizationType: UITextAutocapitalizationType
    public let autocorrectionType: UITextAutocorrectionType
    
    // MARK: - Initialization
    public init(
        placeholder: String,
        submitButtonTitle: String,
        maxLength: Int? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        autocorrectionType: UITextAutocorrectionType = .default
    )
}
```

### NotificationActionCategory

```swift
public class NotificationActionCategory {
    // MARK: - Properties
    public let identifier: String
    public let actions: [NotificationAction]
    public let options: UNNotificationCategoryOptions
    public let intentIdentifiers: [String]
    
    // MARK: - Initialization
    public init(
        identifier: String,
        actions: [NotificationAction],
        options: UNNotificationCategoryOptions = [],
        intentIdentifiers: [String] = []
    )
}
```

## Action Types

### Basic Actions

```swift
// Create basic notification actions
let viewAction = NotificationAction(
    title: "View",
    identifier: "view_action",
    options: [.foreground]
)

let shareAction = NotificationAction(
    title: "Share",
    identifier: "share_action",
    options: [.foreground]
)

let dismissAction = NotificationAction(
    title: "Dismiss",
    identifier: "dismiss_action",
    options: [.destructive]
)

// Create notification with basic actions
let notificationWithActions = NotificationContent(
    title: "New Message",
    body: "You have a new message from John",
    actions: [viewAction, shareAction, dismissAction]
)
```

### Text Input Actions

```swift
// Create text input action
let replyAction = NotificationAction(
    title: "Reply",
    identifier: "reply_action",
    options: [.foreground],
    textInput: TextInputAction(
        placeholder: "Type your reply...",
        submitButtonTitle: "Send",
        maxLength: 280,
        keyboardType: .default,
        autocapitalizationType: .sentences
    )
)

// Create notification with text input
let messageNotification = NotificationContent(
    title: "New Message",
    body: "John sent you a message",
    actions: [replyAction, viewAction, dismissAction]
)
```

### Authentication Actions

```swift
// Create authentication required action
let likeAction = NotificationAction(
    title: "👍 Like",
    identifier: "like_action",
    options: [.authenticationRequired]
)

let bookmarkAction = NotificationAction(
    title: "🔖 Bookmark",
    identifier: "bookmark_action",
    options: [.authenticationRequired]
)

// Create notification with authentication actions
let socialNotification = NotificationContent(
    title: "New Post",
    body: "Check out this amazing post",
    actions: [likeAction, bookmarkAction, shareAction]
)
```

### Custom Styled Actions

```swift
// Create custom styled actions
let primaryAction = NotificationAction(
    title: "Primary Action",
    identifier: "primary_action",
    options: [.foreground],
    icon: "star.fill",
    backgroundColor: UIColor.systemBlue,
    textColor: UIColor.white
)

let secondaryAction = NotificationAction(
    title: "Secondary Action",
    identifier: "secondary_action",
    options: [.foreground],
    icon: "heart.fill",
    backgroundColor: UIColor.systemRed,
    textColor: UIColor.white
)

// Create notification with custom styled actions
let styledNotification = NotificationContent(
    title: "Custom Styled",
    body: "Notification with custom styled actions",
    actions: [primaryAction, secondaryAction]
)
```

## Action Categories

### Message Category

```swift
// Create message action category
let messageCategory = NotificationActionCategory(
    identifier: "message_category",
    actions: [
        NotificationAction(title: "View", identifier: "view_message", options: [.foreground]),
        NotificationAction(title: "Reply", identifier: "reply_message", options: [.foreground]),
        NotificationAction(title: "Share", identifier: "share_message", options: [.foreground]),
        NotificationAction(title: "Delete", identifier: "delete_message", options: [.destructive])
    ],
    options: [.customDismissAction]
)

// Register message category
notificationManager.registerActionCategory(messageCategory)
```

### Social Category

```swift
// Create social action category
let socialCategory = NotificationActionCategory(
    identifier: "social_category",
    actions: [
        NotificationAction(title: "👍 Like", identifier: "like_post", options: [.authenticationRequired]),
        NotificationAction(title: "💬 Comment", identifier: "comment_post", options: [.foreground]),
        NotificationAction(title: "🔖 Bookmark", identifier: "bookmark_post", options: [.authenticationRequired]),
        NotificationAction(title: "📤 Share", identifier: "share_post", options: [.foreground])
    ],
    options: [.allowInCarPlay]
)

// Register social category
notificationManager.registerActionCategory(socialCategory)
```

### Reminder Category

```swift
// Create reminder action category
let reminderCategory = NotificationActionCategory(
    identifier: "reminder_category",
    actions: [
        NotificationAction(title: "✅ Complete", identifier: "complete_reminder", options: [.foreground]),
        NotificationAction(title: "⏰ Snooze", identifier: "snooze_reminder", options: [.foreground]),
        NotificationAction(title: "📅 Reschedule", identifier: "reschedule_reminder", options: [.foreground]),
        NotificationAction(title: "❌ Dismiss", identifier: "dismiss_reminder", options: [.destructive])
    ],
    options: [.customDismissAction]
)

// Register reminder category
notificationManager.registerActionCategory(reminderCategory)
```

## Action Handling

### Action Response Handling

```swift
// Handle action responses
class NotificationActionHandler: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let actionIdentifier = response.actionIdentifier
        let notification = response.notification
        
        switch actionIdentifier {
        case "view_action":
            handleViewAction(notification)
        case "share_action":
            handleShareAction(notification)
        case "reply_action":
            handleReplyAction(response)
        case "like_action":
            handleLikeAction(notification)
        case "bookmark_action":
            handleBookmarkAction(notification)
        default:
            break
        }
        
        completionHandler()
    }
    
    private func handleViewAction(_ notification: UNNotification) {
        // Navigate to the relevant screen
        let userInfo = notification.request.content.userInfo
        let itemID = userInfo["item_id"] as? String
        
        // Navigate to item detail
        navigateToItemDetail(itemID: itemID)
    }
    
    private func handleShareAction(_ notification: UNNotification) {
        // Share the content
        let userInfo = notification.request.content.userInfo
        let shareURL = userInfo["share_url"] as? String
        
        // Present share sheet
        presentShareSheet(url: shareURL)
    }
    
    private func handleReplyAction(_ response: UNNotificationResponse) {
        // Handle text input response
        if let textInputResponse = response as? UNTextInputNotificationResponse {
            let replyText = textInputResponse.userText
            let notificationID = response.notification.request.identifier
            
            // Send reply
            sendReply(text: replyText, for: notificationID)
        }
    }
    
    private func handleLikeAction(_ notification: UNNotification) {
        // Handle like action
        let userInfo = notification.request.content.userInfo
        let postID = userInfo["post_id"] as? String
        
        // Like the post
        likePost(postID: postID)
    }
    
    private func handleBookmarkAction(_ notification: UNNotification) {
        // Handle bookmark action
        let userInfo = notification.request.content.userInfo
        let postID = userInfo["post_id"] as? String
        
        // Bookmark the post
        bookmarkPost(postID: postID)
    }
}
```

### Action Analytics

```swift
// Track action analytics
class ActionAnalytics {
    
    func trackAction(
        actionIdentifier: String,
        notificationID: String,
        userInfo: [AnyHashable: Any]
    ) {
        let analyticsManager = NotificationAnalyticsManager()
        
        analyticsManager.trackEvent("notification_action_tapped", properties: [
            "action_identifier": actionIdentifier,
            "notification_id": notificationID,
            "action_type": getActionType(actionIdentifier),
            "timestamp": Date().timeIntervalSince1970
        ])
    }
    
    private func getActionType(_ actionIdentifier: String) -> String {
        switch actionIdentifier {
        case "view_action", "view_message":
            return "view"
        case "share_action", "share_message", "share_post":
            return "share"
        case "reply_action", "reply_message":
            return "reply"
        case "like_action", "like_post":
            return "like"
        case "bookmark_action", "bookmark_post":
            return "bookmark"
        case "complete_reminder":
            return "complete"
        case "snooze_reminder":
            return "snooze"
        default:
            return "unknown"
        }
    }
}
```

## Advanced Features

### Dynamic Actions

```swift
// Create dynamic actions based on context
func createDynamicActions(for notification: NotificationContent) -> [NotificationAction] {
    var actions: [NotificationAction] = []
    
    // Always add view action
    actions.append(NotificationAction(
        title: "View",
        identifier: "view_action",
        options: [.foreground]
    ))
    
    // Add context-specific actions
    if let category = notification.category {
        switch category {
        case "message":
            actions.append(NotificationAction(
                title: "Reply",
                identifier: "reply_action",
                options: [.foreground]
            ))
        case "social":
            actions.append(NotificationAction(
                title: "👍 Like",
                identifier: "like_action",
                options: [.authenticationRequired]
            ))
        case "reminder":
            actions.append(NotificationAction(
                title: "✅ Complete",
                identifier: "complete_action",
                options: [.foreground]
            ))
        default:
            break
        }
    }
    
    // Add share action for shareable content
    if notification.userInfo["shareable"] as? Bool == true {
        actions.append(NotificationAction(
            title: "Share",
            identifier: "share_action",
            options: [.foreground]
        ))
    }
    
    return actions
}
```

### Action Chaining

```swift
// Chain multiple actions
func chainActions(_ actions: [NotificationAction]) -> NotificationAction {
    let chainedAction = NotificationAction(
        title: "Multi-Action",
        identifier: "chained_action",
        options: [.foreground]
    )
    
    // Execute actions in sequence
    for action in actions {
        executeAction(action)
    }
    
    return chainedAction
}

private func executeAction(_ action: NotificationAction) {
    // Execute individual action logic
    switch action.identifier {
    case "like_action":
        performLikeAction()
    case "share_action":
        performShareAction()
    case "bookmark_action":
        performBookmarkAction()
    default:
        break
    }
}
```

### Action Templates

```swift
// Create reusable action templates
struct ActionTemplates {
    
    static let messageActions = [
        NotificationAction(title: "View", identifier: "view_message", options: [.foreground]),
        NotificationAction(title: "Reply", identifier: "reply_message", options: [.foreground]),
        NotificationAction(title: "Share", identifier: "share_message", options: [.foreground])
    ]
    
    static let socialActions = [
        NotificationAction(title: "👍 Like", identifier: "like_post", options: [.authenticationRequired]),
        NotificationAction(title: "💬 Comment", identifier: "comment_post", options: [.foreground]),
        NotificationAction(title: "📤 Share", identifier: "share_post", options: [.foreground])
    ]
    
    static let reminderActions = [
        NotificationAction(title: "✅ Complete", identifier: "complete_reminder", options: [.foreground]),
        NotificationAction(title: "⏰ Snooze", identifier: "snooze_reminder", options: [.foreground]),
        NotificationAction(title: "❌ Dismiss", identifier: "dismiss_reminder", options: [.destructive])
    ]
}

// Use action templates
func createNotificationWithTemplate(template: [NotificationAction]) -> NotificationContent {
    return NotificationContent(
        title: "Template Notification",
        body: "Using action template",
        actions: template
    )
}
```

## Error Handling

### Action Errors

```swift
public enum ActionError: Error {
    case invalidActionIdentifier
    case actionNotSupported
    case authenticationRequired
    case networkError
    case validationError
    case timeoutError
}

// Handle action errors
func handleActionError(_ error: ActionError, for action: NotificationAction) {
    switch error {
    case .invalidActionIdentifier:
        print("❌ Invalid action identifier: \(action.identifier)")
    case .actionNotSupported:
        print("❌ Action not supported: \(action.title)")
    case .authenticationRequired:
        print("❌ Authentication required for action: \(action.title)")
        // Prompt user for authentication
        requestAuthentication()
    case .networkError:
        print("❌ Network error for action: \(action.title)")
        // Retry action after delay
        retryAction(action, after: 5.0)
    case .validationError:
        print("❌ Validation error for action: \(action.title)")
        // Show validation error to user
        showValidationError()
    case .timeoutError:
        print("❌ Timeout error for action: \(action.title)")
        // Show timeout error to user
        showTimeoutError()
    }
}
```

## Best Practices

### Action Design

1. **Keep actions simple and clear**
   - Use descriptive titles
   - Limit to 4 actions per notification
   - Use icons for visual clarity

2. **Follow platform guidelines**
   - Use standard action patterns
   - Respect user preferences
   - Handle authentication properly

3. **Implement proper error handling**
   - Validate action responses
   - Handle network errors gracefully
   - Provide user feedback

4. **Track action analytics**
   - Monitor action usage
   - Analyze user engagement
   - Optimize based on data

5. **Test thoroughly**
   - Test all action scenarios
   - Verify error handling
   - Test on different devices

### Performance Considerations

- **Minimize action processing time**
- **Use background processing for heavy operations**
- **Cache action results when appropriate**
- **Implement proper memory management**
- **Monitor action performance metrics**

### Security Notes

- **Validate all action inputs**
- **Sanitize user content**
- **Handle sensitive data appropriately**
- **Follow privacy guidelines**
- **Implement proper authentication**
