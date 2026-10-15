import Foundation

/// When a local notification is delivered.
///
/// ```swift
/// .after(minutes: 10)                      // once, ten minutes from now
/// .daily(hour: 8, minute: 30)              // every day at 08:30
/// .weekly(weekday: 2, hour: 9)             // every Monday at 09:00
/// .date(meeting.start.addingTimeInterval(-900))
/// ```
public enum NotificationTrigger: Sendable, Hashable, Codable {
    /// Delivered as soon as it is scheduled.
    case immediately
    /// Delivered after a number of seconds. Repeating intervals must be at least 60 seconds.
    case timeInterval(TimeInterval, repeats: Bool)
    /// Delivered once, at a date.
    case date(Date)
    /// Delivered when the date components match, once or every time they match.
    case calendar(DateComponents, repeats: Bool)
    /// Delivered when the device enters or leaves a region (iOS and watchOS).
    case region(LocationRegion, repeats: Bool)

    /// Once, after `seconds`.
    public static func after(seconds: TimeInterval) -> NotificationTrigger {
        .timeInterval(seconds, repeats: false)
    }

    /// Once, after `minutes`.
    public static func after(minutes: Double) -> NotificationTrigger {
        .timeInterval(minutes * 60, repeats: false)
    }

    /// Once, after `hours`.
    public static func after(hours: Double) -> NotificationTrigger {
        .timeInterval(hours * 3600, repeats: false)
    }

    /// Every day at a time of day.
    public static func daily(hour: Int, minute: Int = 0) -> NotificationTrigger {
        .calendar(DateComponents(hour: hour, minute: minute), repeats: true)
    }

    /// Every week on a weekday (1 is Sunday, 7 is Saturday) at a time of day.
    public static func weekly(weekday: Int, hour: Int, minute: Int = 0) -> NotificationTrigger {
        .calendar(DateComponents(hour: hour, minute: minute, weekday: weekday), repeats: true)
    }

    /// Every month on a day of the month at a time of day.
    public static func monthly(day: Int, hour: Int, minute: Int = 0) -> NotificationTrigger {
        .calendar(DateComponents(day: day, hour: hour, minute: minute), repeats: true)
    }

    /// Whether the system delivers the notification more than once.
    public var repeats: Bool {
        switch self {
        case .immediately, .date: false
        case .timeInterval(_, let repeats), .calendar(_, let repeats), .region(_, let repeats): repeats
        }
    }

    /// Checks the values that the system rejects or crashes on.
    public func validate(calendar: Calendar = .current) throws(NotificationValidationError) {
        switch self {
        case .immediately:
            return
        case .timeInterval(let interval, let repeats):
            guard interval.isFinite, interval > 0 else { throw .invalidTimeInterval(interval) }
            if repeats, interval < 60 { throw .repeatingIntervalTooShort(interval) }
        case .date(let date):
            guard DateBounds.contains(date) else { throw .invalidDate }
        case .calendar(let components, _):
            try CalendarComponentsCheck.validate(components, calendar: calendar)
        case .region(let region, _):
            try region.validate()
        }
    }

    /// The next date the trigger fires after `now`, or `nil` for region triggers and for
    /// date components that never match again.
    ///
    /// - Parameters:
    ///   - now: The moment to look from.
    ///   - anchor: When a time-interval trigger was scheduled. Intervals count from it.
    ///   - calendar: Used for calendar triggers.
    public func nextFireDate(after now: Date, anchor: Date? = nil, calendar: Calendar = .current) -> Date? {
        switch self {
        case .immediately:
            return now
        case .timeInterval(let interval, let repeats):
            guard interval.isFinite, interval > 0 else { return nil }
            let start = anchor ?? now
            let first = start.addingTimeInterval(interval)
            guard repeats, first <= now else { return first }
            // Whole intervals that have passed since the first delivery, computed in floating
            // point so a long-running repetition cannot overflow an integer.
            let elapsed = ((now.timeIntervalSince(first)) / interval).rounded(.down) + 1
            return first.addingTimeInterval(elapsed * interval)
        case .date(let date):
            return date
        case .calendar(let components, _):
            return calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)
        case .region:
            return nil
        }
    }
}

/// A circular region for a location trigger.
public struct LocationRegion: Sendable, Hashable, Codable {
    public var identifier: String
    public var latitude: Double
    public var longitude: Double
    /// Radius in meters. The system clamps it to the largest radius it can monitor.
    public var radius: Double
    public var notifyOnEntry: Bool
    public var notifyOnExit: Bool

    public init(
        identifier: String,
        latitude: Double,
        longitude: Double,
        radius: Double,
        notifyOnEntry: Bool = true,
        notifyOnExit: Bool = false
    ) {
        self.identifier = identifier
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.notifyOnEntry = notifyOnEntry
        self.notifyOnExit = notifyOnExit
    }

    /// Checks the coordinate, the radius and that the region notifies on something.
    public func validate() throws(NotificationValidationError) {
        guard !identifier.isEmpty,
              latitude.isFinite, (-90...90).contains(latitude),
              longitude.isFinite, (-180...180).contains(longitude),
              radius.isFinite, radius > 0,
              notifyOnEntry || notifyOnExit
        else { throw .invalidRegion }
    }
}

/// Dates that every conversion in the package can represent: from the year 2000 to roughly
/// the year 2400. Outside that range, conversions to whole seconds could overflow.
enum DateBounds {
    static let earliest = Date(timeIntervalSince1970: 946_684_800)
    static let latest = Date(timeIntervalSince1970: 13_569_465_600)

    static func contains(_ date: Date) -> Bool {
        let seconds = date.timeIntervalSince1970
        return seconds.isFinite && date >= earliest && date <= latest
    }
}

enum CalendarComponentsCheck {
    private static let ranges: [(Calendar.Component, ClosedRange<Int>)] = [
        (.year, 2000...2400), (.month, 1...12), (.day, 1...31), (.hour, 0...23),
        (.minute, 0...59), (.second, 0...59), (.weekday, 1...7), (.weekdayOrdinal, -5...5),
        (.weekOfMonth, 1...6), (.weekOfYear, 1...53)
    ]

    static func validate(_ components: DateComponents, calendar: Calendar) throws(NotificationValidationError) {
        // Components the scheduler does not reason about are rejected rather than passed on.
        guard components.era == nil, components.quarter == nil, components.nanosecond == nil,
              components.yearForWeekOfYear == nil
        else { throw .invalidDateComponents }
        var anySet = false
        for (component, range) in ranges {
            guard let value = components.value(for: component) else { continue }
            anySet = true
            guard range.contains(value) else { throw .invalidDateComponents }
        }
        guard anySet else { throw .invalidDateComponents }
        guard calendar.nextDate(after: Date(timeIntervalSince1970: 946_684_800), matching: components, matchingPolicy: .nextTime) != nil
        else { throw .invalidDateComponents }
    }
}
