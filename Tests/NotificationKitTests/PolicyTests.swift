import Foundation
import Testing
@testable import NotificationKit

@Suite("Quiet hours")
struct QuietHoursTests {
    let calendar = Fixtures.calendar()

    @Test("parses HH:mm and rejects everything else", arguments: [
        ("07:30", true), ("7:30", true), ("00:00", true), ("23:59", true),
        ("24:00", false), ("07:60", false), ("7:5", false), ("+1:00", false), ("0730", false),
        ("", false), ("07:30:00", false), ("-1:30", false), ("٠٧:٣٠", false), ("07 :30", false)
    ])
    func parsing(_ text: String, valid: Bool) {
        #expect((TimeOfDay(text) != nil) == valid)
    }

    @Test("rejects an empty window and invalid weekdays")
    func invalidConfiguration() {
        #expect(throws: QuietHours.ConfigurationError.emptyWindow) { try QuietHours(from: "22:00", to: "22:00") }
        #expect(throws: QuietHours.ConfigurationError.invalidTime("25:00")) { try QuietHours(from: "25:00", to: "07:00") }
        #expect(throws: QuietHours.ConfigurationError.invalidWeekdays) { try QuietHours(from: "22:00", to: "07:00", weekdays: []) }
        #expect(throws: QuietHours.ConfigurationError.invalidWeekdays) { try QuietHours(from: "22:00", to: "07:00", weekdays: [0, 8]) }
    }

    @Test("moves a date inside an overnight window to its end")
    func overnightWindow() throws {
        let quiet = try QuietHours(from: "22:00", to: "07:30")
        let late = Fixtures.date("2026-10-15 23:15:00")
        let early = Fixtures.date("2026-10-16 03:00:00")
        let day = Fixtures.date("2026-10-16 12:00:00")
        #expect(quiet.adjustedDate(for: late, calendar: calendar) == Fixtures.date("2026-10-16 07:30:00"))
        #expect(quiet.adjustedDate(for: early, calendar: calendar) == Fixtures.date("2026-10-16 07:30:00"))
        #expect(quiet.adjustedDate(for: day, calendar: calendar) == day)
        // The window is half-open: its start is quiet, its end is not.
        #expect(quiet.contains(Fixtures.date("2026-10-15 22:00:00"), calendar: calendar))
        #expect(!quiet.contains(Fixtures.date("2026-10-16 07:30:00"), calendar: calendar))
    }

    @Test("handles a window within one day")
    func sameDayWindow() throws {
        let meeting = try QuietHours(from: "13:00", to: "14:00")
        #expect(meeting.adjustedDate(for: Fixtures.date("2026-10-15 13:30:00"), calendar: calendar) == Fixtures.date("2026-10-15 14:00:00"))
        #expect(!meeting.contains(Fixtures.date("2026-10-15 12:59:59"), calendar: calendar))
    }

    @Test("a window that starts on an active weekday covers the next morning")
    func weekdays() throws {
        // 2026-10-16 is a Friday (weekday 6).
        let weekendNights = try QuietHours(from: "23:00", to: "09:00", weekdays: [6, 7])
        #expect(weekendNights.contains(Fixtures.date("2026-10-17 08:00:00"), calendar: calendar)) // Saturday morning
        #expect(!weekendNights.contains(Fixtures.date("2026-10-16 08:00:00"), calendar: calendar)) // Friday morning
        #expect(weekendNights.contains(Fixtures.date("2026-10-18 08:00:00"), calendar: calendar)) // Sunday morning
        #expect(!weekendNights.contains(Fixtures.date("2026-10-19 08:00:00"), calendar: calendar)) // Monday morning
    }

    @Test("keeps working across a daylight saving change")
    func daylightSaving() throws {
        let newYork = Fixtures.calendar("America/New_York")
        // Clocks jump from 02:00 to 03:00 on 2026-03-08.
        let quiet = try QuietHours(from: "01:00", to: "02:30")
        let inGap = Fixtures.date("2026-03-08 01:45:00", in: newYork)
        let adjusted = quiet.adjustedDate(for: inGap, calendar: newYork)
        #expect(adjusted > inGap)
        #expect(!quiet.contains(adjusted, calendar: newYork))
        // Clocks fall back from 02:00 to 01:00 on 2026-11-01.
        let fallBack = Fixtures.date("2026-11-01 01:30:00", in: newYork)
        #expect(quiet.contains(fallBack, calendar: newYork))
        #expect(!quiet.contains(quiet.adjustedDate(for: fallBack, calendar: newYork), calendar: newYork))
    }

    @Test("lets time-sensitive and critical notifications through by default")
    func levels() throws {
        let quiet = try QuietHours(from: "22:00", to: "07:00")
        #expect(quiet.allows(.critical))
        #expect(quiet.allows(.timeSensitive))
        #expect(!quiet.allows(.active))
        #expect(!quiet.allows(.passive))
    }

    @Test("rejects invalid values when decoding")
    func decoding() throws {
        let valid = #"{"start":"22:00","end":"07:00","weekdays":[1,2],"allowsTimeSensitive":false,"allowsCritical":true}"#
        let decoded = try JSONDecoder().decode(QuietHours.self, from: Data(valid.utf8))
        #expect(decoded.weekdays == [1, 2])
        #expect(!decoded.allowsTimeSensitive)
        let invalid = #"{"start":"22:00","end":"22:00","weekdays":[1],"allowsTimeSensitive":true,"allowsCritical":true}"#
        #expect(throws: (any Error).self) { try JSONDecoder().decode(QuietHours.self, from: Data(invalid.utf8)) }
    }
}

@Suite("Frequency cap")
struct FrequencyCapTests {
    let base = Date(timeIntervalSince1970: 1_800_000_000)

    @Test("rejects limits below 1 and intervals that are not usable")
    func invalidConfiguration() {
        #expect(throws: FrequencyCap.ConfigurationError.invalidLimit(0)) { try FrequencyCap(limit: 0, per: 60) }
        for interval in [0, -1, Double.nan, Double.infinity, 400 * 86_400.0] {
            #expect(throws: FrequencyCap.ConfigurationError.self) { try FrequencyCap(limit: 1, per: interval) }
        }
    }

    @Test("keeps a date that fits and moves one that does not")
    func basic() throws {
        let cap = try FrequencyCap(limit: 2, per: 3600)
        let existing = [base, base.addingTimeInterval(600)]
        #expect(cap.earliestDate(onOrAfter: base.addingTimeInterval(3_700), existing: existing) == base.addingTimeInterval(3_700))
        #expect(cap.earliestDate(onOrAfter: base.addingTimeInterval(1_200), existing: existing) == base.addingTimeInterval(3_600))
    }

    @Test("looks at notifications after the new one too")
    func futureNotificationsCount() throws {
        let cap = try FrequencyCap(limit: 2, per: 3600)
        let existing = [base.addingTimeInterval(1_000), base.addingTimeInterval(2_000)]
        // A notification at `base` would make three within an hour together with the later two.
        let result = cap.earliestDate(onOrAfter: base, existing: existing)
        #expect(result == base.addingTimeInterval(4_600))
        #expect(cap.allows(result, sorted: existing))
    }

    @Test("finds the earliest allowed date (checked against a brute-force search)", arguments: 0..<40)
    func matchesBruteForce(seed: Int) throws {
        var generator = SeededGenerator(seed: UInt64(seed + 1))
        let limit = Int.random(in: 1...3, using: &generator)
        let interval = TimeInterval(Int.random(in: 2...10, using: &generator))
        let cap = try FrequencyCap(limit: limit, per: interval)
        // Existing dates that respect the cap, on a one-second grid.
        var existing: [Date] = []
        for second in 0..<40 where Bool.random(using: &generator) {
            let date = base.addingTimeInterval(TimeInterval(second))
            if cap.allows(date, sorted: existing) { existing.append(date) }
        }
        let start = base.addingTimeInterval(TimeInterval(Int.random(in: 0..<40, using: &generator)))
        let result = cap.earliestDate(onOrAfter: start, existing: existing)
        #expect(result >= start)
        #expect(cap.allows(result, sorted: existing))
        #expect(Self.windowsRespectCap(existing + [result], cap: cap))
        // No earlier whole second works (candidates are whole seconds here).
        var probe = start
        while probe < result {
            #expect(!cap.allows(probe, sorted: existing), "\(probe) was allowed but \(result) was returned")
            probe = probe.addingTimeInterval(1)
        }
    }

    @Test("stays fast with many existing notifications")
    func manyExisting() throws {
        let cap = try FrequencyCap(limit: 1, per: 60)
        let existing = (0..<2_000).map { base.addingTimeInterval(TimeInterval($0 * 60)) }
        let clock = ContinuousClock()
        let elapsed = clock.measure {
            let result = cap.earliestDate(onOrAfter: base, existing: existing)
            #expect(result == base.addingTimeInterval(2_000 * 60))
        }
        #expect(elapsed < .seconds(5))
    }

    static func windowsRespectCap(_ dates: [Date], cap: FrequencyCap) -> Bool {
        let sorted = dates.sorted()
        for (index, start) in sorted.enumerated() {
            let count = sorted[index...].prefix { $0 < start.addingTimeInterval(cap.interval) }.count
            if count > cap.limit { return false }
        }
        return true
    }
}

/// A small deterministic generator (SplitMix64) so failures can be reproduced.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var value = state
        value = (value ^ (value >> 30)) &* 0xBF58_476D_1CE4_E5B9
        value = (value ^ (value >> 27)) &* 0x94D0_49BB_1331_11EB
        return value ^ (value >> 31)
    }
}
