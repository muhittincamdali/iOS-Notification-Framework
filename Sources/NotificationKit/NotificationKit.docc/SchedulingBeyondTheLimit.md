# Scheduling Beyond the Limit

How the scheduler keeps more than 64 notifications, and how quiet hours and the frequency cap
choose a fire date.

## The 64-notification limit

The system keeps the 64 pending local notifications of an app that fire soonest and discards
the others without an error. A repeating notification counts once. An app that schedules a
reminder for every day of the next three months therefore loses most of them, and
`UNUserNotificationCenter.add(_:)` never says so.

``NotificationScheduler`` keeps every notification it schedules in a ``SchedulerState``, saved
by a ``NotificationStore`` (a JSON file in Application Support by default). It gives the
system only the soonest ones that fit and marks the rest ``ScheduledNotification/Placement/queued``:

```swift
let results = try await scheduler.schedule(reminders) // 90 notifications
results.filter { $0.placement == .system }.count     // 64
results.filter { $0.placement == .queued }.count     // 26
```

Each call to ``NotificationScheduler/refresh()`` compares the state with the system's pending
requests:

- one-time notifications the system no longer holds and whose date has passed were delivered,
  and their record is dropped;
- queued notifications move into the slots that are now free, soonest first;
- a notification scheduled for an earlier date than one already with the system takes its slot,
  and the later one goes back to the queue (it is removed from the system first, so the system
  never holds more than 64 and never drops one itself).

The queue only moves while the app runs, so call `refresh()` at launch and when the app comes
to the foreground. A queued notification whose date passes before it reaches the system is
dropped and listed in ``RefreshReport/expired``; set ``SchedulingPolicy/overdueBehavior`` to
``SchedulingPolicy/OverdueBehavior/deliverNow`` to deliver it late instead.

Notifications that other code adds to `UNUserNotificationCenter` keep their slots: the scheduler
counts them and uses only what is left. ``SchedulingPolicy/systemCapacity`` lowers the number
of slots the scheduler uses, which leaves room for such code.

## Quiet hours

``QuietHours`` describes a daily window, such as 22:00 to 07:30. A one-time notification whose
fire date falls inside the window is moved to the window's end:

```swift
let scheduler = NotificationScheduler(policy: SchedulingPolicy(
    quietHours: try QuietHours(from: "22:00", to: "07:30")
))
let result = try await scheduler.schedule(LocalNotification(
    id: "digest", title: "Your daily digest", trigger: .after(hours: 2)
))
result.adjustments // [.quietHours] when it is 21:00 now
result.fireDate    // tomorrow 07:30
```

The check uses the date the notification fires, so a reminder scheduled at 21:00 for 23:00 is
held back too. Windows that start later than they end run over midnight. ``QuietHours/weekdays``
limits the days on which a window starts; a window that starts on Friday at 23:00 still covers
Saturday morning.

Time-sensitive and critical notifications pass through by default
(``QuietHours/allowsTimeSensitive``, ``QuietHours/allowsCritical``). Repeating notifications keep
the time the user picked: someone who asks for a reminder every day at 23:00 gets it at 23:00.

## Frequency cap

``FrequencyCap`` limits how many one-time notifications fire within any stretch of time:

```swift
SchedulingPolicy(frequencyCap: try FrequencyCap(limit: 3, per: 3600))
```

A notification that would be the fourth within an hour moves to the earliest later moment that
keeps every hour-long window at three or fewer. Notifications delivered recently count too: the
scheduler remembers their dates for one `interval`. The search checks only the requested date
and the dates one interval after each existing notification, so it ends after a number of steps
bounded by the number of notifications.

Quiet hours and the cap work together: if the cap moves a notification into quiet hours, it
moves to the end of the window, and the cap is checked again from there. Each step moves the
date later, so the process settles.

## What the scheduler checks

Before anything reaches the system, ``LocalNotification/validate(calendar:)`` rejects values
that `UserNotifications` crashes on or silently ignores:

| Value                                | Without the check                  |
| ------------------------------------ | ---------------------------------- |
| Repeating time interval below 60 s   | Objective-C exception, app crashes |
| Time interval of 0, negative or NaN  | Objective-C exception, app crashes |
| Date components such as hour 25      | Never fires                        |
| One-time date in the past            | Never fires                        |
| Relevance score outside 0...1 or NaN | Undefined ordering                 |
| Custom data with NaN or deep nesting | Cannot be stored or encoded        |

Each one throws a ``NotificationValidationError`` instead.
