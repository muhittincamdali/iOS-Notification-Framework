import Foundation

/// A notification managed by ``NotificationScheduler``, with where it is and when it fires.
public struct ScheduledNotification: Sendable, Hashable, Codable, Identifiable {
    /// Where the notification waits.
    public enum Placement: String, Sendable, Hashable, Codable {
        /// Handed to the system, which delivers it.
        case system
        /// Waiting in the scheduler's queue for a free system slot.
        case queued
    }

    /// Why the fire date differs from the one requested.
    public enum Adjustment: String, Sendable, Hashable, Codable {
        /// Moved to the end of quiet hours.
        case quietHours
        /// Moved later to keep the frequency cap.
        case frequencyCap
    }

    /// The notification as handed to the system. One-time triggers are resolved to
    /// ``NotificationTrigger/date(_:)`` with the final fire date.
    public var notification: LocalNotification
    /// The trigger the app asked for.
    public var requestedTrigger: NotificationTrigger
    /// When the app scheduled the notification. Repeating intervals count from here.
    public var scheduledAt: Date
    /// The next delivery, or `nil` for region triggers.
    public var fireDate: Date?
    /// The date the requested trigger gave, before quiet hours and the frequency cap.
    public var requestedFireDate: Date?
    public var adjustments: [Adjustment]
    public var placement: Placement

    public var id: String { notification.id }
}

/// What the scheduler does on top of the system's own scheduling.
public struct SchedulingPolicy: Sendable, Hashable {
    /// What happens to a queued notification whose date passed before a slot was free, which
    /// happens when the app is not opened while more than 64 notifications are due.
    public enum OverdueBehavior: String, Sendable, Hashable, Codable {
        /// Drop it and report it in ``RefreshReport/expired``.
        case discard
        /// Deliver it now.
        case deliverNow
    }

    /// The pending notifications the system keeps per app. Requests beyond it are dropped by
    /// the system without an error.
    public static let systemLimit = 64

    public var quietHours: QuietHours?
    public var frequencyCap: FrequencyCap?
    /// System slots the scheduler may use, from 1 to 64. Lower it to leave room for
    /// notifications scheduled by other code.
    public var systemCapacity: Int {
        didSet { systemCapacity = min(max(systemCapacity, 1), Self.systemLimit) }
    }
    /// The most notifications the scheduler manages (system and queue together).
    public var maximumCount: Int {
        didSet { maximumCount = min(max(maximumCount, 1), 10_000) }
    }
    public var overdueBehavior: OverdueBehavior

    public init(
        quietHours: QuietHours? = nil,
        frequencyCap: FrequencyCap? = nil,
        systemCapacity: Int = SchedulingPolicy.systemLimit,
        maximumCount: Int = 500,
        overdueBehavior: OverdueBehavior = .discard
    ) {
        self.quietHours = quietHours
        self.frequencyCap = frequencyCap
        self.systemCapacity = min(max(systemCapacity, 1), Self.systemLimit)
        self.maximumCount = min(max(maximumCount, 1), 10_000)
        self.overdueBehavior = overdueBehavior
    }
}

/// What ``NotificationScheduler/refresh()`` changed.
public struct RefreshReport: Sendable, Hashable {
    /// Notifications moved from the queue to the system.
    public var promoted: [String] = []
    /// Notifications moved from the system back to the queue to make room for earlier ones.
    public var demoted: [String] = []
    /// One-time notifications the system has delivered since the last refresh.
    public var delivered: [String] = []
    /// Queued notifications whose date passed while they waited, dropped because the policy's
    /// ``SchedulingPolicy/OverdueBehavior`` is `discard`.
    public var expired: [String] = []

    public init() {}
}

/// Errors from ``NotificationScheduler``.
public enum SchedulerError: Error, Hashable, Sendable {
    /// The scheduler already manages ``SchedulingPolicy/maximumCount`` notifications.
    case limitReached(Int)
    /// Two notifications in one call have the same identifier.
    case duplicateIdentifier(String)
}

extension SchedulerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .limitReached(let limit): "The scheduler already manages \(limit) notifications."
        case .duplicateIdentifier(let id): "More than one notification has the identifier \"\(id)\"."
        }
    }
}
