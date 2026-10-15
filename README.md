<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg" alt="NotificationKit: Schedule local notifications past iOS's 64 limit, route taps and send pushes through APNs."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg" alt="Latest version: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg" alt="Supported platforms: iOS 17+ · macOS 14+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg" alt="Language version: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg" alt="License: MIT"></picture></a>
</p>

<p align="center">
<a href="#quick-start"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-en-light.svg" alt="Get started"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-en-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-en-light.svg" alt="Examples"></picture></a>
</p>

<!-- brand:end -->

NotificationKit is a Swift package for apps that schedule notifications on the device and for
the servers that push to them. It wraps `UserNotifications` in value types and fixes the parts of
it that fail silently: iOS keeps only the 64 soonest pending notifications of an app and drops
the rest without an error, some invalid values crash the app instead of throwing, and the
delegate callbacks are hard to use from Swift concurrency. A second library,
`NotificationKitAPNs`, sends pushes through Apple's APNs service from a server or a script, using
the same payload type the app reads. Neither library has dependencies outside Apple's SDK.

## Highlights

- **No lost notifications past 64** — `NotificationScheduler` hands iOS the 64 soonest
  notifications, keeps the others in a saved queue and moves them up as slots free.
- **Quiet hours and a frequency cap** — checked against the time a notification fires, so a
  reminder set at 21:00 for 23:00 waits for the morning, and a fourth notification within an
  hour moves to the first allowed time.
- **Errors instead of crashes** — a repeating interval under 60 seconds, a NaN relevance score
  or hour 25 throws a `NotificationValidationError` before `UNUserNotificationCenter` sees it.
- **Taps, actions and deep links as values** — `NotificationEventHandler` turns the delegate
  callbacks into `AsyncStream`s, and `DeepLinkRouter` opens screens only from the schemes and
  hosts you allow.
- **Push on both sides** — typed `PushPayload` with APNs' rules and size limits, a
  `DeviceToken` that never prints in full, a Notification Service Extension that downloads media
  within Apple's limits, and an APNs client with token authentication.
- **Tested** — 109 Swift Testing tests on macOS and an iPhone simulator, with an in-memory
  notification center that has the system's 64-notification limit; three UI tests on a
  simulator tap real banners and open an order from a real push.

## Quick start

**1. Add the package**

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Add the `NotificationKit` library to your app target.

**2. Import the module**

```swift
import NotificationKit
```

**3. Use it**

Replace the `ContentView.swift` of a new iOS app with:

```swift
import NotificationKit
import SwiftUI

let scheduler = NotificationScheduler() // one for the whole app

struct ContentView: View {
    var body: some View {
        Button("Remind me in 10 seconds") {
            Task {
                do {
                    try await scheduler.requestAuthorization()
                    try await scheduler.schedule(LocalNotification(
                        id: "water",
                        title: "Time for a glass of water",
                        body: "You asked for this reminder 10 seconds ago.",
                        trigger: .after(seconds: 10)
                    ))
                } catch {
                    print("Could not schedule the reminder:", error)
                }
            }
        }
    }
}
```

Run the app, tap the button, allow notifications and go to the Home Screen: the reminder
arrives 10 seconds later. To show notifications while the app is open too, install a
`NotificationEventHandler` (see [Responding to taps and actions](#responding-to-taps-and-actions)).

## Installation

### Swift Package Manager

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Or add it to the `dependencies` in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Notification-Framework.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "NotificationKit", package: "iOS-Notification-Framework")
    ]),
    // A server or command-line tool that sends pushes:
    .executableTarget(name: "PushServer", dependencies: [
        .product(name: "NotificationKitAPNs", package: "iOS-Notification-Framework")
    ])
]
```

## Usage

The samples below are copied from
[`Examples/NotificationLab/NotificationLab/ReadmeSamples.swift`](Examples/NotificationLab/NotificationLab/ReadmeSamples.swift),
which the example app and the package's tests compile.

### Scheduling

A `LocalNotification` is a value with a `NotificationTrigger`: after a delay, at a date, on
matching date components (`.daily`, `.weekly`, `.monthly`) or on entering a region. Scheduling
another notification with the same identifier replaces the earlier one.

```swift
func scheduleReminders(with scheduler: NotificationScheduler) async throws {
    var standup = LocalNotification(
        id: "standup",
        title: "Stand-up in 10 minutes",
        body: "Room 4B or the usual video link.",
        trigger: .weekly(weekday: 2, hour: 9, minute: 20) // Mondays at 09:20
    )
    standup.threadID = "meetings"
    standup.deepLink = URL(string: "myapp://meetings/standup")

    let invoice = LocalNotification(
        id: "invoice-1042",
        title: "Invoice 1042 is due tomorrow",
        trigger: .date(.now.addingTimeInterval(86_400))
    )

    let results = try await scheduler.schedule([standup, invoice])
    for result in results {
        // .system: handed to iOS; .queued: waits for a free slot (iOS keeps only 64).
        print(result.id, result.placement, result.fireDate ?? "on location")
    }
}
```

Call `try await scheduler.refresh()` when the app starts and when it returns to the
foreground; it forgets delivered notifications and moves queued ones into free slots.

### Quiet hours and a frequency cap

```swift
func makeScheduler() throws -> NotificationScheduler {
    NotificationScheduler(policy: SchedulingPolicy(
        // One-time notifications that would fire between 22:00 and 07:30 arrive at 07:30.
        quietHours: try QuietHours(from: "22:00", to: "07:30"),
        // At most three notifications in any hour; later ones move back.
        frequencyCap: try FrequencyCap(limit: 3, per: 3600)
    ))
}
```

Time-sensitive and critical notifications pass through quiet hours by default. Repeating
notifications keep the time the user chose.

### Actions

```swift
let messageCategory = NotificationCategory(
    id: "message",
    actions: [
        .textInput(id: "reply", title: "Reply", buttonTitle: "Send", placeholder: "Message"),
        .button(id: "mark-read", title: "Mark as Read", systemImageName: "checkmark"),
        .button(id: "mute", title: "Mute Thread", options: .destructive),
    ]
)

func registerCategories(with scheduler: NotificationScheduler) async {
    await scheduler.register([messageCategory])
}
```

### Responding to taps and actions

Create one `NotificationEventHandler` when the app starts and call `events.install()` before
launch finishes (in your `App` initializer), so a tap that launched the app is not missed.

```swift
enum Screen: Hashable, Sendable {
    case order(String)
    case inbox
}

func makeRouter() throws -> DeepLinkRouter<Screen> {
    // Only these schemes and hosts are accepted; links from a push come from a server.
    var router = DeepLinkRouter<Screen>(schemes: ["myapp", "https"], hosts: ["example.com"])
    try router.register("orders/:id") { .order($0.parameters["id"]!) }
    try router.register("inbox") { _ in .inbox }
    return router
}

func handleResponses(from events: NotificationEventHandler, router: DeepLinkRouter<Screen>, open: (Screen) -> Void) async {
    for await response in events.responses {
        switch response.action {
        case .custom("reply"):
            print("Reply:", response.textInput ?? "")
        case .custom("mark-read"):
            print("Read:", response.notification.id)
        default:
            if let screen = router.destination(for: response) { open(screen) }
        }
    }
}
```

### Push notifications on the device

```swift
func didRegisterForPushes(deviceToken data: Data) throws -> DeviceToken {
    let token = try DeviceToken(data: data)
    print("Registered:", token) // DeviceToken(3f2a…91bc, 32 bytes): safe to log
    // Send token.hexString to your server.
    return token
}

func readPayload(of notification: ReceivedNotification) {
    // The same type the server encodes with; see Examples/PushSender.
    if let link = notification.deepLink { print("Opens", link) }
    if let orderID = notification.userInfo["orderID"]?.stringValue { print("Order", orderID) }
}
```

`print(token)` shows `DeviceToken(3f2a…91bc, 32 bytes)`; the same redaction applies to
`dump`, string interpolation and the debugger.

### Sending from a server

From [`Examples/PushSender`](Examples/PushSender), a command-line tool built on
`NotificationKitAPNs`:

```swift
import NotificationKit
import NotificationKitAPNs

func makePayload(options: [String: String]) throws -> PushPayload {
    var payload = PushPayload.alert(
        title: try require("title", in: options),
        body: try require("body", in: options)
    )
    if let link = options["deeplink"] {
        payload.deepLink = URL(string: link)
    }
    if let media = options["media-url"] {
        // Picked up by the app's Notification Service Extension (MediaAttachmentService).
        payload.aps.mutableContent = true
        payload.custom["media-url"] = .string(media)
    }
    return payload
}

func send(options: [String: String]) async throws {
    let key = try APNsSigningKey(
        p8File: URL(fileURLWithPath: try require("key", in: options)),
        keyID: try require("key-id", in: options),
        teamID: try require("team-id", in: options)
    )
    let client = APNsClient(key: key, environment: options["sandbox"] != nil ? .development : .production)
    let request = APNsRequest(
        payload: try makePayload(options: options),
        deviceToken: try DeviceToken(hexString: try require("token", in: options)),
        topic: try require("topic", in: options)
    )
    do {
        let delivery = try await client.send(request)
        print("Accepted by APNs, apns-id \(delivery.apnsID)")
    } catch let error as APNsError where error.isTokenInvalid {
        print("The token is no longer valid; delete it from your database. (\(error.reason?.rawValue ?? "410"))")
        throw error
    }
}
```

### Notification Service Extension

Make the principal class of a Notification Service Extension target a subclass of
`MediaAttachmentService`. Pushes with `"mutable-content": 1` and a `"media-url"` then show the
image, audio or video. Downloads are `https` only and stop at Apple's size limits.

```swift
import NotificationKit

// The principal class of the extension. Pushes with "mutable-content": 1 and a "media-url"
// get the image, audio or video attached before they are shown.
final class NotificationService: MediaAttachmentService {}
```

### Testing

`InMemoryNotificationCenter` behaves like the system's center, including the 64-notification
limit, so scheduling logic runs in plain unit tests:

```swift
func scheduledCount() async throws -> Int {
    let center = InMemoryNotificationCenter(authorizationStatus: .authorized)
    let scheduler = NotificationScheduler(center: center, store: InMemoryNotificationStore())
    let reminders = (1...70).map { LocalNotification(id: "r\($0)", title: "Reminder \($0)", trigger: .after(minutes: Double($0))) }
    try await scheduler.schedule(reminders)
    return await center.pending.count // 64: the other 6 wait in the scheduler's queue
}
```

## Demo

| Banner                                                  | Queue past 64                                         | Opened from a push                                                         |
| ------------------------------------------------------- | ----------------------------------------------------- | -------------------------------------------------------------------------- |
| ![Reminder banner, light](docs/images/banner-light.png) | ![Scheduled list, light](docs/images/queue-light.png) | ![Order opened from a push, light](docs/images/push-destination-light.png) |
| ![Reminder banner, dark](docs/images/banner-dark.png)   | ![Scheduled list, dark](docs/images/queue-dark.png)   | ![Order opened from a push, dark](docs/images/push-destination-dark.png)   |

The screenshots come from the UI tests of the example app on an iPhone simulator, run by
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh). The tests allow
notifications, schedule a reminder and tap its banner, schedule 70 reminders (64 go to iOS, the
rest wait in the queue; one more lands in quiet hours), and open an order from a push that the
script builds with `PushPayload` and delivers with `xcrun simctl push`.

To try it yourself, open `NotificationLab.xcodeproj` in
[`Examples/NotificationLab`](Examples/NotificationLab), choose an iPhone simulator and press
**Run**. [Examples/README.md](Examples/README.md) has the details.

## Documentation

Reference documentation and articles:

- [API reference](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/)
  for `NotificationKit` and
  [`NotificationKitAPNs`](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/)
  (DocC, published to GitHub Pages from `main`)
- Build it locally in Xcode with **Product › Build Documentation**, or from the command line:

```sh
xcodebuild docbuild -scheme NotificationKit-Package -destination 'generic/platform=macOS'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/gettingstarted)
  — add the package, ask for permission, schedule and react to taps
  ([source](Sources/NotificationKit/NotificationKit.docc/GettingStarted.md)).
- [Scheduling Beyond the Limit](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/schedulingbeyondthelimit)
  — the queue, quiet hours, the frequency cap and the values checked before scheduling
  ([source](Sources/NotificationKit/NotificationKit.docc/SchedulingBeyondTheLimit.md)).
- [Responding to Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/respondingtonotifications)
  — categories, actions, event streams and deep links
  ([source](Sources/NotificationKit/NotificationKit.docc/RespondingToNotifications.md)).
- [Remote Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/remotenotifications)
  — device tokens, payloads, media in a service extension and simulator pushes
  ([source](Sources/NotificationKit/NotificationKit.docc/RemoteNotifications.md)).
- [Testing Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/testingnotifications)
  — the in-memory center and a controllable clock
  ([source](Sources/NotificationKit/NotificationKit.docc/TestingNotifications.md)).
- [Sending Push Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/sendingpushnotifications)
  — APNs keys, environments, alerts, background and Live Activity pushes, error handling
  ([source](Sources/NotificationKitAPNs/NotificationKitAPNs.docc/SendingPushNotifications.md)).

## Requirements

| Platform  | Minimum version       |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| watchOS   | 10                    |
| visionOS  | 1                     |
| Toolchain | Swift 6.2 · Xcode 26+ |

Location triggers work on iOS and watchOS; attachments are not available on watchOS, where named
sounds also play the default sound. `NotificationKitAPNs` needs CryptoKit, so it does not build
on Linux. CI builds with the default Xcode of GitHub's `macos-26` runner image. The package is
developed with Xcode 27.

## Architecture

- `NotificationKit` is split by job: `Content/` (the notification value, sounds, JSON user
  info, validation errors), `Triggers/`, `Policy/` (quiet hours, frequency cap), `Scheduling/`,
  `Center/` (the system and in-memory centers), `Categories/`, `Events/` (delegate, responses,
  deep links), `Push/` (payload, token) and `Extension/` (media downloads).
- `NotificationScheduler` is an actor that runs calls one at a time. It decides with two pure
  types: `FireDateResolver` applies quiet hours and the cap, `SlotPlanner` decides which
  notifications the system holds. Both are tested without a device.
- The system is reached only through the `NotificationCenterClient` protocol;
  `UserNotificationCenterClient` maps values to `UNNotificationRequest`, and
  `InMemoryNotificationCenter` stands in for it in tests and previews.
- Input from outside the app (push payloads, deep links, downloaded media, saved state) is
  bounded: nesting depth and value counts for JSON, link length and segments, download size,
  file size of the saved queue, and range checks before any `Double` becomes an `Int`.
- `NotificationKitAPNs` builds requests as values (`APNsRequest`), signs ES256 provider tokens
  with CryptoKit, and sends through an `APNsTransport` protocol backed by `URLSession`.

Run the tests locally:

```sh
swift test                                    # macOS
xcodebuild test -scheme NotificationKit-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Roadmap

- Add the package to the Swift Package Index; `.spi.yml` is already in the repository.
- Broadcast push channels for Live Activities (iOS 18) in `NotificationKitAPNs`.
- A Linux build of `NotificationKitAPNs` on swift-crypto.

## Contributing

Contributions are welcome. Read the [contributing guide](https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/CONTRIBUTING.md) and the [code of conduct](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) before opening a pull request. Report security issues privately as described in the [security policy](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## License

Released under the MIT license. See [LICENSE](LICENSE).
