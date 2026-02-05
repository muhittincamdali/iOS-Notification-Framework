//
//  Notification.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import CoreGraphics
@preconcurrency import UserNotifications

/// A type-safe notification model with comprehensive builder pattern support
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
    public var attachments: [NotificationAttachment] = []
    
    /// Interruption level (iOS 15+)
    public var interruptionLevel: UNNotificationInterruptionLevel = .active
    
    /// Relevance score for notification ordering
    public var relevanceScore: Double = 0
    
    /// Target content identifier (for replacing)
    public var targetContentIdentifier: String?
    
    /// Filter criteria (iOS 16+)
    public var filterCriteria: String?
    
    /// Summary argument
    public var summaryArgument: String?
    
    /// Summary argument count
    public var summaryArgumentCount: Int = 1
    
    /// Notification channel ID
    public var channelId: String?
    
    /// A/B test ID
    public var abTestId: String?
    
    /// Bypass quiet hours
    public var bypassQuietHours: Bool = false
    
    /// Bypass rate limiting
    public var bypassRateLimiting: Bool = false
    
    /// Deep link URL
    public var deepLink: String?
    
    /// Launch image name
    public var launchImageName: String?
    
    /// Action data for quick actions
    public var actionData: [String: Any] = [:]
    
    /// Personalization data
    public var personalization: PersonalizationData?
    
    /// Expiration date
    public var expirationDate: Date?
    
    /// Priority level
    public var priority: NotificationPriority = .normal
    
    // MARK: - Initialization
    
    /// Creates a new notification with the given identifier
    /// - Parameter id: The unique notification identifier
    public init(id: String) {
        self.id = id
    }
    
    /// Creates a new notification with auto-generated ID
    public init() {
        self.id = UUID().uuidString
    }
    
    // MARK: - Basic Builder Methods
    
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
    
    /// Sets a named sound
    public func sound(named name: String) -> Notification {
        var copy = self
        copy.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: name))
        return copy
    }
    
    /// Sets critical sound with volume
    @available(iOS 12.0, *)
    public func criticalSound(named name: String? = nil, volume: Float = 1.0) -> Notification {
        var copy = self
        if let name = name {
            copy.sound = UNNotificationSound.criticalSoundNamed(
                UNNotificationSoundName(rawValue: name),
                withAudioVolume: volume
            )
        } else {
            copy.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: volume)
        }
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
    
    // MARK: - Trigger Builder Methods
    
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
    
    /// Triggers after minutes
    public func afterMinutes(_ minutes: Int) -> Notification {
        trigger(.after(minutes: minutes))
    }
    
    /// Triggers after hours
    public func afterHours(_ hours: Int) -> Notification {
        trigger(.after(hours: hours))
    }
    
    /// Triggers at specific date
    public func at(date: Date) -> Notification {
        trigger(.on(date: date))
    }
    
    /// Triggers daily at specified time
    public func daily(at hour: Int, minute: Int = 0) -> Notification {
        trigger(.daily(at: hour, minute: minute))
    }
    
    /// Triggers weekly on specified day
    public func weekly(on weekday: Int, at hour: Int, minute: Int = 0) -> Notification {
        trigger(.weekly(on: weekday, at: hour, minute: minute))
    }
    
    // MARK: - Rich Content Builder Methods
    
    /// Adds an attachment URL
    /// - Parameter url: The attachment URL
    /// - Returns: The modified notification
    public func attachment(_ url: URL) -> Notification {
        var copy = self
        copy.attachments.append(NotificationAttachment(url: url))
        return copy
    }
    
    /// Adds an attachment with options
    public func attachment(_ attachment: NotificationAttachment) -> Notification {
        var copy = self
        copy.attachments.append(attachment)
        return copy
    }
    
    /// Adds an image attachment
    public func image(_ url: URL, thumbnail: Bool = false) -> Notification {
        var copy = self
        var attachment = NotificationAttachment(url: url)
        attachment.type = .image
        attachment.showThumbnail = thumbnail
        copy.attachments.append(attachment)
        return copy
    }
    
    /// Adds a video attachment
    public func video(_ url: URL) -> Notification {
        var copy = self
        var attachment = NotificationAttachment(url: url)
        attachment.type = .video
        copy.attachments.append(attachment)
        return copy
    }
    
    /// Adds an audio attachment
    public func audio(_ url: URL) -> Notification {
        var copy = self
        var attachment = NotificationAttachment(url: url)
        attachment.type = .audio
        copy.attachments.append(attachment)
        return copy
    }
    
    /// Adds a GIF attachment
    public func gif(_ url: URL) -> Notification {
        var copy = self
        var attachment = NotificationAttachment(url: url)
        attachment.type = .gif
        copy.attachments.append(attachment)
        return copy
    }
    
    // MARK: - Interruption Level Builder Methods
    
    /// Sets the interruption level (iOS 15+)
    /// - Parameter level: The interruption level
    /// - Returns: The modified notification
    public func interruptionLevel(_ level: UNNotificationInterruptionLevel) -> Notification {
        var copy = self
        copy.interruptionLevel = level
        return copy
    }
    
    /// Marks as passive (no sound/vibration)
    public func passive() -> Notification {
        interruptionLevel(.passive)
    }
    
    /// Marks as active (default)
    public func active() -> Notification {
        interruptionLevel(.active)
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
    
    // MARK: - Advanced Builder Methods
    
    /// Adds custom user info
    /// - Parameter userInfo: The user info dictionary
    /// - Returns: The modified notification
    public func userInfo(_ userInfo: [String: Any]) -> Notification {
        var copy = self
        copy.userInfo = userInfo
        return copy
    }
    
    /// Adds a user info value
    public func userInfo(key: String, value: Any) -> Notification {
        var copy = self
        copy.userInfo[key] = value
        return copy
    }
    
    /// Sets the target content identifier
    public func targetContent(_ identifier: String) -> Notification {
        var copy = self
        copy.targetContentIdentifier = identifier
        return copy
    }
    
    /// Sets the summary argument
    public func summary(_ argument: String, count: Int = 1) -> Notification {
        var copy = self
        copy.summaryArgument = argument
        copy.summaryArgumentCount = count
        return copy
    }
    
    /// Sets the notification channel
    public func channel(_ channelId: String) -> Notification {
        var copy = self
        copy.channelId = channelId
        return copy
    }
    
    /// Sets the A/B test
    public func abTest(_ testId: String) -> Notification {
        var copy = self
        copy.abTestId = testId
        return copy
    }
    
    /// Bypasses quiet hours
    public func bypassQuietHours(_ bypass: Bool = true) -> Notification {
        var copy = self
        copy.bypassQuietHours = bypass
        return copy
    }
    
    /// Bypasses rate limiting
    public func bypassRateLimit(_ bypass: Bool = true) -> Notification {
        var copy = self
        copy.bypassRateLimiting = bypass
        return copy
    }
    
    /// Sets the deep link
    public func deepLink(_ url: String) -> Notification {
        var copy = self
        copy.deepLink = url
        copy.userInfo["deepLink"] = url
        return copy
    }
    
    /// Sets the launch image
    public func launchImage(_ name: String) -> Notification {
        var copy = self
        copy.launchImageName = name
        return copy
    }
    
    /// Sets the priority
    public func priority(_ priority: NotificationPriority) -> Notification {
        var copy = self
        copy.priority = priority
        return copy
    }
    
    /// Sets the expiration date
    public func expires(at date: Date) -> Notification {
        var copy = self
        copy.expirationDate = date
        return copy
    }
    
    /// Sets the expiration from now
    public func expires(after interval: TimeInterval) -> Notification {
        var copy = self
        copy.expirationDate = Date().addingTimeInterval(interval)
        return copy
    }
    
    /// Adds action data
    public func actionData(_ data: [String: Any]) -> Notification {
        var copy = self
        copy.actionData = data
        copy.userInfo["actionData"] = data
        return copy
    }
    
    /// Sets personalization
    public func personalize(_ data: PersonalizationData) -> Notification {
        var copy = self
        copy.personalization = data
        return applyPersonalization(copy)
    }
    
    private func applyPersonalization(_ notification: Notification) -> Notification {
        guard let data = notification.personalization else { return notification }
        
        var copy = notification
        
        // Apply name
        if let name = data.userName {
            copy.title = copy.title.replacingOccurrences(of: "{{name}}", with: name)
            copy.body = copy.body.replacingOccurrences(of: "{{name}}", with: name)
        }
        
        // Apply custom values
        for (key, value) in data.customValues {
            copy.title = copy.title.replacingOccurrences(of: "{{\(key)}}", with: value)
            copy.body = copy.body.replacingOccurrences(of: "{{\(key)}}", with: value)
        }
        
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
        
        if let targetContentIdentifier = targetContentIdentifier {
            content.targetContentIdentifier = targetContentIdentifier
        }
        
        if let summaryArgument = summaryArgument {
            content.summaryArgument = summaryArgument
            content.summaryArgumentCount = summaryArgumentCount
        }
        
        #if os(iOS)
        if let launchImageName = launchImageName {
            content.launchImageName = launchImageName
        }
        #endif
        
        if #available(iOS 16.0, *), let filterCriteria = filterCriteria {
            content.filterCriteria = filterCriteria
        }
        
        // Add attachments
        content.attachments = attachments.compactMap { attachment in
            try? attachment.toUNAttachment()
        }
        
        let unTrigger = trigger.toUNTrigger()
        
        return UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: unTrigger
        )
    }
}

// MARK: - Notification Attachment

/// A notification attachment with rich options
public struct NotificationAttachment: Sendable {
    
    public enum AttachmentType: String, Sendable {
        case image
        case video
        case audio
        case gif
        case unknown
    }
    
    /// Attachment URL
    public var url: URL
    
    /// Attachment type
    public var type: AttachmentType = .unknown
    
    /// Custom identifier
    public var identifier: String?
    
    /// Show thumbnail
    public var showThumbnail: Bool = true
    
    /// Thumbnail clipping rect
    public var thumbnailClippingRect: CGRect?
    
    /// Thumbnail time (for videos)
    public var thumbnailTime: TimeInterval?
    
    /// Hide extension
    public var hidesExtension: Bool = false
    
    // MARK: - Initialization
    
    public init(url: URL) {
        self.url = url
    }
    
    // MARK: - Builder
    
    /// Sets custom identifier
    public func identifier(_ id: String) -> NotificationAttachment {
        var copy = self
        copy.identifier = id
        return copy
    }
    
    /// Hides thumbnail
    public func hideThumbnail() -> NotificationAttachment {
        var copy = self
        copy.showThumbnail = false
        return copy
    }
    
    /// Sets thumbnail clipping rect
    public func thumbnailClip(_ rect: CGRect) -> NotificationAttachment {
        var copy = self
        copy.thumbnailClippingRect = rect
        return copy
    }
    
    /// Sets thumbnail time for video
    public func thumbnailAt(_ seconds: TimeInterval) -> NotificationAttachment {
        var copy = self
        copy.thumbnailTime = seconds
        return copy
    }
    
    // MARK: - Conversion
    
    func toUNAttachment() throws -> UNNotificationAttachment {
        var options: [String: Any] = [:]
        
        if !showThumbnail {
            options[UNNotificationAttachmentOptionsThumbnailHiddenKey] = true
        }
        
        if let rect = thumbnailClippingRect {
            options[UNNotificationAttachmentOptionsThumbnailClippingRectKey] = CGRect.toDictionary(rect)
        }
        
        if let time = thumbnailTime {
            options[UNNotificationAttachmentOptionsThumbnailTimeKey] = time
        }
        
        return try UNNotificationAttachment(
            identifier: identifier ?? UUID().uuidString,
            url: url,
            options: options.isEmpty ? nil : options
        )
    }
}

// MARK: - Notification Priority

/// Priority level for notifications
public enum NotificationPriority: Int, Sendable {
    case low = 0
    case normal = 5
    case high = 10
    case urgent = 15
}

// MARK: - Personalization Data

/// Data for personalizing notifications
public struct PersonalizationData: Sendable {
    /// User's name
    public var userName: String?
    
    /// Custom key-value pairs
    public var customValues: [String: String] = [:]
    
    public init(userName: String? = nil) {
        self.userName = userName
    }
    
    /// Adds a custom value
    public func value(_ key: String, _ value: String) -> PersonalizationData {
        var copy = self
        copy.customValues[key] = value
        return copy
    }
}

// MARK: - CGRect Extension

extension CGRect {
    /// Converts CGRect to dictionary for notification attachment options
    static func toDictionary(_ rect: CGRect) -> [String: Any] {
        return [
            "X": rect.origin.x,
            "Y": rect.origin.y,
            "Width": rect.size.width,
            "Height": rect.size.height
        ]
    }
}
