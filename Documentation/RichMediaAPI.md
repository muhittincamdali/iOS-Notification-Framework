# Rich Media API

<!-- TOC START -->
## Table of Contents
- [Rich Media API](#rich-media-api)
- [Overview](#overview)
- [Core Classes](#core-classes)
  - [RichNotificationContent](#richnotificationcontent)
  - [MediaType Enum](#mediatype-enum)
  - [ImageCompression Enum](#imagecompression-enum)
  - [VideoQuality Enum](#videoquality-enum)
  - [AudioFormat Enum](#audioformat-enum)
- [Image Notifications](#image-notifications)
  - [Basic Image Notification](#basic-image-notification)
  - [Advanced Image Configuration](#advanced-image-configuration)
- [Video Notifications](#video-notifications)
  - [Basic Video Notification](#basic-video-notification)
  - [Advanced Video Configuration](#advanced-video-configuration)
- [Audio Notifications](#audio-notifications)
  - [Basic Audio Notification](#basic-audio-notification)
  - [Advanced Audio Configuration](#advanced-audio-configuration)
- [Media Management](#media-management)
  - [Media Download and Caching](#media-download-and-caching)
  - [Media Validation](#media-validation)
  - [Media Compression](#media-compression)
- [Error Handling](#error-handling)
  - [Rich Media Errors](#rich-media-errors)
  - [Error Handling Example](#error-handling-example)
- [Best Practices](#best-practices)
  - [Performance Optimization](#performance-optimization)
  - [User Experience](#user-experience)
  - [Security Considerations](#security-considerations)
- [Integration Examples](#integration-examples)
  - [With Analytics](#with-analytics)
  - [With Customization](#with-customization)
<!-- TOC END -->


## Overview

The Rich Media API provides comprehensive support for displaying images, videos, and audio content in iOS notifications, enabling rich and engaging user experiences.

## Core Classes

### RichNotificationContent

```swift
public class RichNotificationContent: NotificationContent {
    // MARK: - Properties
    public var mediaType: MediaType
    public var mediaURL: URL?
    public var thumbnailURL: URL?
    public var mediaData: Data?
    public var mediaSize: CGSize?
    public var mediaDuration: TimeInterval?
    
    // MARK: - Media Configuration
    public var imageCompression: ImageCompression
    public var videoQuality: VideoQuality
    public var audioFormat: AudioFormat
    public var cachePolicy: CachePolicy
    public var progressiveLoading: Bool
    
    // MARK: - Initialization
    public init(
        title: String,
        body: String,
        mediaType: MediaType,
        mediaURL: URL? = nil,
        thumbnailURL: URL? = nil
    )
}
```

### MediaType Enum

```swift
public enum MediaType {
    case image
    case video
    case audio
    case gif
    case custom(String)
}
```

### ImageCompression Enum

```swift
public enum ImageCompression {
    case none
    case low
    case medium
    case high
    case custom(quality: Float)
}
```

### VideoQuality Enum

```swift
public enum VideoQuality {
    case low
    case medium
    case high
    case ultra
    case custom(bitrate: Int)
}
```

### AudioFormat Enum

```swift
public enum AudioFormat {
    case mp3
    case aac
    case wav
    case m4a
    case custom(format: String)
}
```

## Image Notifications

### Basic Image Notification

```swift
// Create image notification
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

// Schedule image notification
try notificationManager.schedule(
    imageNotification,
    at: Date().addingTimeInterval(60)
)
```

### Advanced Image Configuration

```swift
// Create advanced image notification
let advancedImageNotification = RichNotificationContent(
    title: "High-Quality Image",
    body: "Beautiful high-resolution image",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/high-res.jpg")
)

// Configure advanced settings
advancedImageNotification.imageCompression = .custom(quality: 0.9)
advancedImageNotification.mediaSize = CGSize(width: 800, height: 600)
advancedImageNotification.cachePolicy = .memoryAndDisk
advancedImageNotification.progressiveLoading = true

// Add custom metadata
advancedImageNotification.userInfo["image_format"] = "JPEG"
advancedImageNotification.userInfo["image_quality"] = "High"
```

## Video Notifications

### Basic Video Notification

```swift
// Create video notification
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

// Schedule video notification
try notificationManager.schedule(
    videoNotification,
    at: Date().addingTimeInterval(120)
)
```

### Advanced Video Configuration

```swift
// Create advanced video notification
let advancedVideoNotification = RichNotificationContent(
    title: "High-Quality Video",
    body: "Ultra HD video content",
    mediaType: .video,
    mediaURL: URL(string: "https://example.com/ultra-hd.mp4")
)

// Configure advanced video settings
advancedVideoNotification.videoQuality = .ultra
advancedVideoNotification.autoPlay = true
advancedVideoNotification.controlsEnabled = true
advancedVideoNotification.mediaDuration = 60.0
advancedVideoNotification.mediaSize = CGSize(width: 1920, height: 1080)

// Add custom video metadata
advancedVideoNotification.userInfo["video_codec"] = "H.264"
advancedVideoNotification.userInfo["video_bitrate"] = "5000"
```

## Audio Notifications

### Basic Audio Notification

```swift
// Create audio notification
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

// Schedule audio notification
try notificationManager.schedule(
    audioNotification,
    at: Date().addingTimeInterval(30)
)
```

### Advanced Audio Configuration

```swift
// Create advanced audio notification
let advancedAudioNotification = RichNotificationContent(
    title: "High-Quality Audio",
    body: "Lossless audio content",
    mediaType: .audio,
    mediaURL: URL(string: "https://example.com/lossless.m4a")
)

// Configure advanced audio settings
advancedAudioNotification.audioFormat = .m4a
advancedAudioNotification.autoPlay = true
advancedAudioNotification.volume = 1.0
advancedAudioNotification.mediaDuration = 120.0

// Add custom audio metadata
advancedAudioNotification.userInfo["audio_codec"] = "AAC"
advancedAudioNotification.userInfo["audio_bitrate"] = "320"
```

## Media Management

### Media Download and Caching

```swift
// Configure media download settings
let mediaSettings = RichMediaSettings()
mediaSettings.downloadTimeout = 30.0
mediaSettings.maxFileSize = 50 * 1024 * 1024 // 50MB
mediaSettings.retryAttempts = 3
mediaSettings.cacheExpiration = 24 * 60 * 60 // 24 hours

// Apply settings
notificationManager.configureRichMedia(mediaSettings)
```

### Media Validation

```swift
// Validate media before scheduling
func validateMedia(_ notification: RichNotificationContent) -> Bool {
    guard let mediaURL = notification.mediaURL else {
        return false
    }
    
    // Check file size
    if let fileSize = getFileSize(from: mediaURL),
       fileSize > 50 * 1024 * 1024 { // 50MB limit
        return false
    }
    
    // Check supported formats
    let supportedFormats = ["jpg", "jpeg", "png", "gif", "mp4", "mov", "mp3", "m4a"]
    let fileExtension = mediaURL.pathExtension.lowercased()
    
    return supportedFormats.contains(fileExtension)
}
```

### Media Compression

```swift
// Compress media for optimal delivery
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
    let compressedData = UIImage(data: imageData)?.jpegData(compressionQuality: compressionQuality)
    
    notification.mediaData = compressedData
}
```

## Error Handling

### Rich Media Errors

```swift
public enum RichMediaError: Error {
    case invalidMediaURL
    case unsupportedMediaType
    case downloadFailed
    case compressionFailed
    case fileTooLarge
    case invalidFormat
    case networkTimeout
    case cacheError
}
```

### Error Handling Example

```swift
do {
    try notificationManager.schedule(richNotification, at: Date())
} catch RichMediaError.invalidMediaURL {
    print("❌ Invalid media URL provided")
} catch RichMediaError.unsupportedMediaType {
    print("❌ Unsupported media type")
} catch RichMediaError.downloadFailed {
    print("❌ Failed to download media")
} catch RichMediaError.fileTooLarge {
    print("❌ Media file too large")
} catch {
    print("❌ Unknown rich media error: \(error)")
}
```

## Best Practices

### Performance Optimization

1. **Use appropriate compression** for different media types
2. **Implement progressive loading** for large files
3. **Cache media content** for offline access
4. **Validate file sizes** before scheduling
5. **Use CDN URLs** for faster delivery

### User Experience

1. **Provide thumbnails** for video content
2. **Set appropriate auto-play** settings
3. **Include fallback content** for failed media
4. **Consider bandwidth** limitations
5. **Test on different devices** and networks

### Security Considerations

1. **Validate media URLs** before downloading
2. **Sanitize file extensions** and content
3. **Implement proper error handling** for malicious content
4. **Use HTTPS URLs** for all media content
5. **Limit file sizes** to prevent abuse

## Integration Examples

### With Analytics

```swift
// Track media engagement
func trackMediaEngagement(_ notification: RichNotificationContent) {
    analyticsManager.trackEvent("media_notification_viewed", properties: [
        "media_type": notification.mediaType.rawValue,
        "media_url": notification.mediaURL?.absoluteString ?? "",
        "notification_id": notification.identifier
    ])
}
```

### With Customization

```swift
// Apply custom styling to media notifications
func applyCustomStyling(_ notification: RichNotificationContent) {
    notification.theme.cornerRadius = 12
    notification.theme.shadowEnabled = true
    notification.theme.borderWidth = 1
    notification.theme.borderColor = UIColor.systemBlue
}
```
