import Foundation

/// A ``NotificationCenterClient`` that keeps notifications in memory, for unit tests and
/// SwiftUI previews.
///
/// It behaves like the system where that matters for scheduling: it keeps only the
/// ``systemLimit`` soonest pending notifications and silently drops the rest, delivers
/// ``NotificationTrigger/immediately`` notifications at once, and rejects the same invalid
/// values. Call ``advance(to:)`` to let time pass.
///
/// ```swift
/// let center = InMemoryNotificationCenter(now: { clock.now })
/// let scheduler = NotificationScheduler(center: center, now: { clock.now })
/// ```
public actor InMemoryNotificationCenter: NotificationCenterClient {
    /// How many pending notifications the system keeps for an app.
    public static let systemLimit = 64

    private struct Entry {
        var notification: LocalNotification
        var addedAt: Date
        /// When a repeating notification was last delivered.
        var lastDelivery: Date?
    }

    private var entries: [Entry] = []
    private let limit: Int
    private let now: @Sendable () -> Date
    private let calendar: Calendar

    /// Notifications that have been delivered, oldest first.
    public private(set) var delivered: [LocalNotification] = []
    /// The categories set by the last ``setCategories(_:)`` call.
    public private(set) var categories: [NotificationCategory] = []
    public private(set) var badgeCount = 0
    public private(set) var authorizationStatus: AuthorizationStatus
    /// Notifications the center dropped because more than ``systemLimit`` were pending.
    public private(set) var dropped: [LocalNotification] = []
    private let grantsAuthorization: Bool

    /// - Parameters:
    ///   - authorizationStatus: The status before ``requestAuthorization(options:)`` is called.
    ///   - grantsAuthorization: What the simulated user answers when asked.
    ///   - limit: Pending notifications kept; the system keeps 64.
    ///   - calendar: Used to compute when calendar triggers fire.
    ///   - now: The current time. Tests pass a clock they control.
    public init(
        authorizationStatus: AuthorizationStatus = .notDetermined,
        grantsAuthorization: Bool = true,
        limit: Int = InMemoryNotificationCenter.systemLimit,
        calendar: Calendar = .current,
        now: @escaping @Sendable () -> Date = Date.init
    ) {
        self.authorizationStatus = authorizationStatus
        self.grantsAuthorization = grantsAuthorization
        self.limit = max(1, limit)
        self.calendar = calendar
        self.now = now
    }

    /// Pending notifications, soonest first.
    public var pending: [LocalNotification] {
        sortedEntries(at: now()).map(\.notification)
    }

    public func requestAuthorization(options: AuthorizationOptions) async throws -> Bool {
        if authorizationStatus == .notDetermined {
            authorizationStatus = grantsAuthorization ? (options.contains(.provisional) ? .provisional : .authorized) : .denied
        }
        return authorizationStatus.allowsDelivery
    }

    public func settings() async -> NotificationSettings {
        let enabled = authorizationStatus.allowsDelivery
        return NotificationSettings(
            authorizationStatus: authorizationStatus,
            alertsEnabled: enabled,
            soundsEnabled: enabled,
            badgesEnabled: enabled
        )
    }

    public func add(_ notification: LocalNotification) async throws {
        try notification.validate(calendar: calendar)
        let date = now()
        entries.removeAll { $0.notification.id == notification.id }
        if notification.trigger == .immediately {
            delivered.append(notification)
            return
        }
        entries.append(Entry(notification: notification, addedAt: date))
        let sorted = sortedEntries(at: date)
        if sorted.count > limit {
            let droppedIDs = Set(sorted[limit...].map(\.notification.id))
            dropped.append(contentsOf: sorted[limit...].map(\.notification))
            entries.removeAll { droppedIDs.contains($0.notification.id) }
        }
    }

    public func pendingNotificationIDs() async -> [String] {
        entries.map(\.notification.id)
    }

    public func deliveredNotificationIDs() async -> [String] {
        delivered.map(\.id)
    }

    public func removePendingNotifications(withIDs ids: [String]) async {
        let ids = Set(ids)
        entries.removeAll { ids.contains($0.notification.id) }
    }

    public func removeDeliveredNotifications(withIDs ids: [String]) async {
        let ids = Set(ids)
        delivered.removeAll { ids.contains($0.id) }
    }

    public func setCategories(_ categories: [NotificationCategory]) async {
        self.categories = categories
    }

    public func setBadgeCount(_ count: Int) async throws {
        guard count >= 0 else { throw NotificationValidationError.negativeBadge(count) }
        badgeCount = count
    }

    /// Delivers every pending notification whose trigger fires up to `date`, in order, and
    /// returns them. Repeating notifications are delivered once and stay pending.
    @discardableResult
    public func advance(to date: Date) -> [LocalNotification] {
        var deliveredNow: [LocalNotification] = []
        for entry in sortedEntries(at: date) {
            let previous = entry.lastDelivery ?? entry.addedAt
            guard let fire = nextFireDate(of: entry, after: previous), fire <= date else { continue }
            deliveredNow.append(entry.notification)
            if entry.notification.trigger.repeats {
                if let index = entries.firstIndex(where: { $0.notification.id == entry.notification.id }) {
                    entries[index].lastDelivery = fire
                }
            } else {
                entries.removeAll { $0.notification.id == entry.notification.id }
            }
        }
        delivered.append(contentsOf: deliveredNow)
        return deliveredNow
    }

    private func nextFireDate(of entry: Entry, after date: Date) -> Date? {
        entry.notification.trigger.nextFireDate(after: date, anchor: entry.addedAt, calendar: calendar)
    }

    /// Entries ordered by their next fire date; region triggers (no date) come last.
    private func sortedEntries(at date: Date) -> [Entry] {
        entries.sorted { lhs, rhs in
            let left = nextFireDate(of: lhs, after: date) ?? .distantFuture
            let right = nextFireDate(of: rhs, after: date) ?? .distantFuture
            return left == right ? lhs.notification.id < rhs.notification.id : left < right
        }
    }
}
