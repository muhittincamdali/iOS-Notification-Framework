//
//  NotificationCategory.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// A notification category for interactive notifications
public struct NotificationCategory: Sendable {
    
    // MARK: - Properties
    
    /// The category identifier
    public let identifier: String
    
    /// The actions for this category
    public var actions: [NotificationAction]
    
    /// Intent identifiers for Siri
    public var intentIdentifiers: [String]
    
    /// Category options
    public var options: UNNotificationCategoryOptions
    
    /// Placeholder for hidden previews
    public var hiddenPreviewsBodyPlaceholder: String?
    
    /// Summary format for grouped notifications
    public var categorySummaryFormat: String?
    
    // MARK: - Initialization
    
    /// Creates a new notification category
    /// - Parameters:
    ///   - identifier: The category identifier
    ///   - actions: The actions for this category
    ///   - intentIdentifiers: Siri intent identifiers
    ///   - options: Category options
    public init(
        identifier: String,
        actions: [NotificationAction] = [],
        intentIdentifiers: [String] = [],
        options: UNNotificationCategoryOptions = []
    ) {
        self.identifier = identifier
        self.actions = actions
        self.intentIdentifiers = intentIdentifiers
        self.options = options
    }
    
    // MARK: - Builder Methods
    
    /// Adds an action to the category
    /// - Parameter action: The action to add
    /// - Returns: The modified category
    public func action(_ action: NotificationAction) -> NotificationCategory {
        var copy = self
        copy.actions.append(action)
        return copy
    }
    
    /// Adds multiple actions
    public func actions(_ actions: [NotificationAction]) -> NotificationCategory {
        var copy = self
        copy.actions.append(contentsOf: actions)
        return copy
    }
    
    /// Sets the category options
    /// - Parameter options: The options
    /// - Returns: The modified category
    public func options(_ options: UNNotificationCategoryOptions) -> NotificationCategory {
        var copy = self
        copy.options = options
        return copy
    }
    
    /// Sets custom dismiss action
    public func customDismissAction() -> NotificationCategory {
        var copy = self
        copy.options.insert(.customDismissAction)
        return copy
    }
    
    /// Allows sending to CarPlay
    #if os(iOS)
    public func allowInCarPlay() -> NotificationCategory {
        var copy = self
        copy.options.insert(.allowInCarPlay)
        return copy
    }
    #endif
    
    /// Hides preview by default
    public func hiddenPreviewsShowTitle() -> NotificationCategory {
        var copy = self
        copy.options.insert(.hiddenPreviewsShowTitle)
        return copy
    }
    
    /// Hides preview subtitle
    public func hiddenPreviewsShowSubtitle() -> NotificationCategory {
        var copy = self
        copy.options.insert(.hiddenPreviewsShowSubtitle)
        return copy
    }
    
    /// Sets hidden previews placeholder
    public func hiddenPreviewsPlaceholder(_ placeholder: String) -> NotificationCategory {
        var copy = self
        copy.hiddenPreviewsBodyPlaceholder = placeholder
        return copy
    }
    
    /// Sets summary format
    public func summaryFormat(_ format: String) -> NotificationCategory {
        var copy = self
        copy.categorySummaryFormat = format
        return copy
    }
    
    /// Adds intent identifier
    public func intent(_ identifier: String) -> NotificationCategory {
        var copy = self
        copy.intentIdentifiers.append(identifier)
        return copy
    }
    
    // MARK: - Conversion
    
    /// Converts to a UNNotificationCategory
    func toUNCategory() -> UNNotificationCategory {
        let unActions = actions.map { $0.toUNAction() }
        
        if let placeholder = hiddenPreviewsBodyPlaceholder,
           let format = categorySummaryFormat {
            return UNNotificationCategory(
                identifier: identifier,
                actions: unActions,
                intentIdentifiers: intentIdentifiers,
                hiddenPreviewsBodyPlaceholder: placeholder,
                categorySummaryFormat: format,
                options: options
            )
        } else if let placeholder = hiddenPreviewsBodyPlaceholder {
            return UNNotificationCategory(
                identifier: identifier,
                actions: unActions,
                intentIdentifiers: intentIdentifiers,
                hiddenPreviewsBodyPlaceholder: placeholder,
                options: options
            )
        } else {
            return UNNotificationCategory(
                identifier: identifier,
                actions: unActions,
                intentIdentifiers: intentIdentifiers,
                options: options
            )
        }
    }
}

// MARK: - Notification Action

/// An action for interactive notifications
public struct NotificationAction: Sendable {
    
    // MARK: - Properties
    
    /// The action identifier
    public let identifier: String
    
    /// The action title
    public let title: String
    
    /// Action options
    public var options: UNNotificationActionOptions
    
    /// Text input button title (for text input actions)
    public var textInputButtonTitle: String?
    
    /// Text input placeholder
    public var textInputPlaceholder: String?
    
    /// Icon name (iOS 15+)
    public var iconName: String?
    
    // MARK: - Initialization
    
    /// Creates a new notification action
    /// - Parameters:
    ///   - identifier: The action identifier
    ///   - title: The action title
    ///   - options: Action options
    public init(
        identifier: String,
        title: String,
        options: UNNotificationActionOptions = []
    ) {
        self.identifier = identifier
        self.title = title
        self.options = options
    }
    
    // MARK: - Builder Methods
    
    /// Marks the action as destructive
    /// - Returns: The modified action
    public func destructive() -> NotificationAction {
        var copy = self
        copy.options.insert(.destructive)
        return copy
    }
    
    /// Marks the action as requiring authentication
    /// - Returns: The modified action
    public func authenticationRequired() -> NotificationAction {
        var copy = self
        copy.options.insert(.authenticationRequired)
        return copy
    }
    
    /// Marks the action as foreground (opens app)
    /// - Returns: The modified action
    public func foreground() -> NotificationAction {
        var copy = self
        copy.options.insert(.foreground)
        return copy
    }
    
    /// Adds text input capability
    /// - Parameters:
    ///   - buttonTitle: The submit button title
    ///   - placeholder: The text field placeholder
    /// - Returns: The modified action
    public func textInput(
        buttonTitle: String,
        placeholder: String = ""
    ) -> NotificationAction {
        var copy = self
        copy.textInputButtonTitle = buttonTitle
        copy.textInputPlaceholder = placeholder
        return copy
    }
    
    /// Sets the icon (iOS 15+)
    public func icon(_ systemName: String) -> NotificationAction {
        var copy = self
        copy.iconName = systemName
        return copy
    }
    
    // MARK: - Conversion
    
    /// Converts to a UNNotificationAction
    func toUNAction() -> UNNotificationAction {
        if let buttonTitle = textInputButtonTitle {
            if #available(iOS 15.0, *), let iconName = iconName {
                return UNTextInputNotificationAction(
                    identifier: identifier,
                    title: title,
                    options: options,
                    icon: UNNotificationActionIcon(systemImageName: iconName),
                    textInputButtonTitle: buttonTitle,
                    textInputPlaceholder: textInputPlaceholder ?? ""
                )
            }
            return UNTextInputNotificationAction(
                identifier: identifier,
                title: title,
                options: options,
                textInputButtonTitle: buttonTitle,
                textInputPlaceholder: textInputPlaceholder ?? ""
            )
        }
        
        if #available(iOS 15.0, *), let iconName = iconName {
            return UNNotificationAction(
                identifier: identifier,
                title: title,
                options: options,
                icon: UNNotificationActionIcon(systemImageName: iconName)
            )
        }
        
        return UNNotificationAction(
            identifier: identifier,
            title: title,
            options: options
        )
    }
}

// MARK: - Common Actions

extension NotificationAction {
    /// Creates a "View" action that opens the app
    public static var view: NotificationAction {
        NotificationAction(identifier: "VIEW", title: "View")
            .foreground()
            .icon("eye")
    }
    
    /// Creates a "Dismiss" action
    public static var dismiss: NotificationAction {
        NotificationAction(identifier: "DISMISS", title: "Dismiss")
            .icon("xmark")
    }
    
    /// Creates a "Reply" action with text input
    public static var reply: NotificationAction {
        NotificationAction(identifier: "REPLY", title: "Reply")
            .textInput(buttonTitle: "Send", placeholder: "Type a message...")
            .icon("arrowshape.turn.up.left")
    }
    
    /// Creates a "Delete" destructive action
    public static var delete: NotificationAction {
        NotificationAction(identifier: "DELETE", title: "Delete")
            .destructive()
            .authenticationRequired()
            .icon("trash")
    }
    
    /// Creates a "Like" action
    public static var like: NotificationAction {
        NotificationAction(identifier: "LIKE", title: "Like")
            .icon("heart")
    }
    
    /// Creates a "Share" action
    public static var share: NotificationAction {
        NotificationAction(identifier: "SHARE", title: "Share")
            .foreground()
            .icon("square.and.arrow.up")
    }
    
    /// Creates a "Snooze" action
    public static var snooze: NotificationAction {
        NotificationAction(identifier: "SNOOZE", title: "Snooze")
            .icon("clock")
    }
    
    /// Creates a "Mark as Read" action
    public static var markAsRead: NotificationAction {
        NotificationAction(identifier: "MARK_READ", title: "Mark as Read")
            .icon("checkmark")
    }
    
    /// Creates an "Archive" action
    public static var archive: NotificationAction {
        NotificationAction(identifier: "ARCHIVE", title: "Archive")
            .icon("archivebox")
    }
    
    /// Creates a "Mute" action
    public static var mute: NotificationAction {
        NotificationAction(identifier: "MUTE", title: "Mute")
            .icon("bell.slash")
    }
}

// MARK: - Common Categories

extension NotificationCategory {
    /// Message category with reply, mark read, and delete
    public static var message: NotificationCategory {
        NotificationCategory(identifier: "MESSAGE")
            .action(.reply)
            .action(.markAsRead)
            .action(.delete)
            .summaryFormat("%u new messages")
    }
    
    /// Social category with like, reply, and view
    public static var social: NotificationCategory {
        NotificationCategory(identifier: "SOCIAL")
            .action(.like)
            .action(.reply)
            .action(.view)
    }
    
    /// Reminder category with snooze and complete
    public static var reminder: NotificationCategory {
        NotificationCategory(identifier: "REMINDER")
            .action(.snooze)
            .action(NotificationAction(identifier: "COMPLETE", title: "Complete")
                .foreground()
                .icon("checkmark.circle"))
    }
    
    /// Email category with reply, archive, and delete
    public static var email: NotificationCategory {
        NotificationCategory(identifier: "EMAIL")
            .action(.reply)
            .action(.archive)
            .action(.delete)
            .summaryFormat("%u new emails")
    }
    
    /// News category with share and mute
    public static var news: NotificationCategory {
        NotificationCategory(identifier: "NEWS")
            .action(.share)
            .action(.mute)
    }
    
    /// Order category with view and track
    public static var order: NotificationCategory {
        NotificationCategory(identifier: "ORDER")
            .action(.view)
            .action(NotificationAction(identifier: "TRACK", title: "Track Order")
                .foreground()
                .icon("location"))
    }
}
