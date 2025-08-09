# Rich Media Notifications Guide

<!-- TOC START -->
## Table of Contents
- [Rich Media Notifications Guide](#rich-media-notifications-guide)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Basic Setup](#basic-setup)
- [Image Notifications](#image-notifications)
  - [Basic Image Notification](#basic-image-notification)
  - [Image with Custom Settings](#image-with-custom-settings)
  - [Multiple Images](#multiple-images)
  - [Local Images](#local-images)
- [Video Notifications](#video-notifications)
  - [Basic Video Notification](#basic-video-notification)
  - [Video with Custom Settings](#video-with-custom-settings)
  - [Video with Subtitles](#video-with-subtitles)
- [Audio Notifications](#audio-notifications)
  - [Basic Audio Notification](#basic-audio-notification)
  - [Audio with Custom Settings](#audio-with-custom-settings)
  - [Audio with Waveform](#audio-with-waveform)
- [Custom Attachments](#custom-attachments)
  - [File Attachments](#file-attachments)
  - [Custom Data Attachments](#custom-data-attachments)
- [Progressive Loading](#progressive-loading)
  - [Progressive Image Loading](#progressive-image-loading)
  - [Lazy Loading](#lazy-loading)
- [Caching Strategies](#caching-strategies)
  - [Memory Caching](#memory-caching)
  - [Disk Caching](#disk-caching)
  - [Hybrid Caching](#hybrid-caching)
- [Performance Optimization](#performance-optimization)
  - [Image Optimization](#image-optimization)
  - [Video Optimization](#video-optimization)
  - [Network Optimization](#network-optimization)
- [Best Practices](#best-practices)
  - [1. Media Size Optimization](#1-media-size-optimization)
  - [2. Network Efficiency](#2-network-efficiency)
  - [3. User Experience](#3-user-experience)
  - [4. Error Handling](#4-error-handling)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
    - [1. Media Not Loading](#1-media-not-loading)
    - [2. Slow Loading](#2-slow-loading)
    - [3. Memory Issues](#3-memory-issues)
  - [Debug Mode](#debug-mode)
  - [Performance Monitoring](#performance-monitoring)
- [Advanced Features](#advanced-features)
  - [Custom Media Processors](#custom-media-processors)
  - [Machine Learning Integration](#machine-learning-integration)
<!-- TOC END -->


## Overview

The Rich Media Notifications module provides comprehensive support for images, videos, audio, and custom attachments in iOS notifications. This guide covers everything you need to know about implementing rich media notifications that engage users with visual and interactive content.

## Table of Contents

- [Getting Started](#getting-started)
- [Image Notifications](#image-notifications)
- [Video Notifications](#video-notifications)
- [Audio Notifications](#audio-notifications)
- [Custom Attachments](#custom-attachments)
- [Progressive Loading](#progressive-loading)
- [Caching Strategies](#caching-strategies)
- [Performance Optimization](#performance-optimization)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
- Notification permissions granted
- Network connectivity for remote media

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

// Enable rich media support
let config = NotificationConfiguration()
config.enableRichMedia = true
config.enableMediaCaching = true
config.enableProgressiveLoading = true

notificationManager.configure(config)
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

// Schedule image notification
try await notificationManager.schedule(
    imageNotification,
    at: Date().addingTimeInterval(60)
)
```

### Image with Custom Settings

```swift
// Create image notification with custom settings
let customImageNotification = RichNotificationContent(
    title: "Featured Product",
    body: "Limited time offer on this amazing product",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/featured.jpg")
)

// Configure image settings
customImageNotification.imageCompression = .high
customImageNotification.cachePolicy = .memoryAndDisk
customImageNotification.progressiveLoading = true
customImageNotification.maxImageSize = CGSize(width: 400, height: 300)
customImageNotification.imageFormat = .jpeg
customImageNotification.quality = 0.8

// Schedule with custom settings
try await notificationManager.schedule(
    customImageNotification,
    at: Date().addingTimeInterval(120)
)
```

### Multiple Images

```swift
// Create notification with multiple images
let multiImageNotification = RichNotificationContent(
    title: "Product Gallery",
    body: "Swipe to see all product images",
    mediaType: .image,
    mediaURLs: [
        URL(string: "https://example.com/image1.jpg")!,
        URL(string: "https://example.com/image2.jpg")!,
        URL(string: "https://example.com/image3.jpg")!
    ]
)

// Configure multi-image settings
multiImageNotification.enableImageSwipe = true
multiImageNotification.imageTransitionDuration = 0.3
multiImageNotification.showImageCounter = true

try await notificationManager.schedule(
    multiImageNotification,
    at: Date().addingTimeInterval(180)
)
```

### Local Images

```swift
// Create notification with local image
let localImageNotification = RichNotificationContent(
    title: "Local Image",
    body: "This image is stored locally",
    mediaType: .image,
    localMediaURL: Bundle.main.url(forResource: "local_image", withExtension: "jpg")
)

// Configure local image settings
localImageNotification.useLocalMedia = true
localImageNotification.localMediaName = "local_image.jpg"

try await notificationManager.schedule(
    localImageNotification,
    at: Date().addingTimeInterval(30)
)
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

// Schedule video notification
try await notificationManager.schedule(
    videoNotification,
    at: Date().addingTimeInterval(120)
)
```

### Video with Custom Settings

```swift
// Create video notification with custom settings
let customVideoNotification = RichNotificationContent(
    title: "Tutorial Video",
    body: "Learn how to use our app",
    mediaType: .video,
    mediaURL: URL(string: "https://example.com/tutorial.mp4"),
    thumbnailURL: URL(string: "https://example.com/tutorial_thumb.jpg")
)

// Configure video settings
customVideoNotification.videoQuality = .medium
customVideoNotification.autoPlay = false
customVideoNotification.controlsEnabled = true
customVideoNotification.loopVideo = false
customVideoNotification.maxVideoDuration = 30.0
customVideoNotification.videoFormat = .mp4
customVideoNotification.enablePictureInPicture = true

// Schedule with custom settings
try await notificationManager.schedule(
    customVideoNotification,
    at: Date().addingTimeInterval(300)
)
```

### Video with Subtitles

```swift
// Create video notification with subtitles
let videoWithSubtitles = RichNotificationContent(
    title: "Educational Video",
    body: "Learn with subtitles",
    mediaType: .video,
    mediaURL: URL(string: "https://example.com/educational.mp4"),
    subtitleURL: URL(string: "https://example.com/subtitles.vtt")
)

// Configure subtitle settings
videoWithSubtitles.subtitleLanguage = "en"
videoWithSubtitles.subtitleEnabled = true
videoWithSubtitles.subtitleSize = 14.0
videoWithSubtitles.subtitleColor = UIColor.white

try await notificationManager.schedule(
    videoWithSubtitles,
    at: Date().addingTimeInterval(600)
)
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

// Schedule audio notification
try await notificationManager.schedule(
    audioNotification,
    at: Date().addingTimeInterval(30)
)
```

### Audio with Custom Settings

```swift
// Create audio notification with custom settings
let customAudioNotification = RichNotificationContent(
    title: "Podcast Episode",
    body: "New episode available",
    mediaType: .audio,
    mediaURL: URL(string: "https://example.com/podcast.mp3")
)

// Configure audio settings
customAudioNotification.audioFormat = .mp3
customAudioNotification.autoPlay = true
customAudioNotification.volume = 0.8
customAudioNotification.loopAudio = false
customAudioNotification.maxAudioDuration = 300.0
customAudioNotification.enableBackgroundPlayback = true
customAudioNotification.audioQuality = .high

// Schedule with custom settings
try await notificationManager.schedule(
    customAudioNotification,
    at: Date().addingTimeInterval(180)
)
```

### Audio with Waveform

```swift
// Create audio notification with waveform
let audioWithWaveform = RichNotificationContent(
    title: "Music Track",
    body: "Listen to this amazing track",
    mediaType: .audio,
    mediaURL: URL(string: "https://example.com/music.mp3")
)

// Configure waveform settings
audioWithWaveform.showWaveform = true
audioWithWaveform.waveformColor = UIColor.systemBlue
audioWithWaveform.waveformHeight = 40.0
audioWithWaveform.waveformStyle = .bars

try await notificationManager.schedule(
    audioWithWaveform,
    at: Date().addingTimeInterval(240)
)
```

## Custom Attachments

### File Attachments

```swift
// Create notification with file attachment
let fileNotification = RichNotificationContent(
    title: "Document Available",
    body: "Your document is ready for download",
    mediaType: .file,
    mediaURL: URL(string: "https://example.com/document.pdf")
)

// Configure file settings
fileNotification.fileType = .pdf
fileNotification.fileSize = 1024 * 1024 // 1MB
fileNotification.enableDownload = true
fileNotification.showFileIcon = true

try await notificationManager.schedule(
    fileNotification,
    at: Date().addingTimeInterval(90)
)
```

### Custom Data Attachments

```swift
// Create notification with custom data
let customDataNotification = RichNotificationContent(
    title: "Custom Data",
    body: "This notification contains custom data",
    mediaType: .custom,
    customData: [
        "type": "analytics",
        "value": "123",
        "timestamp": Date().timeIntervalSince1970
    ]
)

// Configure custom data settings
customDataNotification.customDataFormat = .json
customDataNotification.enableDataEncryption = true
customDataNotification.dataCompression = true

try await notificationManager.schedule(
    customDataNotification,
    at: Date().addingTimeInterval(60)
)
```

## Progressive Loading

### Progressive Image Loading

```swift
// Create notification with progressive loading
let progressiveNotification = RichNotificationContent(
    title: "Progressive Loading",
    body: "This image loads progressively",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/large-image.jpg")
)

// Configure progressive loading
progressiveNotification.progressiveLoading = true
progressiveNotification.loadingPlaceholder = "Loading..."
progressiveNotification.loadingIndicator = .spinner
progressiveNotification.loadingTimeout = 30.0
progressiveNotification.retryAttempts = 3

try await notificationManager.schedule(
    progressiveNotification,
    at: Date().addingTimeInterval(150)
)
```

### Lazy Loading

```swift
// Create notification with lazy loading
let lazyLoadingNotification = RichNotificationContent(
    title: "Lazy Loading",
    body: "Media loads when notification is viewed",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/lazy-image.jpg")
)

// Configure lazy loading
lazyLoadingNotification.lazyLoading = true
lazyLoadingNotification.preloadThumbnail = true
lazyLoadingNotification.loadOnView = true
lazyLoadingNotification.cacheStrategy = .lazy

try await notificationManager.schedule(
    lazyLoadingNotification,
    at: Date().addingTimeInterval(200)
)
```

## Caching Strategies

### Memory Caching

```swift
// Configure memory caching
let memoryCacheConfig = MediaCacheConfiguration()
memoryCacheConfig.memoryCacheEnabled = true
memoryCacheConfig.memoryCacheSize = 50 * 1024 * 1024 // 50MB
memoryCacheConfig.memoryCacheExpiration = 3600 // 1 hour

notificationManager.configureMediaCache(memoryCacheConfig)
```

### Disk Caching

```swift
// Configure disk caching
let diskCacheConfig = MediaCacheConfiguration()
diskCacheConfig.diskCacheEnabled = true
diskCacheConfig.diskCacheSize = 200 * 1024 * 1024 // 200MB
diskCacheConfig.diskCacheExpiration = 86400 // 24 hours
diskCacheConfig.diskCacheDirectory = "MediaCache"

notificationManager.configureMediaCache(diskCacheConfig)
```

### Hybrid Caching

```swift
// Configure hybrid caching (memory + disk)
let hybridCacheConfig = MediaCacheConfiguration()
hybridCacheConfig.memoryCacheEnabled = true
hybridCacheConfig.diskCacheEnabled = true
hybridCacheConfig.cacheStrategy = .hybrid
hybridCacheConfig.priority = .high

notificationManager.configureMediaCache(hybridCacheConfig)
```

## Performance Optimization

### Image Optimization

```swift
// Optimize image notifications
let optimizedImageNotification = RichNotificationContent(
    title: "Optimized Image",
    body: "This image is optimized for performance",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/optimized.jpg")
)

// Configure optimization settings
optimizedImageNotification.imageCompression = .high
optimizedImageNotification.imageFormat = .webp
optimizedImageNotification.maxImageSize = CGSize(width: 300, height: 200)
optimizedImageNotification.quality = 0.7
optimizedImageNotification.enableImageResizing = true
optimizedImageNotification.resizeAlgorithm = .lanczos

try await notificationManager.schedule(
    optimizedImageNotification,
    at: Date().addingTimeInterval(300)
)
```

### Video Optimization

```swift
// Optimize video notifications
let optimizedVideoNotification = RichNotificationContent(
    title: "Optimized Video",
    body: "This video is optimized for mobile",
    mediaType: .video,
    mediaURL: URL(string: "https://example.com/optimized.mp4")
)

// Configure video optimization
optimizedVideoNotification.videoQuality = .low
optimizedVideoNotification.videoFormat = .mp4
optimizedVideoNotification.maxVideoDuration = 15.0
optimizedVideoNotification.enableVideoCompression = true
optimizedVideoNotification.compressionLevel = .medium

try await notificationManager.schedule(
    optimizedVideoNotification,
    at: Date().addingTimeInterval(400)
)
```

### Network Optimization

```swift
// Configure network optimization
let networkConfig = NetworkConfiguration()
networkConfig.enableCompression = true
networkConfig.timeout = 30.0
networkConfig.retryAttempts = 3
networkConfig.cachePolicy = .returnCacheDataElseLoad

notificationManager.configureNetwork(networkConfig)
```

## Best Practices

### 1. Media Size Optimization

```swift
// Optimize media sizes for notifications
let sizeOptimizedNotification = RichNotificationContent(
    title: "Size Optimized",
    body: "This media is optimized for notification size",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/small-image.jpg")
)

// Recommended sizes
sizeOptimizedNotification.maxImageSize = CGSize(width: 400, height: 300)
sizeOptimizedNotification.maxVideoDuration = 30.0
sizeOptimizedNotification.maxAudioDuration = 60.0
sizeOptimizedNotification.maxFileSize = 5 * 1024 * 1024 // 5MB
```

### 2. Network Efficiency

```swift
// Use efficient network strategies
let networkEfficientNotification = RichNotificationContent(
    title: "Network Efficient",
    body: "This notification uses efficient networking",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/efficient.jpg")
)

// Configure network efficiency
networkEfficientNotification.useCDN = true
networkEfficientNotification.enableCompression = true
networkEfficientNotification.cacheStrategy = .aggressive
networkEfficientNotification.loadingPriority = .high
```

### 3. User Experience

```swift
// Enhance user experience
let userFriendlyNotification = RichNotificationContent(
    title: "User Friendly",
    body: "This notification provides great UX",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/friendly.jpg")
)

// Configure UX settings
userFriendlyNotification.showLoadingIndicator = true
userFriendlyNotification.enableRetry = true
userFriendlyNotification.showErrorMessages = true
userFriendlyNotification.enableAccessibility = true
```

### 4. Error Handling

```swift
// Handle media loading errors
let errorHandlingNotification = RichNotificationContent(
    title: "Error Handling",
    body: "This notification handles errors gracefully",
    mediaType: .image,
    mediaURL: URL(string: "https://example.com/error.jpg")
)

// Configure error handling
errorHandlingNotification.fallbackImage = "fallback.jpg"
errorHandlingNotification.retryAttempts = 3
errorHandlingNotification.showErrorUI = true
errorHandlingNotification.enableGracefulDegradation = true
```

## Troubleshooting

### Common Issues

#### 1. Media Not Loading

```swift
// Check network connectivity
let networkStatus = notificationManager.getNetworkStatus()
print("Network status: \(networkStatus)")

// Check media URL validity
let isValidURL = notificationManager.validateMediaURL(mediaURL)
print("URL valid: \(isValidURL)")
```

#### 2. Slow Loading

```swift
// Check cache status
let cacheStatus = notificationManager.getCacheStatus()
print("Cache hit rate: \(cacheStatus.hitRate)%")
print("Cache size: \(cacheStatus.size)MB")

// Optimize loading
notificationManager.optimizeLoadingStrategy()
```

#### 3. Memory Issues

```swift
// Check memory usage
let memoryUsage = notificationManager.getMemoryUsage()
print("Memory usage: \(memoryUsage.current)MB / \(memoryUsage.limit)MB")

// Clear cache if needed
notificationManager.clearCache()
```

### Debug Mode

```swift
// Enable debug logging for media
notificationManager.enableMediaDebugMode()

// Get media debug logs
notificationManager.getMediaDebugLogs { logs in
    for log in logs {
        print("🔍 Media Debug: \(log)")
    }
}
```

### Performance Monitoring

```swift
// Monitor media performance
notificationManager.startMediaPerformanceMonitoring()

// Get performance metrics
notificationManager.getMediaPerformanceMetrics { metrics in
    print("📊 Average load time: \(metrics.averageLoadTime)ms")
    print("📊 Cache hit rate: \(metrics.cacheHitRate)%")
    print("📊 Network requests: \(metrics.networkRequests)")
    print("📊 Failed loads: \(metrics.failedLoads)")
}
```

## Advanced Features

### Custom Media Processors

```swift
// Implement custom media processor
class CustomMediaProcessor: MediaProcessor {
    func processImage(_ image: UIImage) -> UIImage {
        // Apply custom image processing
        return image.applyingFilter(.monochrome)
    }
    
    func processVideo(_ videoURL: URL) -> URL {
        // Apply custom video processing
        return videoURL.applyingCompression()
    }
}

// Use custom processor
notificationManager.setMediaProcessor(CustomMediaProcessor())
```

### Machine Learning Integration

```swift
// Use ML for media optimization
class MLMediaOptimizer {
    func optimizeMediaForUser(
        _ mediaURL: URL,
        userPreferences: UserPreferences
    ) async throws -> URL {
        let optimizedURL = await predictOptimalMediaFormat(mediaURL, userPreferences)
        return optimizedURL
    }
}
```

This comprehensive guide covers all aspects of rich media notifications in the iOS Notification Framework. Follow these patterns to create engaging, visually appealing notifications that enhance user experience.
