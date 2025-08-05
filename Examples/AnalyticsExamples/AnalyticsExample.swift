import Foundation
import UserNotifications
import NotificationFramework

// MARK: - Analytics Examples
// This file demonstrates comprehensive analytics and tracking capabilities
// using the iOS Notification Framework.

class AnalyticsExample {
    
    // MARK: - Properties
    private let notificationManager = NotificationManager.shared
    private let analyticsManager = NotificationAnalyticsManager()
    
    // MARK: - Initialization
    init() {
        setupAnalytics()
    }
    
    // MARK: - Setup
    private func setupAnalytics() {
        // Configure analytics manager
        analyticsManager.configure(
            trackingEnabled: true,
            privacyMode: .enhanced
        )
        
        // Request permissions
        notificationManager.requestPermissions { [weak self] granted in
            if granted {
                print("✅ Analytics permissions granted")
                self?.runAllAnalyticsExamples()
            } else {
                print("❌ Analytics permissions denied")
            }
        }
    }
    
    // MARK: - Delivery Analytics Examples
    
    /// Example 1: Track notification delivery
    func trackDeliveryAnalytics() {
        let notificationID = "notification_123"
        
        // Track delivery
        analyticsManager.trackDelivery(
            notificationID: notificationID,
            deliveryTime: Date(),
            deliveryChannel: .push
        )
        
        // Track delivery with additional data
        analyticsManager.trackDelivery(
            notificationID: notificationID,
            deliveryTime: Date(),
            deliveryChannel: .local,
            userInfo: [
                "category": "welcome",
                "priority": "high",
                "target_audience": "new_users"
            ]
        )
        
        print("✅ Delivery analytics tracked")
    }
    
    /// Example 2: Get delivery metrics
    func getDeliveryMetrics() {
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
    }
    
    // MARK: - Engagement Analytics Examples
    
    /// Example 3: Track user engagement
    func trackEngagementAnalytics() {
        let notificationID = "notification_123"
        
        // Track engagement
        analyticsManager.trackEngagement(
            notificationID: notificationID,
            action: "view",
            timestamp: Date()
        )
        
        // Track engagement with additional context
        analyticsManager.trackEngagement(
            notificationID: notificationID,
            action: "share",
            timestamp: Date(),
            userInfo: [
                "user_segment": "premium",
                "notification_type": "rich_media",
                "time_to_action": 15.5
            ]
        )
        
        print("✅ Engagement analytics tracked")
    }
    
    /// Example 4: Get engagement metrics
    func getEngagementMetrics() {
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
    }
    
    // MARK: - A/B Testing Examples
    
    /// Example 5: Create and run A/B test
    func runABTest() {
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
    }
    
    /// Example 6: Analyze A/B test results
    func analyzeABTestResults() {
        let results = ABTestResults(
            testID: "notification_style_test",
            variantAEngagement: 25.5,
            variantBEngagement: 32.8,
            winner: "variant_b",
            confidenceLevel: 95.2,
            totalParticipants: 1000,
            testDuration: 86400 // 24 hours
        )
        
        print("📊 A/B Test Analysis:")
        print("Test ID: \(results.testID)")
        print("Variant A: \(results.variantAEngagement)%")
        print("Variant B: \(results.variantBEngagement)%")
        print("Winner: \(results.winner ?? "None")")
        print("Confidence: \(results.confidenceLevel)%")
        print("Participants: \(results.totalParticipants)")
        print("Duration: \(results.testDuration)s")
    }
    
    // MARK: - Performance Analytics Examples
    
    /// Example 7: Track performance metrics
    func trackPerformanceAnalytics() {
        let notificationID = "notification_123"
        
        // Track performance metrics
        analyticsManager.trackPerformance(
            notificationID: notificationID,
            metrics: [
                "delivery_time": 1.5,
                "render_time": 0.8,
                "interaction_time": 2.3,
                "memory_usage": 15.2,
                "battery_impact": 0.3
            ]
        )
        
        print("✅ Performance analytics tracked")
    }
    
    /// Example 8: Set up performance alerts
    func setupPerformanceAlerts() {
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
        
        print("✅ Performance alerts configured")
    }
    
    // MARK: - User Segmentation Examples
    
    /// Example 9: Track segment analytics
    func trackSegmentAnalytics() {
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
        
        print("✅ Segment analytics tracked")
    }
    
    /// Example 10: Get segment analytics
    func getSegmentAnalytics() {
        analyticsManager.getSegmentAnalytics { analytics in
            for segment in analytics.segments {
                print("📊 Segment: \(segment.id)")
                print("  Users: \(segment.userCount)")
                print("  Engagement: \(segment.engagementRate)%")
                print("  Conversion: \(segment.conversionRate)%")
            }
        }
    }
    
    // MARK: - Real-Time Analytics Examples
    
    /// Example 11: Enable real-time analytics
    func enableRealTimeAnalytics() {
        // Set up real-time analytics
        analyticsManager.enableRealTimeAnalytics { data in
            print("📊 Real-Time Analytics:")
            print("Active notifications: \(data.activeNotifications)")
            print("Recent deliveries: \(data.recentDeliveries)")
            print("Current engagement: \(data.currentEngagement)%")
            print("Error rate: \(data.errorRate)%")
        }
        
        print("✅ Real-time analytics enabled")
    }
    
    /// Example 12: Track real-time events
    func trackRealTimeEvents() {
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
        
        print("✅ Real-time events tracked")
    }
    
    // MARK: - Privacy and Compliance Examples
    
    /// Example 13: Configure privacy settings
    func configurePrivacySettings() {
        // Configure privacy settings
        analyticsManager.configure(
            trackingEnabled: true,
            privacyMode: .enhanced
        )
        
        print("✅ Privacy settings configured")
    }
    
    /// Example 14: Anonymize user data
    func anonymizeUserData() {
        // Anonymize user data
        analyticsManager.anonymizeUserData(
            userID: "user_123",
            data: [
                "email": "user@example.com",
                "name": "John Doe",
                "location": "New York"
            ]
        ) { anonymizedData in
            print("Anonymized data: \(anonymizedData)")
        }
        
        print("✅ User data anonymized")
    }
    
    // MARK: - Error Handling Examples
    
    /// Example 15: Handle analytics errors
    func handleAnalyticsErrors() {
        do {
            try analyticsManager.trackEvent("test_event", properties: [:])
        } catch AnalyticsError.trackingDisabled {
            print("❌ Analytics tracking is disabled")
        } catch AnalyticsError.invalidData {
            print("❌ Invalid analytics data")
        } catch AnalyticsError.networkError {
            print("❌ Network error in analytics")
        } catch AnalyticsError.privacyViolation {
            print("❌ Privacy violation detected")
        } catch AnalyticsError.quotaExceeded {
            print("❌ Analytics quota exceeded")
        } catch {
            print("❌ Unknown analytics error: \(error)")
        }
    }
    
    // MARK: - Usage Example
    
    /// Run all analytics examples
    func runAllAnalyticsExamples() {
        print("🚀 Running Analytics Examples...")
        
        // Delivery analytics
        trackDeliveryAnalytics()
        getDeliveryMetrics()
        
        // Engagement analytics
        trackEngagementAnalytics()
        getEngagementMetrics()
        
        // A/B testing
        runABTest()
        analyzeABTestResults()
        
        // Performance analytics
        trackPerformanceAnalytics()
        setupPerformanceAlerts()
        
        // User segmentation
        trackSegmentAnalytics()
        getSegmentAnalytics()
        
        // Real-time analytics
        enableRealTimeAnalytics()
        trackRealTimeEvents()
        
        // Privacy and compliance
        configurePrivacySettings()
        anonymizeUserData()
        
        // Error handling
        handleAnalyticsErrors()
        
        print("✅ All analytics examples completed")
    }
} 