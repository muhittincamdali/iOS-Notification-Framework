import Foundation
import Testing
@testable import NotificationKit

@Suite("Triggers")
struct TriggerTests {
    let calendar = Fixtures.calendar()

    @Test("rejects intervals the system would crash on", arguments: [0, -1, Double.nan, Double.infinity, -Double.infinity])
    func rejectsInvalidIntervals(_ interval: Double) {
        #expect(throws: NotificationValidationError.self) {
            try NotificationTrigger.timeInterval(interval, repeats: false).validate(calendar: calendar)
        }
    }

    @Test("requires 60 seconds for repeating intervals")
    func repeatingMinimum() throws {
        #expect(throws: NotificationValidationError.repeatingIntervalTooShort(59)) {
            try NotificationTrigger.timeInterval(59, repeats: true).validate(calendar: calendar)
        }
        try NotificationTrigger.timeInterval(60, repeats: true).validate(calendar: calendar)
        try NotificationTrigger.timeInterval(1, repeats: false).validate(calendar: calendar)
    }

    @Test("rejects date components outside their ranges")
    func rejectsInvalidComponents() throws {
        let invalid: [DateComponents] = [
            DateComponents(hour: 24), DateComponents(minute: 60), DateComponents(weekday: 8),
            DateComponents(month: 13), DateComponents(day: 0), DateComponents(hour: Int.max),
            DateComponents(), DateComponents(era: 1, hour: 9), DateComponents(hour: 9, nanosecond: 5)
        ]
        for components in invalid {
            #expect(throws: NotificationValidationError.invalidDateComponents) {
                try NotificationTrigger.calendar(components, repeats: true).validate(calendar: calendar)
            }
        }
        try NotificationTrigger.daily(hour: 23, minute: 59).validate(calendar: calendar)
        try NotificationTrigger.weekly(weekday: 7, hour: 0).validate(calendar: calendar)
    }

    @Test("rejects dates that cannot be converted to seconds")
    func rejectsUnrepresentableDates() {
        let dates = [Date(timeIntervalSince1970: .nan), Date(timeIntervalSince1970: .infinity), .distantFuture, .distantPast]
        for date in dates {
            #expect(throws: NotificationValidationError.invalidDate) {
                try NotificationTrigger.date(date).validate(calendar: calendar)
            }
        }
    }

    @Test("rejects regions with invalid coordinates or no events", arguments: [
        LocationRegion(identifier: "a", latitude: 91, longitude: 0, radius: 100),
        LocationRegion(identifier: "a", latitude: 0, longitude: .nan, radius: 100),
        LocationRegion(identifier: "a", latitude: 0, longitude: 0, radius: 0),
        LocationRegion(identifier: "a", latitude: 0, longitude: 0, radius: 100, notifyOnEntry: false, notifyOnExit: false),
        LocationRegion(identifier: "", latitude: 0, longitude: 0, radius: 100)
    ])
    func rejectsInvalidRegions(_ region: LocationRegion) {
        #expect(throws: NotificationValidationError.invalidRegion) { try region.validate() }
    }

    @Test("computes the next repetition of an interval long after it started")
    func nextRepeatingIntervalDate() throws {
        let anchor = Fixtures.date("2026-01-01 00:00:00")
        let now = Fixtures.date("2026-10-15 12:00:30")
        let trigger = NotificationTrigger.timeInterval(3600, repeats: true)
        let next = try #require(trigger.nextFireDate(after: now, anchor: anchor, calendar: calendar))
        #expect(next == Fixtures.date("2026-10-15 13:00:00"))
        // One second apart for 300 years: computed without integer overflow.
        let far = NotificationTrigger.timeInterval(60, repeats: true)
            .nextFireDate(after: Date(timeIntervalSince1970: 1e10), anchor: Date(timeIntervalSince1970: 0), calendar: calendar)
        #expect(far != nil)
    }

    @Test("finds the next daily occurrence")
    func nextDaily() {
        let now = Fixtures.date("2026-10-15 09:30:00")
        #expect(NotificationTrigger.daily(hour: 9).nextFireDate(after: now, calendar: calendar) == Fixtures.date("2026-10-16 09:00:00"))
        #expect(NotificationTrigger.daily(hour: 10).nextFireDate(after: now, calendar: calendar) == Fixtures.date("2026-10-15 10:00:00"))
    }

    @Test("round-trips through Codable")
    func codable() throws {
        let triggers: [NotificationTrigger] = [
            .immediately, .after(minutes: 5), .date(Fixtures.date("2026-12-24 18:00:00")), .weekly(weekday: 2, hour: 9),
            .region(LocationRegion(identifier: "office", latitude: 41.0, longitude: 29.0, radius: 150), repeats: true)
        ]
        let data = try JSONEncoder().encode(triggers)
        #expect(try JSONDecoder().decode([NotificationTrigger].self, from: data) == triggers)
    }
}

@Suite("LocalNotification")
struct LocalNotificationTests {
    @Test("validates identifier, content, badge, relevance, sound and user info")
    func validation() throws {
        let valid = LocalNotification(id: "ok", title: "Hello")
        try valid.validate()

        var copy = valid
        copy.id = ""
        #expect(throws: NotificationValidationError.invalidIdentifier) { try copy.validate() }
        copy.id = String(repeating: "x", count: 257)
        #expect(throws: NotificationValidationError.invalidIdentifier) { try copy.validate() }

        copy = LocalNotification(id: "silent", sound: nil)
        #expect(throws: NotificationValidationError.emptyContent) { try copy.validate() }

        copy = valid
        copy.badge = -1
        #expect(throws: NotificationValidationError.negativeBadge(-1)) { try copy.validate() }

        for score in [Double.nan, 1.5, -0.1] {
            copy = valid
            copy.relevanceScore = score
            #expect(throws: NotificationValidationError.self) { try copy.validate() }
        }

        copy = valid
        copy.sound = .critical(name: "alarm.caf", volume: .nan)
        #expect(throws: NotificationValidationError.self) { try copy.validate() }
        copy.sound = .named("")
        #expect(throws: NotificationValidationError.emptySoundName) { try copy.validate() }

        copy = valid
        copy.userInfo = ["score": .number(.infinity)]
        #expect(throws: NotificationValidationError.invalidUserInfo) { try copy.validate() }

        copy = valid
        let remote = URL(string: "https://example.com/a.jpg")!
        copy.attachments = [NotificationAttachment(id: "a", url: remote)]
        #expect(throws: NotificationValidationError.invalidAttachment(remote)) { try copy.validate() }
    }

    @Test("a badge-only notification is valid")
    func badgeOnly() throws {
        try LocalNotification(id: "badge", badge: 3, sound: nil).validate()
    }

    @Test("stores the deep link in userInfo")
    func deepLink() {
        var notification = LocalNotification(id: "x", title: "t")
        notification.deepLink = URL(string: "myapp://orders/42")
        #expect(notification.userInfo["deeplink"] == "myapp://orders/42")
        #expect(notification.deepLink?.host() == "orders")
        notification.deepLink = nil
        #expect(notification.userInfo["deeplink"] == nil)
    }
}
