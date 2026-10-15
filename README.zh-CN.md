<!-- i18n-source: README.md@ec016ee0ad2ba2aa43292d365964c8583f51666d status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg" alt="NotificationKit: Schedule local notifications past iOS's 64 limit, route taps and send pushes through APNs."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg" alt="CI 状态"></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg" alt="最新版本: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg" alt="支持的平台: iOS 17+ · macOS 14+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg" alt="语言版本: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg" alt="许可证: MIT"></picture></a>
</p>

<p align="center">
<a href="#快速开始"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-zh-CN-light.svg" alt="开始使用"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-zh-CN-light.svg" alt="文档"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-zh-CN-light.svg" alt="示例"></picture></a>
</p>

> 本文是英文 README 的译文。如两者内容不一致，以英文版为准。

<!-- brand:end -->

NotificationKit 是一个 Swift 软件包，面向在设备上调度通知的应用，也面向向这些应用推送消息的服务器。它用值类型封装 `UserNotifications`，并修复了其中会静默失败的几处问题：iOS 只保留应用最近的 64 条待发送通知，其余的会被直接丢弃且不报任何错误；某些无效值会让应用崩溃而不是抛出错误；delegate 回调也很难在 Swift concurrency 中使用。第二个库 `NotificationKitAPNs` 可以在服务器或脚本中通过 Apple 的 APNs 服务发送推送，并使用与应用读取时相同的 payload 类型。两个库都不依赖 Apple SDK 之外的任何东西。

## 亮点

- **超过 64 条也不丢通知** — `NotificationScheduler` 把最近的 64 条通知交给 iOS，其余的保存在持久化队列中，有空位时再依次补上。
- **静默时段与频率上限** — 按通知触发的时间来检查：例如 21:00 设置、23:00 触发的提醒会等到早晨，一小时内的第四条通知会顺延到第一个允许的时间。
- **抛出错误，而不是崩溃** — 小于 60 秒的重复间隔、NaN 的 relevance score 或 25 点，都会在 `UNUserNotificationCenter` 看到之前抛出 `NotificationValidationError`。
- **点击、操作与 deep link 都是值** — `NotificationEventHandler` 把 delegate 回调转换成 `AsyncStream`，`DeepLinkRouter` 只会从你允许的 scheme 和 host 打开页面。
- **服务端与客户端都支持推送** — 遵循 APNs 规则和大小限制的强类型 `PushPayload`、绝不完整输出的 `DeviceToken`、能在 Apple 限制内下载媒体的 Notification Service Extension，以及支持 token 认证的 APNs 客户端。
- **经过测试** — 在 macOS 和 iPhone 模拟器上运行 109 个 Swift Testing 测试，并配有一个遵循系统 64 条通知上限的内存通知中心；另有三个 UI 测试，在模拟器上点击真实的横幅，并通过真实推送打开订单。

## 快速开始

**1. 添加软件包**

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

把 `NotificationKit` 库添加到你的 App target。

**2. 导入模块**

```swift
import NotificationKit
```

**3. 开始使用**

把新建 iOS 应用中的 `ContentView.swift` 替换为：

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

运行应用，点击按钮，允许通知，然后回到主屏幕：提醒会在 10 秒后到达。若想在应用处于前台时也显示通知，请安装一个 `NotificationEventHandler`（参见[响应点击和操作](#响应点击和操作)）。

## 安装

### Swift Package Manager

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

或者将其添加到 `Package.swift` 的 `dependencies` 中：

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

## 使用方法

以下示例复制自
[`Examples/NotificationLab/NotificationLab/ReadmeSamples.swift`](Examples/NotificationLab/NotificationLab/ReadmeSamples.swift)，示例应用和软件包的测试都会编译这个文件。

### 调度通知

`LocalNotification` 是一个带有 `NotificationTrigger` 的值：可以在延迟一段时间后、在指定日期、在匹配的日期组件上（`.daily`、`.weekly`、`.monthly`）或在进入某个区域时触发。使用相同标识符再次调度通知，会替换之前的那一条。

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

请在应用启动时和回到前台时调用 `try await scheduler.refresh()`；它会清除已送达的通知，并把队列中的通知移入空闲的位置。

### 静默时段与频率上限

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

时效性（time-sensitive）通知和紧急（critical）通知默认会绕过静默时段。重复通知则保持用户选择的时间。

### 操作

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

### 响应点击和操作

应用启动时创建一个 `NotificationEventHandler`，并在启动完成之前（在你的 `App` 初始化方法中）调用 `events.install()`，这样就不会错过那次启动应用的点击。

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

### 设备端的推送通知

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

`print(token)` 会输出 `DeviceToken(3f2a…91bc, 32 bytes)`；`dump`、字符串插值和调试器中也采用同样的脱敏处理。

### 从服务器发送

下面的代码来自 [`Examples/PushSender`](Examples/PushSender)，这是一个基于 `NotificationKitAPNs` 构建的命令行工具：

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

把 Notification Service Extension target 的主类（principal class）设为 `MediaAttachmentService` 的子类。带有 `"mutable-content": 1` 和 `"media-url"` 的推送随后会显示图片、音频或视频。下载仅支持 `https`，并在达到 Apple 的大小限制时停止。

```swift
import NotificationKit

// The principal class of the extension. Pushes with "mutable-content": 1 and a "media-url"
// get the image, audio or video attached before they are shown.
final class NotificationService: MediaAttachmentService {}
```

### 测试

`InMemoryNotificationCenter` 的行为与系统通知中心一致，包括 64 条通知的上限，因此调度逻辑可以在普通的单元测试中运行：

```swift
func scheduledCount() async throws -> Int {
    let center = InMemoryNotificationCenter(authorizationStatus: .authorized)
    let scheduler = NotificationScheduler(center: center, store: InMemoryNotificationStore())
    let reminders = (1...70).map { LocalNotification(id: "r\($0)", title: "Reminder \($0)", trigger: .after(minutes: Double($0))) }
    try await scheduler.schedule(reminders)
    return await center.pending.count // 64: the other 6 wait in the scheduler's queue
}
```

## 演示

| 横幅                                            | 超过 64 条的队列                                 | 从推送打开                                                        |
| ----------------------------------------------- | ------------------------------------------------ | ----------------------------------------------------------------- |
| ![提醒横幅，浅色](docs/images/banner-light.png) | ![已调度列表，浅色](docs/images/queue-light.png) | ![从推送打开的订单，浅色](docs/images/push-destination-light.png) |
| ![提醒横幅，深色](docs/images/banner-dark.png)  | ![已调度列表，深色](docs/images/queue-dark.png)  | ![从推送打开的订单，深色](docs/images/push-destination-dark.png)  |

截图来自示例应用在 iPhone 模拟器上的 UI 测试，由
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh) 运行。这些测试会允许通知、调度一条提醒并点击它的横幅，调度 70 条提醒（64 条交给 iOS，其余的在队列中等待；另有一条落在静默时段内），并通过一条推送打开订单；这条推送由脚本用 `PushPayload` 构建，再用 `xcrun simctl push` 送达。

想自己试一试，请打开 [`Examples/NotificationLab`](Examples/NotificationLab) 中的 `NotificationLab.xcodeproj`，选择一台 iPhone 模拟器并点击 **Run**。更多细节见 [Examples/README.md](Examples/README.md)。

## 文档

API 参考文档与文章：

- `NotificationKit` 的 [API 参考](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/)，
  以及
  [`NotificationKitAPNs`](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/)
  （DocC，从 `main` 分支发布到 GitHub Pages）
- 可以在 Xcode 中通过 **Product › Build Documentation** 在本地构建，或使用命令行：

```sh
xcodebuild docbuild -scheme NotificationKit-Package -destination 'generic/platform=macOS'
```

## 指南

- [Getting Started](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/gettingstarted)
  — 添加软件包、请求权限、调度通知并响应点击
  （[源文件](Sources/NotificationKit/NotificationKit.docc/GettingStarted.md)）。
- [Scheduling Beyond the Limit](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/schedulingbeyondthelimit)
  — 队列、静默时段、频率上限，以及调度前会检查的值
  （[源文件](Sources/NotificationKit/NotificationKit.docc/SchedulingBeyondTheLimit.md)）。
- [Responding to Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/respondingtonotifications)
  — 类别、操作、事件流和 deep link
  （[源文件](Sources/NotificationKit/NotificationKit.docc/RespondingToNotifications.md)）。
- [Remote Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/remotenotifications)
  — 设备 token、payload、service extension 中的媒体，以及模拟器推送
  （[源文件](Sources/NotificationKit/NotificationKit.docc/RemoteNotifications.md)）。
- [Testing Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/testingnotifications)
  — 内存通知中心和可控的时钟
  （[源文件](Sources/NotificationKit/NotificationKit.docc/TestingNotifications.md)）。
- [Sending Push Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/sendingpushnotifications)
  — APNs 密钥、环境、alert、后台推送与 Live Activity 推送、错误处理
  （[源文件](Sources/NotificationKitAPNs/NotificationKitAPNs.docc/SendingPushNotifications.md)）。

## 系统要求

| 平台     | 最低版本              |
| -------- | --------------------- |
| iOS      | 17                    |
| macOS    | 14                    |
| watchOS  | 10                    |
| visionOS | 1                     |
| 工具链   | Swift 6.2 · Xcode 26+ |

位置触发器适用于 iOS 和 watchOS；watchOS 上不支持附件，指定名称的声音也会播放默认声音。`NotificationKitAPNs` 需要 CryptoKit，因此无法在 Linux 上构建。CI 使用 GitHub `macos-26` runner 镜像默认的 Xcode 进行构建。该软件包使用 Xcode 27 开发。

## 架构

- `NotificationKit` 按职责划分：`Content/`（通知值、声音、JSON user info、校验错误）、`Triggers/`、`Policy/`（静默时段、频率上限）、`Scheduling/`、`Center/`（系统通知中心和内存通知中心）、`Categories/`、`Events/`（delegate、响应、deep link）、`Push/`（payload、token）和 `Extension/`（媒体下载）。
- `NotificationScheduler` 是一个 actor，逐个执行调用。它依靠两个纯类型做决策：`FireDateResolver` 应用静默时段和频率上限，`SlotPlanner` 决定系统持有哪些通知。两者都无需设备即可测试。
- 只通过 `NotificationCenterClient` 协议访问系统；`UserNotificationCenterClient` 把值映射为 `UNNotificationRequest`，`InMemoryNotificationCenter` 则在测试和预览中替代它。
- 来自应用外部的输入（推送 payload、deep link、下载的媒体、保存的状态）都有边界限制：JSON 的嵌套深度和值数量、链接长度和路径段数、下载大小、保存的队列文件大小，以及任何 `Double` 转为 `Int` 之前的范围检查。
- `NotificationKitAPNs` 把请求构建为值（`APNsRequest`），用 CryptoKit 签发 ES256 provider token，并通过基于 `URLSession` 的 `APNsTransport` 协议发送。

在本地运行测试：

```sh
swift test                                    # macOS
xcodebuild test -scheme NotificationKit-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## 路线图

- 把软件包添加到 Swift Package Index；仓库中已经有 `.spi.yml`。
- 在 `NotificationKitAPNs` 中支持 Live Activity 的广播推送频道（iOS 18）。
- 基于 swift-crypto 的 `NotificationKitAPNs` Linux 构建。

## 参与贡献

欢迎参与贡献。提交 pull request 之前，请先阅读[贡献指南](https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/CONTRIBUTING.md)和[行为准则](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)。如发现安全问题，请按照[安全策略](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)私下报告。

## 许可证

基于 MIT 许可证发布。详见 [LICENSE](LICENSE)。
