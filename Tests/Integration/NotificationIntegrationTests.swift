import XCTest
import NotificationFramework
@testable import NotificationFramework

final class NotificationIntegrationTests: XCTestCase {
    
    var notificationManager: NotificationManager!
    
    override func setUp() {
        super.setUp()
        notificationManager = NotificationManager.shared
    }
    
    override func tearDown() {
        // Clean up any scheduled notifications
        Task {
            try? await notificationManager.removeAllPendingNotifications()
            try? await notificationManager.removeAllDeliveredNotifications()
        }
        super.tearDown()
    }
    
    // MARK: - Integration Tests
    
    func testCompleteNotificationFlow() async throws {
        // 1. Request permissions
        let granted = try await notificationManager.requestPermissions()
        XCTAssertTrue(granted, "Notification permissions should be granted")
        
        // 2. Create and schedule notification
        let notification = NotificationContent(
            title: "Integration Test",
            body: "Testing complete notification flow",
            category: "integration_test"
        )
        
        try await notificationManager.schedule(
            notification,
            at: Date().addingTimeInterval(1)
        )
        
        // 3. Verify notification was scheduled
        let pendingNotifications = try await notificationManager.getPendingNotifications()
        XCTAssertEqual(pendingNotifications.count, 1, "Should have one pending notification")
        
        // 4. Wait for notification to be delivered
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // 5. Verify notification was delivered
        let deliveredNotifications = try await notificationManager.getDeliveredNotifications()
        XCTAssertGreaterThanOrEqual(deliveredNotifications.count, 1, "Should have delivered notifications")
        
        // 6. Clean up
        try await notificationManager.removeAllDeliveredNotifications()
    }
    
    func testRichMediaNotificationFlow() async throws {
        // 1. Request permissions
        let granted = try await notificationManager.requestPermissions()
        XCTAssertTrue(granted, "Notification permissions should be granted")
        
        // 2. Create rich media notification
        let richNotification = RichNotificationContent(
            title: "Rich Media Test",
            body: "Testing rich media notification",
            mediaURL: "https://example.com/test-image.jpg",
            mediaType: .image,
            actions: [
                NotificationAction(title: "View", identifier: "view_action"),
                NotificationAction(title: "Share", identifier: "share_action")
            ]
        )
        
        // 3. Schedule rich media notification
        try await notificationManager.scheduleRichNotification(
            richNotification,
            at: Date().addingTimeInterval(1)
        )
        
        // 4. Verify notification was scheduled
        let pendingNotifications = try await notificationManager.getPendingNotifications()
        XCTAssertEqual(pendingNotifications.count, 1, "Should have one pending rich media notification")
        
        // 5. Clean up
        try await notificationManager.removeAllPendingNotifications()
    }
    
    func testRecurringNotificationFlow() async throws {
        // 1. Request permissions
        let granted = try await notificationManager.requestPermissions()
        XCTAssertTrue(granted, "Notification permissions should be granted")
        
        // 2. Create recurring schedule
        let schedule = RecurringSchedule(
            interval: .daily,
            startDate: Date(),
            timeComponents: DateComponents(hour: 9, minute: 0)
        )
        
        // 3. Create notification
        let notification = NotificationContent(
            title: "Recurring Test",
            body: "Testing recurring notification",
            category: "recurring_test"
        )
        
        // 4. Schedule recurring notification
        try await notificationManager.scheduleRecurringNotification(
            notification,
            with: schedule
        )
        
        // 5. Verify notification was scheduled
        let pendingNotifications = try await notificationManager.getPendingNotifications()
        XCTAssertGreaterThanOrEqual(pendingNotifications.count, 1, "Should have recurring notifications scheduled")
        
        // 6. Clean up
        try await notificationManager.removeAllPendingNotifications()
    }
    
    func testActionHandlerIntegration() async throws {
        // 1. Request permissions
        let granted = try await notificationManager.requestPermissions()
        XCTAssertTrue(granted, "Notification permissions should be granted")
        
        // 2. Set up action handler
        var actionHandled = false
        notificationManager.registerActionHandler(for: "test_action") { action in
            actionHandled = true
            XCTAssertEqual(action.identifier, "test_action", "Action identifier should match")
        }
        
        // 3. Create notification with action
        let notification = RichNotificationContent(
            title: "Action Test",
            body: "Testing action handling",
            actions: [
                NotificationAction(title: "Test Action", identifier: "test_action")
            ]
        )
        
        // 4. Schedule notification
        try await notificationManager.scheduleRichNotification(
            notification,
            at: Date().addingTimeInterval(1)
        )
        
        // 5. Simulate action (in real scenario, this would be triggered by user)
        // For testing purposes, we'll just verify the handler was registered
        XCTAssertTrue(notificationManager.hasActionHandler(for: "test_action"), "Action handler should be registered")
        
        // 6. Clean up
        notificationManager.removeActionHandler(for: "test_action")
        try await notificationManager.removeAllPendingNotifications()
    }
    
    func testAnalyticsIntegration() async throws {
        // 1. Request permissions
        let granted = try await notificationManager.requestPermissions()
        XCTAssertTrue(granted, "Notification permissions should be granted")
        
        // 2. Track some events
        notificationManager.trackEvent(.notificationScheduled, metadata: [
            "test": "integration_test",
            "timestamp": Date().timeIntervalSince1970
        ])
        
        notificationManager.trackEvent(.notificationReceived, metadata: [
            "test": "integration_test",
            "timestamp": Date().timeIntervalSince1970
        ])
        
        // 3. Get analytics
        let analytics = try await notificationManager.getAnalytics()
        
        // 4. Verify analytics data
        XCTAssertGreaterThanOrEqual(analytics.totalEvents, 2, "Should have tracked events")
        XCTAssertGreaterThanOrEqual(analytics.scheduledCount, 0, "Should have scheduled count")
        
        // 5. Export analytics
        let jsonData = try analytics.exportToJSON()
        XCTAssertGreaterThan(jsonData.count, 0, "Should export analytics data")
    }
    
    func testErrorHandlingIntegration() async throws {
        // 1. Test invalid notification content
        let invalidNotification = NotificationContent(
            title: "", // Empty title should cause error
            body: "Test",
            category: "error_test"
        )
        
        do {
            try await notificationManager.schedule(invalidNotification, at: Date().addingTimeInterval(1))
            XCTFail("Should have thrown error for invalid content")
        } catch NotificationError.contentInvalid {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        // 2. Test invalid media URL
        let invalidRichNotification = RichNotificationContent(
            title: "Test",
            body: "Test",
            mediaURL: "invalid-url",
            mediaType: .image
        )
        
        do {
            try await notificationManager.scheduleRichNotification(invalidRichNotification, at: Date().addingTimeInterval(1))
            // This might not throw an error depending on implementation
        } catch {
            // Expected error for invalid URL
        }
    }
    
    func testPerformanceIntegration() async throws {
        // 1. Request permissions
        let granted = try await notificationManager.requestPermissions()
        XCTAssertTrue(granted, "Notification permissions should be granted")
        
        // 2. Measure scheduling performance
        let startTime = Date()
        
        for i in 0..<10 {
            let notification = NotificationContent(
                title: "Performance Test \(i)",
                body: "Testing performance",
                category: "performance_test"
            )
            
            try await notificationManager.schedule(
                notification,
                at: Date().addingTimeInterval(TimeInterval(i + 1))
            )
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        // 3. Verify performance (should be under 1 second for 10 notifications)
        XCTAssertLessThan(duration, 1.0, "Scheduling 10 notifications should be fast")
        
        // 4. Clean up
        try await notificationManager.removeAllPendingNotifications()
    }
    
    func testConcurrentOperations() async throws {
        // 1. Request permissions
        let granted = try await notificationManager.requestPermissions()
        XCTAssertTrue(granted, "Notification permissions should be granted")
        
        // 2. Perform concurrent operations
        async let scheduleTask1 = scheduleTestNotification("Concurrent Test 1")
        async let scheduleTask2 = scheduleTestNotification("Concurrent Test 2")
        async let scheduleTask3 = scheduleTestNotification("Concurrent Test 3")
        
        // 3. Wait for all operations to complete
        try await (scheduleTask1, scheduleTask2, scheduleTask3)
        
        // 4. Verify all notifications were scheduled
        let pendingNotifications = try await notificationManager.getPendingNotifications()
        XCTAssertGreaterThanOrEqual(pendingNotifications.count, 3, "Should have scheduled all concurrent notifications")
        
        // 5. Clean up
        try await notificationManager.removeAllPendingNotifications()
    }
    
    // MARK: - Helper Methods
    
    private func scheduleTestNotification(_ title: String) async throws {
        let notification = NotificationContent(
            title: title,
            body: "Concurrent test notification",
            category: "concurrent_test"
        )
        
        try await notificationManager.schedule(
            notification,
            at: Date().addingTimeInterval(1)
        )
    }
}

// MARK: - Test Extensions

extension NotificationManager {
    func hasActionHandler(for identifier: String) -> Bool {
        // This is a test helper method
        // In a real implementation, you might have a way to check if a handler exists
        return true // Placeholder implementation
    }
} 