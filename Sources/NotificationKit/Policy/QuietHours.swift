import Foundation

/// A time of day, from 00:00 to 23:59.
public struct TimeOfDay: Sendable, Hashable, Codable, Comparable, CustomStringConvertible {
    public let hour: Int
    public let minute: Int

    /// Returns `nil` unless `hour` is 0...23 and `minute` is 0...59.
    public init?(hour: Int, minute: Int = 0) {
        guard (0...23).contains(hour), (0...59).contains(minute) else { return nil }
        self.hour = hour
        self.minute = minute
    }

    /// Parses `"HH:mm"` (24-hour clock, for example `"07:30"` or `"22:00"`).
    public init?(_ text: String) {
        let parts = text.split(separator: ":", omittingEmptySubsequences: false)
        guard parts.count == 2, parts.allSatisfy({ (1...2).contains($0.count) && $0.allSatisfy { $0.isASCII && $0.isNumber } }),
              let hour = Int(parts[0]), let minute = Int(parts[1]), parts[1].count == 2
        else { return nil }
        self.init(hour: hour, minute: minute)
    }

    public init(from decoder: any Decoder) throws {
        let text = try decoder.singleValueContainer().decode(String.self)
        guard let value = TimeOfDay(text) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Expected HH:mm, found \(text)"))
        }
        self = value
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }

    var minutesSinceMidnight: Int { hour * 60 + minute }

    public var description: String {
        (hour < 10 ? "0" : "") + "\(hour):" + (minute < 10 ? "0" : "") + "\(minute)"
    }

    public static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        lhs.minutesSinceMidnight < rhs.minutesSinceMidnight
    }
}

/// A daily window in which one-time notifications are held back and delivered at its end.
///
/// ```swift
/// let night = try QuietHours(from: "22:00", to: "07:30")
/// night.contains(tonightAt23, calendar: .current)        // true
/// night.adjustedDate(for: tonightAt23, calendar: .current) // tomorrow 07:30
/// ```
///
/// A window that starts later than it ends runs over midnight. Repeating notifications keep the
/// time they were scheduled for: someone who asks for a reminder every day at 23:00 gets it at
/// 23:00.
public struct QuietHours: Sendable, Hashable, Codable {
    /// Why quiet hours could not be created.
    public enum ConfigurationError: Error, Hashable, Sendable {
        /// A time is not in `HH:mm` form or out of range.
        case invalidTime(String)
        /// Start and end are the same, which leaves no window (or a window with no end).
        case emptyWindow
        /// A weekday is outside 1...7, or the set is empty.
        case invalidWeekdays
    }

    public let start: TimeOfDay
    public let end: TimeOfDay
    /// Weekdays (1 is Sunday, 7 is Saturday) on which a window starts. A window that starts on
    /// Friday at 22:00 still ends on Saturday morning.
    public let weekdays: Set<Int>
    /// Whether time-sensitive notifications are delivered during quiet hours.
    public var allowsTimeSensitive: Bool
    /// Whether critical notifications are delivered during quiet hours.
    public var allowsCritical: Bool

    public init(
        start: TimeOfDay,
        end: TimeOfDay,
        weekdays: Set<Int> = Set(1...7),
        allowsTimeSensitive: Bool = true,
        allowsCritical: Bool = true
    ) throws(ConfigurationError) {
        guard start != end else { throw .emptyWindow }
        guard !weekdays.isEmpty, weekdays.isSubset(of: 1...7) else { throw .invalidWeekdays }
        self.start = start
        self.end = end
        self.weekdays = weekdays
        self.allowsTimeSensitive = allowsTimeSensitive
        self.allowsCritical = allowsCritical
    }

    /// Creates quiet hours from two `HH:mm` times.
    public init(from start: String, to end: String, weekdays: Set<Int> = Set(1...7)) throws(ConfigurationError) {
        guard let startTime = TimeOfDay(start) else { throw .invalidTime(start) }
        guard let endTime = TimeOfDay(end) else { throw .invalidTime(end) }
        try self.init(start: startTime, end: endTime, weekdays: weekdays)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            start: container.decode(TimeOfDay.self, forKey: .start),
            end: container.decode(TimeOfDay.self, forKey: .end),
            weekdays: container.decode(Set<Int>.self, forKey: .weekdays),
            allowsTimeSensitive: container.decode(Bool.self, forKey: .allowsTimeSensitive),
            allowsCritical: container.decode(Bool.self, forKey: .allowsCritical)
        )
    }

    /// Whether the window lets a notification of this level through.
    public func allows(_ level: InterruptionLevel) -> Bool {
        switch level {
        case .critical: allowsCritical
        case .timeSensitive: allowsTimeSensitive
        case .active, .passive: false
        }
    }

    /// Whether `date` falls inside a quiet window.
    public func contains(_ date: Date, calendar: Calendar) -> Bool {
        window(containing: date, calendar: calendar) != nil
    }

    /// `date` itself when it is outside quiet hours; otherwise the end of its window.
    public func adjustedDate(for date: Date, calendar: Calendar) -> Date {
        window(containing: date, calendar: calendar)?.end ?? date
    }

    /// The quiet window that contains `date`, if any. Windows that run over midnight are found
    /// from the day they start on.
    public func window(containing date: Date, calendar: Calendar) -> DateInterval? {
        let today = calendar.startOfDay(for: date)
        for offset in [-1, 0] {
            guard let day = calendar.date(byAdding: .day, value: offset, to: today),
                  weekdays.contains(calendar.component(.weekday, from: day)),
                  let window = window(startingOn: day, calendar: calendar),
                  window.start <= date, date < window.end
            else { continue }
            return window
        }
        return nil
    }

    private func window(startingOn day: Date, calendar: Calendar) -> DateInterval? {
        let endDay = end > start ? day : calendar.date(byAdding: .day, value: 1, to: day)
        // On days when a clock change skips the start or end time, the system moves it to the
        // next valid time, which is also when a notification would be delivered.
        guard let endDay,
              let startDate = calendar.date(bySettingHour: start.hour, minute: start.minute, second: 0, of: day),
              let endDate = calendar.date(bySettingHour: end.hour, minute: end.minute, second: 0, of: endDay),
              startDate < endDate
        else { return nil }
        return DateInterval(start: startDate, end: endDate)
    }
}
