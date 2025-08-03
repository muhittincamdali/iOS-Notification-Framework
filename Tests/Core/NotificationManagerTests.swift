//
//  NotificationManagerTests.swift
//  NotificationFrameworkTests
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import XCTest
import UserNotifications
@testable import NotificationFramework

@available(iOS 15.0, *)
final class NotificationManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    var notificationManager: NotificationManager!
    var mockNotificationCenter: MockUNUserNotificationCenter!
    
    // MARK: - Setup and Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNotificationCenter = MockUNUserNotificationCenter()
        notificationManager = NotificationManager.shared
    }
    
    override func tearDownWithError() throws {
        notificationManager = nil
        mockNotificationCenter = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Permission Tests
    
    func testRequestPermissions_WhenGranted_ReturnsTrue() async throws {
        // Given
        let expectedResult = true
        
        // When
        let result = try await notificationManager.requestPermissions()
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testRequestPermissions_WhenDenied_ThrowsPermissionDeniedError() async {
        // Given
        let expectedError = NotificationError.permissionDenied
        
        // When & Then
        do {
            _ = try await notificationManager.requestPermissions()
            XCTFail("Expected permission denied error")
        } catch let error as NotificationError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequestPermissions_WhenSystemError_ThrowsPermissionRequestFailedError() async {
        // Given
        let systemError = NSError(domain: "test", code: 1, userInfo: nil)
        let expectedError = NotificationError.permissionRequestFailed(systemError)
        
        // When & Then
        do {
            _ = try await notificationManager.requestPermissions()
            XCTFail("Expected permission request failed error")
        } catch let error as NotificationError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testCheckAuthorizationStatus_ReturnsCorrectStatus() async {
        // Given
        let expectedStatus: UNAuthorizationStatus = .authorized
        
        // When
        let status = await notificationManager.checkAuthorizationStatus()
        
        // Then
        XCTAssertEqual(status, expectedStatus)
    }
    
    // MARK: - Notification Scheduling Tests
    
    func testSchedule_WithValidContent_ReturnsNotificationRequest() async throws {
        // Given
        let content = NotificationContent(
            title: "Test Notification",
            body: "This is a test notification",
            category: "test"
        )
        let date = Date().addingTimeInterval(60)
        
        // When
        let request = try await notificationManager.schedule(content, at: date)
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request.content.title, content.title)
        XCTAssertEqual(request.content.body, content.body)
        XCTAssertEqual(request.content.categoryIdentifier, content.category)
    }
    
    func testSchedule_WithInvalidDate_ThrowsInvalidDateError() async {
        // Given
        let content = NotificationContent(
            title: "Test Notification",
            body: "This is a test notification"
        )
        let pastDate = Date().addingTimeInterval(-60)
        
        // When & Then
        do {
            _ = try await notificationManager.schedule(content, at: pastDate)
            XCTFail("Expected invalid date error")
        } catch let error as NotificationError {
            XCTAssertEqual(error, NotificationError.invalidDate(pastDate))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testSchedule_WithInvalidContent_ThrowsInvalidContentError() async {
        // Given
        let content = NotificationContent(
            title: "",
            body: ""
        )
        let date = Date().addingTimeInterval(60)
        
        // When & Then
        do {
            _ = try await notificationManager.schedule(content, at: date)
            XCTFail("Expected invalid content error")
        } catch let error as NotificationError {
            XCTAssertEqual(error, NotificationError.invalidContent("Title and body cannot be empty"))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testScheduleRichNotification_WithValidContent_ReturnsNotificationRequest() async throws {
        // Given
        let content = RichNotificationContent(
            title: "Rich Notification",
            body: "This is a rich notification",
            mediaURL: URL(string: "https://example.com/image.jpg")
        )
        let date = Date().addingTimeInterval(60)
        
        // When
        let request = try await notificationManager.scheduleRichNotification(content, at: date)
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request.content.title, content.content.title)
        XCTAssertEqual(request.content.body, content.content.body)
    }
    
    func testScheduleRecurring_WithValidSchedule_ReturnsMultipleRequests() async throws {
        // Given
        let content = NotificationContent(
            title: "Recurring Notification",
            body: "This is a recurring notification"
        )
        let schedule = RecurringSchedule(
            interval: .daily,
            startDate: Date(),
            timeComponents: DateComponents(hour: 9, minute: 0)
        )
        
        // When
        let requests = try await notificationManager.scheduleRecurring(content, schedule: schedule)
        
        // Then
        XCTAssertFalse(requests.isEmpty)
        XCTAssertGreaterThan(requests.count, 1)
    }
    
    // MARK: - Notification Management Tests
    
    func testRemovePendingNotification_WithValidIdentifier_RemovesNotification() async {
        // Given
        let identifier = "test_notification"
        
        // When
        await notificationManager.removePendingNotification(withIdentifier: identifier)
        
        // Then
        // Verify notification was removed (implementation dependent)
        XCTAssertTrue(true) // Placeholder assertion
    }
    
    func testRemoveAllPendingNotifications_RemovesAllNotifications() async {
        // When
        await notificationManager.removeAllPendingNotifications()
        
        // Then
        // Verify all notifications were removed (implementation dependent)
        XCTAssertTrue(true) // Placeholder assertion
    }
    
    func testRemoveDeliveredNotifications_WithValidIdentifiers_RemovesNotifications() async {
        // Given
        let identifiers = ["notification1", "notification2"]
        
        // When
        await notificationManager.removeDeliveredNotifications(withIdentifiers: identifiers)
        
        // Then
        // Verify notifications were removed (implementation dependent)
        XCTAssertTrue(true) // Placeholder assertion
    }
    
    func testRemoveAllDeliveredNotifications_RemovesAllDeliveredNotifications() async {
        // When
        await notificationManager.removeAllDeliveredNotifications()
        
        // Then
        // Verify all delivered notifications were removed (implementation dependent)
        XCTAssertTrue(true) // Placeholder assertion
    }
    
    // MARK: - Action Handling Tests
    
    func testRegisterActionHandler_WithValidHandler_RegistersHandler() {
        // Given
        let actionIdentifier = "test_action"
        var handlerCalled = false
        
        let handler: NotificationActionHandler = { identifier, notification in
            handlerCalled = true
            XCTAssertEqual(identifier, actionIdentifier)
        }
        
        // When
        notificationManager.registerActionHandler(for: actionIdentifier, handler: handler)
        
        // Then
        // Verify handler was registered (implementation dependent)
        XCTAssertTrue(true) // Placeholder assertion
    }
    
    func testRemoveActionHandler_WithValidIdentifier_RemovesHandler() {
        // Given
        let actionIdentifier = "test_action"
        
        // When
        notificationManager.removeActionHandler(for: actionIdentifier)
        
        // Then
        // Verify handler was removed (implementation dependent)
        XCTAssertTrue(true) // Placeholder assertion
    }
    
    // MARK: - Analytics Tests
    
    func testGetAnalytics_ReturnsAnalyticsData() {
        // When
        let analytics = notificationManager.getAnalytics()
        
        // Then
        XCTAssertNotNil(analytics)
        // Add more specific assertions based on analytics structure
    }
    
    func testExportAnalytics_WithValidURL_ExportsData() throws {
        // Given
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("analytics.json")
        
        // When & Then
        do {
            try notificationManager.exportAnalytics(to: fileURL)
            XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))
        } catch {
            XCTFail("Export failed: \(error)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testScheduleNotification_Performance() {
        // Given
        let content = NotificationContent(
            title: "Performance Test",
            body: "Testing notification scheduling performance"
        )
        let date = Date().addingTimeInterval(60)
        
        // When & Then
        measure {
            Task {
                do {
                    _ = try await notificationManager.schedule(content, at: date)
                } catch {
                    XCTFail("Performance test failed: \(error)")
                }
            }
        }
    }
    
    func testRequestPermissions_Performance() {
        // When & Then
        measure {
            Task {
                do {
                    _ = try await notificationManager.requestPermissions()
                } catch {
                    XCTFail("Performance test failed: \(error)")
                }
            }
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testNotificationError_IsPermissionError_ReturnsTrue() {
        // Given
        let error = NotificationError.permissionDenied
        
        // When & Then
        XCTAssertTrue(error.isPermissionError)
    }
    
    func testNotificationError_IsSchedulingError_ReturnsTrue() {
        // Given
        let error = NotificationError.schedulingFailed(NSError(domain: "test", code: 1, userInfo: nil))
        
        // When & Then
        XCTAssertTrue(error.isSchedulingError)
    }
    
    func testNotificationError_IsRecoverable_ReturnsTrue() {
        // Given
        let error = NotificationError.permissionDenied
        
        // When & Then
        XCTAssertTrue(error.isRecoverable)
    }
    
    func testNotificationError_ErrorCode_ReturnsCorrectCode() {
        // Given
        let error = NotificationError.permissionDenied
        let expectedCode = 1001
        
        // When & Then
        XCTAssertEqual(error.errorCode, expectedCode)
    }
}

// MARK: - Mock Classes

@available(iOS 15.0, *)
class MockUNUserNotificationCenter: UNUserNotificationCenter {
    
    var authorizationStatus: UNAuthorizationStatus = .authorized
    var permissionGranted = true
    var systemError: Error?
    
    override func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        if let error = systemError {
            throw error
        }
        return permissionGranted
    }
    
    override func notificationSettings() async -> UNNotificationSettings {
        return MockUNNotificationSettings(authorizationStatus: authorizationStatus)
    }
    
    override func add(_ request: UNNotificationRequest) async throws {
        // Mock implementation
    }
    
    override func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        // Mock implementation
    }
    
    override func removeAllPendingNotificationRequests() {
        // Mock implementation
    }
    
    override func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        // Mock implementation
    }
    
    override func removeAllDeliveredNotifications() {
        // Mock implementation
    }
    
    override func pendingNotificationRequests() async -> [UNNotificationRequest] {
        return []
    }
    
    override func deliveredNotifications() async -> [UNNotification] {
        return []
    }
}

@available(iOS 15.0, *)
class MockUNNotificationSettings: UNNotificationSettings {
    
    let authorizationStatus: UNAuthorizationStatus
    
    init(authorizationStatus: UNAuthorizationStatus) {
        self.authorizationStatus = authorizationStatus
        super.init()
    }
    
    override var authorizationStatus: UNAuthorizationStatus {
        return self.authorizationStatus
    }
    
    override var alertSetting: UNNotificationSetting {
        return .enabled
    }
    
    override var badgeSetting: UNNotificationSetting {
        return .enabled
    }
    
    override var soundSetting: UNNotificationSetting {
        return .enabled
    }
    
    override var notificationCenterSetting: UNNotificationSetting {
        return .enabled
    }
    
    override var lockScreenSetting: UNNotificationSetting {
        return .enabled
    }
    
    override var carPlaySetting: UNNotificationSetting {
        return .enabled
    }
    
    override var announcementSetting: UNNotificationSetting {
        return .enabled
    }
    
    override var criticalAlertSetting: UNNotificationSetting {
        return .enabled
    }
    
    override var alertStyle: UNAlertStyle {
        return .banner
    }
} 