<!-- i18n-source: README.md@3e5602b25e123d445fd60722eaff734a9354ff87 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg" alt="NotificationKit: Schedule local notifications past iOS's 64 limit, route taps and send pushes through APNs."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg" alt="Статус CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg" alt="Последняя версия: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg" alt="Поддерживаемые платформы: iOS 17+ · macOS 14+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg" alt="Версия языка: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg" alt="Лицензия: MIT"></picture></a>
</p>

<p align="center">
<a href="#быстрый-старт"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-ru-light.svg" alt="Начать"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-ru-light.svg" alt="Документация"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-ru-light.svg" alt="Примеры"></picture></a>
</p>

> Это перевод README на английском языке. Если они расходятся, актуальна английская версия.

<!-- brand:end -->

NotificationKit — это Swift-пакет для приложений, которые планируют уведомления на устройстве, и для серверов, которые отправляют им push-уведомления. Он оборачивает `UserNotifications` в типы-значения и исправляет те места, где этот фреймворк отказывает молча: iOS хранит только 64 ближайших ожидающих уведомления приложения, а остальные отбрасывает без ошибки; некоторые недопустимые значения приводят к аварийному завершению приложения вместо выброса ошибки; а колбэки delegate неудобно использовать из Swift concurrency. Вторая библиотека, `NotificationKitAPNs`, отправляет push-уведомления через сервис Apple APNs с сервера или из скрипта, используя тот же тип payload, который читает приложение. Ни одна из библиотек не зависит ни от чего, кроме SDK Apple.

## Основные возможности

- **Ни одно уведомление не теряется после 64-го** — `NotificationScheduler` передаёт iOS 64 ближайших уведомления, остальные хранит в сохранённой очереди и подтягивает их по мере освобождения мест.
- **Тихие часы и ограничение частоты** — проверяются по времени срабатывания уведомления: напоминание, поставленное в 21:00 на 23:00, ждёт утра, а четвёртое уведомление в течение часа переносится на первое разрешённое время.
- **Ошибки вместо аварийных завершений** — повторяющийся интервал короче 60 секунд, значение relevance score NaN или час 25 приводят к выбросу `NotificationValidationError` ещё до того, как их увидит `UNUserNotificationCenter`.
- **Нажатия, действия и deep link как значения** — `NotificationEventHandler` превращает колбэки delegate в `AsyncStream`, а `DeepLinkRouter` открывает экраны только по разрешённым вами scheme и host.
- **Push с обеих сторон** — типизированный `PushPayload` с правилами и ограничениями размера APNs, `DeviceToken`, который никогда не выводится целиком, Notification Service Extension, загружающий медиа в пределах лимитов Apple, и клиент APNs с токенной аутентификацией.
- **Протестировано** — 109 тестов Swift Testing на macOS и в симуляторе iPhone, с центром уведомлений в памяти, у которого такой же лимит в 64 уведомления, как у системы; три UI-теста в симуляторе нажимают на настоящие баннеры и открывают заказ из настоящего push.

## Быстрый старт

**1. Добавьте пакет**

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Добавьте библиотеку `NotificationKit` в таргет вашего приложения.

**2. Импортируйте модуль**

```swift
import NotificationKit
```

**3. Используйте**

Замените `ContentView.swift` в новом приложении для iOS на следующий код:

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

Запустите приложение, нажмите кнопку, разрешите уведомления и перейдите на экран «Домой»: напоминание придёт через 10 секунд. Чтобы уведомления показывались и при открытом приложении, установите `NotificationEventHandler` (см. [Реакция на нажатия и действия](#реакция-на-нажатия-и-действия)).

## Установка

### Swift Package Manager

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Или добавьте его в `dependencies` вашего `Package.swift`:

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

## Использование

Примеры ниже скопированы из
[`Examples/NotificationLab/NotificationLab/ReadmeSamples.swift`](Examples/NotificationLab/NotificationLab/ReadmeSamples.swift);
этот файл компилируют приложение-пример и тесты пакета.

### Планирование

`LocalNotification` — это значение с `NotificationTrigger`: через заданный интервал, в указанную дату, по совпадающим компонентам даты (`.daily`, `.weekly`, `.monthly`) или при входе в регион. Если запланировать другое уведомление с тем же идентификатором, оно заменит предыдущее.

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

Вызывайте `try await scheduler.refresh()` при запуске приложения и при его возвращении на передний план: метод забывает доставленные уведомления и переносит уведомления из очереди на освободившиеся места.

### Тихие часы и ограничение частоты

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

Срочные (time-sensitive) и критические уведомления по умолчанию проходят сквозь тихие часы. Повторяющиеся уведомления сохраняют время, выбранное пользователем.

### Действия

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

### Реакция на нажатия и действия

Создайте один `NotificationEventHandler` при запуске приложения и вызовите `events.install()` до завершения запуска (в инициализаторе вашего `App`), чтобы не пропустить нажатие, которым было запущено приложение.

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

### Push-уведомления на устройстве

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

`print(token)` выводит `DeviceToken(3f2a…91bc, 32 bytes)`; то же сокрытие применяется к `dump`, интерполяции строк и отладчику.

### Отправка с сервера

Из [`Examples/PushSender`](Examples/PushSender) — консольной утилиты на основе `NotificationKitAPNs`:

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

Сделайте principal class таргета Notification Service Extension подклассом `MediaAttachmentService`. Тогда push-уведомления с `"mutable-content": 1` и `"media-url"` будут показывать изображение, аудио или видео. Загрузка идёт только по `https` и прекращается на ограничениях Apple по размеру.

```swift
import NotificationKit

// The principal class of the extension. Pushes with "mutable-content": 1 and a "media-url"
// get the image, audio or video attached before they are shown.
final class NotificationService: MediaAttachmentService {}
```

### Тестирование

`InMemoryNotificationCenter` ведёт себя как системный центр уведомлений, включая лимит в 64 уведомления, поэтому логику планирования можно запускать в обычных unit-тестах:

```swift
func scheduledCount() async throws -> Int {
    let center = InMemoryNotificationCenter(authorizationStatus: .authorized)
    let scheduler = NotificationScheduler(center: center, store: InMemoryNotificationStore())
    let reminders = (1...70).map { LocalNotification(id: "r\($0)", title: "Reminder \($0)", trigger: .after(minutes: Double($0))) }
    try await scheduler.schedule(reminders)
    return await center.pending.count // 64: the other 6 wait in the scheduler's queue
}
```

## Демо

| Баннер                                                            | Очередь после 64                                                     | Открыто из push                                                                  |
| ----------------------------------------------------------------- | -------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| ![Баннер напоминания, светлая тема](docs/images/banner-light.png) | ![Список запланированных, светлая тема](docs/images/queue-light.png) | ![Заказ, открытый из push, светлая тема](docs/images/push-destination-light.png) |
| ![Баннер напоминания, тёмная тема](docs/images/banner-dark.png)   | ![Список запланированных, тёмная тема](docs/images/queue-dark.png)   | ![Заказ, открытый из push, тёмная тема](docs/images/push-destination-dark.png)   |

Скриншоты сделаны в UI-тестах приложения-примера в симуляторе iPhone, которые запускает
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh). Тесты разрешают уведомления, планируют напоминание и нажимают на его баннер, планируют 70 напоминаний (64 уходят в iOS, остальные ждут в очереди; ещё одно попадает на тихие часы) и открывают заказ из push, который скрипт собирает через `PushPayload` и доставляет командой `xcrun simctl push`.

Чтобы попробовать самостоятельно, откройте `NotificationLab.xcodeproj` в [`Examples/NotificationLab`](Examples/NotificationLab), выберите симулятор iPhone и нажмите **Run**. Подробности — в [Examples/README.md](Examples/README.md).

## Документация

Справочник API и статьи:

- [Справочник API](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/)
  для `NotificationKit` и
  [`NotificationKitAPNs`](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/)
  (DocC, публикуется на GitHub Pages из ветки `main`)
- Локально документацию можно собрать в Xcode через **Product › Build Documentation** или из командной строки:

```sh
xcodebuild docbuild -scheme NotificationKit-Package -destination 'generic/platform=macOS'
```

## Руководства

- [Getting Started](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/gettingstarted)
  — добавление пакета, запрос разрешения, планирование и реакция на нажатия
  ([исходник](Sources/NotificationKit/NotificationKit.docc/GettingStarted.md)).
- [Scheduling Beyond the Limit](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/schedulingbeyondthelimit)
  — очередь, тихие часы, ограничение частоты и значения, которые проверяются перед планированием
  ([исходник](Sources/NotificationKit/NotificationKit.docc/SchedulingBeyondTheLimit.md)).
- [Responding to Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/respondingtonotifications)
  — категории, действия, потоки событий и deep link
  ([исходник](Sources/NotificationKit/NotificationKit.docc/RespondingToNotifications.md)).
- [Remote Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/remotenotifications)
  — токены устройств, payload, медиа в service extension и push в симуляторе
  ([исходник](Sources/NotificationKit/NotificationKit.docc/RemoteNotifications.md)).
- [Testing Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/testingnotifications)
  — центр уведомлений в памяти и управляемые часы
  ([исходник](Sources/NotificationKit/NotificationKit.docc/TestingNotifications.md)).
- [Sending Push Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/sendingpushnotifications)
  — ключи APNs, окружения, alert, фоновые push и push для Live Activity, обработка ошибок
  ([исходник](Sources/NotificationKitAPNs/NotificationKitAPNs.docc/SendingPushNotifications.md)).

## Требования

| Платформа   | Минимальная версия    |
| ----------- | --------------------- |
| iOS         | 17                    |
| macOS       | 14                    |
| watchOS     | 10                    |
| visionOS    | 1                     |
| Инструменты | Swift 6.2 · Xcode 26+ |

Триггеры по местоположению работают на iOS и watchOS; вложения на watchOS недоступны, а именованные звуки там тоже воспроизводят звук по умолчанию. `NotificationKitAPNs` требует CryptoKit, поэтому под Linux не собирается. CI собирает проект в Xcode по умолчанию из образа раннера `macos-26` на GitHub. Пакет разрабатывается в Xcode 27.

## Архитектура

- `NotificationKit` разделён по задачам: `Content/` (значение уведомления, звуки, JSON user info, ошибки валидации), `Triggers/`, `Policy/` (тихие часы, ограничение частоты), `Scheduling/`, `Center/` (системный центр и центр в памяти), `Categories/`, `Events/` (delegate, ответы, deep link), `Push/` (payload, токен) и `Extension/` (загрузка медиа).
- `NotificationScheduler` — это actor, который выполняет вызовы по одному. Решения он принимает с помощью двух чистых типов: `FireDateResolver` применяет тихие часы и ограничение, а `SlotPlanner` определяет, какие уведомления держит система. Оба тестируются без устройства.
- К системе обращаются только через протокол `NotificationCenterClient`; `UserNotificationCenterClient` преобразует значения в `UNNotificationRequest`, а `InMemoryNotificationCenter` заменяет его в тестах и превью.
- Данные, приходящие извне приложения (payload push, deep link, загруженные медиа, сохранённое состояние), ограничены: глубина вложенности и число значений в JSON, длина ссылки и число сегментов, размер загрузки, размер файла сохранённой очереди и проверки диапазона, прежде чем любой `Double` станет `Int`.
- `NotificationKitAPNs` собирает запросы как значения (`APNsRequest`), подписывает provider-токены ES256 через CryptoKit и отправляет их через протокол `APNsTransport` поверх `URLSession`.

Запустите тесты локально:

```sh
swift test                                    # macOS
xcodebuild test -scheme NotificationKit-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## План развития

- Добавить пакет в Swift Package Index; файл `.spi.yml` уже есть в репозитории.
- Каналы широковещательных push для Live Activity (iOS 18) в `NotificationKitAPNs`.
- Сборка `NotificationKitAPNs` под Linux на основе swift-crypto.

## Участие в разработке

Мы рады вашему участию. Перед открытием pull request прочитайте [руководство для участников](https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/CONTRIBUTING.md) и [кодекс поведения](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). О проблемах безопасности сообщайте конфиденциально, как описано в [политике безопасности](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Лицензия

Распространяется по лицензии MIT. Подробнее — в файле [LICENSE](LICENSE).
