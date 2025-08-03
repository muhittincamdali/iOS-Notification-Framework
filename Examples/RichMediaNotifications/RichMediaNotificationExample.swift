import Foundation
import NotificationFramework
import UserNotifications

/// Rich media notification examples demonstrating various media types
class RichMediaNotificationExample {
    
    private let notificationManager = NotificationManager.shared
    
    /// Demonstrates image notifications
    func demonstrateImageNotifications() async throws {
        let imageNotifications = [
            RichNotificationContent(
                title: "New Product",
                body: "Check out our latest product",
                mediaURL: "https://example.com/product1.jpg",
                mediaType: .image
            ),
            RichNotificationContent(
                title: "Photo Update",
                body: "New photo uploaded to your album",
                mediaURL: "https://example.com/photo1.jpg",
                mediaType: .image
            ),
            RichNotificationContent(
                title: "Profile Picture",
                body: "Your friend updated their profile picture",
                mediaURL: "https://example.com/profile.jpg",
                mediaType: .image
            )
        ]
        
        for (index, notification) in imageNotifications.enumerated() {
            let delay = TimeInterval(index + 1) * 10
            try await notificationManager.scheduleRichNotification(
                notification,
                at: Date().addingTimeInterval(delay)
            )
            print("Scheduled image notification \(index + 1)")
        }
    }
    
    /// Demonstrates video notifications
    func demonstrateVideoNotifications() async throws {
        let videoNotifications = [
            RichNotificationContent(
                title: "New Video",
                body: "Watch our latest tutorial",
                mediaURL: "https://example.com/tutorial.mp4",
                mediaType: .video
            ),
            RichNotificationContent(
                title: "Video Message",
                body: "You received a video message",
                mediaURL: "https://example.com/message.mp4",
                mediaType: .video
            )
        ]
        
        for (index, notification) in videoNotifications.enumerated() {
            let delay = TimeInterval(index + 1) * 15
            try await notificationManager.scheduleRichNotification(
                notification,
                at: Date().addingTimeInterval(delay)
            )
            print("Scheduled video notification \(index + 1)")
        }
    }
    
    /// Demonstrates audio notifications
    func demonstrateAudioNotifications() async throws {
        let audioNotifications = [
            RichNotificationContent(
                title: "Voice Message",
                body: "You have a new voice message",
                mediaURL: "https://example.com/voice.m4a",
                mediaType: .audio
            ),
            RichNotificationContent(
                title: "Podcast Episode",
                body: "New episode available",
                mediaURL: "https://example.com/podcast.m4a",
                mediaType: .audio
            )
        ]
        
        for (index, notification) in audioNotifications.enumerated() {
            let delay = TimeInterval(index + 1) * 20
            try await notificationManager.scheduleRichNotification(
                notification,
                at: Date().addingTimeInterval(delay)
            )
            print("Scheduled audio notification \(index + 1)")
        }
    }
    
    /// Demonstrates GIF notifications
    func demonstrateGIFNotifications() async throws {
        let gifNotifications = [
            RichNotificationContent(
                title: "Animated Content",
                body: "Check out this animated GIF",
                mediaURL: "https://example.com/animation.gif",
                mediaType: .gif
            ),
            RichNotificationContent(
                title: "Celebration",
                body: "Congratulations! Here's a celebration GIF",
                mediaURL: "https://example.com/celebration.gif",
                mediaType: .gif
            )
        ]
        
        for (index, notification) in gifNotifications.enumerated() {
            let delay = TimeInterval(index + 1) * 25
            try await notificationManager.scheduleRichNotification(
                notification,
                at: Date().addingTimeInterval(delay)
            )
            print("Scheduled GIF notification \(index + 1)")
        }
    }
    
    /// Demonstrates rich notifications with actions
    func demonstrateRichNotificationsWithActions() async throws {
        let richNotificationWithActions = RichNotificationContent(
            title: "Interactive Product",
            body: "Check out this interactive product",
            mediaURL: "https://example.com/interactive.jpg",
            mediaType: .image,
            actions: [
                NotificationAction(
                    title: "View Details",
                    identifier: "view_details",
                    options: [.foreground]
                ),
                NotificationAction(
                    title: "Add to Cart",
                    identifier: "add_to_cart",
                    options: [.authenticationRequired]
                ),
                NotificationAction(
                    title: "Share",
                    identifier: "share",
                    options: [.destructive]
                )
            ]
        )
        
        try await notificationManager.scheduleRichNotification(
            richNotificationWithActions,
            at: Date().addingTimeInterval(30)
        )
        
        print("Scheduled rich notification with actions")
    }
    
    /// Demonstrates media validation
    func demonstrateMediaValidation() async throws {
        let validURLs = [
            "https://example.com/valid1.jpg",
            "https://example.com/valid2.png",
            "https://example.com/valid3.gif"
        ]
        
        let invalidURLs = [
            "https://example.com/invalid1.txt",
            "https://example.com/invalid2.pdf",
            "invalid-url"
        ]
        
        // Test valid URLs
        for (index, url) in validURLs.enumerated() {
            let notification = RichNotificationContent(
                title: "Valid Media \(index + 1)",
                body: "Testing valid media URL",
                mediaURL: url,
                mediaType: .image
            )
            
            do {
                try await notificationManager.scheduleRichNotification(
                    notification,
                    at: Date().addingTimeInterval(TimeInterval(index + 1) * 5)
                )
                print("Successfully scheduled notification with valid URL: \(url)")
            } catch {
                print("Failed to schedule notification with valid URL: \(url) - \(error)")
            }
        }
        
        // Test invalid URLs
        for (index, url) in invalidURLs.enumerated() {
            let notification = RichNotificationContent(
                title: "Invalid Media \(index + 1)",
                body: "Testing invalid media URL",
                mediaURL: url,
                mediaType: .image
            )
            
            do {
                try await notificationManager.scheduleRichNotification(
                    notification,
                    at: Date().addingTimeInterval(TimeInterval(index + 1) * 5)
                )
                print("Unexpectedly scheduled notification with invalid URL: \(url)")
            } catch {
                print("Correctly failed to schedule notification with invalid URL: \(url) - \(error)")
            }
        }
    }
    
    /// Demonstrates media type detection
    func demonstrateMediaTypeDetection() async throws {
        let mediaURLs = [
            ("https://example.com/image.jpg", MediaType.image),
            ("https://example.com/video.mp4", MediaType.video),
            ("https://example.com/audio.m4a", MediaType.audio),
            ("https://example.com/animation.gif", MediaType.gif)
        ]
        
        for (url, expectedType) in mediaURLs {
            let detectedType = detectMediaType(from: url)
            let notification = RichNotificationContent(
                title: "Media Type Test",
                body: "Testing media type detection",
                mediaURL: url,
                mediaType: detectedType
            )
            
            try await notificationManager.scheduleRichNotification(
                notification,
                at: Date().addingTimeInterval(5)
            )
            
            print("Detected media type: \(detectedType.rawValue) for URL: \(url)")
        }
    }
    
    // MARK: - Helper Methods
    
    private func detectMediaType(from url: String) -> MediaType {
        let lowercasedURL = url.lowercased()
        
        if lowercasedURL.hasSuffix(".jpg") || lowercasedURL.hasSuffix(".jpeg") || lowercasedURL.hasSuffix(".png") {
            return .image
        } else if lowercasedURL.hasSuffix(".mp4") || lowercasedURL.hasSuffix(".mov") || lowercasedURL.hasSuffix(".avi") {
            return .video
        } else if lowercasedURL.hasSuffix(".m4a") || lowercasedURL.hasSuffix(".mp3") || lowercasedURL.hasSuffix(".wav") {
            return .audio
        } else if lowercasedURL.hasSuffix(".gif") {
            return .gif
        } else {
            return .image // Default to image
        }
    }
}

// MARK: - Usage Example

@main
struct RichMediaNotificationExampleApp {
    static func main() async throws {
        let example = RichMediaNotificationExample()
        
        print("Starting rich media notification examples...")
        
        // Request permissions first
        let granted = try await NotificationManager.shared.requestPermissions()
        guard granted else {
            print("Notification permissions not granted")
            return
        }
        
        // Demonstrate various rich media notifications
        try await example.demonstrateImageNotifications()
        try await example.demonstrateVideoNotifications()
        try await example.demonstrateAudioNotifications()
        try await example.demonstrateGIFNotifications()
        try await example.demonstrateRichNotificationsWithActions()
        try await example.demonstrateMediaValidation()
        try await example.demonstrateMediaTypeDetection()
        
        print("Rich media notification examples completed successfully!")
    }
} 