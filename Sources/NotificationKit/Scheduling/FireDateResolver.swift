import Foundation

/// Applies quiet hours and the frequency cap to a new notification.
struct FireDateResolver {
    let policy: SchedulingPolicy
    let calendar: Calendar

    /// Resolves `notification` scheduled at `now`, next to the notifications already managed
    /// and the recent deliveries that count toward the frequency cap.
    func resolve(
        _ notification: LocalNotification,
        at now: Date,
        existing: [ScheduledNotification],
        recentDeliveries: [Date]
    ) throws(NotificationValidationError) -> ScheduledNotification {
        let trigger = notification.trigger
        // Repeating and region triggers keep the schedule the app chose.
        if case .region = trigger { return passthrough(notification, at: now) }
        if trigger.repeats { return passthrough(notification, at: now) }
        guard let requested = trigger.nextFireDate(after: now, anchor: now, calendar: calendar),
              trigger == .immediately || requested > now
        else { throw .fireDateInPast }

        let (fireDate, adjustments) = adjust(
            requested,
            level: notification.interruptionLevel,
            capDates: recentDeliveries + existing.compactMap { $0.notification.trigger.repeats ? nil : $0.fireDate }
        )
        var resolved = notification
        if fireDate != requested || trigger != .immediately {
            resolved.trigger = .date(fireDate)
        }
        guard DateBounds.contains(fireDate) else { throw .invalidDate }
        return ScheduledNotification(
            notification: resolved,
            requestedTrigger: trigger,
            scheduledAt: now,
            fireDate: fireDate,
            requestedFireDate: requested,
            adjustments: adjustments,
            placement: .queued
        )
    }

    /// Moves `date` out of quiet hours and under the cap. Each step only moves the date later,
    /// and the cap's candidates are finite, so the loop settles; the bound guards against a
    /// calendar that keeps reporting a window.
    func adjust(_ date: Date, level: InterruptionLevel, capDates: [Date]) -> (Date, [ScheduledNotification.Adjustment]) {
        let quietHours = policy.quietHours.flatMap { $0.allows(level) ? nil : $0 }
        let cap = (level == .critical || level == .timeSensitive) ? nil : policy.frequencyCap
        var current = date
        var adjustments: [ScheduledNotification.Adjustment] = []
        for _ in 0...(capDates.count + 2) {
            var next = current
            if let quietHours {
                let moved = quietHours.adjustedDate(for: next, calendar: calendar)
                if moved != next, !adjustments.contains(.quietHours) { adjustments.append(.quietHours) }
                next = moved
            }
            if let cap {
                let moved = cap.earliestDate(onOrAfter: next, existing: capDates)
                if moved != next, !adjustments.contains(.frequencyCap) { adjustments.append(.frequencyCap) }
                next = moved
            }
            if next == current { break }
            current = next
        }
        return (current, adjustments)
    }

    private func passthrough(_ notification: LocalNotification, at now: Date) -> ScheduledNotification {
        let fireDate = notification.trigger.nextFireDate(after: now, anchor: now, calendar: calendar)
        return ScheduledNotification(
            notification: notification,
            requestedTrigger: notification.trigger,
            scheduledAt: now,
            fireDate: fireDate,
            requestedFireDate: fireDate,
            adjustments: [],
            placement: .queued
        )
    }
}
