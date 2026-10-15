import Foundation
import Testing
import UserNotifications
@testable import NotificationKit

@Suite("Mapping to UserNotifications")
struct SystemMappingTests {
    @Test("copies every content field")
    func content() throws {
        var notification = LocalNotification(
            id: "order", title: "Shipped", subtitle: "A-1042", body: "On its way", badge: 4, sound: .named("chime.caf"),
            categoryID: "order", threadID: "orders", userInfo: ["n": 1], interruptionLevel: .timeSensitive,
            relevanceScore: 0.7, targetContentID: "orders", filterCriteria: "work"
        )
        notification.deepLink = URL(string: "myapp://orders/A-1042")
        let content = try NotificationContentMapper.content(for: notification)
        #expect(content.title == "Shipped")
        #expect(content.subtitle == "A-1042")
        #expect(content.body == "On its way")
        #expect(content.badge == 4)
        #expect(content.categoryIdentifier == "order")
        #expect(content.threadIdentifier == "orders")
        #expect(content.interruptionLevel == .timeSensitive)
        #expect(content.relevanceScore == 0.7)
        #expect(content.targetContentIdentifier == "orders")
        #expect(content.filterCriteria == "work")
        #expect(content.userInfo["n"] as? Int == 1)
        #expect(content.userInfo["deeplink"] as? String == "myapp://orders/A-1042")
        #expect(content.sound != nil)
    }

    @Test("maps each trigger")
    func triggers() throws {
        let calendar = Fixtures.calendar()
        #expect(try NotificationContentMapper.trigger(for: .immediately, calendar: calendar) == nil)

        let interval = try #require(try NotificationContentMapper.trigger(for: .timeInterval(120, repeats: true), calendar: calendar) as? UNTimeIntervalNotificationTrigger)
        #expect(interval.timeInterval == 120)
        #expect(interval.repeats)

        let date = Fixtures.date("2026-12-24 18:30:15")
        let calendarTrigger = try #require(try NotificationContentMapper.trigger(for: .date(date), calendar: calendar) as? UNCalendarNotificationTrigger)
        #expect(!calendarTrigger.repeats)
        #expect(calendarTrigger.dateComponents.timeZone == calendar.timeZone)
        #expect(calendar.date(from: calendarTrigger.dateComponents) == date)

        let daily = try #require(try NotificationContentMapper.trigger(for: .daily(hour: 8, minute: 15), calendar: calendar) as? UNCalendarNotificationTrigger)
        #expect(daily.repeats)
        #expect(daily.dateComponents.hour == 8)
        #expect(daily.dateComponents.minute == 15)

        let region = NotificationTrigger.region(LocationRegion(identifier: "office", latitude: 41, longitude: 29, radius: 100), repeats: false)
        #if os(iOS) || os(watchOS)
        let location = try #require(try NotificationContentMapper.trigger(for: region, calendar: calendar) as? UNLocationNotificationTrigger)
        #expect(location.region.identifier == "office")
        #else
        #expect(throws: NotificationValidationError.unsupportedTrigger) { try NotificationContentMapper.trigger(for: region, calendar: calendar) }
        #endif
    }

    @Test("maps categories, actions and their options")
    func categories() throws {
        let category = NotificationCategory(
            id: "message",
            actions: [
                .textInput(id: "reply", title: "Reply", buttonTitle: "Send", placeholder: "Message", systemImageName: "arrowshape.turn.up.left"),
                .button(id: "delete", title: "Delete", options: [.destructive, .authenticationRequired]),
                .button(id: "open", title: "Open", options: .foreground)
            ],
            options: [.customDismissAction],
            hiddenPreviewsBodyPlaceholder: "%u new messages"
        )
        let mapped = NotificationContentMapper.category(for: category)
        #expect(mapped.identifier == "message")
        #expect(mapped.actions.map(\.identifier) == ["reply", "delete", "open"])
        #expect(mapped.options.contains(.customDismissAction))
        #expect(mapped.hiddenPreviewsBodyPlaceholder == "%u new messages")
        let reply = try #require(mapped.actions[0] as? UNTextInputNotificationAction)
        #expect(reply.textInputButtonTitle == "Send")
        #expect(reply.textInputPlaceholder == "Message")
        #expect(mapped.actions[1].options.contains(.destructive))
        #expect(mapped.actions[1].options.contains(.authenticationRequired))
        #expect(mapped.actions[2].options.contains(.foreground))
    }

    @Test("maps authorization options and presentation options")
    func options() {
        let options = AuthorizationOptions([.alert, .badge, .provisional]).unOptions
        #expect(options.contains(.alert))
        #expect(options.contains(.badge))
        #expect(options.contains(.provisional))
        #expect(!options.contains(.sound))
        #expect(PresentationOptions.standard.unOptions == [.banner, .list, .sound, .badge])
        #expect(PresentationOptions([]).unOptions.isEmpty)
        #expect(AuthorizationStatus(UNAuthorizationStatus.denied) == .denied)
        #expect(AuthorizationStatus(UNAuthorizationStatus.provisional) == .provisional)
    }
}

@Suite("In-memory center")
struct InMemoryCenterTests {
    let clock = TestClock(Fixtures.date("2026-10-15 12:00:00"))

    @Test("drops all but the soonest 64, like the system")
    func systemLimit() async throws {
        let clock = clock
        let center = InMemoryNotificationCenter(authorizationStatus: .authorized, now: { clock.now })
        for index in (1...70).reversed() {
            try await center.add(Fixtures.notification("n\(index)", after: TimeInterval(index * 60)))
        }
        #expect(await center.pending.count == 64)
        #expect(Set(await center.dropped.map(\.id)) == Set((65...70).map { "n\($0)" }))
    }

    @Test("delivers in order and keeps repeating notifications pending")
    func delivery() async throws {
        let clock = clock
        let center = InMemoryNotificationCenter(authorizationStatus: .authorized, now: { clock.now })
        try await center.add(LocalNotification(id: "repeat", title: "r", trigger: .timeInterval(60, repeats: true)))
        try await center.add(Fixtures.notification("once", after: 30))
        clock.advance(by: 90)
        #expect(await center.advance(to: clock.now).map(\.id) == ["once", "repeat"])
        #expect(await center.pending.map(\.id) == ["repeat"])
        // The same repetition is not delivered twice.
        #expect(await center.advance(to: clock.now).isEmpty)
        clock.advance(by: 60)
        #expect(await center.advance(to: clock.now).map(\.id) == ["repeat"])
    }

    @Test("rejects what the system would reject")
    func validation() async {
        let center = InMemoryNotificationCenter()
        await #expect(throws: NotificationValidationError.repeatingIntervalTooShort(10)) {
            try await center.add(LocalNotification(id: "x", title: "x", trigger: .timeInterval(10, repeats: true)))
        }
    }

    @Test("answers the permission prompt as configured")
    func authorization() async throws {
        let granting = InMemoryNotificationCenter()
        #expect(try await granting.requestAuthorization(options: .standard))
        #expect(await granting.authorizationStatus == .authorized)
        let provisional = InMemoryNotificationCenter()
        #expect(try await provisional.requestAuthorization(options: [.alert, .provisional]))
        #expect(await provisional.authorizationStatus == .provisional)
    }
}
