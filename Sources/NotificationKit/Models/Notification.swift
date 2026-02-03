//
//  Notification.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// A type-safe notification model with builder pattern support
public struct Notification: Sendable {
    
    // MARK: - Properties
    
    /// Unique identifier for the notification
    public let id: String
    
    /// The notification title
    public var title: String = ""
    
    /// The notification subtitle
    public var subtitle: String = ""
    
    /// The notification body text
    public var body: String = ""
    
    /// The notification sound
    public var sound: UNNotificationSound?
    
    /// The notification badge number
    public var badge: Int?
    
    /// The notification category identifier
    public var categoryIdentifier: String?
    
    /// The notification thread identifier for grouping
    public var threadIdentifier: String?
    
    /// Custom user info dictionary
    public var userInfo: [String: Any] = [:]
    
    /// The notification trigger
    public var trigger: NotificationTrigger = .immediate
    
    /// Attachment URLs
    public var attachments: [URL] = []
    
    /// Interruption level (iOS 15+)
    public var interruptionLevel: UNNotificationInterruptionLevel = .active
    
    /// Relevance score for notification ordering
    public var relevanceScore: Double = 0
    
    // MARK: - Initialization
    
    /// Creates a new notification with the given identifier
    /// - Parameter id: The unique notification identifier
    public init(id: String) {
        self.id = id
    }
    
    // MARK: - Builder Methods
    
    /// Sets the notification title
    /// - Parameter title: The title text
    /// - Returns: The modified notification
    public func title(_ title: String) -> Notification {
        var copy = self
        copy.title = title
        return copy
    }
    
    /// Sets the notification subtitle
    /// - Parameter subtitle: The subtitle text
    /// - Returns: The modified notification
    public func subtitle(_ subtitle: String) -> Notification {
        var copy = self
        copy.subtitle = subtitle
        return copy
    }
    
    /// Sets the notification body
    /// - Parameter body: The body text
    /// - Returns: The modified notification
    public func body(_ body: String) -> Notification {
        var copy = self
        copy.body = body
        return copy
    }
    
    /// Sets the notification sound
    /// - Parameter sound: The sound to play
    /// - Returns: The modified notification
    public func sound(_ sound: UNNotificationSound) -> Notification {
        var copy = self
        copy.sound = sound
        return copy
    }
    
    /// Sets the notification badge number
    /// - Parameter badge: The badge count
    /// - Returns: The modified notification
    public func badge(_ badge: Int) -> Notification {
        var copy = self
        copy.badge = badge
        return copy
    }
    
    /// Sets the notification category for interactive notifications
    /// - Parameter categoryIdentifier: The category identifier
    /// - Returns: The modified notification
    public func category(_ categoryIdentifier: String) -> Notification {
        var copy = self
        copy.categoryIdentifier = categoryIdentifier
        return copy
    }
    
    /// Sets the thread identifier for grouping
    /// - Parameter threadIdentifier: The thread identifier
    /// - Returns: The modified notification
    public func thread(_ threadIdentifier: String) -> Notification {
        var copy = self
        copy.threadIdentifier = threadIdentifier
        return copy
    }
    
    /// Sets the notification trigger
    /// - Parameter trigger: The trigger type
    /// - Returns: The modified notification
    public func trigger(_ trigger: NotificationTrigger) -> Notification {
        var copy = self
        copy.trigger = trigger
        return copy
    }
    
    /// Convenience method to set time interval trigger
    /// - Parameter interval: The time interval
    /// - Returns: The modified notification
    public func trigger(after interval: TimeInterval) -> Notification {
        trigger(.timeInterval(interval))
    }
    
    /// Adds an attachment URL
    /// - Parameter url: The attachment URL
    /// - Returns: The modified notification
    public func attachment(_ url: URL) -> Notification {
        var copy = self
        copy.attachments.append(url)
        return copy
    }
    
    /// Sets the interruption level (iOS 15+)
    /// - Parameter level: The interruption level
    /// - Returns: The modified notification
    public func interruptionLevel(_ level: UNNotificationInterruptionLevel) -> Notification {
        var copy = self
        copy.interruptionLevel = level
        return copy
    }
    
    /// Marks as time sensitive (iOS 15+)
    /// - Returns: The modified notification
    public func timeSensitive() -> Notification {
        interruptionLevel(.timeSensitive)
    }
    
    /// Marks as critical (requires entitlement)
    /// - Returns: The modified notification
    public func critical() -> Notification {
        interruptionLevel(.critical)
    }
    
    /// Sets the relevance score
    /// - Parameter score: The relevance score (0.0 to 1.0)
    /// - Returns: The modified notification
    public func relevanceScore(_ score: Double) -> Notification {
        var copy = self
        copy.relevanceScore = min(1.0, max(0.0, score))
        return copy
    }
    
    /// Adds custom user info
    /// - Parameter userInfo: The user info dictionary
    /// - Returns: The modified notification
    public func userInfo(_ userInfo: [String: Any]) -> Notification {
        var copy = self
        copy.userInfo = userInfo
        return copy
    }
    
    // MARK: - Conversion
    
    /// Converts to a UNNotificationRequest
    func toRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        
        if let sound = sound {
            content.sound = sound
        }
        
        if let badge = badge {
            content.badge = NSNumber(value: badge)
        }
        
        if let categoryIdentifier = categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }
        
        if let threadIdentifier = threadIdentifier {
            content.threadIdentifier = threadIdentifier
        }
        
        content.userInfo = userInfo
        content.interruptionLevel = interruptionLevel
        content.relevanceScore = relevanceScore
        
        // Add attachments
        content.attachments = attachments.compactMap { url in
            try? UNNotificationAttachment(identifier: UUID().uuidString, url: url)
        }
        
        let unTrigger = trigger.toUNTrigger()
        
        return UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: unTrigger
        )
    }
}
