//
//  NotificationKitTests.swift
//  NotificationKitTests
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import XCTest
import UserNotifications
@testable import NotificationKit

final class NotificationKitTests: XCTestCase {
    
    // MARK: - Notification Builder Tests
    
    func testNotificationBuilder() {
        let notification = Notification(id: "test-1")
            .title("Test Title")
            .subtitle("Test Subtitle")
            .body("Test Body")
            .badge(5)
            .category("TEST_CATEGORY")
            .thread("conversation-1")
            .relevanceScore(0.8)
        
        XCTAssertEqual(notification.id, "test-1")
        XCTAssertEqual(notification.title, "Test Title")
        XCTAssertEqual(notification.subtitle, "Test Subtitle")
        XCTAssertEqual(notification.body, "Test Body")
        XCTAssertEqual(notification.badge, 5)
        XCTAssertEqual(notification.categoryIdentifier, "TEST_CATEGORY")
        XCTAssertEqual(notification.threadIdentifier, "conversation-1")
        XCTAssertEqual(notification.relevanceScore, 0.8)
    }
    
    func testNotificationTimeSensitive() {
        let notification = Notification(id: "urgent")
            .title("Urgent Alert")
            .timeSensitive()
        
        XCTAssertEqual(notification.interruptionLevel, .timeSensitive)
    }
    
    func testNotificationCritical() {
        let notification = Notification(id: "critical")
            .title("Critical Alert")
            .critical()
        
        XCTAssertEqual(notification.interruptionLevel, .critical)
    }
    
    func testNotificationDeepLink() {
        let notification = Notification(id: "deep")
            .title("Check this out")
            .deepLink("/product/123")
        
        XCTAssertEqual(notification.deepLink, "/product/123")
        XCTAssertEqual(notification.userInfo["deepLink"] as? String, "/product/123")
    }
    
    func testNotificationPriority() {
        let notification = Notification(id: "high")
            .title("High Priority")
            .priority(.high)
        
        XCTAssertEqual(notification.priority, .high)
    }
    
    func testNotificationPersonalization() {
        let data = PersonalizationData(userName: "John")
            .value("product", "iPhone")
        
        let notification = Notification(id: "personal")
            .title("Hey {{name}}!")
            .body("Check out the new {{product}}")
            .personalize(data)
        
        XCTAssertEqual(notification.title, "Hey John!")
        XCTAssertEqual(notification.body, "Check out the new iPhone")
    }
    
    // MARK: - Trigger Tests
    
    func testTriggerImmediate() {
        let trigger = NotificationTrigger.immediate
        XCTAssertNil(trigger.toUNTrigger())
    }
    
    func testTriggerTimeInterval() {
        let trigger = NotificationTrigger.timeInterval(60)
        let unTrigger = trigger.toUNTrigger()
        
        XCTAssertNotNil(unTrigger)
        XCTAssertTrue(unTrigger is UNTimeIntervalNotificationTrigger)
    }
    
    func testTriggerDaily() {
        let trigger = NotificationTrigger.daily(at: 9, minute: 30)
        let unTrigger = trigger.toUNTrigger()
        
        XCTAssertNotNil(unTrigger)
        XCTAssertTrue(unTrigger is UNCalendarNotificationTrigger)
    }
    
    func testTriggerWeekly() {
        let trigger = NotificationTrigger.weekly(on: .monday, at: 10, minute: 0)
        let unTrigger = trigger.toUNTrigger()
        
        XCTAssertNotNil(unTrigger)
        XCTAssertTrue(unTrigger is UNCalendarNotificationTrigger)
    }
    
    func testTriggerAfterMinutes() {
        let trigger = NotificationTrigger.after(minutes: 30)
        let unTrigger = trigger.toUNTrigger() as? UNTimeIntervalNotificationTrigger
        
        XCTAssertNotNil(unTrigger)
        XCTAssertEqual(unTrigger?.timeInterval, 1800)
    }
    
    func testTriggerNextFireDate() {
        let trigger = NotificationTrigger.after(hours: 2)
        let fireDate = trigger.nextFireDate
        
        XCTAssertNotNil(fireDate)
        XCTAssertTrue(fireDate! > Date())
    }
    
    // MARK: - Category Tests
    
    func testCategoryBuilder() {
        let category = NotificationCategory(identifier: "MESSAGE")
            .action(.view)
            .action(.reply)
            .action(.dismiss)
        
        XCTAssertEqual(category.identifier, "MESSAGE")
        XCTAssertEqual(category.actions.count, 3)
    }
    
    func testActionBuilder() {
        let action = NotificationAction(identifier: "SNOOZE", title: "Snooze")
            .foreground()
        
        XCTAssertEqual(action.identifier, "SNOOZE")
        XCTAssertEqual(action.title, "Snooze")
        XCTAssertTrue(action.options.contains(.foreground))
    }
    
    func testActionDestructive() {
        let action = NotificationAction(identifier: "DELETE", title: "Delete")
            .destructive()
            .authenticationRequired()
        
        XCTAssertTrue(action.options.contains(.destructive))
        XCTAssertTrue(action.options.contains(.authenticationRequired))
    }
    
    func testTextInputAction() {
        let action = NotificationAction(identifier: "REPLY", title: "Reply")
            .textInput(buttonTitle: "Send", placeholder: "Type here...")
        
        XCTAssertEqual(action.textInputButtonTitle, "Send")
        XCTAssertEqual(action.textInputPlaceholder, "Type here...")
    }
    
    // MARK: - Channel Tests
    
    func testChannelCreation() {
        let channel = NotificationChannel(
            id: "promotions",
            name: "Promotions",
            description: "Sales and offers",
            importance: .low
        )
        
        XCTAssertEqual(channel.id, "promotions")
        XCTAssertEqual(channel.name, "Promotions")
        XCTAssertEqual(channel.importance, .low)
        XCTAssertTrue(channel.isEnabled)
    }
    
    func testChannelBuilder() {
        let channel = NotificationChannel.alerts
            .group("important")
            .sound("alert.wav")
            .bypassDoNotDisturb()
        
        XCTAssertEqual(channel.groupId, "important")
        XCTAssertEqual(channel.sound, "alert.wav")
        XCTAssertTrue(channel.bypassDND)
    }
    
    // MARK: - Configuration Tests
    
    func testQuietHoursConfiguration() {
        let config = QuietHoursConfiguration.nightTime
        
        XCTAssertEqual(config.startTime, "22:00")
        XCTAssertEqual(config.endTime, "08:00")
    }
    
    func testRateLimitingConfiguration() {
        let config = RateLimitingConfiguration.moderate
        
        XCTAssertEqual(config.maxPerHour, 5)
        XCTAssertEqual(config.maxPerDay, 20)
    }
    
    // MARK: - A/B Testing Tests
    
    func testABExperimentCreation() {
        let experiment = ABExperiment.titleTest(
            id: "title-test-1",
            name: "Title A/B Test",
            titleA: "Check this out!",
            titleB: "You won't believe this!"
        )
        
        XCTAssertEqual(experiment.id, "title-test-1")
        XCTAssertEqual(experiment.variants.count, 2)
        XCTAssertTrue(experiment.isActive)
    }
    
    func testABVariantBuilder() {
        let variant = ABVariant(id: "A", name: "Control", weight: 0.5)
            .title("Original Title")
            .body("Original Body")
        
        XCTAssertEqual(variant.weight, 0.5)
        XCTAssertEqual(variant.overrides["title"] as? String, "Original Title")
        XCTAssertEqual(variant.overrides["body"] as? String, "Original Body")
    }
    
    // MARK: - Time Range Tests
    
    func testTimeRange() {
        let range = TimeRange.workHours
        
        XCTAssertEqual(range.startHour, 9)
        XCTAssertEqual(range.endHour, 17)
    }
    
    // MARK: - Frequency Tests
    
    func testNotificationFrequency() {
        XCTAssertEqual(NotificationFrequency.all.displayName, "All Notifications")
        XCTAssertEqual(NotificationFrequency.important.displayName, "Important Only")
        XCTAssertEqual(NotificationFrequency.minimal.displayName, "Minimal")
        XCTAssertEqual(NotificationFrequency.none.displayName, "Critical Only")
    }
    
    // MARK: - Time Window Tests
    
    func testTimeWindow() {
        let window = TimeWindow.next(hours: 24)
        
        XCTAssertTrue(window.end > window.start)
        XCTAssertEqual(
            window.end.timeIntervalSince(window.start),
            86400,
            accuracy: 1
        )
    }
    
    // MARK: - Attachment Tests
    
    func testAttachmentBuilder() {
        let url = URL(string: "https://example.com/image.jpg")!
        var attachment = NotificationAttachment(url: url)
            .identifier("main-image")
        attachment.type = .image
        
        XCTAssertEqual(attachment.identifier, "main-image")
        XCTAssertEqual(attachment.type, .image)
        XCTAssertTrue(attachment.showThumbnail)
    }
    
    func testAttachmentValidation() {
        let url = URL(string: "https://example.com/image.jpg")!
        let validation = RichNotificationSupport.validateAttachment(url)
        
        XCTAssertTrue(validation.isValid)
    }
    
    // MARK: - Recurrence Pattern Tests
    
    func testRecurrencePatternDaily() {
        let pattern = RecurrencePattern.daily(hour: 9, minute: 0)
        
        switch pattern {
        case .daily(let hour, let minute):
            XCTAssertEqual(hour, 9)
            XCTAssertEqual(minute, 0)
        default:
            XCTFail("Expected daily pattern")
        }
    }
    
    // MARK: - TimeInterval Extension Tests
    
    func testTimeIntervalMinutes() {
        let interval = TimeInterval.minutes(5)
        XCTAssertEqual(interval, 300)
    }
    
    func testTimeIntervalHours() {
        let interval = TimeInterval.hours(2)
        XCTAssertEqual(interval, 7200)
    }
    
    func testTimeIntervalDays() {
        let interval = TimeInterval.days(1)
        XCTAssertEqual(interval, 86400)
    }
    
    // MARK: - Weekday Constants Tests
    
    func testWeekdayConstants() {
        XCTAssertEqual(Int.sunday, 1)
        XCTAssertEqual(Int.monday, 2)
        XCTAssertEqual(Int.tuesday, 3)
        XCTAssertEqual(Int.wednesday, 4)
        XCTAssertEqual(Int.thursday, 5)
        XCTAssertEqual(Int.friday, 6)
        XCTAssertEqual(Int.saturday, 7)
    }
    
    // MARK: - Error Tests
    
    func testNotificationKitErrors() {
        let error = NotificationKitError.rateLimitExceeded
        XCTAssertEqual(error.errorDescription, "Rate limit exceeded for notifications")
    }
    
    func testDeepLinkErrors() {
        let error = DeepLinkError.noHandler("/unknown")
        XCTAssertEqual(error.errorDescription, "No handler registered for path: /unknown")
    }
    
    #if os(iOS)
    func testLocationErrors() {
        let error = LocationNotificationError.maxGeofencesReached
        XCTAssertEqual(error.errorDescription, "Maximum number of geofences (20) reached")
    }
    #endif
}
