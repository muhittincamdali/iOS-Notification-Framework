import Foundation

/// Schedules local notifications past the system's 64-notification limit, with quiet hours
/// and a frequency cap.
///
/// ```swift
/// let scheduler = NotificationScheduler(policy: SchedulingPolicy(
///     quietHours: try QuietHours(from: "22:00", to: "07:00")
/// ))
/// try await scheduler.requestAuthorization()
/// try await scheduler.schedule(LocalNotification(id: "standup", title: "Stand-up in 10 minutes",
///                                                trigger: .after(minutes: 10)))
/// ```
///
/// The system keeps only the 64 soonest pending notifications of an app and silently drops the
/// others. The scheduler hands the system the soonest ones, keeps the rest in its own queue
/// (saved by a ``NotificationStore``), and moves them up when slots free. Call ``refresh()``
/// when the app starts or comes to the foreground so that happens.
///
/// Calls run one at a time in the order they were made, so two `schedule` calls cannot
/// interleave their changes.
public actor NotificationScheduler {
    private let center: any NotificationCenterClient
    private let store: any NotificationStore
    private let calendar: Calendar
    private let now: @Sendable () -> Date
    public private(set) var policy: SchedulingPolicy
    private var state: SchedulerState?
    private var tail: Task<Void, Never>?

    /// The most delivery dates remembered for the frequency cap.
    static let maximumHistoryCount = 1_000

    /// - Parameters:
    ///   - center: The system center by default; ``InMemoryNotificationCenter`` in tests.
    ///   - store: Where the queue is saved. Defaults to a file in Application Support.
    ///   - policy: Quiet hours, frequency cap and how many system slots to use.
    ///   - calendar: Used for date triggers and quiet hours.
    ///   - now: The current time. Tests pass a clock they control.
    public init(
        center: any NotificationCenterClient = UserNotificationCenterClient(),
        store: any NotificationStore = FileNotificationStore.applicationSupport(),
        policy: SchedulingPolicy = SchedulingPolicy(),
        calendar: Calendar = .autoupdatingCurrent,
        now: @escaping @Sendable () -> Date = Date.init
    ) {
        self.center = center
        self.store = store
        self.policy = policy
        self.calendar = calendar
        self.now = now
    }

    // MARK: - Permission and settings

    /// Asks the user for permission to show notifications.
    @discardableResult
    public func requestAuthorization(options: AuthorizationOptions = .standard) async throws -> Bool {
        try await center.requestAuthorization(options: options)
    }

    public func settings() async -> NotificationSettings {
        await center.settings()
    }

    /// Registers the categories (action buttons) the app uses, replacing earlier ones.
    public func register(_ categories: [NotificationCategory]) async {
        await center.setCategories(categories)
    }

    public func setBadgeCount(_ count: Int) async throws {
        try await center.setBadgeCount(count)
    }

    /// Changes the policy. Notifications already scheduled keep their dates.
    public func updatePolicy(_ policy: SchedulingPolicy) {
        self.policy = policy
    }

    // MARK: - Scheduling

    /// Schedules a notification, replacing one with the same identifier.
    ///
    /// - Returns: Where the notification went and when it fires after quiet hours and the
    ///   frequency cap.
    /// - Throws: ``NotificationValidationError`` for values the system would reject,
    ///   ``SchedulerError`` when the scheduler is full, or the system's error.
    @discardableResult
    public func schedule(_ notification: LocalNotification) async throws -> ScheduledNotification {
        let results = try await schedule([notification])
        guard let result = results.first else { throw SchedulerError.duplicateIdentifier(notification.id) }
        return result
    }

    /// Schedules several notifications. All of them are checked before any is scheduled.
    @discardableResult
    public func schedule(_ notifications: [LocalNotification]) async throws -> [ScheduledNotification] {
        try await serialized { scheduler in try await scheduler.performSchedule(notifications) }
    }

    /// Cancels pending or queued notifications. Delivered ones stay in Notification Center.
    public func cancel(ids: [String]) async throws {
        try await serialized { scheduler in
            let ids = Set(ids)
            var state = try await scheduler.loadedState()
            state.entries.removeAll { ids.contains($0.id) }
            await scheduler.center.removePendingNotifications(withIDs: Array(ids))
            scheduler.state = state
            _ = try await scheduler.performRefresh()
        }
    }

    /// Cancels every notification this scheduler manages. Notifications scheduled by other code
    /// are left alone.
    public func cancelAll() async throws {
        try await serialized { scheduler in
            var state = try await scheduler.loadedState()
            let ids = state.entries.map(\.id)
            state.entries.removeAll()
            await scheduler.center.removePendingNotifications(withIDs: ids)
            scheduler.state = state
            try await scheduler.store.save(state)
        }
    }

    /// Removes delivered notifications from Notification Center.
    public func removeDelivered(ids: [String]) async {
        await center.removeDeliveredNotifications(withIDs: ids)
    }

    /// Forgets delivered notifications, drops or delivers overdue queued ones, and moves queued
    /// notifications into free system slots.
    @discardableResult
    public func refresh() async throws -> RefreshReport {
        try await serialized { scheduler in try await scheduler.performRefresh() }
    }

    /// Every managed notification, soonest first, after a ``refresh()``.
    public func scheduled() async throws -> [ScheduledNotification] {
        try await serialized { scheduler in
            _ = try await scheduler.performRefresh()
            return try await scheduler.loadedState().entries
        }
    }

    // MARK: - Work

    private func performSchedule(_ notifications: [LocalNotification]) async throws -> [ScheduledNotification] {
        var seen = Set<String>()
        for notification in notifications {
            guard seen.insert(notification.id).inserted else { throw SchedulerError.duplicateIdentifier(notification.id) }
            try notification.validate(calendar: calendar)
        }
        let date = now()
        let pending = Set(await center.pendingNotificationIDs())
        var state = try await loadedState()
        var pruned = planner.prune(state.entries, pendingIDs: pending, now: date)
        pruned.entries.removeAll { seen.contains($0.id) }
        guard pruned.entries.count + notifications.count <= policy.maximumCount else {
            throw SchedulerError.limitReached(policy.maximumCount)
        }
        let resolver = FireDateResolver(policy: policy, calendar: calendar)
        let recent = prunedHistory(state.deliveryHistory + pruned.deliveredDates, now: date)
        for notification in notifications {
            pruned.entries.append(try resolver.resolve(notification, at: date, existing: pruned.entries, recentDeliveries: recent))
        }
        try await apply(planner.assign(pruned, pendingIDs: pending), to: &state, now: date)
        return notifications.compactMap { notification in state.entries.first { $0.id == notification.id } }
    }

    private func performRefresh() async throws -> RefreshReport {
        var state = try await loadedState()
        let date = now()
        let plan = planner.plan(entries: state.entries, pendingIDs: Set(await center.pendingNotificationIDs()), now: date)
        try await apply(plan, to: &state, now: date)
        return plan.report
    }

    /// Takes demoted notifications out of the system before adding new ones, so the system
    /// never holds more than its limit and never drops one on its own.
    private func apply(_ plan: SlotPlanner.Plan, to state: inout SchedulerState, now date: Date) async throws {
        state.entries = plan.entries.sorted(by: SlotPlanner.isSooner)
        state.deliveryHistory = prunedHistory(state.deliveryHistory + plan.deliveredDates, now: date)
        if !plan.remove.isEmpty { await center.removePendingNotifications(withIDs: plan.remove) }
        var failure: (any Error)?
        for entry in plan.add {
            do {
                try await center.add(entry.notification)
            } catch {
                state.entries.removeAll { $0.id == entry.id }
                failure = failure ?? error
            }
        }
        self.state = state
        try await store.save(state)
        if let failure { throw failure }
    }

    private var planner: SlotPlanner {
        SlotPlanner(capacity: policy.systemCapacity, overdueBehavior: policy.overdueBehavior, calendar: calendar)
    }

    /// Keeps the deliveries that can still count toward the frequency cap.
    private func prunedHistory(_ history: [Date], now date: Date) -> [Date] {
        guard let cap = policy.frequencyCap else { return [] }
        let cutoff = date.addingTimeInterval(-cap.interval)
        return Array(history.filter { $0 > cutoff }.sorted().suffix(Self.maximumHistoryCount))
    }

    /// Loads the saved state once. Entries that fail validation (from a damaged or older file)
    /// and duplicates are dropped rather than handed to the system.
    private func loadedState() async throws -> SchedulerState {
        if let state { return state }
        var loaded = try await store.load() ?? SchedulerState()
        var seen = Set<String>()
        loaded.entries = Array(loaded.entries.filter { entry in
            (try? entry.notification.validate(calendar: calendar)) != nil && seen.insert(entry.id).inserted
        }.prefix(policy.maximumCount))
        loaded.deliveryHistory = Array(loaded.deliveryHistory.filter(DateBounds.contains).suffix(Self.maximumHistoryCount))
        state = loaded
        return loaded
    }

    /// Runs `operation` after every operation started before it has finished.
    private func serialized<T: Sendable>(
        _ operation: @escaping @Sendable (isolated NotificationScheduler) async throws -> T
    ) async throws -> T {
        let previous = tail
        let task = Task {
            await previous?.value
            return try await operation(self)
        }
        tail = Task { _ = try? await task.value }
        return try await task.value
    }
}
