# Testing Notifications

Test scheduling logic without a device, a simulator or a permission prompt.

## Use the in-memory center

`UNUserNotificationCenter.current()` needs an app bundle, so it cannot run in a plain unit
test. ``NotificationScheduler`` talks to the system through ``NotificationCenterClient``; give it
an ``InMemoryNotificationCenter`` and an ``InMemoryNotificationStore`` instead:

```swift
import NotificationKit
import Testing

@Test func keepsTheSoonestWithTheSystem() async throws {
    let center = InMemoryNotificationCenter(authorizationStatus: .authorized)
    let scheduler = NotificationScheduler(center: center, store: InMemoryNotificationStore())
    let reminders = (1...70).map {
        LocalNotification(id: "r\($0)", title: "Reminder \($0)", trigger: .after(minutes: Double($0)))
    }
    try await scheduler.schedule(reminders)
    #expect(await center.pending.count == 64)
}
```

The in-memory center behaves like the system where it matters for scheduling: it keeps only the
64 soonest pending notifications and records the others in
``InMemoryNotificationCenter/dropped``, delivers ``NotificationTrigger/immediately`` at once,
and rejects the same invalid values.

## Control time

Pass the same clock to the center and the scheduler, then move it:

```swift
final class TestClock: @unchecked Sendable {
    private let lock = NSLock()
    private var current = Date(timeIntervalSince1970: 1_800_000_000)
    var now: Date { lock.withLock { current } }
    func advance(by seconds: TimeInterval) { lock.withLock { current += seconds } }
}

let clock = TestClock()
let center = InMemoryNotificationCenter(authorizationStatus: .authorized, now: { clock.now })
let scheduler = NotificationScheduler(center: center, store: InMemoryNotificationStore(),
                                      now: { clock.now })

clock.advance(by: 600)
await center.advance(to: clock.now)          // delivers what is due
let report = try await scheduler.refresh()   // report.delivered, report.promoted
```

Give the scheduler and ``QuietHours`` a `Calendar` with a fixed time zone so results do not
depend on the machine that runs the tests.

## Test the rest end to end

Banners, taps and pushes need the real system. The example app's UI tests
(`Examples/NotificationLab/NotificationLabUITests`) run on a simulator: they allow
notifications, schedule a reminder, tap its banner, fill the queue past 64, and open an order
from a push sent with `xcrun simctl push`.
