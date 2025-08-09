# Analytics API

<!-- TOC START -->
## Table of Contents
- [Analytics API](#analytics-api)
- [Overview](#overview)
- [Core Classes](#core-classes)
  - [NotificationAnalyticsManager](#notificationanalyticsmanager)
  - [DeliveryMetrics](#deliverymetrics)
  - [EngagementMetrics](#engagementmetrics)
- [Delivery Analytics](#delivery-analytics)
  - [Track Delivery](#track-delivery)
  - [Get Delivery Metrics](#get-delivery-metrics)
  - [Delivery Channel Tracking](#delivery-channel-tracking)
- [Engagement Analytics](#engagement-analytics)
  - [Track User Engagement](#track-user-engagement)
  - [Get Engagement Metrics](#get-engagement-metrics)
  - [Action Tracking](#action-tracking)
- [A/B Testing](#ab-testing)
  - [Create A/B Test](#create-ab-test)
  - [A/B Test Results](#ab-test-results)
- [Performance Monitoring](#performance-monitoring)
  - [Track Performance](#track-performance)
  - [Performance Alerts](#performance-alerts)
- [User Segmentation](#user-segmentation)
  - [Segment Users](#segment-users)
  - [Segment Analytics](#segment-analytics)
- [Real-Time Analytics](#real-time-analytics)
  - [Live Dashboard](#live-dashboard)
  - [Real-Time Events](#real-time-events)
- [Privacy and Compliance](#privacy-and-compliance)
  - [Privacy Mode](#privacy-mode)
  - [Data Anonymization](#data-anonymization)
- [Error Handling](#error-handling)
  - [Analytics Errors](#analytics-errors)
- [Best Practices](#best-practices)
  - [Analytics Guidelines](#analytics-guidelines)
<!-- TOC END -->


## Overview

The Analytics API provides comprehensive tracking and analytics capabilities for notification delivery, user engagement, and performance monitoring.

## Core Classes

### NotificationAnalyticsManager

```swift
public class NotificationAnalyticsManager {
    // MARK: - Properties
    public let analyticsProvider: AnalyticsProvider
    public let trackingEnabled: Bool
    public let privacyMode: PrivacyMode
    
    // MARK: - Initialization
    public init(analyticsProvider: AnalyticsProvider, trackingEnabled: Bool = true, privacyMode: PrivacyMode = .standard)
}
```

### DeliveryMetrics

```swift
public struct DeliveryMetrics {
    public let totalSent: Int
    public let delivered: Int
    public let failed: Int
    public let deliveryRate: Double
    public let averageDeliveryTime: TimeInterval
    public let deliveryChannels: [DeliveryChannel: Int]
}
```

### EngagementMetrics

```swift
public struct EngagementMetrics {
    public let totalInteractions: Int
    public let uniqueUsers: Int
    public let averageEngagementRate: Double
    public let mostPopularAction: String
    public let averageTimeToAction: TimeInterval
    public let actionBreakdown: [String: Int]
}
```

## Delivery Analytics

### Track Delivery

```swift
// Initialize analytics manager
let analyticsManager = NotificationAnalyticsManager()

// Track notification delivery
analyticsManager.trackDelivery(
    notificationID: "notification_123",
    deliveryTime: Date(),
    deliveryChannel: .push
)

// Track delivery with additional data
analyticsManager.trackDelivery(
    notificationID: "notification_123",
    deliveryTime: Date(),
    deliveryChannel: .local,
    userInfo: [
        "category": "welcome",
        "priority": "high",
        "target_audience": "new_users"
    ]
)
```

### Get Delivery Metrics

```swift
// Get comprehensive delivery metrics
analyticsManager.trackDeliveryMetrics { metrics in
    print("📊 Delivery Metrics:")
    print("Total sent: \(metrics.totalSent)")
    print("Delivered: \(metrics.delivered)")
    print("Failed: \(metrics.failed)")
    print("Delivery rate: \(metrics.deliveryRate)%")
    print("Average delivery time: \(metrics.averageDeliveryTime)s")
    
    // Channel breakdown
    for (channel, count) in metrics.deliveryChannels {
        print("\(channel): \(count)")
    }
}
```

### Delivery Channel Tracking

```swift
// Track delivery by channel
public enum DeliveryChannel {
    case push
    case local
    case email
    case sms
    case inApp
}

// Track specific channel delivery
analyticsManager.trackDeliveryByChannel(
    channel: .push,
    notificationID: "notification_123",
    success: true,
    deliveryTime: Date()
)
```

## Engagement Analytics

### Track User Engagement

```swift
// Track user interaction with notification
analyticsManager.trackEngagement(
    notificationID: "notification_123",
    action: "view",
    timestamp: Date()
)

// Track engagement with additional context
analyticsManager.trackEngagement(
    notificationID: "notification_123",
    action: "share",
    timestamp: Date(),
    userInfo: [
        "user_segment": "premium",
        "notification_type": "rich_media",
        "time_to_action": 15.5
    ]
)
```

### Get Engagement Metrics

```swift
// Get comprehensive engagement metrics
analyticsManager.trackEngagementMetrics { metrics in
    print("📈 Engagement Metrics:")
    print("Total interactions: \(metrics.totalInteractions)")
    print("Unique users: \(metrics.uniqueUsers)")
    print("Average engagement rate: \(metrics.averageEngagementRate)%")
    print("Most popular action: \(metrics.mostPopularAction)")
    print("Average time to action: \(metrics.averageTimeToAction)s")
    
    // Action breakdown
    for (action, count) in metrics.actionBreakdown {
        print("\(action): \(count)")
    }
}
```

### Action Tracking

```swift
// Track specific actions
analyticsManager.trackAction(
    action: "view",
    notificationID: "notification_123",
    userID: "user_456",
    timestamp: Date()
)

// Track action with properties
analyticsManager.trackAction(
    action: "share",
    notificationID: "notification_123",
    userID: "user_456",
    timestamp: Date(),
    properties: [
        "share_platform": "twitter",
        "share_content": "image",
        "user_segment": "active"
    ]
)
```

## A/B Testing

### Create A/B Test

```swift
// Create A/B test for notification content
let abTest = NotificationABTest(
    testID: "notification_style_test",
    variants: [
        NotificationVariant(
            id: "variant_a",
            title: "Simple Title",
            body: "Simple message"
        ),
        NotificationVariant(
            id: "variant_b",
            title: "Emoji Title 🎉",
            body: "Exciting message with emoji!"
        )
    ],
    distribution: .equal
)

// Run A/B test
notificationManager.runABTest(abTest) { results in
    print("🧪 A/B Test Results:")
    print("Variant A engagement: \(results.variantAEngagement)%")
    print("Variant B engagement: \(results.variantBEngagement)%")
    print("Winner: \(results.winner)")
    print("Confidence level: \(results.confidenceLevel)%")
}
```

### A/B Test Results

```swift
public struct ABTestResults {
    public let testID: String
    public let variantAEngagement: Double
    public let variantBEngagement: Double
    public let winner: String?
    public let confidenceLevel: Double
    public let totalParticipants: Int
    public let testDuration: TimeInterval
}

// Analyze A/B test results
func analyzeABTestResults(_ results: ABTestResults) {
    print("📊 A/B Test Analysis:")
    print("Test ID: \(results.testID)")
    print("Variant A: \(results.variantAEngagement)%")
    print("Variant B: \(results.variantBEngagement)%")
    print("Winner: \(results.winner ?? "None")")
    print("Confidence: \(results.confidenceLevel)%")
    print("Participants: \(results.totalParticipants)")
    print("Duration: \(results.testDuration)s")
}
```

## Performance Monitoring

### Track Performance

```swift
// Track notification performance
analyticsManager.trackPerformance(
    notificationID: "notification_123",
    metric: "delivery_time",
    value: 1.5,
    unit: "seconds"
)

// Track multiple performance metrics
analyticsManager.trackPerformance(
    notificationID: "notification_123",
    metrics: [
        "delivery_time": 1.5,
        "render_time": 0.8,
        "interaction_time": 2.3
    ]
)
```

### Performance Alerts

```swift
// Set up performance alerts
analyticsManager.setPerformanceAlert(
    metric: "delivery_time",
    threshold: 5.0,
    action: { notificationID in
        print("⚠️ Performance alert: \(notificationID) delivery time exceeded threshold")
    }
)

// Monitor performance trends
analyticsManager.monitorPerformanceTrend(
    metric: "engagement_rate",
    window: 24 * 60 * 60, // 24 hours
    action: { trend in
        if trend.direction == .decreasing {
            print("📉 Engagement rate is decreasing")
        }
    }
)
```

## User Segmentation

### Segment Users

```swift
// Create user segments
let userSegments = [
    UserSegment(id: "new_users", criteria: ["days_since_signup": "< 7"]),
    UserSegment(id: "active_users", criteria: ["session_count": "> 10"]),
    UserSegment(id: "premium_users", criteria: ["subscription_type": "premium"])
]

// Track segment-specific metrics
analyticsManager.trackSegmentMetrics(
    segment: "premium_users",
    notificationID: "notification_123",
    engagement: 0.85
)
```

### Segment Analytics

```swift
// Get segment analytics
analyticsManager.getSegmentAnalytics { analytics in
    for segment in analytics.segments {
        print("📊 Segment: \(segment.id)")
        print("  Users: \(segment.userCount)")
        print("  Engagement: \(segment.engagementRate)%")
        print("  Conversion: \(segment.conversionRate)%")
    }
}
```

## Real-Time Analytics

### Live Dashboard

```swift
// Set up real-time analytics
analyticsManager.enableRealTimeAnalytics { data in
    print("📊 Real-Time Analytics:")
    print("Active notifications: \(data.activeNotifications)")
    print("Recent deliveries: \(data.recentDeliveries)")
    print("Current engagement: \(data.currentEngagement)%")
    print("Error rate: \(data.errorRate)%")
}
```

### Real-Time Events

```swift
// Track real-time events
analyticsManager.trackRealTimeEvent(
    event: "notification_delivered",
    notificationID: "notification_123",
    timestamp: Date(),
    metadata: [
        "channel": "push",
        "user_agent": "iOS 15.0",
        "network": "wifi"
    ]
)
```

## Privacy and Compliance

### Privacy Mode

```swift
public enum PrivacyMode {
    case standard
    case enhanced
    case minimal
    case disabled
}

// Configure privacy settings
let analyticsManager = NotificationAnalyticsManager(
    analyticsProvider: provider,
    trackingEnabled: true,
    privacyMode: .enhanced
)
```

### Data Anonymization

```swift
// Anonymize user data
analyticsManager.anonymizeUserData(
    userID: "user_123",
    data: [
        "email": "user@example.com",
        "name": "John Doe",
        "location": "New York"
    ]
) { anonymizedData in
    // Use anonymized data for analytics
    print("Anonymized data: \(anonymizedData)")
}
```

## Error Handling

### Analytics Errors

```swift
public enum AnalyticsError: Error {
    case trackingDisabled
    case invalidData
    case networkError
    case privacyViolation
    case quotaExceeded
}

// Handle analytics errors
func handleAnalyticsError(_ error: AnalyticsError) {
    switch error {
    case .trackingDisabled:
        print("❌ Analytics tracking is disabled")
    case .invalidData:
        print("❌ Invalid analytics data")
    case .networkError:
        print("❌ Network error in analytics")
    case .privacyViolation:
        print("❌ Privacy violation detected")
    case .quotaExceeded:
        print("❌ Analytics quota exceeded")
    }
}
```

## Best Practices

### Analytics Guidelines

1. **Respect user privacy**
   - Use appropriate privacy modes
   - Anonymize sensitive data
   - Follow GDPR/CCPA guidelines

2. **Optimize for performance**
   - Batch analytics events
   - Use background processing
   - Monitor analytics overhead

3. **Ensure data quality**
   - Validate analytics data
   - Handle errors gracefully
   - Maintain data consistency

4. **Test thoroughly**
   - Test all analytics scenarios
   - Verify data accuracy
   - Test privacy compliance
