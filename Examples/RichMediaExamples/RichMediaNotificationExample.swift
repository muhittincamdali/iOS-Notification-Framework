import Foundation
import UserNotifications
import NotificationFramework
import UIKit

// MARK: - Rich Media Notification Examples
// This file demonstrates how to create and schedule rich media notifications
// with images, videos, and audio content.

class RichMediaNotificationExample {
    
    // MARK: - Properties
    private let notificationManager = NotificationManager.shared
    
    // MARK: - Initialization
    init() {
        setupRichMediaManager()
    }
    
    // MARK: - Setup
    private func setupRichMediaManager() {
        // Configure rich media settings
        let richMediaSettings = RichMediaSettings()
        richMediaSettings.downloadTimeout = 30.0
        richMediaSettings.maxFileSize = 50 * 1024 * 1024 // 50MB
        richMediaSettings.retryAttempts = 3
        richMediaSettings.cacheExpiration = 24 * 60 * 60 // 24 hours
        
        // Apply settings
        notificationManager.configureRichMedia(richMediaSettings)
        
        // Request permissions
        notificationManager.requestPermissions { [weak self] granted in
            if granted {
                print("✅ Rich media notification permissions granted")
                self?.registerRichMediaCategories()
            } else {
                print("❌ Rich media notification permissions denied")
            }
        }
    }
    
    // MARK: - Notification Categories
    private func registerRichMediaCategories() {
        // Create rich media notification actions
        let viewAction = UNNotificationAction(
            identifier: "VIEW_MEDIA_ACTION",
            title: "View",
            options: [.foreground]
        )
        
        let shareAction = UNNotificationAction(
            identifier: "SHARE_MEDIA_ACTION",
            title: "Share",
            options: [.foreground]
        )
        
        let saveAction = UNNotificationAction(
            identifier: "SAVE_MEDIA_ACTION",
            title: "Save",
            options: [.foreground]
        )
        
        // Create rich media category
        let richMediaCategory = UNNotificationCategory(
            identifier: "RICH_MEDIA_CATEGORY",
            actions: [viewAction, shareAction, saveAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        // Register category
        UNUserNotificationCenter.current().setNotificationCategories([richMediaCategory])
    }
    
    // MARK: - Image Notification Examples
    
    /// Example 1: Basic image notification
    func createBasicImageNotification() {
        let imageNotification = RichNotificationContent(
            title: "New Product Available",
            body: "Check out our latest collection",
            mediaType: .image,
            mediaURL: URL(string: "https://example.com/product.jpg")
        )
        
        // Configure image settings
        imageNotification.imageCompression = .high
        imageNotification.cachePolicy = .memoryAndDisk
        imageNotification.progressiveLoading = true
        
        do {
            try notificationManager.schedule(
                imageNotification,
                at: Date().addingTimeInterval(5)
            )
            print("✅ Basic image notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule basic image notification: \(error)")
        }
    }
    
    /// Example 2: High-quality image notification
    func createHighQualityImageNotification() {
        let highQualityImageNotification = RichNotificationContent(
            title: "High-Quality Image",
            body: "Beautiful high-resolution image",
            mediaType: .image,
            mediaURL: URL(string: "https://example.com/high-res.jpg")
        )
        
        // Configure high-quality settings
        highQualityImageNotification.imageCompression = .custom(quality: 0.9)
        highQualityImageNotification.mediaSize = CGSize(width: 800, height: 600)
        highQualityImageNotification.cachePolicy = .memoryAndDisk
        highQualityImageNotification.progressiveLoading = true
        
        // Add custom metadata
        highQualityImageNotification.userInfo["image_format"] = "JPEG"
        highQualityImageNotification.userInfo["image_quality"] = "High"
        highQualityImageNotification.userInfo["image_resolution"] = "800x600"
        
        do {
            try notificationManager.schedule(
                highQualityImageNotification,
                at: Date().addingTimeInterval(10)
            )
            print("✅ High-quality image notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule high-quality image notification: \(error)")
        }
    }
    
    /// Example 3: GIF image notification
    func createGIFImageNotification() {
        let gifNotification = RichNotificationContent(
            title: "Animated GIF",
            body: "Check out this animated content",
            mediaType: .gif,
            mediaURL: URL(string: "https://example.com/animation.gif")
        )
        
        // Configure GIF settings
        gifNotification.cachePolicy = .memoryAndDisk
        gifNotification.progressiveLoading = true
        gifNotification.mediaSize = CGSize(width: 400, height: 300)
        
        do {
            try notificationManager.schedule(
                gifNotification,
                at: Date().addingTimeInterval(15)
            )
            print("✅ GIF image notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule GIF image notification: \(error)")
        }
    }
    
    // MARK: - Video Notification Examples
    
    /// Example 4: Basic video notification
    func createBasicVideoNotification() {
        let videoNotification = RichNotificationContent(
            title: "Product Demo",
            body: "Watch how to use our new feature",
            mediaType: .video,
            mediaURL: URL(string: "https://example.com/demo.mp4"),
            thumbnailURL: URL(string: "https://example.com/thumbnail.jpg")
        )
        
        // Configure video settings
        videoNotification.videoQuality = .medium
        videoNotification.autoPlay = false
        videoNotification.controlsEnabled = true
        videoNotification.mediaDuration = 30.0
        
        do {
            try notificationManager.schedule(
                videoNotification,
                at: Date().addingTimeInterval(20)
            )
            print("✅ Basic video notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule basic video notification: \(error)")
        }
    }
    
    /// Example 5: High-quality video notification
    func createHighQualityVideoNotification() {
        let highQualityVideoNotification = RichNotificationContent(
            title: "Ultra HD Video",
            body: "Experience ultra high-definition content",
            mediaType: .video,
            mediaURL: URL(string: "https://example.com/ultra-hd.mp4"),
            thumbnailURL: URL(string: "https://example.com/hd-thumbnail.jpg")
        )
        
        // Configure high-quality video settings
        highQualityVideoNotification.videoQuality = .ultra
        highQualityVideoNotification.autoPlay = true
        highQualityVideoNotification.controlsEnabled = true
        highQualityVideoNotification.mediaDuration = 60.0
        highQualityVideoNotification.mediaSize = CGSize(width: 1920, height: 1080)
        
        // Add custom video metadata
        highQualityVideoNotification.userInfo["video_codec"] = "H.264"
        highQualityVideoNotification.userInfo["video_bitrate"] = "5000"
        highQualityVideoNotification.userInfo["video_resolution"] = "1920x1080"
        
        do {
            try notificationManager.schedule(
                highQualityVideoNotification,
                at: Date().addingTimeInterval(25)
            )
            print("✅ High-quality video notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule high-quality video notification: \(error)")
        }
    }
    
    /// Example 6: Short video notification
    func createShortVideoNotification() {
        let shortVideoNotification = RichNotificationContent(
            title: "Quick Tip",
            body: "Learn something new in 10 seconds",
            mediaType: .video,
            mediaURL: URL(string: "https://example.com/quick-tip.mp4")
        )
        
        // Configure short video settings
        shortVideoNotification.videoQuality = .low
        shortVideoNotification.autoPlay = true
        shortVideoNotification.controlsEnabled = false
        shortVideoNotification.mediaDuration = 10.0
        
        do {
            try notificationManager.schedule(
                shortVideoNotification,
                at: Date().addingTimeInterval(30)
            )
            print("✅ Short video notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule short video notification: \(error)")
        }
    }
    
    // MARK: - Audio Notification Examples
    
    /// Example 7: Basic audio notification
    func createBasicAudioNotification() {
        let audioNotification = RichNotificationContent(
            title: "Voice Message",
            body: "You have a new voice message",
            mediaType: .audio,
            mediaURL: URL(string: "https://example.com/message.mp3")
        )
        
        // Configure audio settings
        audioNotification.audioFormat = .mp3
        audioNotification.autoPlay = true
        audioNotification.volume = 0.8
        audioNotification.mediaDuration = 45.0
        
        do {
            try notificationManager.schedule(
                audioNotification,
                at: Date().addingTimeInterval(35)
            )
            print("✅ Basic audio notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule basic audio notification: \(error)")
        }
    }
    
    /// Example 8: High-quality audio notification
    func createHighQualityAudioNotification() {
        let highQualityAudioNotification = RichNotificationContent(
            title: "Lossless Audio",
            body: "Experience crystal clear sound quality",
            mediaType: .audio,
            mediaURL: URL(string: "https://example.com/lossless.m4a")
        )
        
        // Configure high-quality audio settings
        highQualityAudioNotification.audioFormat = .m4a
        highQualityAudioNotification.autoPlay = true
        highQualityAudioNotification.volume = 1.0
        highQualityAudioNotification.mediaDuration = 120.0
        
        // Add custom audio metadata
        highQualityAudioNotification.userInfo["audio_codec"] = "AAC"
        highQualityAudioNotification.userInfo["audio_bitrate"] = "320"
        highQualityAudioNotification.userInfo["audio_quality"] = "Lossless"
        
        do {
            try notificationManager.schedule(
                highQualityAudioNotification,
                at: Date().addingTimeInterval(40)
            )
            print("✅ High-quality audio notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule high-quality audio notification: \(error)")
        }
    }
    
    /// Example 9: Podcast audio notification
    func createPodcastAudioNotification() {
        let podcastNotification = RichNotificationContent(
            title: "New Podcast Episode",
            body: "Listen to our latest episode",
            mediaType: .audio,
            mediaURL: URL(string: "https://example.com/podcast.mp3")
        )
        
        // Configure podcast settings
        podcastNotification.audioFormat = .mp3
        podcastNotification.autoPlay = false
        podcastNotification.volume = 0.7
        podcastNotification.mediaDuration = 1800.0 // 30 minutes
        
        // Add podcast metadata
        podcastNotification.userInfo["podcast_title"] = "Tech Talk"
        podcastNotification.userInfo["episode_number"] = "42"
        podcastNotification.userInfo["duration"] = "30:00"
        
        do {
            try notificationManager.schedule(
                podcastNotification,
                at: Date().addingTimeInterval(45)
            )
            print("✅ Podcast audio notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule podcast audio notification: \(error)")
        }
    }
    
    // MARK: - Custom Media Examples
    
    /// Example 10: Custom media type notification
    func createCustomMediaNotification() {
        let customMediaNotification = RichNotificationContent(
            title: "Custom Media",
            body: "This is a custom media type",
            mediaType: .custom("pdf"),
            mediaURL: URL(string: "https://example.com/document.pdf")
        )
        
        // Configure custom media settings
        customMediaNotification.cachePolicy = .memoryAndDisk
        customMediaNotification.progressiveLoading = true
        
        // Add custom metadata
        customMediaNotification.userInfo["media_type"] = "PDF"
        customMediaNotification.userInfo["file_size"] = "2.5MB"
        customMediaNotification.userInfo["pages"] = "10"
        
        do {
            try notificationManager.schedule(
                customMediaNotification,
                at: Date().addingTimeInterval(50)
            )
            print("✅ Custom media notification scheduled successfully")
        } catch {
            print("❌ Failed to schedule custom media notification: \(error)")
        }
    }
    
    // MARK: - Media Management
    
    /// Validate media before scheduling
    func validateMedia(_ notification: RichNotificationContent) -> Bool {
        guard let mediaURL = notification.mediaURL else {
            print("❌ Media URL is required")
            return false
        }
        
        // Check file size limit
        if let fileSize = getFileSize(from: mediaURL),
           fileSize > 50 * 1024 * 1024 { // 50MB limit
            print("❌ Media file too large (max 50MB)")
            return false
        }
        
        // Check supported formats
        let supportedFormats = ["jpg", "jpeg", "png", "gif", "mp4", "mov", "mp3", "m4a", "wav"]
        let fileExtension = mediaURL.pathExtension.lowercased()
        
        guard supportedFormats.contains(fileExtension) else {
            print("❌ Unsupported media format: \(fileExtension)")
            return false
        }
        
        return true
    }
    
    /// Get file size from URL
    private func getFileSize(from url: URL) -> Int64? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int64
        } catch {
            return nil
        }
    }
    
    /// Compress media for optimal delivery
    func compressMedia(_ notification: RichNotificationContent) {
        switch notification.mediaType {
        case .image:
            compressImage(notification)
        case .video:
            compressVideo(notification)
        case .audio:
            compressAudio(notification)
        default:
            break
        }
    }
    
    private func compressImage(_ notification: RichNotificationContent) {
        guard let imageData = notification.mediaData else { return }
        
        let compressionQuality: CGFloat = 0.8
        if let image = UIImage(data: imageData),
           let compressedData = image.jpegData(compressionQuality: compressionQuality) {
            notification.mediaData = compressedData
            print("✅ Image compressed successfully")
        }
    }
    
    private func compressVideo(_ notification: RichNotificationContent) {
        // Video compression would be implemented here
        print("📹 Video compression placeholder")
    }
    
    private func compressAudio(_ notification: RichNotificationContent) {
        // Audio compression would be implemented here
        print("🎵 Audio compression placeholder")
    }
    
    // MARK: - Error Handling
    
    /// Handle rich media errors
    func handleRichMediaError(_ error: Error) {
        switch error {
        case RichMediaError.invalidMediaURL:
            print("❌ Invalid media URL provided")
        case RichMediaError.unsupportedMediaType:
            print("❌ Unsupported media type")
        case RichMediaError.downloadFailed:
            print("❌ Failed to download media")
        case RichMediaError.fileTooLarge:
            print("❌ Media file too large")
        case RichMediaError.invalidFormat:
            print("❌ Invalid media format")
        case RichMediaError.networkTimeout:
            print("❌ Network timeout while downloading media")
        case RichMediaError.cacheError:
            print("❌ Cache error occurred")
        default:
            print("❌ Unknown rich media error: \(error)")
        }
    }
    
    // MARK: - Analytics Integration
    
    /// Track media engagement
    func trackMediaEngagement(_ notification: RichNotificationContent) {
        let analyticsManager = NotificationAnalyticsManager()
        
        analyticsManager.trackEvent("media_notification_viewed", properties: [
            "media_type": notification.mediaType.rawValue,
            "media_url": notification.mediaURL?.absoluteString ?? "",
            "notification_id": notification.identifier,
            "media_size": notification.mediaSize?.description ?? "",
            "media_duration": notification.mediaDuration?.description ?? ""
        ])
        
        print("📊 Media engagement tracked")
    }
    
    // MARK: - Usage Example
    
    /// Run all rich media notification examples
    func runAllExamples() {
        print("🚀 Running Rich Media Notification Examples...")
        
        // Image notifications
        createBasicImageNotification()
        createHighQualityImageNotification()
        createGIFImageNotification()
        
        // Video notifications
        createBasicVideoNotification()
        createHighQualityVideoNotification()
        createShortVideoNotification()
        
        // Audio notifications
        createBasicAudioNotification()
        createHighQualityAudioNotification()
        createPodcastAudioNotification()
        
        // Custom media notifications
        createCustomMediaNotification()
        
        print("✅ All rich media notification examples completed")
    }
} 