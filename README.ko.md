<!-- i18n-source: README.md@ec016ee0ad2ba2aa43292d365964c8583f51666d status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg" alt="NotificationKit: Schedule local notifications past iOS's 64 limit, route taps and send pushes through APNs."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg" alt="CI 상태"></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg" alt="최신 버전: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg" alt="지원 플랫폼: iOS 17+ · macOS 14+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg" alt="언어 버전: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg" alt="라이선스: MIT"></picture></a>
</p>

<p align="center">
<a href="#빠른-시작"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-ko-light.svg" alt="시작하기"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-ko-light.svg" alt="문서"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-ko-light.svg" alt="예제"></picture></a>
</p>

> 이 문서는 영어 README의 번역본입니다. 내용이 다를 경우 영어 버전이 최신입니다.

<!-- brand:end -->

NotificationKit은 기기에서 알림을 예약하는 앱과, 그 앱에 푸시를 보내는 서버를 위한 Swift 패키지입니다. `UserNotifications`를 값 타입으로 감싸고, 조용히 실패하던 부분을 바로잡습니다. iOS는 앱의 대기 중인 알림 가운데 가장 가까운 64개만 유지하고 나머지는 오류 없이 버립니다. 일부 잘못된 값은 오류를 던지는 대신 앱을 비정상 종료시킵니다. delegate 콜백은 Swift concurrency에서 쓰기 불편합니다. 두 번째 라이브러리인 `NotificationKitAPNs`는 서버나 스크립트에서 Apple의 APNs 서비스를 통해 푸시를 보내며, 앱이 읽는 것과 같은 payload 타입을 사용합니다. 두 라이브러리 모두 Apple SDK 외의 의존성이 없습니다.

## 주요 기능

- **64개를 넘어도 알림이 사라지지 않습니다** — `NotificationScheduler`는 가장 가까운 64개의 알림을 iOS에 넘기고, 나머지는 저장된 큐에 보관했다가 자리가 나면 앞으로 옮깁니다.
- **방해 금지 시간과 빈도 제한** — 알림이 울리는 시각을 기준으로 검사합니다. 그래서 21:00에 23:00용으로 설정한 알림은 아침까지 기다리고, 한 시간 안의 네 번째 알림은 허용되는 첫 시각으로 옮겨집니다.
- **비정상 종료 대신 오류** — 60초 미만의 반복 간격, NaN인 relevance score, 25시 같은 값은 `UNUserNotificationCenter`에 닿기 전에 `NotificationValidationError`를 던집니다.
- **탭, 액션, deep link를 값으로** — `NotificationEventHandler`는 delegate 콜백을 `AsyncStream`으로 바꿔 주고, `DeepLinkRouter`는 허용한 scheme과 host의 링크로만 화면을 엽니다.
- **양쪽 모두에서 푸시 지원** — APNs의 규칙과 크기 제한을 따르는 타입이 있는 `PushPayload`, 전체가 출력되지 않는 `DeviceToken`, Apple의 제한 안에서 미디어를 내려받는 Notification Service Extension, 토큰 인증을 쓰는 APNs 클라이언트를 제공합니다.
- **테스트됨** — macOS와 iPhone 시뮬레이터에서 109개의 Swift Testing 테스트를 실행하며, 시스템과 같은 64개 알림 제한을 가진 인메모리 알림 센터를 갖추고 있습니다. 또한 시뮬레이터에서 실제 배너를 탭하고 실제 푸시로 주문을 여는 UI 테스트가 세 개 있습니다.

## 빠른 시작

**1. 패키지 추가**

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

`NotificationKit` 라이브러리를 앱 타깃에 추가하세요.

**2. 모듈 가져오기**

```swift
import NotificationKit
```

**3. 사용하기**

새 iOS 앱의 `ContentView.swift`를 다음 코드로 바꾸세요.

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

앱을 실행하고 버튼을 탭한 다음 알림을 허용하고 홈 화면으로 이동하세요. 10초 뒤에 알림이 도착합니다. 앱이 열려 있을 때도 알림을 표시하려면 `NotificationEventHandler`를 설치하세요([탭과 액션에 응답하기](#탭과-액션에-응답하기) 참고).

## 설치

### Swift Package Manager

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

또는 `Package.swift`의 `dependencies`에 추가하세요.

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

## 사용법

아래 예제는
[`Examples/NotificationLab/NotificationLab/ReadmeSamples.swift`](Examples/NotificationLab/NotificationLab/ReadmeSamples.swift)에서 가져온 것이며, 예제 앱과 패키지 테스트가 이 파일을 컴파일합니다.

### 예약

`LocalNotification`은 `NotificationTrigger`를 가진 값입니다. 일정 시간이 지난 뒤, 특정 날짜, 일치하는 날짜 구성 요소(`.daily`, `.weekly`, `.monthly`), 또는 특정 지역에 진입할 때 알림이 울립니다. 같은 식별자로 다른 알림을 예약하면 이전 알림이 대체됩니다.

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

앱이 시작될 때와 포그라운드로 돌아올 때 `try await scheduler.refresh()`를 호출하세요. 이미 전달된 알림은 정리하고, 큐에 있던 알림은 비어 있는 슬롯으로 옮깁니다.

### 방해 금지 시간과 빈도 제한

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

시간 민감(time-sensitive) 알림과 긴급(critical) 알림은 기본적으로 방해 금지 시간을 통과합니다. 반복 알림은 사용자가 고른 시각을 그대로 유지합니다.

### 액션

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

### 탭과 액션에 응답하기

앱이 시작될 때 `NotificationEventHandler`를 하나 만들고, 앱을 실행시킨 탭을 놓치지 않도록 실행이 끝나기 전에(`App` 이니셜라이저에서) `events.install()`을 호출하세요.

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

### 기기에서의 푸시 알림

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

`print(token)`은 `DeviceToken(3f2a…91bc, 32 bytes)`를 출력합니다. `dump`, 문자열 보간, 디버거에서도 같은 마스킹이 적용됩니다.

### 서버에서 보내기

[`Examples/PushSender`](Examples/PushSender)에서 가져온 코드로, `NotificationKitAPNs` 위에 만든 명령줄 도구입니다.

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

Notification Service Extension 타깃의 principal class를 `MediaAttachmentService`의 서브클래스로 지정하세요. 그러면 `"mutable-content": 1`과 `"media-url"`이 있는 푸시에 이미지, 오디오, 비디오가 표시됩니다. 다운로드는 `https`만 지원하며 Apple의 크기 제한에서 중단됩니다.

```swift
import NotificationKit

// The principal class of the extension. Pushes with "mutable-content": 1 and a "media-url"
// get the image, audio or video attached before they are shown.
final class NotificationService: MediaAttachmentService {}
```

### 테스트

`InMemoryNotificationCenter`는 64개 알림 제한을 포함해 시스템의 알림 센터처럼 동작하므로, 예약 로직을 일반 단위 테스트에서 실행할 수 있습니다.

```swift
func scheduledCount() async throws -> Int {
    let center = InMemoryNotificationCenter(authorizationStatus: .authorized)
    let scheduler = NotificationScheduler(center: center, store: InMemoryNotificationStore())
    let reminders = (1...70).map { LocalNotification(id: "r\($0)", title: "Reminder \($0)", trigger: .after(minutes: Double($0))) }
    try await scheduler.schedule(reminders)
    return await center.pending.count // 64: the other 6 wait in the scheduler's queue
}
```

## 데모

| 배너                                               | 64개를 넘는 큐                                           | 푸시로 열린 화면                                                    |
| -------------------------------------------------- | -------------------------------------------------------- | ------------------------------------------------------------------- |
| ![알림 배너, 라이트](docs/images/banner-light.png) | ![예약된 알림 목록, 라이트](docs/images/queue-light.png) | ![푸시로 열린 주문, 라이트](docs/images/push-destination-light.png) |
| ![알림 배너, 다크](docs/images/banner-dark.png)    | ![예약된 알림 목록, 다크](docs/images/queue-dark.png)    | ![푸시로 열린 주문, 다크](docs/images/push-destination-dark.png)    |

스크린샷은 iPhone 시뮬레이터에서 예제 앱의 UI 테스트를 실행해 얻은 것이며,
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh)가 이를 실행합니다. 테스트는 알림을 허용하고, 알림 하나를 예약해 그 배너를 탭하고, 알림 70개를 예약하며(64개는 iOS로 넘어가고 나머지는 큐에서 기다립니다. 하나는 방해 금지 시간에 걸립니다), 스크립트가 `PushPayload`로 만들어 `xcrun simctl push`로 전달한 푸시에서 주문을 엽니다.

직접 해 보려면 [`Examples/NotificationLab`](Examples/NotificationLab)의 `NotificationLab.xcodeproj`를 열고 iPhone 시뮬레이터를 선택한 다음 **Run**을 누르세요. 자세한 내용은 [Examples/README.md](Examples/README.md)를 참고하세요.

## 문서

API 레퍼런스와 문서:

- `NotificationKit`의 [API 레퍼런스](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/)와
  [`NotificationKitAPNs`](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/)
  (DocC, `main`에서 GitHub Pages로 게시됩니다)
- 로컬에서는 Xcode의 **Product › Build Documentation**으로 빌드하거나 명령줄에서 빌드할 수 있습니다.

```sh
xcodebuild docbuild -scheme NotificationKit-Package -destination 'generic/platform=macOS'
```

## 가이드

- [Getting Started](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/gettingstarted)
  — 패키지 추가, 권한 요청, 예약, 탭에 응답하기
  ([소스](Sources/NotificationKit/NotificationKit.docc/GettingStarted.md)).
- [Scheduling Beyond the Limit](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/schedulingbeyondthelimit)
  — 큐, 방해 금지 시간, 빈도 제한, 예약 전에 검사하는 값
  ([소스](Sources/NotificationKit/NotificationKit.docc/SchedulingBeyondTheLimit.md)).
- [Responding to Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/respondingtonotifications)
  — 카테고리, 액션, 이벤트 스트림, deep link
  ([소스](Sources/NotificationKit/NotificationKit.docc/RespondingToNotifications.md)).
- [Remote Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/remotenotifications)
  — 기기 토큰, payload, service extension의 미디어, 시뮬레이터 푸시
  ([소스](Sources/NotificationKit/NotificationKit.docc/RemoteNotifications.md)).
- [Testing Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/testingnotifications)
  — 인메모리 알림 센터와 제어할 수 있는 시계
  ([소스](Sources/NotificationKit/NotificationKit.docc/TestingNotifications.md)).
- [Sending Push Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/sendingpushnotifications)
  — APNs 키, 환경, alert, 백그라운드 푸시와 Live Activity 푸시, 오류 처리
  ([소스](Sources/NotificationKitAPNs/NotificationKitAPNs.docc/SendingPushNotifications.md)).

## 요구 사항

| 플랫폼   | 최소 버전             |
| -------- | --------------------- |
| iOS      | 17                    |
| macOS    | 14                    |
| watchOS  | 10                    |
| visionOS | 1                     |
| 툴체인   | Swift 6.2 · Xcode 26+ |

위치 트리거는 iOS와 watchOS에서 동작합니다. watchOS에서는 첨부 파일을 사용할 수 없고, 이름이 지정된 사운드도 기본 사운드로 재생됩니다. `NotificationKitAPNs`는 CryptoKit이 필요하므로 Linux에서는 빌드되지 않습니다. CI는 GitHub의 `macos-26` 러너 이미지에 들어 있는 기본 Xcode로 빌드합니다. 이 패키지는 Xcode 27로 개발하고 있습니다.

## 아키텍처

- `NotificationKit`은 역할별로 나뉩니다. `Content/`(알림 값, 사운드, JSON user info, 검증 오류), `Triggers/`, `Policy/`(방해 금지 시간, 빈도 제한), `Scheduling/`, `Center/`(시스템 및 인메모리 알림 센터), `Categories/`, `Events/`(delegate, 응답, deep link), `Push/`(payload, 토큰), `Extension/`(미디어 다운로드)입니다.
- `NotificationScheduler`는 호출을 한 번에 하나씩 실행하는 actor입니다. 판단은 두 개의 순수한 타입이 맡습니다. `FireDateResolver`는 방해 금지 시간과 제한을 적용하고, `SlotPlanner`는 시스템이 보유할 알림을 결정합니다. 둘 다 기기 없이 테스트합니다.
- 시스템에는 `NotificationCenterClient` 프로토콜로만 접근합니다. `UserNotificationCenterClient`는 값을 `UNNotificationRequest`로 변환하고, 테스트와 프리뷰에서는 `InMemoryNotificationCenter`가 그 자리를 대신합니다.
- 앱 바깥에서 들어오는 입력(푸시 payload, deep link, 다운로드한 미디어, 저장된 상태)에는 한계를 둡니다. JSON의 중첩 깊이와 값의 개수, 링크 길이와 세그먼트 수, 다운로드 크기, 저장되는 큐의 파일 크기, 그리고 `Double`을 `Int`로 바꾸기 전의 범위 검사입니다.
- `NotificationKitAPNs`는 요청을 값(`APNsRequest`)으로 만들고, CryptoKit으로 ES256 provider token에 서명하며, `URLSession` 기반의 `APNsTransport` 프로토콜을 통해 전송합니다.

로컬에서 테스트를 실행하려면:

```sh
swift test                                    # macOS
xcodebuild test -scheme NotificationKit-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## 로드맵

- 패키지를 Swift Package Index에 추가합니다. `.spi.yml`은 이미 저장소에 있습니다.
- `NotificationKitAPNs`에 Live Activity용 브로드캐스트 푸시 채널(iOS 18)을 추가합니다.
- swift-crypto 기반의 `NotificationKitAPNs` Linux 빌드.

## 기여하기

기여를 환영합니다. pull request를 열기 전에 [기여 가이드](https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/CONTRIBUTING.md)와 [행동 강령](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)을 읽어 주세요. 보안 문제는 [보안 정책](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)에 따라 비공개로 제보해 주세요.

## 라이선스

MIT 라이선스로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
