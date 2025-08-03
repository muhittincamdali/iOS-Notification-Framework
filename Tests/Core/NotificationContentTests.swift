//
//  NotificationContentTests.swift
//  NotificationFrameworkTests
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import XCTest
import UserNotifications
@testable import NotificationFramework

@available(iOS 15.0, *)
final class NotificationContentTests: XCTestCase {
    
    // MARK: - NotificationContent Tests
    
    func testNotificationContentInitialization() {
        let content = NotificationContent(
            title: "Test Title",
            body: "Test Body",
            category: "test",
            sound: .default,
            badge: 1
        )
        
        XCTAssertEqual(content.title, "Test Title")
        XCTAssertEqual(content.body, "Test Body")
        XCTAssertEqual(content.category, "test")
        XCTAssertEqual(content.sound, .default)
        XCTAssertEqual(content.badge, 1)
    }
    
    func testNotificationContentDefaultValues() {
        let content = NotificationContent(
            title: "Test",
            body: "Test"
        )
        
        XCTAssertEqual(content.category, "default")
        XCTAssertEqual(content.sound, .default)
        XCTAssertNil(content.badge)
        XCTAssertTrue(content.userInfo.isEmpty)
        XCTAssertNil(content.threadIdentifier)
        XCTAssertNil(content.targetContentIdentifier)
        XCTAssertEqual(content.interruptionLevel, .active)
        XCTAssertEqual(content.relevanceScore, 0.5)
        XCTAssertTrue(content.actions.isEmpty)
        XCTAssertEqual(content.priority, .normal)
        XCTAssertFalse(content.isSilent)
    }
    
    func testNotificationContentWithAllProperties() {
        let userInfo = ["key": "value"]
        let actions = [
            NotificationAction(title: "Action 1", identifier: "action1"),
            NotificationAction(title: "Action 2", identifier: "action2")
        ]
        
        let content = NotificationContent(
            title: "Test Title",
            body: "Test Body",
            category: "test",
            sound: .default,
            badge: 5,
            userInfo: userInfo,
            threadIdentifier: "thread1",
            targetContentIdentifier: "target1",
            interruptionLevel: .critical,
            relevanceScore: 0.8,
            actions: actions,
            priority: .high,
            isSilent: true
        )
        
        XCTAssertEqual(content.title, "Test Title")
        XCTAssertEqual(content.body, "Test Body")
        XCTAssertEqual(content.category, "test")
        XCTAssertEqual(content.sound, .default)
        XCTAssertEqual(content.badge, 5)
        XCTAssertEqual(content.userInfo["key"] as? String, "value")
        XCTAssertEqual(content.threadIdentifier, "thread1")
        XCTAssertEqual(content.targetContentIdentifier, "target1")
        XCTAssertEqual(content.interruptionLevel, .critical)
        XCTAssertEqual(content.relevanceScore, 0.8)
        XCTAssertEqual(content.actions.count, 2)
        XCTAssertEqual(content.priority, .high)
        XCTAssertTrue(content.isSilent)
    }
    
    // MARK: - RichNotificationContent Tests
    
    func testRichNotificationContentInitialization() {
        let baseContent = NotificationContent(
            title: "Test Title",
            body: "Test Body"
        )
        
        let richContent = RichNotificationContent(
            content: baseContent,
            mediaURL: URL(string: "https://example.com/image.jpg"),
            mediaType: .image
        )
        
        XCTAssertEqual(richContent.content.title, "Test Title")
        XCTAssertEqual(richContent.content.body, "Test Body")
        XCTAssertEqual(richContent.mediaURL?.absoluteString, "https://example.com/image.jpg")
        XCTAssertEqual(richContent.mediaType, .image)
    }
    
    func testRichNotificationContentWithAllProperties() {
        let baseContent = NotificationContent(
            title: "Test Title",
            body: "Test Body"
        )
        
        let thumbnailData = "test data".data(using: .utf8)
        
        let richContent = RichNotificationContent(
            content: baseContent,
            mediaURL: URL(string: "https://example.com/video.mp4"),
            mediaType: .video,
            thumbnailData: thumbnailData,
            duration: 120.0,
            subtitle: "Test Subtitle",
            summaryArgument: "Test Summary",
            summaryArgumentCount: 5
        )
        
        XCTAssertEqual(richContent.content.title, "Test Title")
        XCTAssertEqual(richContent.content.body, "Test Body")
        XCTAssertEqual(richContent.mediaURL?.absoluteString, "https://example.com/video.mp4")
        XCTAssertEqual(richContent.mediaType, .video)
        XCTAssertEqual(richContent.thumbnailData, thumbnailData)
        XCTAssertEqual(richContent.duration, 120.0)
        XCTAssertEqual(richContent.subtitle, "Test Subtitle")
        XCTAssertEqual(richContent.summaryArgument, "Test Summary")
        XCTAssertEqual(richContent.summaryArgumentCount, 5)
    }
    
    func testRichNotificationContentConvenienceInitializer() {
        let richContent = RichNotificationContent(
            title: "Test Title",
            body: "Test Body",
            mediaURL: URL(string: "https://example.com/image.jpg"),
            actions: [
                NotificationAction(title: "View", identifier: "view_action")
            ]
        )
        
        XCTAssertEqual(richContent.content.title, "Test Title")
        XCTAssertEqual(richContent.content.body, "Test Body")
        XCTAssertEqual(richContent.mediaURL?.absoluteString, "https://example.com/image.jpg")
        XCTAssertEqual(richContent.content.actions.count, 1)
    }
    
    // MARK: - NotificationAction Tests
    
    func testNotificationActionInitialization() {
        let action = NotificationAction(
            title: "Test Action",
            identifier: "test_action",
            options: [.foreground],
            icon: nil,
            textInputButtonTitle: "Send",
            textInputPlaceholder: "Enter text"
        )
        
        XCTAssertEqual(action.title, "Test Action")
        XCTAssertEqual(action.identifier, "test_action")
        XCTAssertEqual(action.options, [.foreground])
        XCTAssertNil(action.icon)
        XCTAssertEqual(action.textInputButtonTitle, "Send")
        XCTAssertEqual(action.textInputPlaceholder, "Enter text")
    }
    
    func testNotificationActionDefaultValues() {
        let action = NotificationAction(
            title: "Test Action",
            identifier: "test_action"
        )
        
        XCTAssertEqual(action.title, "Test Action")
        XCTAssertEqual(action.identifier, "test_action")
        XCTAssertTrue(action.options.isEmpty)
        XCTAssertNil(action.icon)
        XCTAssertNil(action.textInputButtonTitle)
        XCTAssertNil(action.textInputPlaceholder)
    }
    
    // MARK: - NotificationPriority Tests
    
    func testNotificationPriorityCases() {
        XCTAssertEqual(NotificationPriority.low.rawValue, 0)
        XCTAssertEqual(NotificationPriority.normal.rawValue, 1)
        XCTAssertEqual(NotificationPriority.high.rawValue, 2)
        XCTAssertEqual(NotificationPriority.critical.rawValue, 3)
    }
    
    func testNotificationPriorityDisplayNames() {
        XCTAssertEqual(NotificationPriority.low.displayName, "Low")
        XCTAssertEqual(NotificationPriority.normal.displayName, "Normal")
        XCTAssertEqual(NotificationPriority.high.displayName, "High")
        XCTAssertEqual(NotificationPriority.critical.displayName, "Critical")
    }
    
    func testNotificationPriorityAuthorizationOptions() {
        XCTAssertEqual(NotificationPriority.low.authorizationOptions, [.alert, .sound])
        XCTAssertEqual(NotificationPriority.normal.authorizationOptions, [.alert, .sound, .badge])
        XCTAssertEqual(NotificationPriority.high.authorizationOptions, [.alert, .sound, .badge, .provisional])
        XCTAssertEqual(NotificationPriority.critical.authorizationOptions, [.alert, .sound, .badge, .provisional, .criticalAlert])
    }
    
    // MARK: - MediaType Tests
    
    func testMediaTypeCases() {
        XCTAssertEqual(MediaType.image.rawValue, "image")
        XCTAssertEqual(MediaType.video.rawValue, "video")
        XCTAssertEqual(MediaType.audio.rawValue, "audio")
        XCTAssertEqual(MediaType.gif.rawValue, "gif")
    }
    
    func testMediaTypeFileExtensions() {
        XCTAssertEqual(MediaType.image.fileExtension, "jpg")
        XCTAssertEqual(MediaType.video.fileExtension, "mp4")
        XCTAssertEqual(MediaType.audio.fileExtension, "mp3")
        XCTAssertEqual(MediaType.gif.fileExtension, "gif")
    }
    
    func testMediaTypeMimeTypes() {
        XCTAssertEqual(MediaType.image.mimeType, "image/jpeg")
        XCTAssertEqual(MediaType.video.mimeType, "video/mp4")
        XCTAssertEqual(MediaType.audio.mimeType, "audio/mpeg")
        XCTAssertEqual(MediaType.gif.mimeType, "image/gif")
    }
    
    // MARK: - RecurringSchedule Tests
    
    func testRecurringScheduleInitialization() {
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(86400 * 7) // 7 days
        let timeComponents = DateComponents(hour: 9, minute: 0)
        
        let schedule = RecurringSchedule(
            interval: .daily,
            startDate: startDate,
            endDate: endDate,
            timeComponents: timeComponents,
            maxNotifications: 10,
            repeatsIndefinitely: false
        )
        
        XCTAssertEqual(schedule.interval, .daily)
        XCTAssertEqual(schedule.startDate, startDate)
        XCTAssertEqual(schedule.endDate, endDate)
        XCTAssertEqual(schedule.timeComponents, timeComponents)
        XCTAssertEqual(schedule.maxNotifications, 10)
        XCTAssertFalse(schedule.repeatsIndefinitely)
    }
    
    func testRecurringScheduleDefaultValues() {
        let startDate = Date()
        let timeComponents = DateComponents(hour: 9, minute: 0)
        
        let schedule = RecurringSchedule(
            interval: .weekly,
            startDate: startDate,
            timeComponents: timeComponents
        )
        
        XCTAssertEqual(schedule.interval, .weekly)
        XCTAssertEqual(schedule.startDate, startDate)
        XCTAssertNil(schedule.endDate)
        XCTAssertEqual(schedule.timeComponents, timeComponents)
        XCTAssertNil(schedule.maxNotifications)
        XCTAssertFalse(schedule.repeatsIndefinitely)
    }
    
    // MARK: - RecurringInterval Tests
    
    func testRecurringIntervalCases() {
        XCTAssertEqual(RecurringInterval.minute.rawValue, 60)
        XCTAssertEqual(RecurringInterval.hour.rawValue, 3600)
        XCTAssertEqual(RecurringInterval.daily.rawValue, 86400)
        XCTAssertEqual(RecurringInterval.weekly.rawValue, 604800)
        XCTAssertEqual(RecurringInterval.monthly.rawValue, 2592000)
        XCTAssertEqual(RecurringInterval.yearly.rawValue, 31536000)
    }
    
    func testRecurringIntervalDisplayNames() {
        XCTAssertEqual(RecurringInterval.minute.displayName, "Every Minute")
        XCTAssertEqual(RecurringInterval.hour.displayName, "Every Hour")
        XCTAssertEqual(RecurringInterval.daily.displayName, "Daily")
        XCTAssertEqual(RecurringInterval.weekly.displayName, "Weekly")
        XCTAssertEqual(RecurringInterval.monthly.displayName, "Monthly")
        XCTAssertEqual(RecurringInterval.yearly.displayName, "Yearly")
    }
    
    func testRecurringIntervalCalendarComponents() {
        XCTAssertEqual(RecurringInterval.minute.calendarComponent, .minute)
        XCTAssertEqual(RecurringInterval.hour.calendarComponent, .hour)
        XCTAssertEqual(RecurringInterval.daily.calendarComponent, .day)
        XCTAssertEqual(RecurringInterval.weekly.calendarComponent, .weekOfYear)
        XCTAssertEqual(RecurringInterval.monthly.calendarComponent, .month)
        XCTAssertEqual(RecurringInterval.yearly.calendarComponent, .year)
    }
    
    // MARK: - Performance Tests
    
    func testNotificationContentCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = NotificationContent(
                    title: "Performance Test",
                    body: "Testing content creation performance",
                    category: "test"
                )
            }
        }
    }
    
    func testRichNotificationContentCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = RichNotificationContent(
                    title: "Performance Test",
                    body: "Testing rich content creation performance",
                    mediaURL: URL(string: "https://example.com/image.jpg")
                )
            }
        }
    }
    
    func testNotificationActionCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = NotificationAction(
                    title: "Performance Test",
                    identifier: "test_action"
                )
            }
        }
    }
} 