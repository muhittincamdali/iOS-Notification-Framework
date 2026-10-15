import Foundation
import Testing
@testable import NotificationKit

@Suite("Scheduler")
struct SchedulerTests {
    let calendar = Fixtures.calendar()
    let clock = TestClock(Fixtures.date("2026-10-15 12:00:00"))

    func makeScheduler(
        policy: SchedulingPolicy = SchedulingPolicy(),
        center: InMemoryNotificationCenter? = nil,
        store: any NotificationStore = InMemoryNotificationStore()
    ) -> (NotificationScheduler, InMemoryNotificationCenter) {
        let clock = clock
        let center = center ?? InMemoryNotificationCenter(authorizationStatus: .authorized, calendar: calendar, now: { clock.now })
        let scheduler = NotificationScheduler(center: center, store: store, policy: policy, calendar: calendar, now: { clock.now })
        return (scheduler, center)
    }

    @Test("keeps the 64 soonest with the system and queues the rest instead of losing them")
    func queuesBeyondTheSystemLimit() async throws {
        let (scheduler, center) = makeScheduler()
        // Scheduled latest first, so the system would keep the wrong ones without the queue.
        let notifications = (1...70).reversed().map { Fixtures.notification("n\($0)", after: TimeInterval($0 * 60)) }
        let results = try await scheduler.schedule(notifications)

        #expect(results.filter { $0.placement == .system }.count == 64)
        #expect(Set(results.filter { $0.placement == .queued }.map(\.id)) == Set((65...70).map { "n\($0)" }))
        #expect(await center.pending.count == 64)
        #expect(await center.dropped.isEmpty)
        #expect(await center.pending.first?.id == "n1")
    }

    @Test("moves queued notifications into slots that free up")
    func refreshPromotesQueued() async throws {
        let (scheduler, center) = makeScheduler()
        try await scheduler.schedule((1...70).map { Fixtures.notification("n\($0)", after: TimeInterval($0 * 60)) })

        clock.advance(by: 10 * 60)
        let delivered = await center.advance(to: clock.now)
        #expect(delivered.map(\.id) == (1...10).map { "n\($0)" })

        let report = try await scheduler.refresh()
        #expect(Set(report.delivered) == Set((1...10).map { "n\($0)" }))
        #expect(Set(report.promoted) == Set((65...70).map { "n\($0)" }))
        #expect(await center.pending.count == 60)
        let all = try await scheduler.scheduled()
        #expect(all.count == 60)
        #expect(all.allSatisfy { $0.placement == .system })
    }

    @Test("an earlier notification takes the slot of the latest one")
    func earlierNotificationDemotesLatest() async throws {
        let (scheduler, center) = makeScheduler()
        try await scheduler.schedule((1...64).map { Fixtures.notification("n\($0)", after: TimeInterval($0 * 60)) })
        let urgent = try await scheduler.schedule(Fixtures.notification("urgent", after: 30))

        #expect(urgent.placement == .system)
        let pending = await center.pending.map(\.id)
        #expect(pending.count == 64)
        #expect(pending.first == "urgent")
        #expect(!pending.contains("n64"))
        let queued = try await scheduler.scheduled().filter { $0.placement == .queued }.map(\.id)
        #expect(queued == ["n64"])
    }

    @Test("leaves room for notifications scheduled by other code")
    func foreignNotificationsReduceCapacity() async throws {
        let (scheduler, center) = makeScheduler()
        for index in 0..<4 {
            try await center.add(LocalNotification(id: "other\(index)", title: "Other", trigger: .after(seconds: 30)))
        }
        let results = try await scheduler.schedule((1...64).map { Fixtures.notification("n\($0)", after: TimeInterval($0 * 60)) })
        #expect(results.filter { $0.placement == .system }.count == 60)
        #expect(await center.pending.count == 64)
        #expect(await center.dropped.isEmpty)
    }

    @Test("holds one-time notifications until quiet hours end")
    func quietHours() async throws {
        let policy = SchedulingPolicy(quietHours: try QuietHours(from: "22:00", to: "07:00"))
        let (scheduler, center) = makeScheduler(policy: policy)
        clock.set(Fixtures.date("2026-10-15 21:30:00"))

        let reminder = try await scheduler.schedule(Fixtures.notification("late", after: 3600))
        #expect(reminder.fireDate == Fixtures.date("2026-10-16 07:00:00"))
        #expect(reminder.requestedFireDate == Fixtures.date("2026-10-15 22:30:00"))
        #expect(reminder.adjustments == [.quietHours])
        #expect(await center.pending.first?.trigger == .date(Fixtures.date("2026-10-16 07:00:00")))

        let alarm = try await scheduler.schedule(Fixtures.notification("alarm", after: 3600, level: .timeSensitive))
        #expect(alarm.fireDate == Fixtures.date("2026-10-15 22:30:00"))
        #expect(alarm.adjustments.isEmpty)

        var daily = LocalNotification(id: "daily", title: "Journal", trigger: .daily(hour: 23))
        daily.sound = nil
        let repeating = try await scheduler.schedule(daily)
        #expect(repeating.notification.trigger == .daily(hour: 23))
        #expect(repeating.fireDate == Fixtures.date("2026-10-15 23:00:00"))
    }

    @Test("an immediate notification during quiet hours waits for the morning")
    func immediateDuringQuietHours() async throws {
        let policy = SchedulingPolicy(quietHours: try QuietHours(from: "22:00", to: "07:00"))
        let (scheduler, center) = makeScheduler(policy: policy)
        clock.set(Fixtures.date("2026-10-15 23:00:00"))
        let result = try await scheduler.schedule(LocalNotification(id: "now", title: "Now"))
        #expect(result.fireDate == Fixtures.date("2026-10-16 07:00:00"))
        #expect(await center.delivered.isEmpty)

        clock.set(Fixtures.date("2026-10-16 08:00:00"))
        let daytime = try await scheduler.schedule(LocalNotification(id: "day", title: "Day"))
        #expect(daytime.notification.trigger == .immediately)
        #expect(await center.delivered.map(\.id) == ["day"])
    }

    @Test("spreads notifications out to keep the frequency cap, counting recent deliveries")
    func frequencyCap() async throws {
        let policy = SchedulingPolicy(frequencyCap: try FrequencyCap(limit: 2, per: 3600))
        let (scheduler, center) = makeScheduler(policy: policy)
        let results = try await scheduler.schedule((1...3).map { Fixtures.notification("n\($0)", after: TimeInterval($0 * 60)) })
        let start = clock.now
        #expect(results.map(\.fireDate) == [start.addingTimeInterval(60), start.addingTimeInterval(120), start.addingTimeInterval(3_660)])
        #expect(results[2].adjustments == [.frequencyCap])

        // After the first two are delivered, they still count for the next hour.
        clock.advance(by: 180)
        await center.advance(to: clock.now)
        let next = try await scheduler.schedule(Fixtures.notification("n4", after: 60))
        #expect(next.fireDate == start.addingTimeInterval(3_720))
        #expect(next.adjustments == [.frequencyCap])
    }

    @Test("quiet hours and the cap together settle on a date that satisfies both")
    func quietHoursAndCap() async throws {
        let policy = SchedulingPolicy(
            quietHours: try QuietHours(from: "22:00", to: "07:00"),
            frequencyCap: try FrequencyCap(limit: 1, per: 3600)
        )
        let (scheduler, _) = makeScheduler(policy: policy)
        clock.set(Fixtures.date("2026-10-15 21:00:00"))
        let first = try await scheduler.schedule(Fixtures.notification("a", after: 30 * 60))
        let second = try await scheduler.schedule(Fixtures.notification("b", after: 40 * 60))
        #expect(first.fireDate == Fixtures.date("2026-10-15 21:30:00"))
        #expect(second.fireDate == Fixtures.date("2026-10-16 07:00:00"))
        #expect(Set(second.adjustments) == [.quietHours, .frequencyCap])
    }

    @Test("replaces a notification with the same identifier")
    func replacesSameIdentifier() async throws {
        let (scheduler, center) = makeScheduler()
        try await scheduler.schedule(Fixtures.notification("same", after: 60))
        var updated = Fixtures.notification("same", after: 600)
        updated.title = "Updated"
        try await scheduler.schedule(updated)
        let pending = await center.pending
        #expect(pending.count == 1)
        #expect(pending.first?.title == "Updated")
        #expect(try await scheduler.scheduled().count == 1)
    }

    @Test("cancels from the system and the queue, then fills the freed slots")
    func cancel() async throws {
        let (scheduler, center) = makeScheduler()
        try await scheduler.schedule((1...66).map { Fixtures.notification("n\($0)", after: TimeInterval($0 * 60)) })
        try await scheduler.cancel(ids: ["n1", "n2", "n66"])
        let all = try await scheduler.scheduled()
        #expect(all.count == 63)
        #expect(all.allSatisfy { $0.placement == .system })
        #expect(await center.pending.count == 63)
        #expect(!(await center.pending.map(\.id)).contains("n1"))

        try await scheduler.cancelAll()
        #expect(await center.pending.isEmpty)
        #expect(try await scheduler.scheduled().isEmpty)
    }

    @Test("cancelAll leaves notifications from other code alone")
    func cancelAllKeepsForeign() async throws {
        let (scheduler, center) = makeScheduler()
        try await center.add(LocalNotification(id: "other", title: "Other", trigger: .after(seconds: 60)))
        try await scheduler.schedule(Fixtures.notification("mine", after: 60))
        try await scheduler.cancelAll()
        #expect(await center.pending.map(\.id) == ["other"])
    }

    @Test("drops or delivers queued notifications whose date passed", arguments: [SchedulingPolicy.OverdueBehavior.discard, .deliverNow])
    func overdue(_ behavior: SchedulingPolicy.OverdueBehavior) async throws {
        let (scheduler, center) = makeScheduler(policy: SchedulingPolicy(systemCapacity: 1, overdueBehavior: behavior))
        try await scheduler.schedule([Fixtures.notification("first", after: 60), Fixtures.notification("second", after: 120)])
        clock.advance(by: 600)
        await center.advance(to: clock.now)
        let report = try await scheduler.refresh()
        #expect(report.delivered == ["first"])
        switch behavior {
        case .discard:
            #expect(report.expired == ["second"])
            #expect(await center.delivered.map(\.id) == ["first"])
        case .deliverNow:
            #expect(report.expired.isEmpty)
            #expect(await center.delivered.map(\.id) == ["first", "second"])
        }
    }

    @Test("rejects past dates, duplicates and more than the maximum")
    func rejections() async throws {
        let (scheduler, center) = makeScheduler(policy: SchedulingPolicy(maximumCount: 3))
        await #expect(throws: NotificationValidationError.fireDateInPast) {
            try await scheduler.schedule(LocalNotification(id: "past", title: "x", trigger: .date(clock.now.addingTimeInterval(-1))))
        }
        await #expect(throws: SchedulerError.duplicateIdentifier("a")) {
            try await scheduler.schedule([Fixtures.notification("a", after: 60), Fixtures.notification("a", after: 90)])
        }
        try await scheduler.schedule((1...3).map { Fixtures.notification("n\($0)", after: 60) })
        await #expect(throws: SchedulerError.limitReached(3)) {
            try await scheduler.schedule(Fixtures.notification("n4", after: 60))
        }
        // An invalid notification in a batch stops the whole batch.
        try await scheduler.cancelAll()
        await #expect(throws: NotificationValidationError.self) {
            try await scheduler.schedule([Fixtures.notification("ok", after: 60), LocalNotification(id: "", title: "x")])
        }
        #expect(await center.pending.isEmpty)
    }

    @Test("a new scheduler with the same store still knows the queue")
    func persistsQueue() async throws {
        let store = InMemoryNotificationStore()
        let clock = clock
        let center = InMemoryNotificationCenter(authorizationStatus: .authorized, calendar: calendar, now: { clock.now })
        let (first, _) = makeScheduler(center: center, store: store)
        try await first.schedule((1...66).map { Fixtures.notification("n\($0)", after: TimeInterval($0 * 60)) })

        let (second, _) = makeScheduler(center: center, store: store)
        clock.advance(by: 120)
        await center.advance(to: clock.now)
        let report = try await second.refresh()
        #expect(Set(report.promoted) == ["n65", "n66"])
        #expect(await center.pending.count == 64)
    }

    @Test("ignores damaged or duplicate entries in a saved state")
    func sanitizesLoadedState() async throws {
        let good = ScheduledNotification(
            notification: Fixtures.notification("good", after: 60), requestedTrigger: .after(seconds: 60),
            scheduledAt: clock.now, fireDate: clock.now.addingTimeInterval(60), requestedFireDate: nil, adjustments: [], placement: .queued
        )
        var bad = good
        bad.notification.id = ""
        var badRelevance = good
        badRelevance.notification.id = "nan"
        badRelevance.notification.relevanceScore = .nan
        let state = SchedulerState(entries: [good, bad, good, badRelevance], deliveryHistory: [Date(timeIntervalSince1970: .nan)])
        let (scheduler, center) = makeScheduler(store: InMemoryNotificationStore(state: state))
        let all = try await scheduler.scheduled()
        #expect(all.map(\.id) == ["good"])
        #expect(await center.pending.map(\.id) == ["good"])
    }

    @Test("concurrent calls do not interleave")
    func concurrentScheduling() async throws {
        let (scheduler, center) = makeScheduler()
        try await withThrowingTaskGroup(of: Void.self) { group in
            for index in 1...100 {
                group.addTask { try await scheduler.schedule(Fixtures.notification("n\(index)", after: TimeInterval(index * 60))) }
            }
            try await group.waitForAll()
        }
        let all = try await scheduler.scheduled()
        #expect(all.count == 100)
        #expect(all.filter { $0.placement == .system }.count == 64)
        #expect(await center.pending.count == 64)
        #expect(await center.dropped.isEmpty)
        #expect(Set(await center.pending.map(\.id)) == Set((1...64).map { "n\($0)" }))
    }

    @Test("passes authorization, categories and the badge through to the center")
    func passThrough() async throws {
        let clock = clock
        let center = InMemoryNotificationCenter(grantsAuthorization: false, calendar: calendar, now: { clock.now })
        let (scheduler, _) = makeScheduler(center: center)
        #expect(try await scheduler.requestAuthorization() == false)
        #expect(await scheduler.settings().authorizationStatus == .denied)
        await scheduler.register([NotificationCategory(id: "message", actions: [.button(id: "read", title: "Read")])])
        #expect(await center.categories.map(\.id) == ["message"])
        try await scheduler.setBadgeCount(3)
        #expect(await center.badgeCount == 3)
        await #expect(throws: NotificationValidationError.negativeBadge(-1)) { try await scheduler.setBadgeCount(-1) }
    }
}

@Suite("File store")
struct FileStoreTests {
    @Test("saves and loads the state")
    func roundTrip() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = FileNotificationStore(url: directory.appendingPathComponent("state.json"))
        #expect(try await store.load() == nil)
        let entry = ScheduledNotification(
            notification: LocalNotification(id: "a", title: "A", trigger: .date(Date(timeIntervalSince1970: 1_900_000_000))),
            requestedTrigger: .after(hours: 2), scheduledAt: Date(timeIntervalSince1970: 1_899_992_800),
            fireDate: Date(timeIntervalSince1970: 1_900_000_000), requestedFireDate: nil, adjustments: [.quietHours], placement: .queued
        )
        let state = SchedulerState(entries: [entry], deliveryHistory: [Date(timeIntervalSince1970: 1_899_990_000)])
        try await store.save(state)
        #expect(try await store.load() == state)
    }

    @Test("refuses to read a file larger than the limit")
    func rejectsLargeFile() async throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: url) }
        try Data(count: FileNotificationStore.maximumFileSize + 1).write(to: url)
        await #expect(throws: FileNotificationStore.StoreError.self) {
            try await FileNotificationStore(url: url).load()
        }
    }
}
