<!-- i18n-source: README.md@3e5602b25e123d445fd60722eaff734a9354ff87 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg" alt="NotificationKit: Schedule local notifications past iOS's 64 limit, route taps and send pushes through APNs."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg" alt="CI durumu"></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg" alt="Son sürüm: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg" alt="Desteklenen platformlar: iOS 17+ · macOS 14+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg" alt="Dil sürümü: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg" alt="Lisans: MIT"></picture></a>
</p>

<p align="center">
<a href="#hızlı-başlangıç"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-tr-light.svg" alt="Başlayın"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-tr-light.svg" alt="Dokümantasyon"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-tr-light.svg" alt="Örnekler"></picture></a>
</p>

> Bu belge İngilizce README'nin çevirisidir. İkisi arasında fark varsa güncel olan İngilizce sürümdür.

<!-- brand:end -->

NotificationKit, bildirimleri cihazda zamanlayan uygulamalar ve onlara push gönderen sunucular için bir Swift paketidir. `UserNotifications` framework'ünü değer tipleriyle sarmalar ve onun sessizce başarısız olan yanlarını düzeltir: iOS bir uygulamanın bekleyen bildirimlerinden yalnızca en yakın 64 tanesini tutar ve gerisini hata vermeden siler, bazı geçersiz değerler hata fırlatmak yerine uygulamayı çökertir, delegate geri çağrıları da Swift concurrency içinde kullanılması zor bir yapıdadır. İkinci kütüphane `NotificationKitAPNs`, bir sunucudan ya da betikten Apple'ın APNs servisi üzerinden push gönderir ve uygulamanın okuduğu payload tipinin aynısını kullanır. İki kütüphanenin de Apple SDK'si dışında bağımlılığı yoktur.

## Öne çıkanlar

- **64'ün ötesinde kayıp bildirim yok** — `NotificationScheduler`, iOS'a en yakın 64 bildirimi verir, diğerlerini kaydedilmiş bir kuyrukta tutar ve yer açıldıkça öne alır.
- **Sessiz saatler ve sıklık sınırı** — bildirimin tetikleneceği zamana göre denetlenir; böylece saat 21:00'de 23:00 için kurulan bir hatırlatıcı sabaha kadar bekler, bir saat içindeki dördüncü bildirim ise izin verilen ilk zamana kayar.
- **Çökme yerine hata** — 60 saniyenin altındaki tekrarlı aralık, NaN bir relevance score ya da 25. saat, `UNUserNotificationCenter` görmeden önce `NotificationValidationError` fırlatır.
- **Dokunuşlar, aksiyonlar ve deep link'ler değer olarak** — `NotificationEventHandler`, delegate geri çağrılarını `AsyncStream`'lere çevirir; `DeepLinkRouter` ise ekranları yalnızca izin verdiğiniz scheme ve host'lardan açar.
- **İki taraf için push** — APNs kurallarını ve boyut sınırlarını bilen tipli `PushPayload`, tamamı asla yazdırılmayan bir `DeviceToken`, medyayı Apple'ın sınırları içinde indiren bir Notification Service Extension ve token kimlik doğrulamalı bir APNs istemcisi.
- **Test edilmiş** — macOS'ta ve bir iPhone simülatöründe 109 Swift Testing testi; sistemin 64 bildirim sınırına sahip, bellekte çalışan bir bildirim merkezi; ayrıca bir simülatörde gerçek banner'lara dokunan ve gerçek bir push'tan sipariş açan üç UI testi.

## Hızlı başlangıç

**1. Paketi ekleyin**

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

`NotificationKit` kütüphanesini uygulama hedefinize ekleyin.

**2. Modülü içe aktarın**

```swift
import NotificationKit
```

**3. Kullanın**

Yeni bir iOS uygulamasındaki `ContentView.swift` dosyasının içeriğini şununla değiştirin:

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

Uygulamayı çalıştırın, düğmeye dokunun, bildirimlere izin verin ve Ana Ekran'a dönün: hatırlatıcı 10 saniye sonra gelir. Uygulama açıkken de bildirim göstermek için bir `NotificationEventHandler` kurun ([Dokunuşlara ve aksiyonlara yanıt verme](#dokunuşlara-ve-aksiyonlara-yanıt-verme) bölümüne bakın).

## Kurulum

### Swift Package Manager

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Ya da `Package.swift` dosyanızdaki `dependencies` listesine ekleyin:

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

## Kullanım

Aşağıdaki örnekler,
[`Examples/NotificationLab/NotificationLab/ReadmeSamples.swift`](Examples/NotificationLab/NotificationLab/ReadmeSamples.swift)
dosyasından alınmıştır; örnek uygulama ve paketin testleri bu dosyayı derler.

### Zamanlama

`LocalNotification`, bir `NotificationTrigger` taşıyan bir değerdir: belirli bir süre sonra, belirli bir tarihte, eşleşen tarih bileşenlerinde (`.daily`, `.weekly`, `.monthly`) ya da bir bölgeye girildiğinde tetiklenir. Aynı tanımlayıcıyla başka bir bildirim zamanlamak, öncekinin yerini alır.

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

Uygulama başlarken ve ön plana dönerken `try await scheduler.refresh()` çağırın; bu çağrı teslim edilmiş bildirimleri unutur ve kuyruktakileri boş yuvalara taşır.

### Sessiz saatler ve sıklık sınırı

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

Zaman duyarlı (time-sensitive) ve kritik bildirimler varsayılan olarak sessiz saatlerden geçer. Tekrarlayan bildirimler kullanıcının seçtiği saati korur.

### Aksiyonlar

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

### Dokunuşlara ve aksiyonlara yanıt verme

Uygulama başlarken tek bir `NotificationEventHandler` oluşturun ve uygulamayı açan bir dokunuşun kaçmaması için `events.install()` çağrısını açılış tamamlanmadan önce (`App` initializer'ınızda) yapın.

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

### Cihazda push bildirimleri

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

`print(token)` çıktısı `DeviceToken(3f2a…91bc, 32 bytes)` olur; aynı maskeleme `dump`, string interpolation ve debugger için de geçerlidir.

### Sunucudan gönderme

[`Examples/PushSender`](Examples/PushSender) içinden, `NotificationKitAPNs` üzerine kurulu bir komut satırı aracı:

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

Bir Notification Service Extension hedefinin principal class'ını `MediaAttachmentService` alt sınıfı yapın. `"mutable-content": 1` ve `"media-url"` içeren push'lar bu durumda görseli, sesi ya da videoyu gösterir. İndirmeler yalnızca `https` ile yapılır ve Apple'ın boyut sınırlarında durur.

```swift
import NotificationKit

// The principal class of the extension. Pushes with "mutable-content": 1 and a "media-url"
// get the image, audio or video attached before they are shown.
final class NotificationService: MediaAttachmentService {}
```

### Test

`InMemoryNotificationCenter`, 64 bildirim sınırı dahil sistemin bildirim merkezi gibi davranır; böylece zamanlama mantığı sıradan unit test'lerde çalışır:

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

| Banner                                                           | 64'ün ötesindeki kuyruk                                                    | Push'tan açılan ekran                                                         |
| ---------------------------------------------------------------- | -------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| ![Hatırlatıcı banner'ı, açık tema](docs/images/banner-light.png) | ![Zamanlanmış bildirimler listesi, açık tema](docs/images/queue-light.png) | ![Push'tan açılan sipariş, açık tema](docs/images/push-destination-light.png) |
| ![Hatırlatıcı banner'ı, koyu tema](docs/images/banner-dark.png)  | ![Zamanlanmış bildirimler listesi, koyu tema](docs/images/queue-dark.png)  | ![Push'tan açılan sipariş, koyu tema](docs/images/push-destination-dark.png)  |

Ekran görüntüleri, örnek uygulamanın bir iPhone simülatöründeki UI testlerinden gelir ve
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh) ile alınır. Testler bildirimlere izin verir, bir hatırlatıcı zamanlayıp banner'ına dokunur, 70 hatırlatıcı zamanlar (64'ü iOS'a gider, kalanı kuyrukta bekler; biri de sessiz saatlere denk gelir) ve betiğin `PushPayload` ile oluşturup `xcrun simctl push` ile ilettiği bir push'tan sipariş açar.

Kendiniz denemek için [`Examples/NotificationLab`](Examples/NotificationLab) içindeki `NotificationLab.xcodeproj` dosyasını açın, bir iPhone simülatörü seçin ve **Run**'a basın. Ayrıntılar [Examples/README.md](Examples/README.md) dosyasında.

## Dokümantasyon

API başvuru belgeleri ve makaleler:

- `NotificationKit` için [API başvurusu](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/)
  ve
  [`NotificationKitAPNs`](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/)
  (DocC, `main` dalından GitHub Pages'e yayımlanır)
- Yerelde Xcode'da **Product › Build Documentation** ile ya da komut satırından derleyebilirsiniz:

```sh
xcodebuild docbuild -scheme NotificationKit-Package -destination 'generic/platform=macOS'
```

## Rehberler

- [Getting Started](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/gettingstarted)
  — paketi ekleme, izin isteme, zamanlama ve dokunuşlara yanıt verme
  ([kaynak](Sources/NotificationKit/NotificationKit.docc/GettingStarted.md)).
- [Scheduling Beyond the Limit](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/schedulingbeyondthelimit)
  — kuyruk, sessiz saatler, sıklık sınırı ve zamanlamadan önce denetlenen değerler
  ([kaynak](Sources/NotificationKit/NotificationKit.docc/SchedulingBeyondTheLimit.md)).
- [Responding to Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/respondingtonotifications)
  — kategoriler, aksiyonlar, olay akışları ve deep link'ler
  ([kaynak](Sources/NotificationKit/NotificationKit.docc/RespondingToNotifications.md)).
- [Remote Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/remotenotifications)
  — device token'lar, payload'lar, bir service extension içinde medya ve simülatörden push
  ([kaynak](Sources/NotificationKit/NotificationKit.docc/RemoteNotifications.md)).
- [Testing Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/testingnotifications)
  — bellekte çalışan bildirim merkezi ve kontrol edilebilir saat
  ([kaynak](Sources/NotificationKit/NotificationKit.docc/TestingNotifications.md)).
- [Sending Push Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/sendingpushnotifications)
  — APNs anahtarları, ortamlar, alert'ler, arka plan ve Live Activity push'ları, hata yönetimi
  ([kaynak](Sources/NotificationKitAPNs/NotificationKitAPNs.docc/SendingPushNotifications.md)).

## Gereksinimler

| Platform     | En düşük sürüm        |
| ------------ | --------------------- |
| iOS          | 17                    |
| macOS        | 14                    |
| watchOS      | 10                    |
| visionOS     | 1                     |
| Araç zinciri | Swift 6.2 · Xcode 26+ |

Konum tetikleyicileri iOS ve watchOS'ta çalışır; watchOS'ta ekler kullanılamaz ve adlandırılmış sesler de varsayılan sesi çalar. `NotificationKitAPNs` CryptoKit gerektirdiği için Linux'ta derlenmez. CI, GitHub'ın `macos-26` runner imajındaki varsayılan Xcode ile derler. Paket Xcode 27 ile geliştirilmektedir.

## Mimari

- `NotificationKit` işlevlerine göre bölünmüştür: `Content/` (bildirim değeri, sesler, JSON user info, doğrulama hataları), `Triggers/`, `Policy/` (sessiz saatler, sıklık sınırı), `Scheduling/`, `Center/` (sistem ve bellek içi merkezler), `Categories/`, `Events/` (delegate, yanıtlar, deep link'ler), `Push/` (payload, token) ve `Extension/` (medya indirmeleri).
- `NotificationScheduler`, çağrıları birer birer çalıştıran bir actor'dür. Kararlarını iki saf tipe dayandırır: `FireDateResolver` sessiz saatleri ve sınırı uygular, `SlotPlanner` sistemin hangi bildirimleri tutacağına karar verir. İkisi de cihaz olmadan test edilir.
- Sisteme yalnızca `NotificationCenterClient` protokolü üzerinden erişilir; `UserNotificationCenterClient` değerleri `UNNotificationRequest`'e eşler, `InMemoryNotificationCenter` ise testlerde ve preview'larda onun yerini alır.
- Uygulama dışından gelen girdi (push payload'ları, deep link'ler, indirilen medya, kaydedilmiş durum) sınırlandırılmıştır: JSON için iç içe geçme derinliği ve değer sayısı, link uzunluğu ve segment sayısı, indirme boyutu, kaydedilen kuyruğun dosya boyutu ve herhangi bir `Double` bir `Int`'e dönüşmeden önce aralık denetimleri.
- `NotificationKitAPNs`, istekleri değer olarak (`APNsRequest`) oluşturur, ES256 provider token'larını CryptoKit ile imzalar ve `URLSession` destekli bir `APNsTransport` protokolü üzerinden gönderir.

Testleri yerelde çalıştırın:

```sh
swift test                                    # macOS
xcodebuild test -scheme NotificationKit-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Yol haritası

- Paketi Swift Package Index'e eklemek; `.spi.yml` depoda hazır.
- `NotificationKitAPNs` içinde Live Activity'ler için broadcast push kanalları (iOS 18).
- `NotificationKitAPNs`'in swift-crypto üzerinde Linux derlemesi.

## Katkıda bulunma

Katkılarınızı bekliyoruz. Pull request açmadan önce [katkı rehberini](https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/CONTRIBUTING.md) ve [davranış kurallarını](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) okuyun. Güvenlik açıklarını [güvenlik politikasında](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) anlatıldığı gibi gizli olarak bildirin.

## Lisans

MIT lisansıyla yayımlanmıştır. Ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.
