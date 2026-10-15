import Foundation

/// Decides which managed notifications the system holds and which wait in the queue.
///
/// The system keeps only the 64 soonest pending notifications per app and drops the rest
/// without an error. The planner keeps the soonest ones in the system and the others in the
/// queue, so nothing is dropped, and moves queued ones up as slots free.
struct SlotPlanner {
    struct Plan: Equatable {
        /// The managed notifications after the plan, with updated placements and fire dates.
        var entries: [ScheduledNotification] = []
        /// Notifications to hand to the system.
        var add: [ScheduledNotification] = []
        /// Identifiers to take out of the system, to make room for earlier notifications.
        var remove: [String] = []
        var report = RefreshReport()
        /// Fire dates of one-time notifications delivered since the last plan.
        var deliveredDates: [Date] = []
    }

    let capacity: Int
    let overdueBehavior: SchedulingPolicy.OverdueBehavior
    let calendar: Calendar

    /// ``prune(_:pendingIDs:now:)`` followed by ``assign(_:pendingIDs:)``.
    func plan(entries: [ScheduledNotification], pendingIDs: Set<String>, now: Date) -> Plan {
        assign(prune(entries, pendingIDs: pendingIDs, now: now), pendingIDs: pendingIDs)
    }

    /// Drops delivered and expired notifications and updates the next fire date of repeating
    /// ones. The returned plan's `entries` are the survivors; nothing is added or removed yet.
    func prune(_ entries: [ScheduledNotification], pendingIDs: Set<String>, now: Date) -> Plan {
        var plan = Plan()
        var kept: [ScheduledNotification] = []
        for var entry in entries {
            let isPending = pendingIDs.contains(entry.id)
            let oneTime = !entry.notification.trigger.repeats
            if entry.placement == .system, !isPending, oneTime, entry.fireDate.map({ $0 <= now }) ?? true {
                plan.report.delivered.append(entry.id)
                if let fireDate = entry.fireDate { plan.deliveredDates.append(fireDate) }
                continue
            }
            if entry.placement == .queued, oneTime, let fireDate = entry.fireDate, fireDate < now {
                guard overdueBehavior == .deliverNow else {
                    plan.report.expired.append(entry.id)
                    continue
                }
                entry.notification.trigger = .immediately
                entry.fireDate = now
            }
            if !oneTime {
                entry.fireDate = entry.notification.trigger.nextFireDate(after: now, anchor: entry.scheduledAt, calendar: calendar)
            }
            kept.append(entry)
        }
        plan.entries = kept
        return plan
    }

    /// Gives the soonest notifications the free system slots and queues the rest.
    func assign(_ pruned: Plan, pendingIDs: Set<String>) -> Plan {
        var plan = pruned
        let kept = pruned.entries
        plan.entries = []
        let managedIDs = Set(kept.map(\.id))
        let foreignCount = pendingIDs.subtracting(managedIDs).count
        let freeSlots = max(0, capacity - foreignCount)
        let ordered = kept.sorted(by: Self.isSooner)
        for (index, var entry) in ordered.enumerated() {
            let inSystem = entry.placement == .system && pendingIDs.contains(entry.id)
            if index < freeSlots {
                if !inSystem {
                    if entry.placement == .queued { plan.report.promoted.append(entry.id) }
                    entry.placement = .system
                    plan.add.append(entry)
                }
            } else {
                if pendingIDs.contains(entry.id) {
                    plan.remove.append(entry.id)
                    if entry.placement == .system { plan.report.demoted.append(entry.id) }
                }
                entry.placement = .queued
            }
            plan.entries.append(entry)
        }
        return plan
    }

    /// Region triggers first (they have no date and must stay with the system to fire), then
    /// by fire date, then by identifier so the order is stable.
    static func isSooner(_ lhs: ScheduledNotification, _ rhs: ScheduledNotification) -> Bool {
        switch (lhs.fireDate, rhs.fireDate) {
        case (nil, nil): lhs.id < rhs.id
        case (nil, _): true
        case (_, nil): false
        case let (left?, right?): left == right ? lhs.id < rhs.id : left < right
        }
    }
}
