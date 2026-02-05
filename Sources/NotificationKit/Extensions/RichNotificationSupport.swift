//
//  RichNotificationSupport.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications
#if canImport(UIKit)
import UIKit
#endif

/// Rich notification support utilities
public enum RichNotificationSupport {
    
    // MARK: - Attachment Download
    
    /// Downloads a media attachment from URL
    /// - Parameters:
    ///   - url: The media URL
    ///   - type: Optional file type hint
    /// - Returns: Local file URL
    public static func downloadAttachment(
        from url: URL,
        type: AttachmentFileType? = nil
    ) async throws -> URL {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Determine file extension
        let fileExtension: String
        if let type = type {
            fileExtension = type.fileExtension
        } else if let mimeType = (response as? HTTPURLResponse)?.mimeType {
            fileExtension = AttachmentFileType.fromMimeType(mimeType).fileExtension
        } else {
            fileExtension = url.pathExtension
        }
        
        // Save to temp directory
        let tempDir = FileManager.default.temporaryDirectory
        let filename = UUID().uuidString + "." + fileExtension
        let localURL = tempDir.appendingPathComponent(filename)
        
        try data.write(to: localURL)
        
        return localURL
    }
    
    /// Downloads multiple attachments concurrently
    public static func downloadAttachments(
        from urls: [URL]
    ) async throws -> [URL] {
        try await withThrowingTaskGroup(of: URL.self) { group in
            for url in urls {
                group.addTask {
                    try await downloadAttachment(from: url)
                }
            }
            
            var results: [URL] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
    }
    
    // MARK: - Image Processing
    
    #if canImport(UIKit)
    /// Resizes an image for notification attachment
    public static func resizeImage(
        _ image: UIImage,
        maxWidth: CGFloat = 1024,
        maxHeight: CGFloat = 1024
    ) -> UIImage? {
        let size = image.size
        
        var newWidth = size.width
        var newHeight = size.height
        
        if size.width > maxWidth {
            newWidth = maxWidth
            newHeight = size.height * (maxWidth / size.width)
        }
        
        if newHeight > maxHeight {
            newHeight = maxHeight
            newWidth = newWidth * (maxHeight / newHeight)
        }
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized
    }
    
    /// Saves image to temporary file for attachment
    public static func saveImageForAttachment(
        _ image: UIImage,
        format: ImageFormat = .jpeg,
        quality: CGFloat = 0.8
    ) throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let filename = UUID().uuidString + "." + format.fileExtension
        let url = tempDir.appendingPathComponent(filename)
        
        let data: Data?
        switch format {
        case .jpeg:
            data = image.jpegData(compressionQuality: quality)
        case .png:
            data = image.pngData()
        }
        
        guard let imageData = data else {
            throw RichNotificationError.imageConversionFailed
        }
        
        try imageData.write(to: url)
        return url
    }
    #endif
    
    // MARK: - Video Thumbnail
    
    /// Extracts thumbnail from video URL
    @available(iOS 14.0, *)
    public static func extractVideoThumbnail(
        from videoURL: URL,
        at time: TimeInterval = 0
    ) async throws -> URL {
        // Use AVAssetImageGenerator in real implementation
        // This is a placeholder that would need AVFoundation
        throw RichNotificationError.videoProcessingNotSupported
    }
    
    // MARK: - Validation
    
    /// Validates an attachment URL
    public static func validateAttachment(_ url: URL) -> AttachmentValidation {
        // Check file exists
        if url.isFileURL {
            guard FileManager.default.fileExists(atPath: url.path) else {
                return .invalid(reason: "File does not exist")
            }
        }
        
        // Check file type
        let ext = url.pathExtension.lowercased()
        let supportedExtensions = ["jpg", "jpeg", "png", "gif", "mp4", "mov", "mp3", "wav", "aiff"]
        
        guard supportedExtensions.contains(ext) else {
            return .invalid(reason: "Unsupported file type: \(ext)")
        }
        
        // Check file size (5MB limit for notifications)
        if url.isFileURL {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
                let size = attributes[.size] as? Int64 ?? 0
                if size > 5 * 1024 * 1024 {
                    return .warning(reason: "File size exceeds 5MB, may be rejected")
                }
            } catch {
                return .warning(reason: "Could not check file size")
            }
        }
        
        return .valid
    }
}

// MARK: - Attachment File Type

/// Supported attachment file types
public enum AttachmentFileType: String, Sendable {
    case jpeg
    case png
    case gif
    case mp4
    case mov
    case mp3
    case wav
    case aiff
    
    public var fileExtension: String {
        rawValue
    }
    
    public var mimeType: String {
        switch self {
        case .jpeg: return "image/jpeg"
        case .png: return "image/png"
        case .gif: return "image/gif"
        case .mp4: return "video/mp4"
        case .mov: return "video/quicktime"
        case .mp3: return "audio/mpeg"
        case .wav: return "audio/wav"
        case .aiff: return "audio/aiff"
        }
    }
    
    public static func fromMimeType(_ mimeType: String) -> AttachmentFileType {
        switch mimeType.lowercased() {
        case "image/jpeg": return .jpeg
        case "image/png": return .png
        case "image/gif": return .gif
        case "video/mp4": return .mp4
        case "video/quicktime": return .mov
        case "audio/mpeg": return .mp3
        case "audio/wav": return .wav
        case "audio/aiff": return .aiff
        default: return .jpeg
        }
    }
}

// MARK: - Image Format

/// Image format for saving
public enum ImageFormat: String {
    case jpeg
    case png
    
    public var fileExtension: String { rawValue }
}

// MARK: - Attachment Validation

/// Result of attachment validation
public enum AttachmentValidation {
    case valid
    case warning(reason: String)
    case invalid(reason: String)
    
    public var isValid: Bool {
        switch self {
        case .valid, .warning: return true
        case .invalid: return false
        }
    }
}

// MARK: - Rich Notification Error

/// Errors for rich notification operations
public enum RichNotificationError: Error, LocalizedError {
    case downloadFailed(URL)
    case imageConversionFailed
    case videoProcessingNotSupported
    case attachmentTooLarge
    case unsupportedFormat(String)
    
    public var errorDescription: String? {
        switch self {
        case .downloadFailed(let url):
            return "Failed to download attachment from \(url)"
        case .imageConversionFailed:
            return "Failed to convert image for attachment"
        case .videoProcessingNotSupported:
            return "Video processing is not supported"
        case .attachmentTooLarge:
            return "Attachment exceeds maximum size"
        case .unsupportedFormat(let format):
            return "Unsupported attachment format: \(format)"
        }
    }
}

// MARK: - Notification Service Extension Helper

/// Helper for implementing Notification Service Extension
public protocol NotificationServiceHandler: AnyObject {
    /// Process notification content before display
    func process(
        content: UNMutableNotificationContent
    ) async throws -> UNMutableNotificationContent
}

/// Base implementation for service extension
open class BaseNotificationServiceHandler: NotificationServiceHandler {
    
    public init() {}
    
    /// Override to customize processing
    open func process(
        content: UNMutableNotificationContent
    ) async throws -> UNMutableNotificationContent {
        
        // Download media attachment if URL provided
        if let mediaURLString = content.userInfo["media_url"] as? String,
           let mediaURL = URL(string: mediaURLString) {
            
            let localURL = try await RichNotificationSupport.downloadAttachment(from: mediaURL)
            let attachment = try UNNotificationAttachment(
                identifier: "media",
                url: localURL,
                options: nil
            )
            content.attachments = [attachment]
        }
        
        return content
    }
}

// MARK: - Notification Content Extension Helper

/// Helper for implementing Notification Content Extension
public protocol NotificationContentHandler: AnyObject {
    /// Configure view for notification
    func configure(for notification: UNNotification)
    
    /// Handle action
    func handleAction(_ action: String, completion: @escaping () -> Void)
}
