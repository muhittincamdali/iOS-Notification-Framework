//
//  NotificationKitTests.swift
//  NotificationKitTests
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import XCTest
@testable import NotificationKit
import UserNotifications

final class NotificationKitTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: NotificationKit!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        sut = NotificationKit()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Notification Builder Tests
    
    func testNotificationBuilder() {
        let notification = Notification(id: "test-1")
            .title("Test Title")
            .subtitle("Test Subtitle")
            .body("Test Body")
            .sound(.default)
            .badge(5)
        
        XCTAssertEqual(notification.id, "test-1")
        XCTAssertEqual(notification.title, "Test Title")
        XCTAssertEqual(notification.subtitle, "Test Subtitle")
        XCTAssertEqual(notification.body, "Test Body")
        XCTAssertNotNil(notification.sound)
        XCTAssertEqual(notification.badge, 5)
    }
    
    func testNotificationWithCategory() {
        let notification = Notification(id: "test-2")
            .title("Alert")
            .category("ALERT_CATEGORY")
            .thread("conversation-1")
        
        XCTAssertEqual(notification.categoryIdentifier, "ALERT_CATEGORY")
        XCTAssertEqual(notification.threadIdentifier, "conversation-1")
    }
    
    func testNotificationWithTimeSensitive() {
        let notification = Notification(id: "test-3")
            .title("Urgent")
            .timeSensitive()
        
        XCTAssertEqual(notification.interruptionLevel, .timeSensitive)
    }
    
    func testNotificationWithRelevanceScore() {
        let notification = Notification(id: "test-4")
            .title("Important")
            .relevanceScore(0.8)
        
        XCTAssertEqual(notification.relevanceScore, 0.8)
    }
    
    func testRelevanceScoreClamping() {
        let notification1 = Notification(id: "test-5")
            .relevanceScore(1.5)
        
        let notification2 = Notification(id: "test-6")
            .relevanceScore(-0.5)
        
        XCTAssertEqual(notification1.relevanceScore, 1.0)
        XCTAssertEqual(notification2.relevanceScore, 0.0)
    }
    
    // MARK: - Trigger Tests
    
    func testTimeIntervalTrigger() {
        let trigger = NotificationTrigger.timeInterval(60)
        let unTrigger = trigger.toUNTrigger() as? UNTimeIntervalNotificationTrigger
        
        XCTAssertNotNil(unTrigger)
        XCTAssertEqual(unTrigger?.timeInterval, 60)
        XCTAssertFalse(unTrigger?.repeats ?? true)
    }
    
    func testTimeIntervalTriggerRepeating() {
        let trigger = NotificationTrigger.timeInterval(3600, repeats: true)
        let unTrigger = trigger.toUNTrigger() as? UNTimeIntervalNotificationTrigger
        
        XCTAssertNotNil(unTrigger)
        XCTAssertTrue(unTrigger?.repeats ?? false)
    }
    
    func testCalendarTrigger() {
        var components = DateComponents()
        components.hour = 9
        components.minute = 30
        
        let trigger = NotificationTrigger.date(components, repeats: true)
        let unTrigger = trigger.toUNTrigger() as? UNCalendarNotificationTrigger
        
        XCTAssertNotNil(unTrigger)
        XCTAssertEqual(unTrigger?.dateComponents.hour, 9)
        XCTAssertEqual(unTrigger?.dateComponents.minute, 30)
    }
    
    func testDailyTrigger() {
        let trigger = NotificationTrigger.daily(at: 8, minute: 0)
        let unTrigger = trigger.toUNTrigger() as? UNCalendarNotificationTrigger
        
        XCTAssertNotNil(unTrigger)
        XCTAssertEqual(unTrigger?.dateComponents.hour, 8)
        XCTAssertEqual(unTrigger?.dateComponents.minute, 0)
        XCTAssertTrue(unTrigger?.repeats ?? false)
    }
    
    func testWeeklyTrigger() {
        let trigger = NotificationTrigger.weekly(on: 2, at: 10, minute: 30)
        let unTrigger = trigger.toUNTrigger() as? UNCalendarNotificationTrigger
        
        XCTAssertNotNil(unTrigger)
        XCTAssertEqual(unTrigger?.dateComponents.weekday, 2)
        XCTAssertEqual(unTrigger?.dateComponents.hour, 10)
        XCTAssertEqual(unTrigger?.dateComponents.minute, 30)
    }
    
    func testImmediateTrigger() {
        let trigger = NotificationTrigger.immediate
        let unTrigger = trigger.toUNTrigger()
        
        XCTAssertNil(unTrigger)
    }
    
    // MARK: - Convenience Time Methods
    
    func testAfterMinutes() {
        let trigger = NotificationTrigger.after(minutes: 5)
        let unTrigger = trigger.toUNTrigger() as? UNTimeIntervalNotificationTrigger
        
        XCTAssertEqual(unTrigger?.timeInterval, 300)
    }
    
    func testAfterHours() {
        let trigger = NotificationTrigger.after(hours: 2)
        let unTrigger = trigger.toUNTrigger() as? UNTimeIntervalNotificationTrigger
        
        XCTAssertEqual(unTrigger?.timeInterval, 7200)
    }
    
    // MARK: - Category Tests
    
    func testCategoryCreation() {
        let category = NotificationCategory(identifier: "MESSAGE")
            .action(.view)
            .action(.reply)
        
        XCTAssertEqual(category.identifier, "MESSAGE")
        XCTAssertEqual(category.actions.count, 2)
    }
    
    func testCategoryOptions() {
        let category = NotificationCategory(identifier: "ALERT")
            .options([.customDismissAction, .allowInCarPlay])
        
        XCTAssertTrue(category.options.contains(.customDismissAction))
        XCTAssertTrue(category.options.contains(.allowInCarPlay))
    }
    
    // MARK: - Action Tests
    
    func testActionCreation() {
        let action = NotificationAction(identifier: "OPEN", title: "Open")
            .foreground()
        
        XCTAssertEqual(action.identifier, "OPEN")
        XCTAssertEqual(action.title, "Open")
        XCTAssertTrue(action.options.contains(.foreground))
    }
    
    func testDestructiveAction() {
        let action = NotificationAction(identifier: "DELETE", title: "Delete")
            .destructive()
            .authenticationRequired()
        
        XCTAssertTrue(action.options.contains(.destructive))
        XCTAssertTrue(action.options.contains(.authenticationRequired))
    }
    
    func testTextInputAction() {
        let action = NotificationAction(identifier: "REPLY", title: "Reply")
            .textInput(buttonTitle: "Send", placeholder: "Message...")
        
        XCTAssertEqual(action.textInputButtonTitle, "Send")
        XCTAssertEqual(action.textInputPlaceholder, "Message...")
    }
    
    func testCommonActions() {
        XCTAssertEqual(NotificationAction.view.identifier, "VIEW")
        XCTAssertEqual(NotificationAction.dismiss.identifier, "DISMISS")
        XCTAssertEqual(NotificationAction.reply.identifier, "REPLY")
        XCTAssertEqual(NotificationAction.delete.identifier, "DELETE")
    }
    
    // MARK: - Request Conversion Tests
    
    func testNotificationToRequest() {
        let notification = Notification(id: "convert-test")
            .title("Title")
            .body("Body")
            .sound(.default)
            .category("TEST")
            .trigger(after: 60)
        
        let request = notification.toRequest()
        
        XCTAssertEqual(request.identifier, "convert-test")
        XCTAssertEqual(request.content.title, "Title")
        XCTAssertEqual(request.content.body, "Body")
        XCTAssertEqual(request.content.categoryIdentifier, "TEST")
        XCTAssertNotNil(request.trigger)
    }
    
    // MARK: - TimeInterval Extension Tests
    
    func testTimeIntervalMinutes() {
        XCTAssertEqual(TimeInterval.minutes(5), 300)
    }
    
    func testTimeIntervalHours() {
        XCTAssertEqual(TimeInterval.hours(2), 7200)
    }
    
    func testTimeIntervalDays() {
        XCTAssertEqual(TimeInterval.days(1), 86400)
    }
}
