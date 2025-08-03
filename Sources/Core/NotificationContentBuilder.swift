//
//  NotificationContentBuilder.swift
//  NotificationFramework
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// A builder class for creating notification content and requests.
///
/// This class provides a fluent interface for building notification content
/// and converting it to UNNotificationRequest objects.
///
/// ## Example Usage
/// ```swift
/// let builder = NotificationContentBuilder()
/// let request = try await builder.buildRequest(
///     from: content,
///     scheduledFor: Date().addingTimeInterval(60)
/// )
/// ```
@available(iOS 15.0, *)
public class NotificationContentBuilder {
    
    // MARK: - Properties
    
    /// Maximum size for media attachments in bytes.
    private let maxMediaSize: Int64 = 10 * 1024 * 1024 // 10MB
    
    /// Supported media types.
    private let supportedMediaTypes: [String] = ["image/jpeg", "image/png", "image/gif", "video/mp4", "audio/mpeg"]
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Methods
    
    /// Builds a notification request from content.
    ///
    /// - Parameters:
    ///   - content: The notification content to build from.
    ///   - scheduledFor: The date when the notification should be delivered.
    ///   - identifier: Optional identifier for the notification request.
    /// - Returns: A UNNotificationRequest object.
    /// - Throws: `NotificationError` if building fails.
    public func buildRequest(
        from content: NotificationContent,
        scheduledFor date: Date,
        identifier: String? = nil
    ) async throws -> UNNotificationRequest {
        
        // Validate content
        try validateContent(content)
        
        // Validate date
        try validateDate(date)
        
        // Create UNNotificationContent
        let unContent = try await createUNNotificationContent(from: content)
        
        // Create trigger
        let trigger = createTrigger(for: date)
        
        // Generate identifier
        let requestIdentifier = identifier ?? generateIdentifier()
        
        // Create request
        let request = UNNotificationRequest(
            identifier: requestIdentifier,
            content: unContent,
            trigger: trigger
        )
        
        return request
    }
    
    /// Builds a rich notification request from content.
    ///
    /// - Parameters:
    ///   - content: The rich notification content to build from.
    ///   - scheduledFor: The date when the notification should be delivered.
    ///   - identifier: Optional identifier for the notification request.
    /// - Returns: A UNNotificationRequest object.
    /// - Throws: `NotificationError` if building fails.
    public func buildRichRequest(
        from content: RichNotificationContent,
        scheduledFor date: Date,
        identifier: String? = nil
    ) async throws -> UNNotificationRequest {
        
        // Validate content
        try validateRichContent(content)
        
        // Validate date
        try validateDate(date)
        
        // Create UNNotificationContent
        let unContent = try await createRichUNNotificationContent(from: content)
        
        // Create trigger
        let trigger = createTrigger(for: date)
        
        // Generate identifier
        let requestIdentifier = identifier ?? generateIdentifier()
        
        // Create request
        let request = UNNotificationRequest(
            identifier: requestIdentifier,
            content: unContent,
            trigger: trigger
        )
        
        return request
    }
    
    // MARK: - Private Methods
    
    /// Validates notification content.
    private func validateContent(_ content: NotificationContent) throws {
        if content.title.isEmpty {
            throw NotificationError.invalidContent("Title cannot be empty")
        }
        
        if content.body.isEmpty {
            throw NotificationError.invalidContent("Body cannot be empty")
        }
        
        if content.title.count > 100 {
            throw NotificationError.invalidContent("Title is too long (maximum 100 characters)")
        }
        
        if content.body.count > 500 {
            throw NotificationError.invalidContent("Body is too long (maximum 500 characters)")
        }
        
        if !isValidIdentifier(content.category) {
            throw NotificationError.invalidContent("Invalid category identifier")
        }
    }
    
    /// Validates rich notification content.
    private func validateRichContent(_ content: RichNotificationContent) throws {
        try validateContent(content.content)
        
        if let mediaURL = content.mediaURL {
            try validateMediaURL(mediaURL)
        }
    }
    
    /// Validates notification date.
    private func validateDate(_ date: Date) throws {
        if date <= Date() {
            throw NotificationError.invalidDate(date)
        }
    }
    
    /// Validates media URL.
    private func validateMediaURL(_ url: URL) throws {
        // Check if file exists
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw NotificationError.mediaFileNotFound(url)
        }
        
        // Check file size
        let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
        let fileSize = attributes[.size] as? Int64 ?? 0
        
        if fileSize > maxMediaSize {
            throw NotificationError.mediaFileTooLarge(fileSize, maxMediaSize)
        }
        
        // Check file type
        let mimeType = getMimeType(for: url)
        if !supportedMediaTypes.contains(mimeType) {
            throw NotificationError.unsupportedMediaType(mimeType)
        }
    }
    
    /// Creates UNNotificationContent from NotificationContent.
    private func createUNNotificationContent(from content: NotificationContent) async throws -> UNNotificationContent {
        let unContent = UNMutableNotificationContent()
        
        unContent.title = content.title
        unContent.body = content.body
        unContent.categoryIdentifier = content.category
        unContent.sound = content.sound
        unContent.badge = content.badge
        unContent.userInfo = content.userInfo
        unContent.threadIdentifier = content.threadIdentifier
        unContent.targetContentIdentifier = content.targetContentIdentifier
        unContent.interruptionLevel = content.interruptionLevel
        unContent.relevanceScore = content.relevanceScore
        unContent.isSilent = content.isSilent
        
        return unContent
    }
    
    /// Creates rich UNNotificationContent from RichNotificationContent.
    private func createRichUNNotificationContent(from content: RichNotificationContent) async throws -> UNNotificationContent {
        let unContent = try await createUNNotificationContent(from: content.content)
        
        // Add media attachment if available
        if let mediaURL = content.mediaURL {
            let attachment = try await createAttachment(from: mediaURL, mediaType: content.mediaType)
            unContent.attachments = [attachment]
        }
        
        // Add subtitle if available
        if let subtitle = content.subtitle {
            unContent.subtitle = subtitle
        }
        
        // Add summary argument if available
        if let summaryArgument = content.summaryArgument {
            unContent.summaryArgument = summaryArgument
        }
        
        // Add summary argument count if available
        if let summaryArgumentCount = content.summaryArgumentCount {
            unContent.summaryArgumentCount = summaryArgumentCount
        }
        
        return unContent
    }
    
    /// Creates a notification trigger for the specified date.
    private func createTrigger(for date: Date) -> UNNotificationTrigger {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
    
    /// Creates a media attachment from URL.
    private func createAttachment(from url: URL, mediaType: MediaType) async throws -> UNNotificationAttachment {
        let options: [AnyHashable: Any] = [
            UNNotificationAttachmentOptionsTypeHintKey: mediaType.mimeType,
            UNNotificationAttachmentOptionsThumbnailHiddenKey: false,
            UNNotificationAttachmentOptionsThumbnailClippingRectKey: CGRect(x: 0, y: 0, width: 1, height: 1).dictionaryRepresentation
        ]
        
        return try UNNotificationAttachment(identifier: generateIdentifier(), url: url, options: options)
    }
    
    /// Generates a unique identifier for notifications.
    private func generateIdentifier() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let random = Int.random(in: 1000...9999)
        return "notification_\(timestamp)_\(random)"
    }
    
    /// Validates an identifier string.
    private func isValidIdentifier(_ identifier: String) -> Bool {
        let pattern = "^[a-zA-Z0-9_]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: identifier.utf16.count)
        return regex?.firstMatch(in: identifier, options: [], range: range) != nil
    }
    
    /// Gets MIME type for a file URL.
    private func getMimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension.lowercased()
        
        switch pathExtension {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "mp4":
            return "video/mp4"
        case "mp3":
            return "audio/mpeg"
        default:
            return "application/octet-stream"
        }
    }
}

// MARK: - Extensions

@available(iOS 15.0, *)
extension CGRect {
    
    /// Returns the dictionary representation of the rectangle.
    var dictionaryRepresentation: [String: Any] {
        return [
            "X": origin.x,
            "Y": origin.y,
            "Width": size.width,
            "Height": size.height
        ]
    }
} 