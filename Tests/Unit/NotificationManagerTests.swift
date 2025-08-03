import XCTest
import UserNotifications
@testable import iOSNotificationFramework

@available(iOS 15.0, *)
final class NotificationManagerTests: XCTestCase {
    
    var notificationManager: NotificationManager!
    
    override func setUpWithError() throws {
        super.setUp()
        notificationManager = NotificationManager.shared
    }
    
    override func tearDownWithError() throws {
        notificationManager = nil
        super.tearDown()
    }
    
    // MARK: - Configuration Tests
    func testConfiguration() {
        let config = NotificationManager.Configuration(
            appName: "TestApp",
            defaultSound: .default,
            defaultBadge: 1,
            enableAnalytics: true,
            enableRichMedia: true,
            enableCustomActions: true
        )
        
        notificationManager.configure(with: config)
        
        // Configuration should be set without errors
        XCTAssertNotNil(notificationManager)
    }
    
    // MARK: - Notification Request Tests
    func testSimpleNotificationRequest() {
        let request = NotificationRequest.simple(
            title: "Test Title",
            body: "Test Body"
        )
        
        XCTAssertEqual(request.title, "Test Title")
        XCTAssertEqual(request.body, "Test Body")
        XCTAssertTrue(request.isValid)
        XCTAssertTrue(request.validationErrors.isEmpty)
    }
    
    func testScheduledNotificationRequest() {
        let request = NotificationRequest.scheduled(
            title: "Scheduled Title",
            body: "Scheduled Body",
            timeInterval: 60
        )
        
        XCTAssertEqual(request.title, "Scheduled Title")
        XCTAssertEqual(request.body, "Scheduled Body")
        
        switch request.trigger {
        case .timeInterval(let interval):
            XCTAssertEqual(interval, 60)
        default:
            XCTFail("Expected timeInterval trigger")
        }
    }
    
    func testRichNotificationRequest() {
        let imageURL = URL(string: "https://example.com/image.jpg")!
        let request = NotificationRequest.rich(
            title: "Rich Title",
            body: "Rich Body",
            imageURL: imageURL
        )
        
        XCTAssertEqual(request.title, "Rich Title")
        XCTAssertEqual(request.body, "Rich Body")
        XCTAssertEqual(request.imageURL, imageURL)
    }
    
    func testNotificationRequestWithDeepLink() {
        let deepLink = "myapp://feature/screen"
        let request = NotificationRequest.withDeepLink(
            title: "Deep Link Title",
            body: "Deep Link Body",
            deepLink: deepLink
        )
        
        XCTAssertEqual(request.title, "Deep Link Title")
        XCTAssertEqual(request.body, "Deep Link Body")
        XCTAssertEqual(request.deepLink, deepLink)
    }
    
    // MARK: - Builder Pattern Tests
    func testNotificationRequestBuilder() {
        let request = NotificationRequest.builder()
            .title("Builder Title")
            .body("Builder Body")
            .subtitle("Builder Subtitle")
            .priority(.high)
            .build()
        
        XCTAssertEqual(request.title, "Builder Title")
        XCTAssertEqual(request.body, "Builder Body")
        XCTAssertEqual(request.subtitle, "Builder Subtitle")
        XCTAssertEqual(request.priority, .high)
    }
    
    func testNotificationRequestBuilderWithAllProperties() {
        let imageURL = URL(string: "https://example.com/image.jpg")!
        let deepLink = "myapp://feature/screen"
        let customData = ["key": "value"]
        
        let request = NotificationRequest.builder()
            .title("Complete Title")
            .body("Complete Body")
            .subtitle("Complete Subtitle")
            .sound(.default)
            .badge(NSNumber(value: 5))
            .categoryIdentifier("test_category")
            .userInfo(["test": "value"])
            .trigger(.timeInterval(120))
            .imageURL(imageURL)
            .deepLink(deepLink)
            .priority(.critical)
            .expirationDate(Date().addingTimeInterval(3600))
            .customData(customData)
            .build()
        
        XCTAssertEqual(request.title, "Complete Title")
        XCTAssertEqual(request.body, "Complete Body")
        XCTAssertEqual(request.subtitle, "Complete Subtitle")
        XCTAssertEqual(request.sound, .default)
        XCTAssertEqual(request.badge, NSNumber(value: 5))
        XCTAssertEqual(request.categoryIdentifier, "test_category")
        XCTAssertEqual(request.userInfo["test"] as? String, "value")
        XCTAssertEqual(request.imageURL, imageURL)
        XCTAssertEqual(request.deepLink, deepLink)
        XCTAssertEqual(request.priority, .critical)
        XCTAssertNotNil(request.expirationDate)
        XCTAssertEqual(request.customData["key"] as? String, "value")
    }
    
    // MARK: - Validation Tests
    func testValidNotificationRequest() {
        let request = NotificationRequest(
            identifier: "test_id",
            title: "Test Title",
            body: "Test Body"
        )
        
        XCTAssertTrue(request.isValid)
        XCTAssertTrue(request.validationErrors.isEmpty)
    }
    
    func testInvalidNotificationRequest() {
        let request = NotificationRequest(
            identifier: "",
            title: "",
            body: ""
        )
        
        XCTAssertFalse(request.isValid)
        XCTAssertFalse(request.validationErrors.isEmpty)
        XCTAssertTrue(request.validationErrors.contains("Identifier cannot be empty"))
        XCTAssertTrue(request.validationErrors.contains("Title cannot be empty"))
        XCTAssertTrue(request.validationErrors.contains("Body cannot be empty"))
    }
    
    func testNotificationRequestWithPastExpirationDate() {
        let pastDate = Date().addingTimeInterval(-3600)
        let request = NotificationRequest(
            identifier: "test_id",
            title: "Test Title",
            body: "Test Body",
            expirationDate: pastDate
        )
        
        XCTAssertTrue(request.validationErrors.contains("Expiration date cannot be in the past"))
    }
    
    // MARK: - Priority Tests
    func testNotificationPriorityMapping() {
        XCTAssertEqual(NotificationPriority.low.userNotificationPriority, .low)
        XCTAssertEqual(NotificationPriority.normal.userNotificationPriority, .normal)
        XCTAssertEqual(NotificationPriority.high.userNotificationPriority, .high)
        XCTAssertEqual(NotificationPriority.critical.userNotificationPriority, .critical)
    }
    
    // MARK: - Trigger Tests
    func testNotificationTriggers() {
        // Immediate trigger
        let immediateRequest = NotificationRequest(
            identifier: "immediate",
            title: "Immediate",
            body: "Immediate",
            trigger: .immediate
        )
        
        switch immediateRequest.trigger {
        case .immediate:
            break
        default:
            XCTFail("Expected immediate trigger")
        }
        
        // Time interval trigger
        let intervalRequest = NotificationRequest(
            identifier: "interval",
            title: "Interval",
            body: "Interval",
            trigger: .timeInterval(300)
        )
        
        switch intervalRequest.trigger {
        case .timeInterval(let interval):
            XCTAssertEqual(interval, 300)
        default:
            XCTFail("Expected timeInterval trigger")
        }
        
        // Calendar trigger
        let dateComponents = DateComponents(year: 2024, month: 1, day: 1, hour: 12, minute: 0)
        let calendarRequest = NotificationRequest(
            identifier: "calendar",
            title: "Calendar",
            body: "Calendar",
            trigger: .calendar(dateComponents)
        )
        
        switch calendarRequest.trigger {
        case .calendar(let components):
            XCTAssertEqual(components.year, 2024)
            XCTAssertEqual(components.month, 1)
            XCTAssertEqual(components.day, 1)
        default:
            XCTFail("Expected calendar trigger")
        }
    }
    
    // MARK: - Error Tests
    func testNotificationErrorDescriptions() {
        let testError = NSError(domain: "TestDomain", code: 1, userInfo: nil)
        
        let schedulingError = NotificationError.schedulingFailed(testError)
        XCTAssertTrue(schedulingError.errorDescription?.contains("Failed to schedule notification") == true)
        
        let multipleError = NotificationError.multipleSchedulingFailed([schedulingError])
        XCTAssertTrue(multipleError.errorDescription?.contains("Failed to schedule multiple notifications") == true)
        
        let permissionError = NotificationError.permissionDenied
        XCTAssertEqual(permissionError.errorDescription, "Notification permissions not granted")
        
        let invalidError = NotificationError.invalidRequest
        XCTAssertEqual(invalidError.errorDescription, "Invalid notification request")
    }
    
    // MARK: - Performance Tests
    func testNotificationRequestCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = NotificationRequest.simple(
                    title: "Performance Test",
                    body: "Performance Test Body"
                )
            }
        }
    }
    
    func testNotificationRequestBuilderPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = NotificationRequest.builder()
                    .title("Builder Performance")
                    .body("Builder Performance Body")
                    .build()
            }
        }
    }
    
    func testNotificationValidationPerformance() {
        let request = NotificationRequest.simple(
            title: "Validation Test",
            body: "Validation Test Body"
        )
        
        measure {
            for _ in 0..<10000 {
                _ = request.isValid
                _ = request.validationErrors
            }
        }
    }
} 