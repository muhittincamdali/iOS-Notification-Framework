<!-- i18n-source: README.md@3e5602b25e123d445fd60722eaff734a9354ff87 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg" alt="NotificationKit: Schedule local notifications past iOS's 64 limit, route taps and send pushes through APNs."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg" alt="CI ステータス"></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg" alt="最新バージョン: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg" alt="対応プラットフォーム: iOS 17+ · macOS 14+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg" alt="言語バージョン: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg" alt="ライセンス: MIT"></picture></a>
</p>

<p align="center">
<a href="#クイックスタート"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-ja-light.svg" alt="はじめる"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-ja-light.svg" alt="ドキュメント"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-ja-light.svg" alt="サンプル"></picture></a>
</p>

> このドキュメントは英語版 README の翻訳です。内容が異なる場合は英語版が最新です。

<!-- brand:end -->

NotificationKit は、端末上で通知をスケジュールするアプリと、そのアプリにプッシュを送るサーバーのための Swift パッケージです。`UserNotifications` を値型で包み、そのままでは黙って失敗してしまう部分を補います。iOS はアプリの保留中の通知のうち直近の 64 件しか保持せず、残りはエラーなしで破棄されます。無効な値によっては例外を投げずにアプリがクラッシュします。delegate のコールバックは Swift concurrency からは扱いにくい形です。もう一つのライブラリ `NotificationKitAPNs` は、サーバーやスクリプトから Apple の APNs サービス経由でプッシュを送ります。このとき、アプリが読み取るのと同じ payload 型を使います。どちらのライブラリも、Apple の SDK 以外には依存していません。

## 主な特長

- **64 件を超えても通知が失われない** — `NotificationScheduler` は直近の 64 件の通知を iOS に渡し、残りは保存済みのキューに保持して、空きができるたびに繰り上げます。
- **サイレント時間帯と頻度の上限** — 通知が発火する時刻を基準に判定します。たとえば 21:00 に 23:00 宛てで設定したリマインダーは朝まで待機し、1 時間以内の 4 件目の通知は、許可された最初の時刻に移動します。
- **クラッシュではなくエラー** — 60 秒未満の繰り返し間隔、NaN の relevance score、25 時といった値は、`UNUserNotificationCenter` に渡る前に `NotificationValidationError` を投げます。
- **タップ、アクション、deep link を値として扱う** — `NotificationEventHandler` は delegate のコールバックを `AsyncStream` に変換し、`DeepLinkRouter` は許可した scheme と host の場合にだけ画面を開きます。
- **サーバー側とアプリ側の両方でプッシュに対応** — APNs の規則とサイズ制限に沿った型付きの `PushPayload`、全体が出力されることのない `DeviceToken`、Apple の制限内でメディアをダウンロードする Notification Service Extension、トークン認証に対応した APNs クライアントを備えます。
- **テスト済み** — macOS と iPhone シミュレータで 109 件の Swift Testing テストを実行します。システムと同じ 64 件の上限を持つメモリ内の通知センターも備えています。さらに、シミュレータ上で実際のバナーをタップし、実際のプッシュから注文を開く UI テストが 3 件あります。

## クイックスタート

**1. パッケージを追加する**

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

`NotificationKit` ライブラリをアプリのターゲットに追加します。

**2. モジュールをインポートする**

```swift
import NotificationKit
```

**3. 使ってみる**

新しい iOS アプリの `ContentView.swift` を次の内容に置き換えます。

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

アプリを実行してボタンをタップし、通知を許可してからホーム画面に戻ってください。10 秒後にリマインダーが届きます。アプリを開いている間も通知を表示するには、`NotificationEventHandler` を設定します（[タップとアクションへの応答](#タップとアクションへの応答)を参照）。

## インストール

### Swift Package Manager

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

または `Package.swift` の `dependencies` に追加します。

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

## 使い方

以下のサンプルは
[`Examples/NotificationLab/NotificationLab/ReadmeSamples.swift`](Examples/NotificationLab/NotificationLab/ReadmeSamples.swift)
からコピーしたものです。このファイルは、サンプルアプリとパッケージのテストがコンパイルします。

### スケジュール

`LocalNotification` は `NotificationTrigger` を持つ値です。一定時間後、指定した日時、一致する日付コンポーネント（`.daily`、`.weekly`、`.monthly`）、または特定の領域への進入のいずれかで発火します。同じ識別子で別の通知をスケジュールすると、以前の通知が置き換えられます。

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

アプリの起動時とフォアグラウンドへの復帰時に `try await scheduler.refresh()` を呼び出してください。配信済みの通知を破棄し、キュー内の通知を空いたスロットへ移します。

### サイレント時間帯と頻度の上限

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

時間依存型（time-sensitive）と重大（critical）な通知は、デフォルトではサイレント時間帯の対象外です。繰り返しの通知は、ユーザーが選んだ時刻のままになります。

### アクション

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

### タップとアクションへの応答

アプリの起動時に `NotificationEventHandler` を 1 つ作成し、起動が完了する前（`App` のイニシャライザ内）に `events.install()` を呼び出してください。そうすれば、アプリを起動したタップを取りこぼしません。

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

### 端末でのプッシュ通知

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

`print(token)` は `DeviceToken(3f2a…91bc, 32 bytes)` と表示します。`dump`、文字列補間、デバッガでも同じように伏せ字になります。

### サーバーからの送信

[`Examples/PushSender`](Examples/PushSender) から。`NotificationKitAPNs` を使って作ったコマンドラインツールです。

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

Notification Service Extension ターゲットのプリンシパルクラスを、`MediaAttachmentService` のサブクラスにします。`"mutable-content": 1` と `"media-url"` を含むプッシュでは、画像、音声、動画が表示されます。ダウンロードは `https` のみで、Apple のサイズ制限に達した時点で停止します。

```swift
import NotificationKit

// The principal class of the extension. Pushes with "mutable-content": 1 and a "media-url"
// get the image, audio or video attached before they are shown.
final class NotificationService: MediaAttachmentService {}
```

### テスト

`InMemoryNotificationCenter` は 64 件の上限を含め、システムの通知センターと同じように動作します。そのため、スケジュールのロジックを通常のユニットテストで実行できます。

```swift
func scheduledCount() async throws -> Int {
    let center = InMemoryNotificationCenter(authorizationStatus: .authorized)
    let scheduler = NotificationScheduler(center: center, store: InMemoryNotificationStore())
    let reminders = (1...70).map { LocalNotification(id: "r\($0)", title: "Reminder \($0)", trigger: .after(minutes: Double($0))) }
    try await scheduler.schedule(reminders)
    return await center.pending.count // 64: the other 6 wait in the scheduler's queue
}
```

## デモ

| バナー                                                          | 64 件を超えるキュー                                              | プッシュから開いた画面                                                      |
| --------------------------------------------------------------- | ---------------------------------------------------------------- | --------------------------------------------------------------------------- |
| ![リマインダーのバナー（ライト）](docs/images/banner-light.png) | ![スケジュール済みの一覧（ライト）](docs/images/queue-light.png) | ![プッシュから開いた注文（ライト）](docs/images/push-destination-light.png) |
| ![リマインダーのバナー（ダーク）](docs/images/banner-dark.png)  | ![スケジュール済みの一覧（ダーク）](docs/images/queue-dark.png)  | ![プッシュから開いた注文（ダーク）](docs/images/push-destination-dark.png)  |

スクリーンショットは、サンプルアプリの UI テストを iPhone シミュレータで実行して取得したもので、
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh) が実行します。テストでは、通知を許可し、リマインダーをスケジュールしてそのバナーをタップし、70 件のリマインダーをスケジュールし（64 件は iOS に渡り、残りはキューで待機します。さらに 1 件はサイレント時間帯に入ります）、プッシュから注文を開きます。このプッシュは、スクリプトが `PushPayload` で組み立て、`xcrun simctl push` で配信します。

自分で試すには、[`Examples/NotificationLab`](Examples/NotificationLab) の `NotificationLab.xcodeproj` を開き、iPhone シミュレータを選んで **Run** を押してください。詳細は [Examples/README.md](Examples/README.md) を参照してください。

## ドキュメント

API リファレンスと解説記事：

- `NotificationKit` の [API リファレンス](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/)と、
  [`NotificationKitAPNs`](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/)
  （DocC。`main` から GitHub Pages に公開しています）
- ローカルでは、Xcode の **Product › Build Documentation** で、またはコマンドラインからビルドできます。

```sh
xcodebuild docbuild -scheme NotificationKit-Package -destination 'generic/platform=macOS'
```

## ガイド

- [Getting Started](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/gettingstarted)
  — パッケージの追加、権限の確認、スケジュール、タップへの応答
  （[ソース](Sources/NotificationKit/NotificationKit.docc/GettingStarted.md)）。
- [Scheduling Beyond the Limit](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/schedulingbeyondthelimit)
  — キュー、サイレント時間帯、頻度の上限、スケジュール前に検証される値
  （[ソース](Sources/NotificationKit/NotificationKit.docc/SchedulingBeyondTheLimit.md)）。
- [Responding to Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/respondingtonotifications)
  — カテゴリ、アクション、イベントストリーム、deep link
  （[ソース](Sources/NotificationKit/NotificationKit.docc/RespondingToNotifications.md)）。
- [Remote Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/remotenotifications)
  — デバイストークン、payload、service extension でのメディア、シミュレータへのプッシュ
  （[ソース](Sources/NotificationKit/NotificationKit.docc/RemoteNotifications.md)）。
- [Testing Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/testingnotifications)
  — メモリ内の通知センターと、制御できるクロック
  （[ソース](Sources/NotificationKit/NotificationKit.docc/TestingNotifications.md)）。
- [Sending Push Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/sendingpushnotifications)
  — APNs キー、環境、alert、バックグラウンドプッシュと Live Activity プッシュ、エラー処理
  （[ソース](Sources/NotificationKitAPNs/NotificationKitAPNs.docc/SendingPushNotifications.md)）。

## 動作要件

| プラットフォーム | 最小バージョン        |
| ---------------- | --------------------- |
| iOS              | 17                    |
| macOS            | 14                    |
| watchOS          | 10                    |
| visionOS         | 1                     |
| ツールチェーン   | Swift 6.2 · Xcode 26+ |

位置情報トリガーは iOS と watchOS で動作します。watchOS では添付ファイルを利用できず、名前付きのサウンドもデフォルトのサウンドが再生されます。`NotificationKitAPNs` は CryptoKit を必要とするため、Linux ではビルドできません。CI は、GitHub の `macos-26` ランナーイメージに入っているデフォルトの Xcode でビルドします。パッケージは Xcode 27 で開発しています。

## アーキテクチャ

- `NotificationKit` は役割ごとに分かれています。`Content/`（通知の値、サウンド、JSON の user info、検証エラー）、`Triggers/`、`Policy/`（サイレント時間帯、頻度の上限）、`Scheduling/`、`Center/`（システムとメモリ内の通知センター）、`Categories/`、`Events/`（delegate、レスポンス、deep link）、`Push/`（payload、トークン）、`Extension/`（メディアのダウンロード）です。
- `NotificationScheduler` は、呼び出しを 1 つずつ実行する actor です。判断には 2 つの純粋な型を使います。`FireDateResolver` はサイレント時間帯と上限を適用し、`SlotPlanner` はシステムに保持させる通知を決めます。どちらも実機なしでテストできます。
- システムへは `NotificationCenterClient` プロトコルを通してのみアクセスします。`UserNotificationCenterClient` が値を `UNNotificationRequest` に変換し、テストやプレビューでは `InMemoryNotificationCenter` がその代わりを務めます。
- アプリの外から入ってくる入力（プッシュの payload、deep link、ダウンロードしたメディア、保存した状態）には上限を設けています。JSON のネストの深さと値の数、リンクの長さとセグメント数、ダウンロードサイズ、保存するキューのファイルサイズ、そして `Double` を `Int` に変換する前の範囲チェックです。
- `NotificationKitAPNs` は、リクエストを値（`APNsRequest`）として組み立て、CryptoKit で ES256 のプロバイダートークンに署名し、`URLSession` をベースにした `APNsTransport` プロトコル経由で送信します。

テストをローカルで実行するには：

```sh
swift test                                    # macOS
xcodebuild test -scheme NotificationKit-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## ロードマップ

- パッケージを Swift Package Index に追加する。`.spi.yml` はすでにリポジトリにあります。
- `NotificationKitAPNs` に、Live Activity 向けのブロードキャストプッシュチャンネル（iOS 18）を追加する。
- swift-crypto を使った `NotificationKitAPNs` の Linux 向けビルド。

## コントリビューション

コントリビューションを歓迎します。pull request を作成する前に[コントリビューションガイド](https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/CONTRIBUTING.md)と[行動規範](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)をお読みください。セキュリティ上の問題は[セキュリティポリシー](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)に従って非公開で報告してください。

## ライセンス

MIT ライセンスで公開しています。詳細は [LICENSE](LICENSE) を参照してください。
