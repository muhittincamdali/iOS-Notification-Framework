# Analytics Guide

## Overview

The Analytics module provides comprehensive tracking and reporting capabilities for iOS notifications, enabling you to measure performance, user engagement, and optimize your notification strategy. This guide covers everything you need to know about implementing analytics in your notification system.

## Table of Contents

- [Getting Started](#getting-started)
- [Basic Analytics](#basic-analytics)
- [Advanced Analytics](#advanced-analytics)
- [A/B Testing](#ab-testing)
- [Performance Monitoring](#performance-monitoring)
- [User Engagement](#user-engagement)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
- Notification permissions granted
- Analytics service (optional)

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

// Enable analytics
let config = NotificationConfiguration()
config.enableAnalytics = true
config.enablePerformanceTracking = true
config.enableUserEngagementTracking = true

notificationManager.configure(config)
```

## Basic Analytics

### Delivery Tracking

```swift
// Initialize analytics manager
let analyticsManager = NotificationAnalyticsManager()

// Track notification delivery
analyticsManager.trackDelivery(
    notificationID: "notification_123",
    deliveryTime: Date(),
    deliveryChannel: .local
)

// Track delivery with metadata
analyticsManager.trackDelivery(
    notificationID: "notification_123",
    deliveryTime: Date(),
    deliveryChannel: .push,
    metadata: [
        "category": "welcome",
        "priority": "high",
        "user_segment": "new_user"
    ]
)
```

### Engagement Tracking

```swift
// Track user engagement
analyticsManager.trackEngagement(
    notificationID: "notification_123",
    action: "view",
    timestamp: Date()
)

// Track engagement with context
analyticsManager.trackEngagement(
    notificationID: "notification_123",
    action: "reply",
    timestamp: Date(),
    context: [
        "response_time": 2.5,
        "user_type": "premium",
        "session_duration": 300
    ]
)
```

### Basic Metrics

```swift
// Get basic delivery metrics
analyticsManager.getDeliveryMetrics { metrics in
    print("📊 Delivery Metrics:")
    print("Total sent: \(metrics.totalSent)")
    print("Delivered: \(metrics.delivered)")
    print("Failed: \(metrics.failed)")
    print("Delivery rate: \(metrics.deliveryRate)%")
    print("Average delivery time: \(metrics.averageDeliveryTime)s")
}

// Get basic engagement metrics
analyticsManager.getEngagementMetrics { metrics in
    print("📈 Engagement Metrics:")
    print("Total interactions: \(metrics.totalInteractions)")
    print("Unique users: \(metrics.uniqueUsers)")
    print("Average engagement rate: \(metrics.averageEngagementRate)%")
    print("Most popular action: \(metrics.mostPopularAction)")
}
```

## Advanced Analytics

### Custom Events

```swift
// Track custom events
analyticsManager.trackEvent(
    "notification_scheduled",
    properties: [
        "notification_type": "reminder",
        "scheduled_time": Date().timeIntervalSince1970,
        "user_preference": "daily"
    ]
)

// Track conversion events
analyticsManager.trackConversion(
    "notification_to_app_open",
    notificationID: "notification_123",
    conversionValue: 1.0,
    properties: [
        "source": "push_notification",
        "campaign": "welcome_series"
    ]
)
```

### User Segmentation

```swift
// Track user segments
analyticsManager.trackUserSegment(
    userID: "user_123",
    segment: "high_engagement",
    properties: [
        "engagement_score": 85,
        "notification_preferences": ["daily", "weekly"],
        "app_usage_frequency": "daily"
    ]
)

// Track user behavior
analyticsManager.trackUserBehavior(
    userID: "user_123",
    behavior: "notification_interaction",
    properties: [
        "interaction_type": "tap",
        "notification_category": "social",
        "time_of_day": "morning"
    ]
)
```

### Cohort Analysis

```swift
// Track cohort data
analyticsManager.trackCohort(
    cohortID: "welcome_series_2024",
    userID: "user_123",
    cohortDate: Date(),
    properties: [
        "cohort_type": "new_users",
        "notification_sequence": 1,
        "user_source": "app_store"
    ]
)

// Get cohort metrics
analyticsManager.getCohortMetrics(cohortID: "welcome_series_2024") { metrics in
    print("📊 Cohort Metrics:")
    print("Cohort size: \(metrics.cohortSize)")
    print("Retention rate: \(metrics.retentionRate)%")
    print("Engagement rate: \(metrics.engagementRate)%")
    print("Conversion rate: \(metrics.conversionRate)%")
}
```

## A/B Testing

### Basic A/B Test

```swift
// Create A/B test
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

### Advanced A/B Testing

```swift
// Create advanced A/B test
let advancedABTest = NotificationABTest(
    testID: "notification_timing_test",
    variants: [
        NotificationVariant(
            id: "morning_variant",
            title: "Good Morning!",
            body: "Start your day right",
            schedule: RecurringSchedule(
                frequency: .daily,
                time: DateComponents(hour: 9, minute: 0)
            )
        ),
        NotificationVariant(
            id: "evening_variant",
            title: "Good Evening!",
            body: "End your day well",
            schedule: RecurringSchedule(
                frequency: .daily,
                time: DateComponents(hour: 18, minute: 0)
            )
        )
    ],
    distribution: .weighted([0.5, 0.5]),
    duration: 30, // 30 days
    successMetric: .engagement
)

// Run advanced A/B test
notificationManager.runAdvancedABTest(advancedABTest) { results in
    print("🧪 Advanced A/B Test Results:")
    print("Test duration: \(results.duration) days")
    print("Sample size: \(results.sampleSize)")
    print("Statistical significance: \(results.statisticalSignificance)")
    print("Winner: \(results.winner)")
    print("Effect size: \(results.effectSize)")
}
```

### Multivariate Testing

```swift
// Create multivariate test
let multivariateTest = NotificationMultivariateTest(
    testID: "notification_optimization_test",
    factors: [
        NotificationFactor(
            name: "title_style",
            levels: ["simple", "emoji", "question"]
        ),
        NotificationFactor(
            name: "send_time",
            levels: ["morning", "afternoon", "evening"]
        ),
        NotificationFactor(
            name: "message_length",
            levels: ["short", "medium", "long"]
        )
    ],
    design: .fractional,
    sampleSize: 1000
)

// Run multivariate test
notificationManager.runMultivariateTest(multivariateTest) { results in
    print("🧪 Multivariate Test Results:")
    print("Best combination: \(results.bestCombination)")
    print("Factor importance: \(results.factorImportance)")
    print("Interaction effects: \(results.interactionEffects)")
}
```

## Performance Monitoring

### Real-time Monitoring

```swift
// Start real-time monitoring
analyticsManager.startRealTimeMonitoring()

// Monitor key metrics
analyticsManager.monitorMetric("delivery_rate") { value in
    print("📊 Current delivery rate: \(value)%")
}

analyticsManager.monitorMetric("engagement_rate") { value in
    print("📈 Current engagement rate: \(value)%")
}

analyticsManager.monitorMetric("error_rate") { value in
    print("❌ Current error rate: \(value)%")
}
```

### Performance Alerts

```swift
// Set up performance alerts
analyticsManager.setAlert(
    metric: "delivery_rate",
    threshold: 95.0,
    condition: .below
) { alert in
    print("🚨 Alert: Delivery rate dropped to \(alert.currentValue)%")
    // Take corrective action
}

analyticsManager.setAlert(
    metric: "error_rate",
    threshold: 5.0,
    condition: .above
) { alert in
    print("🚨 Alert: Error rate increased to \(alert.currentValue)%")
    // Investigate and fix issues
}
```

### Performance Dashboards

```swift
// Create performance dashboard
let dashboard = NotificationPerformanceDashboard()
dashboard.addMetric("delivery_rate", title: "Delivery Rate")
dashboard.addMetric("engagement_rate", title: "Engagement Rate")
dashboard.addMetric("conversion_rate", title: "Conversion Rate")
dashboard.addMetric("error_rate", title: "Error Rate")

// Get dashboard data
dashboard.getData { data in
    print("📊 Dashboard Data:")
    for metric in data.metrics {
        print("\(metric.title): \(metric.value)\(metric.unit)")
    }
}
```

## User Engagement

### Engagement Scoring

```swift
// Calculate user engagement score
analyticsManager.calculateEngagementScore(userID: "user_123") { score in
    print("📊 User Engagement Score: \(score)")
    
    // Segment user based on score
    switch score {
    case 0..<25:
        print("Low engagement user")
    case 25..<50:
        print("Medium engagement user")
    case 50..<75:
        print("High engagement user")
    case 75...100:
        print("Very high engagement user")
    default:
        break
    }
}
```

### Engagement Patterns

```swift
// Analyze engagement patterns
analyticsManager.analyzeEngagementPatterns { patterns in
    print("📈 Engagement Patterns:")
    print("Peak engagement time: \(patterns.peakTime)")
    print("Most engaging day: \(patterns.mostEngagingDay)")
    print("Preferred notification type: \(patterns.preferredType)")
    print("Average session duration: \(patterns.averageSessionDuration)s")
}
```

### User Journey Tracking

```swift
// Track user journey
analyticsManager.trackUserJourney(
    userID: "user_123",
    step: "notification_received",
    properties: [
        "notification_type": "welcome",
        "step_number": 1,
        "journey_id": "welcome_series_2024"
    ]
)

analyticsManager.trackUserJourney(
    userID: "user_123",
    step: "notification_opened",
    properties: [
        "notification_type": "welcome",
        "step_number": 2,
        "journey_id": "welcome_series_2024",
        "time_to_open": 5.2
    ]
)
```

## Best Practices

### 1. Privacy Compliance

```swift
// Ensure GDPR compliance
let privacyConfig = AnalyticsPrivacyConfiguration()
privacyConfig.gdprCompliant = true
privacyConfig.anonymizeUserData = true
privacyConfig.retentionPeriod = 90 // days
privacyConfig.allowDataExport = true

analyticsManager.configurePrivacy(privacyConfig)
```

### 2. Data Quality

```swift
// Validate analytics data
analyticsManager.validateData { validation in
    if validation.isValid {
        print("✅ Analytics data is valid")
    } else {
        print("❌ Analytics data validation failed:")
        for error in validation.errors {
            print("- \(error)")
        }
    }
}
```

### 3. Performance Optimization

```swift
// Optimize analytics performance
let performanceConfig = AnalyticsPerformanceConfiguration()
performanceConfig.batchSize = 100
performanceConfig.flushInterval = 60 // seconds
performanceConfig.enableCompression = true
performanceConfig.maxRetries = 3

analyticsManager.configurePerformance(performanceConfig)
```

### 4. Error Handling

```swift
// Handle analytics errors
analyticsManager.setErrorHandler { error in
    print("❌ Analytics Error: \(error)")
    
    // Log error for debugging
    logError(error)
    
    // Retry if appropriate
    if shouldRetry(error) {
        retryAnalyticsOperation()
    }
}
```

### 5. Data Export

```swift
// Export analytics data
analyticsManager.exportData(
    format: .csv,
    dateRange: DateInterval(start: Date().addingTimeInterval(-86400*30), duration: 86400*30)
) { data in
    // Save data to file
    saveToFile(data, filename: "analytics_export.csv")
}
```

## Troubleshooting

### Common Issues

#### 1. Data Not Tracking

```swift
// Check analytics configuration
let config = analyticsManager.getConfiguration()
print("Analytics enabled: \(config.enabled)")
print("Tracking enabled: \(config.trackingEnabled)")
print("Privacy mode: \(config.privacyMode)")

// Check network connectivity
let networkStatus = analyticsManager.getNetworkStatus()
print("Network status: \(networkStatus)")
```

#### 2. Performance Issues

```swift
// Check analytics performance
let performance = analyticsManager.getPerformanceMetrics()
print("Queue size: \(performance.queueSize)")
print("Processing time: \(performance.averageProcessingTime)ms")
print("Memory usage: \(performance.memoryUsage)MB")

// Optimize if needed
if performance.queueSize > 1000 {
    analyticsManager.flushQueue()
}
```

#### 3. Data Accuracy

```swift
// Validate data accuracy
analyticsManager.validateAccuracy { accuracy in
    print("Data accuracy: \(accuracy.score)%")
    print("Missing data: \(accuracy.missingData)")
    print("Duplicate data: \(accuracy.duplicateData)")
    print("Invalid data: \(accuracy.invalidData)")
}
```

### Debug Mode

```swift
// Enable analytics debug mode
analyticsManager.enableDebugMode()

// Get debug logs
analyticsManager.getDebugLogs { logs in
    for log in logs {
        print("🔍 Analytics Debug: \(log)")
    }
}
```

### Performance Monitoring

```swift
// Monitor analytics performance
analyticsManager.startPerformanceMonitoring()

// Get performance metrics
analyticsManager.getPerformanceMetrics { metrics in
    print("📊 Analytics Performance:")
    print("Events processed: \(metrics.eventsProcessed)")
    print("Average processing time: \(metrics.averageProcessingTime)ms")
    print("Memory usage: \(metrics.memoryUsage)MB")
    print("Network requests: \(metrics.networkRequests)")
}
```

## Advanced Features

### Machine Learning Integration

```swift
// Integrate with ML for predictions
class MLAnalytics {
    func predictOptimalSendTime(
        for userID: String,
        notificationType: String
    ) async throws -> Date {
        let userBehavior = await analyticsManager.getUserBehavior(userID)
        let prediction = await mlModel.predict(userBehavior, notificationType)
        return prediction.optimalTime
    }
    
    func predictEngagementProbability(
        for notification: NotificationContent,
        userID: String
    ) async throws -> Double {
        let features = await extractFeatures(notification, userID)
        let probability = await mlModel.predictEngagement(features)
        return probability
    }
}
```

### Custom Analytics Providers

```swift
// Integrate with custom analytics providers
class CustomAnalyticsProvider: AnalyticsProvider {
    func trackEvent(
        _ event: String,
        properties: [String: Any]
    ) async throws {
        // Send to custom analytics service
        try await customService.track(event, properties)
    }
    
    func getMetrics(
        for dateRange: DateInterval
    ) async throws -> AnalyticsMetrics {
        // Get metrics from custom service
        return try await customService.getMetrics(dateRange)
    }
}

// Use custom provider
analyticsManager.setProvider(CustomAnalyticsProvider())
```

This comprehensive guide covers all aspects of analytics in the iOS Notification Framework. Follow these patterns to track, measure, and optimize your notification strategy for maximum user engagement and app success.
