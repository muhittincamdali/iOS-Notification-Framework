# Getting Started

Add the package, ask for permission, schedule a notification and react when the user taps it.

## Add the package

In Xcode, choose **File › Add Package Dependencies…**, enter
`https://github.com/muhittincamdali/iOS-Notification-Framework` and add the `NotificationKit`
library to your app target. In a `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Notification-Framework.git", from: "2.0.0")
],
targets: [
    .target(name: "MyApp", dependencies: [
        .product(name: "NotificationKit", package: "iOS-Notification-Framework")
    ])
]
```

NotificationKit needs iOS 17, macOS 14, watchOS 10 or visionOS 1, and Swift 6.2 (Xcode 26) or
later.

## Ask for permission and schedule

Create one ``NotificationScheduler`` for the whole app. It saves its queue in Application
Support, so a second instance would work on the same file without coordinating with the first.

```swift
import NotificationKit

let scheduler = NotificationScheduler()

func remindMe() async throws {
    try await scheduler.requestAuthorization()
    try await scheduler.schedule(LocalNotification(
        id: "water",
        title: "Time for a glass of water",
        body: "You asked for this reminder 10 seconds ago.",
        trigger: .after(seconds: 10)
    ))
}
```

``NotificationScheduler/requestAuthorization(options:)`` shows the system prompt the first time
and returns the stored answer afterwards. Ask when the user does something that needs
notifications, not at launch: the prompt is shown only once.

A notification is a value. Change it like any other struct before you schedule it:

```swift
var reminder = LocalNotification(id: "standup", title: "Stand-up in 10 minutes",
                                 trigger: .weekly(weekday: 2, hour: 9, minute: 20))
reminder.threadID = "meetings"
reminder.interruptionLevel = .timeSensitive
reminder.deepLink = URL(string: "myapp://meetings/standup")
```

Scheduling another notification with the same identifier replaces the earlier one.

## Show notifications while the app is open

By default the system does not show a notification while its app is in the foreground. Install
a ``NotificationEventHandler`` while the app launches; it shows them as banners and reports what
the user does:

```swift
@main
struct MyApp: App {
    let events = NotificationEventHandler()

    init() {
        events.install()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    for await response in events.responses {
                        print(response.action, response.notification.id)
                    }
                }
        }
    }
}
```

## Keep the queue moving

Call ``NotificationScheduler/refresh()`` when the app starts and when it returns to the
foreground. It forgets delivered notifications and moves queued ones into the free system slots:

```swift
.onChange(of: scenePhase) { _, phase in
    if phase == .active { Task { try? await scheduler.refresh() } }
}
```

<doc:SchedulingBeyondTheLimit> explains the queue, quiet hours and the frequency cap.
