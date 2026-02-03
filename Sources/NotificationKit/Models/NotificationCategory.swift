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
    
    /// Sets the category options
    /// - Parameter options: The options
    /// - Returns: The modified category
    public func options(_ options: UNNotificationCategoryOptions) -> NotificationCategory {
        var copy = self
        copy.options = options
        return copy
    }
    
    // MARK: - Conversion
    
    /// Converts to a UNNotificationCategory
    func toUNCategory() -> UNNotificationCategory {
        let unActions = actions.map { $0.toUNAction() }
        
        return UNNotificationCategory(
            identifier: identifier,
            actions: unActions,
            intentIdentifiers: intentIdentifiers,
            options: options
        )
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
    
    // MARK: - Conversion
    
    /// Converts to a UNNotificationAction
    func toUNAction() -> UNNotificationAction {
        if let buttonTitle = textInputButtonTitle {
            return UNTextInputNotificationAction(
                identifier: identifier,
                title: title,
                options: options,
                textInputButtonTitle: buttonTitle,
                textInputPlaceholder: textInputPlaceholder ?? ""
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
    }
    
    /// Creates a "Dismiss" action
    public static var dismiss: NotificationAction {
        NotificationAction(identifier: "DISMISS", title: "Dismiss")
    }
    
    /// Creates a "Reply" action with text input
    public static var reply: NotificationAction {
        NotificationAction(identifier: "REPLY", title: "Reply")
            .textInput(buttonTitle: "Send", placeholder: "Type a message...")
    }
    
    /// Creates a "Delete" destructive action
    public static var delete: NotificationAction {
        NotificationAction(identifier: "DELETE", title: "Delete")
            .destructive()
            .authenticationRequired()
    }
}
