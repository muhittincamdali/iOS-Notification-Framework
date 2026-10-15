import Foundation

/// At most `limit` one-time notifications within any stretch of `interval` seconds.
///
/// ```swift
/// // No more than three notifications in any hour.
/// let cap = try FrequencyCap(limit: 3, per: 3600)
/// ```
///
/// When a new notification would break the cap, ``NotificationScheduler`` moves it to the
/// earliest later time that keeps it, instead of dropping it.
public struct FrequencyCap: Sendable, Hashable, Codable {
    /// Why a cap could not be created.
    public enum ConfigurationError: Error, Hashable, Sendable {
        /// The limit is less than 1.
        case invalidLimit(Int)
        /// The interval is not a finite number of seconds greater than zero, or longer than a year.
        case invalidInterval(TimeInterval)
    }

    /// The longest interval accepted: one year.
    public static let maximumInterval: TimeInterval = 366 * 86_400

    public let limit: Int
    public let interval: TimeInterval

    public init(limit: Int, per interval: TimeInterval) throws(ConfigurationError) {
        guard limit >= 1 else { throw .invalidLimit(limit) }
        guard interval.isFinite, interval > 0, interval <= Self.maximumInterval else { throw .invalidInterval(interval) }
        self.limit = limit
        self.interval = interval
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(limit: container.decode(Int.self, forKey: .limit), per: container.decode(TimeInterval.self, forKey: .interval))
    }

    /// The earliest date at or after `date` at which one more notification keeps the cap, given
    /// the fire dates of the notifications already scheduled.
    ///
    /// Only `date` and the dates `interval` after an existing one can be the answer, so the
    /// search checks those candidates in order and always ends: one `interval` after the last
    /// existing date no window can be full.
    public func earliestDate(onOrAfter date: Date, existing: [Date]) -> Date {
        let sorted = existing.sorted()
        let candidates = [date] + sorted.map { $0.addingTimeInterval(interval) }.filter { $0 > date }
        for candidate in candidates.sorted() where allows(candidate, sorted: sorted) {
            return candidate
        }
        // Not reached: the last candidate is always allowed. Kept so the function cannot return
        // a date that breaks the cap.
        return (sorted.last ?? date).addingTimeInterval(interval)
    }

    /// Whether one more notification at `date` keeps every window of length `interval` at or
    /// under `limit`. Windows are half-open, `[start, start + interval)`.
    func allows(_ date: Date, sorted: [Date]) -> Bool {
        // A window starting at s holds `date` when s is in (date - interval, date]. The count of
        // existing dates in such a window peaks either at s = date or at s = one of the existing
        // dates in that range, so those are the only windows to count.
        let earliestStart = date.addingTimeInterval(-interval)
        let firstInRange = Self.firstIndex(in: sorted, notBelow: earliestStart, inclusive: false)
        let pastRange = Self.firstIndex(in: sorted, notBelow: date, inclusive: false)
        let starts = [date] + sorted[firstInRange..<pastRange]
        for start in starts {
            let windowEnd = start.addingTimeInterval(interval)
            let count = Self.firstIndex(in: sorted, notBelow: windowEnd, inclusive: true)
                - Self.firstIndex(in: sorted, notBelow: start, inclusive: true)
            if count + 1 > limit { return false }
        }
        return true
    }

    /// Binary search in ascending `dates`: the index of the first date `>= bound` when
    /// `inclusive`, or the first date `> bound` otherwise.
    static func firstIndex(in dates: [Date], notBelow bound: Date, inclusive: Bool) -> Int {
        var low = 0
        var high = dates.count
        while low < high {
            let middle = low + (high - low) / 2
            let isBelow = inclusive ? dates[middle] < bound : dates[middle] <= bound
            if isBelow { low = middle + 1 } else { high = middle }
        }
        return low
    }
}
