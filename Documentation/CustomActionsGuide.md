# Custom Actions Guide

## Overview

The Custom Actions module provides comprehensive support for interactive notification buttons and responses in iOS notifications. This guide covers everything you need to know about implementing custom actions that engage users and drive app interactions.

## Table of Contents

- [Getting Started](#getting-started)
- [Basic Actions](#basic-actions)
- [Advanced Actions](#advanced-actions)
- [Action Categories](#action-categories)
- [Text Input Actions](#text-input-actions)
- [Authentication Actions](#authentication-actions)
- [Deep Linking](#deep-linking)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
- Notification permissions granted
- Understanding of notification categories

### Installation

Add the framework to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Notification-Framework.git", from: "1.0.0")
]
```

### Basic Setup

```swift
import NotificationFramework

// Initialize notification manager
let notificationManager = NotificationManager.shared

// Enable custom actions
let config = NotificationConfiguration()
config.enableCustomActions = true
config.enableTextInputActions = true
config.enableAuthenticationActions = true

notificationManager.configure(config)
```

## Basic Actions

### Simple Action Button

```swift
// Create simple action
let viewAction = NotificationAction(
    title: "View",
    identifier: "view_action",
    options: [.foreground]
)

// Create notification with action
let notification = NotificationContent(
    title: "New Message",
    body: "You have a new message from John",
    category: "message",
    actions: [viewAction]
)

// Schedule notification
try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

### Multiple Actions

```swift
// Create multiple actions
let viewAction = NotificationAction(
    title: "View",
    identifier: "view_action",
    options: [.foreground]
)

let replyAction = NotificationAction(
    title: "Reply",
    identifier: "reply_action",
    options: [.foreground]
)

let deleteAction = NotificationAction(
    title: "Delete",
    identifier: "delete_action",
    options: [.destructive]
)

// Create notification with multiple actions
let notification = NotificationContent(
    title: "New Message",
    body: "You have a new message from John",
    category: "message",
    actions: [viewAction, replyAction, deleteAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

### Action with Icon

```swift
// Create action with custom icon
let likeAction = NotificationAction(
    title: "👍 Like",
    identifier: "like_action",
    options: [.foreground],
    icon: "heart.fill"
)

let shareAction = NotificationAction(
    title: "📤 Share",
    identifier: "share_action",
    options: [.foreground],
    icon: "square.and.arrow.up"
)

let notification = NotificationContent(
    title: "New Post",
    body: "Check out this amazing post",
    category: "social",
    actions: [likeAction, shareAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

## Advanced Actions

### Destructive Actions

```swift
// Create destructive action
let deleteAction = NotificationAction(
    title: "Delete",
    identifier: "delete_action",
    options: [.destructive, .foreground]
)

let notification = NotificationContent(
    title: "Confirm Deletion",
    body: "Are you sure you want to delete this item?",
    category: "confirmation",
    actions: [deleteAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

### Background Actions

```swift
// Create background action
let snoozeAction = NotificationAction(
    title: "Snooze",
    identifier: "snooze_action",
    options: [.background]
)

let completeAction = NotificationAction(
    title: "Complete",
    identifier: "complete_action",
    options: [.background]
)

let notification = NotificationContent(
    title: "Task Reminder",
    body: "Don't forget to complete your task",
    category: "reminder",
    actions: [snoozeAction, completeAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

### Action with User Info

```swift
// Create action with user info
let viewAction = NotificationAction(
    title: "View Profile",
    identifier: "view_profile_action",
    options: [.foreground],
    userInfo: [
        "user_id": "12345",
        "profile_type": "public"
    ]
)

let notification = NotificationContent(
    title: "New Follower",
    body: "John started following you",
    category: "social",
    actions: [viewAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

## Action Categories

### Message Actions

```swift
// Create message category
let messageCategory = NotificationCategory(
    identifier: "message",
    actions: [
        NotificationAction(title: "View", identifier: "view_action"),
        NotificationAction(title: "Reply", identifier: "reply_action"),
        NotificationAction(title: "Forward", identifier: "forward_action"),
        NotificationAction(title: "Delete", identifier: "delete_action", options: [.destructive])
    ],
    options: [.customDismissAction]
)

// Register message category
notificationManager.registerCategory(messageCategory)
```

### Social Actions

```swift
// Create social category
let socialCategory = NotificationCategory(
    identifier: "social",
    actions: [
        NotificationAction(title: "👍 Like", identifier: "like_action"),
        NotificationAction(title: "💬 Comment", identifier: "comment_action"),
        NotificationAction(title: "📤 Share", identifier: "share_action"),
        NotificationAction(title: "🔖 Save", identifier: "save_action")
    ],
    options: [.allowInCarPlay]
)

// Register social category
notificationManager.registerCategory(socialCategory)
```

### Reminder Actions

```swift
// Create reminder category
let reminderCategory = NotificationCategory(
    identifier: "reminder",
    actions: [
        NotificationAction(title: "⏰ Snooze", identifier: "snooze_action"),
        NotificationAction(title: "✅ Complete", identifier: "complete_action"),
        NotificationAction(title: "📅 Reschedule", identifier: "reschedule_action")
    ],
    options: [.allowInCarPlay]
)

// Register reminder category
notificationManager.registerCategory(reminderCategory)
```

## Text Input Actions

### Basic Text Input

```swift
// Create text input action
let replyAction = NotificationAction(
    title: "Reply",
    identifier: "reply_action",
    options: [.foreground],
    textInput: TextInputAction(
        placeholder: "Type your reply...",
        submitButtonTitle: "Send"
    )
)

let notification = NotificationContent(
    title: "New Message",
    body: "You have a new message from John",
    category: "message",
    actions: [replyAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

### Advanced Text Input

```swift
// Create advanced text input action
let commentAction = NotificationAction(
    title: "💬 Comment",
    identifier: "comment_action",
    options: [.foreground],
    textInput: TextInputAction(
        placeholder: "Write a comment...",
        submitButtonTitle: "Post",
        maxLength: 280,
        keyboardType: .default,
        autocapitalization: .sentences
    )
)

let notification = NotificationContent(
    title: "New Post",
    body: "Check out this amazing post",
    category: "social",
    actions: [commentAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

### Multiple Text Inputs

```swift
// Create notification with multiple text inputs
let quickReplyAction = NotificationAction(
    title: "Quick Reply",
    identifier: "quick_reply_action",
    options: [.foreground],
    textInput: TextInputAction(
        placeholder: "Quick reply...",
        submitButtonTitle: "Send",
        maxLength: 100
    )
)

let detailedReplyAction = NotificationAction(
    title: "Detailed Reply",
    identifier: "detailed_reply_action",
    options: [.foreground],
    textInput: TextInputAction(
        placeholder: "Write a detailed reply...",
        submitButtonTitle: "Send",
        maxLength: 1000,
        keyboardType: .default
    )
)

let notification = NotificationContent(
    title: "New Message",
    body: "You have a new message from John",
    category: "message",
    actions: [quickReplyAction, detailedReplyAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

## Authentication Actions

### Authentication Required Actions

```swift
// Create authentication required action
let secureAction = NotificationAction(
    title: "🔒 Secure Action",
    identifier: "secure_action",
    options: [.authenticationRequired, .foreground]
)

let notification = NotificationContent(
    title: "Secure Notification",
    body: "This action requires authentication",
    category: "secure",
    actions: [secureAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

### Biometric Authentication

```swift
// Create biometric authentication action
let biometricAction = NotificationAction(
    title: "🔐 Unlock",
    identifier: "biometric_action",
    options: [.authenticationRequired, .foreground],
    authenticationType: .biometric
)

let notification = NotificationContent(
    title: "Secure Content",
    body: "Use biometric authentication to unlock",
    category: "secure",
    actions: [biometricAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

## Deep Linking

### Basic Deep Linking

```swift
// Create action with deep link
let viewAction = NotificationAction(
    title: "View Details",
    identifier: "view_details_action",
    options: [.foreground],
    deepLink: "myapp://product/12345"
)

let notification = NotificationContent(
    title: "New Product",
    body: "Check out our latest product",
    category: "product",
    actions: [viewAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

### Complex Deep Linking

```swift
// Create action with complex deep link
let profileAction = NotificationAction(
    title: "View Profile",
    identifier: "view_profile_action",
    options: [.foreground],
    deepLink: "myapp://profile/user/12345?tab=posts&highlight=latest"
)

let notification = NotificationContent(
    title: "New Follower",
    body: "John started following you",
    category: "social",
    actions: [profileAction]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

### Dynamic Deep Linking

```swift
// Create action with dynamic deep link
let dynamicAction = NotificationAction(
    title: "View Content",
    identifier: "view_content_action",
    options: [.foreground],
    dynamicDeepLink: { userInfo in
        let contentId = userInfo["content_id"] as? String ?? ""
        let contentType = userInfo["content_type"] as? String ?? "post"
        return "myapp://\(contentType)/\(contentId)"
    }
)

let notification = NotificationContent(
    title: "New Content",
    body: "Check out this new content",
    category: "content",
    actions: [dynamicAction],
    userInfo: [
        "content_id": "67890",
        "content_type": "article"
    ]
)

try await notificationManager.schedule(
    notification,
    at: Date().addingTimeInterval(60)
)
```

## Action Handlers

### Basic Action Handler

```swift
// Create action handler
class NotificationActionHandler: NotificationActionHandlerProtocol {
    func handleAction(
        _ action: NotificationAction,
        for notification: NotificationContent,
        completion: @escaping (Bool) -> Void
    ) {
        switch action.identifier {
        case "view_action":
            handleViewAction(notification)
            completion(true)
        case "reply_action":
            handleReplyAction(notification)
            completion(true)
        case "delete_action":
            handleDeleteAction(notification)
            completion(true)
        default:
            completion(false)
        }
    }
    
    private func handleViewAction(_ notification: NotificationContent) {
        // Navigate to message detail
        navigateToMessageDetail(notification.userInfo)
    }
    
    private func handleReplyAction(_ notification: NotificationContent) {
        // Open reply interface
        openReplyInterface(notification.userInfo)
    }
    
    private func handleDeleteAction(_ notification: NotificationContent) {
        // Delete message
        deleteMessage(notification.userInfo)
    }
}

// Register action handler
notificationManager.setActionHandler(NotificationActionHandler())
```

### Advanced Action Handler

```swift
// Create advanced action handler
class AdvancedActionHandler: NotificationActionHandlerProtocol {
    func handleAction(
        _ action: NotificationAction,
        for notification: NotificationContent,
        completion: @escaping (Bool) -> Void
    ) {
        // Log action for analytics
        analyticsManager.trackAction(action.identifier, notification: notification)
        
        // Handle based on action type
        switch action.type {
        case .view:
            handleViewAction(action, notification, completion)
        case .reply:
            handleReplyAction(action, notification, completion)
        case .delete:
            handleDeleteAction(action, notification, completion)
        case .custom:
            handleCustomAction(action, notification, completion)
        }
    }
    
    private func handleViewAction(
        _ action: NotificationAction,
        _ notification: NotificationContent,
        _ completion: @escaping (Bool) -> Void
    ) {
        // Navigate to content
        if let deepLink = action.deepLink {
            navigateToDeepLink(deepLink)
        } else {
            navigateToDefaultView(notification.userInfo)
        }
        completion(true)
    }
    
    private func handleReplyAction(
        _ action: NotificationAction,
        _ notification: NotificationContent,
        _ completion: @escaping (Bool) -> Void
    ) {
        // Handle text input
        if let textInput = action.textInput {
            presentTextInput(textInput) { text in
                self.sendReply(text, for: notification)
                completion(true)
            }
        } else {
            openReplyInterface(notification.userInfo)
            completion(true)
        }
    }
    
    private func handleDeleteAction(
        _ action: NotificationAction,
        _ notification: NotificationContent,
        _ completion: @escaping (Bool) -> Void
    ) {
        // Show confirmation dialog
        showDeleteConfirmation { confirmed in
            if confirmed {
                self.deleteContent(notification.userInfo)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func handleCustomAction(
        _ action: NotificationAction,
        _ notification: NotificationContent,
        _ completion: @escaping (Bool) -> Void
    ) {
        // Handle custom action
        performCustomAction(action, notification) { success in
            completion(success)
        }
    }
}

// Register advanced action handler
notificationManager.setActionHandler(AdvancedActionHandler())
```

## Best Practices

### 1. Action Design

```swift
// Design clear, actionable buttons
let clearAction = NotificationAction(
    title: "View Details", // Clear, specific action
    identifier: "view_details_action",
    options: [.foreground]
)

// Avoid vague actions
let vagueAction = NotificationAction(
    title: "OK", // Too vague
    identifier: "ok_action",
    options: [.foreground]
)
```

### 2. Action Limits

```swift
// Limit actions to 4 per notification (iOS limit)
let notification = NotificationContent(
    title: "New Message",
    body: "You have a new message from John",
    category: "message",
    actions: [
        NotificationAction(title: "View", identifier: "view_action"),
        NotificationAction(title: "Reply", identifier: "reply_action"),
        NotificationAction(title: "Forward", identifier: "forward_action"),
        NotificationAction(title: "Delete", identifier: "delete_action")
        // Maximum 4 actions
    ]
)
```

### 3. Action Ordering

```swift
// Order actions by importance and frequency
let notification = NotificationContent(
    title: "New Message",
    body: "You have a new message from John",
    category: "message",
    actions: [
        NotificationAction(title: "Reply", identifier: "reply_action"), // Most common
        NotificationAction(title: "View", identifier: "view_action"),   // Second most common
        NotificationAction(title: "Forward", identifier: "forward_action"), // Less common
        NotificationAction(title: "Delete", identifier: "delete_action") // Least common
    ]
)
```

### 4. Accessibility

```swift
// Ensure actions are accessible
let accessibleAction = NotificationAction(
    title: "View Details",
    identifier: "view_details_action",
    options: [.foreground],
    accessibilityLabel: "View message details",
    accessibilityHint: "Double tap to view the full message"
)
```

### 5. Error Handling

```swift
// Handle action failures gracefully
func handleActionFailure(_ action: NotificationAction, error: Error) {
    // Log error
    analyticsManager.trackActionError(action.identifier, error: error)
    
    // Show user-friendly error message
    showErrorMessage("Unable to perform action. Please try again.")
    
    // Retry mechanism
    if shouldRetryAction(action) {
        retryAction(action)
    }
}
```

## Troubleshooting

### Common Issues

#### 1. Actions Not Appearing

```swift
// Check if category is registered
let categories = notificationManager.getRegisteredCategories()
print("Registered categories: \(categories)")

// Ensure category matches
if !categories.contains("message") {
    notificationManager.registerCategory(messageCategory)
}
```

#### 2. Action Not Responding

```swift
// Check if action handler is set
let handler = notificationManager.getActionHandler()
if handler == nil {
    notificationManager.setActionHandler(MyActionHandler())
}

// Verify action identifier
print("Action identifier: \(action.identifier)")
```

#### 3. Deep Links Not Working

```swift
// Check deep link format
let deepLink = action.deepLink
print("Deep link: \(deepLink)")

// Validate deep link
if let url = URL(string: deepLink) {
    print("Valid URL: \(url)")
} else {
    print("❌ Invalid deep link format")
}
```

### Debug Mode

```swift
// Enable action debug mode
notificationManager.enableActionDebugMode()

// Get action debug logs
notificationManager.getActionDebugLogs { logs in
    for log in logs {
        print("🔍 Action Debug: \(log)")
    }
}
```

### Performance Monitoring

```swift
// Monitor action performance
notificationManager.startActionPerformanceMonitoring()

// Get performance metrics
notificationManager.getActionPerformanceMetrics { metrics in
    print("📊 Action response time: \(metrics.averageResponseTime)ms")
    print("📊 Action success rate: \(metrics.successRate)%")
    print("📊 Most used action: \(metrics.mostUsedAction)")
}
```

## Advanced Features

### Custom Action Types

```swift
// Create custom action type
enum CustomActionType {
    case like
    case share
    case bookmark
    case report
}

// Implement custom action
class CustomAction: NotificationAction {
    let customType: CustomActionType
    
    init(
        title: String,
        identifier: String,
        customType: CustomActionType,
        options: NotificationActionOptions = []
    ) {
        self.customType = customType
        super.init(title: title, identifier: identifier, options: options)
    }
}
```

### Action Analytics

```swift
// Track action analytics
class ActionAnalytics {
    func trackAction(
        _ action: NotificationAction,
        notification: NotificationContent
    ) {
        analyticsManager.trackEvent("notification_action", properties: [
            "action_id": action.identifier,
            "action_title": action.title,
            "notification_category": notification.category,
            "timestamp": Date().timeIntervalSince1970
        ])
    }
}
```

This comprehensive guide covers all aspects of custom actions in the iOS Notification Framework. Follow these patterns to create engaging, interactive notifications that drive user engagement and app usage.
