<!-- i18n-source: README.md@3e5602b25e123d445fd60722eaff734a9354ff87 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg" alt="NotificationKit: Schedule local notifications past iOS's 64 limit, route taps and send pushes through APNs."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg" alt="État de la CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg" alt="Dernière version: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg" alt="Plateformes prises en charge: iOS 17+ · macOS 14+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg" alt="Version du langage: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg" alt="Licence: MIT"></picture></a>
</p>

<p align="center">
<a href="#démarrage-rapide"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-fr-light.svg" alt="Commencer"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-fr-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-fr-light.svg" alt="Exemples"></picture></a>
</p>

> Ceci est une traduction du README anglais. En cas de différence, la version anglaise fait foi.

<!-- brand:end -->

NotificationKit est un paquet Swift pour les apps qui programment des notifications sur l’appareil et pour les serveurs qui leur envoient des notifications push. Il enveloppe `UserNotifications` dans des types valeur et corrige les points où ce framework échoue sans rien dire : iOS ne conserve que les 64 notifications en attente les plus proches d’une app et supprime les autres sans erreur, certaines valeurs invalides font planter l’app au lieu de lever une erreur, et les rappels du delegate sont difficiles à utiliser avec Swift concurrency. Une seconde bibliothèque, `NotificationKitAPNs`, envoie des notifications push via le service APNs d’Apple depuis un serveur ou un script, avec le même type de payload que celui lu par l’app. Aucune des deux bibliothèques n’a de dépendance en dehors du SDK d’Apple.

## Points forts

- **Aucune notification perdue au-delà de 64** — `NotificationScheduler` confie à iOS les 64 notifications les plus proches, garde les autres dans une file enregistrée et les fait avancer à mesure que des places se libèrent.
- **Heures calmes et limite de fréquence** — vérifiées par rapport à l’heure de déclenchement de la notification : un rappel défini à 21 h 00 pour 23 h 00 attend le matin, et une quatrième notification dans la même heure passe à la première heure autorisée.
- **Des erreurs plutôt que des plantages** — un intervalle de répétition inférieur à 60 secondes, un relevance score NaN ou l’heure 25 lèvent une `NotificationValidationError` avant que `UNUserNotificationCenter` ne les voie.
- **Appuis, actions et deep links sous forme de valeurs** — `NotificationEventHandler` transforme les rappels du delegate en `AsyncStream`, et `DeepLinkRouter` n’ouvre des écrans qu’à partir des schémas et des hôtes que vous autorisez.
- **Des notifications push des deux côtés** — un `PushPayload` typé qui respecte les règles et les limites de taille d’APNs, un `DeviceToken` qui ne s’affiche jamais en entier, une Notification Service Extension qui télécharge des médias dans les limites d’Apple et un client APNs avec authentification par jeton.
- **Testé** — 109 tests Swift Testing sur macOS et sur un simulateur d’iPhone, avec un centre de notifications en mémoire qui reprend la limite de 64 notifications du système ; trois tests d’interface sur un simulateur touchent de vraies bannières et ouvrent une commande depuis un vrai push.

## Démarrage rapide

**1. Ajouter le paquet**

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Ajoutez la bibliothèque `NotificationKit` à la cible de votre app.

**2. Importer le module**

```swift
import NotificationKit
```

**3. L’utiliser**

Remplacez le fichier `ContentView.swift` d’une nouvelle app iOS par :

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

Lancez l’app, touchez le bouton, autorisez les notifications et revenez à l’écran d’accueil : le rappel arrive 10 secondes plus tard. Pour afficher aussi les notifications lorsque l’app est ouverte, installez un `NotificationEventHandler` (voir [Répondre aux appuis et aux actions](#répondre-aux-appuis-et-aux-actions)).

## Installation

### Swift Package Manager

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Ou ajoutez-le aux `dependencies` de votre `Package.swift` :

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

## Utilisation

Les exemples ci-dessous sont copiés depuis
[`Examples/NotificationLab/NotificationLab/ReadmeSamples.swift`](Examples/NotificationLab/NotificationLab/ReadmeSamples.swift),
que l’app d’exemple et les tests du paquet compilent.

### Programmation

Une `LocalNotification` est une valeur associée à un `NotificationTrigger` : après un délai, à une date, sur des composantes de date correspondantes (`.daily`, `.weekly`, `.monthly`) ou à l’entrée dans une région. Programmer une autre notification avec le même identifiant remplace la précédente.

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

Appelez `try await scheduler.refresh()` au lancement de l’app et à son retour au premier plan : cet appel oublie les notifications déjà délivrées et fait passer celles de la file dans les places libres.

### Heures calmes et limite de fréquence

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

Les notifications urgentes (time-sensitive) et critiques traversent les heures calmes par défaut. Les notifications répétées gardent l’heure choisie par l’utilisateur.

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

### Répondre aux appuis et aux actions

Créez un seul `NotificationEventHandler` au lancement de l’app et appelez `events.install()` avant la fin du lancement (dans l’initialiseur de votre `App`), afin de ne pas manquer l’appui qui a ouvert l’app.

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

### Notifications push sur l’appareil

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

`print(token)` affiche `DeviceToken(3f2a…91bc, 32 bytes)` ; le même masquage s’applique à `dump`, à l’interpolation de chaînes et au débogueur.

### Envoi depuis un serveur

Extrait de [`Examples/PushSender`](Examples/PushSender), un outil en ligne de commande construit sur `NotificationKitAPNs` :

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

Faites de la classe principale d’une cible Notification Service Extension une sous-classe de `MediaAttachmentService`. Les notifications push avec `"mutable-content": 1` et un `"media-url"` affichent alors l’image, l’audio ou la vidéo. Les téléchargements se font uniquement en `https` et s’arrêtent aux limites de taille d’Apple.

```swift
import NotificationKit

// The principal class of the extension. Pushes with "mutable-content": 1 and a "media-url"
// get the image, audio or video attached before they are shown.
final class NotificationService: MediaAttachmentService {}
```

### Tests

`InMemoryNotificationCenter` se comporte comme le centre du système, limite de 64 notifications comprise, si bien que la logique de programmation s’exécute dans de simples tests unitaires :

```swift
func scheduledCount() async throws -> Int {
    let center = InMemoryNotificationCenter(authorizationStatus: .authorized)
    let scheduler = NotificationScheduler(center: center, store: InMemoryNotificationStore())
    let reminders = (1...70).map { LocalNotification(id: "r\($0)", title: "Reminder \($0)", trigger: .after(minutes: Double($0))) }
    try await scheduler.schedule(reminders)
    return await center.pending.count // 64: the other 6 wait in the scheduler's queue
}
```

## Démo

| Bannière                                                   | File au-delà de 64                                                         | Ouvert depuis un push                                                             |
| ---------------------------------------------------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| ![Bannière de rappel, clair](docs/images/banner-light.png) | ![Liste des notifications programmées, clair](docs/images/queue-light.png) | ![Commande ouverte depuis un push, clair](docs/images/push-destination-light.png) |
| ![Bannière de rappel, sombre](docs/images/banner-dark.png) | ![Liste des notifications programmées, sombre](docs/images/queue-dark.png) | ![Commande ouverte depuis un push, sombre](docs/images/push-destination-dark.png) |

Les captures d’écran proviennent des tests d’interface de l’app d’exemple sur un simulateur d’iPhone, exécutés par
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh). Les tests autorisent les notifications, programment un rappel et touchent sa bannière, programment 70 rappels (64 vont à iOS, les autres attendent dans la file ; un de plus tombe dans les heures calmes) et ouvrent une commande depuis un push que le script construit avec `PushPayload` et livre avec `xcrun simctl push`.

Pour l’essayer vous-même, ouvrez `NotificationLab.xcodeproj` dans [`Examples/NotificationLab`](Examples/NotificationLab), choisissez un simulateur d’iPhone et appuyez sur **Run**. [Examples/README.md](Examples/README.md) donne les détails.

## Documentation

Référence de l’API et articles :

- [Référence de l’API](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/)
  de `NotificationKit` et de
  [`NotificationKitAPNs`](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/)
  (DocC, publiée sur GitHub Pages depuis `main`)
- Générez-la en local dans Xcode avec **Product › Build Documentation**, ou en ligne de commande :

```sh
xcodebuild docbuild -scheme NotificationKit-Package -destination 'generic/platform=macOS'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/gettingstarted)
  — ajouter le paquet, demander l’autorisation, programmer et réagir aux appuis
  ([source](Sources/NotificationKit/NotificationKit.docc/GettingStarted.md)).
- [Scheduling Beyond the Limit](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/schedulingbeyondthelimit)
  — la file, les heures calmes, la limite de fréquence et les valeurs vérifiées avant la programmation
  ([source](Sources/NotificationKit/NotificationKit.docc/SchedulingBeyondTheLimit.md)).
- [Responding to Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/respondingtonotifications)
  — catégories, actions, flux d’événements et deep links
  ([source](Sources/NotificationKit/NotificationKit.docc/RespondingToNotifications.md)).
- [Remote Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/remotenotifications)
  — jetons d’appareil, payloads, médias dans une service extension et push sur le simulateur
  ([source](Sources/NotificationKit/NotificationKit.docc/RemoteNotifications.md)).
- [Testing Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/testingnotifications)
  — le centre en mémoire et une horloge contrôlable
  ([source](Sources/NotificationKit/NotificationKit.docc/TestingNotifications.md)).
- [Sending Push Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/sendingpushnotifications)
  — clés APNs, environnements, alertes, push en arrière-plan et de Live Activity, gestion des erreurs
  ([source](Sources/NotificationKitAPNs/NotificationKitAPNs.docc/SendingPushNotifications.md)).

## Prérequis

| Plateforme      | Version minimale      |
| --------------- | --------------------- |
| iOS             | 17                    |
| macOS           | 14                    |
| watchOS         | 10                    |
| visionOS        | 1                     |
| Chaîne d’outils | Swift 6.2 · Xcode 26+ |

Les déclencheurs de localisation fonctionnent sur iOS et watchOS ; les pièces jointes ne sont pas disponibles sur watchOS, où les sons nommés jouent aussi le son par défaut. `NotificationKitAPNs` nécessite CryptoKit et ne se compile donc pas sous Linux. La CI compile avec le Xcode par défaut de l’image de runner `macos-26` de GitHub. Le paquet est développé avec Xcode 27.

## Architecture

- `NotificationKit` est découpé par rôle : `Content/` (la valeur de notification, les sons, le user info JSON, les erreurs de validation), `Triggers/`, `Policy/` (heures calmes, limite de fréquence), `Scheduling/`, `Center/` (les centres du système et en mémoire), `Categories/`, `Events/` (delegate, réponses, deep links), `Push/` (payload, jeton) et `Extension/` (téléchargements de médias).
- `NotificationScheduler` est un actor qui exécute les appels un par un. Il décide à l’aide de deux types purs : `FireDateResolver` applique les heures calmes et la limite, `SlotPlanner` détermine les notifications que garde le système. Les deux sont testés sans appareil.
- On n’atteint le système que par le protocole `NotificationCenterClient` ; `UserNotificationCenterClient` convertit les valeurs en `UNNotificationRequest`, et `InMemoryNotificationCenter` le remplace dans les tests et les aperçus.
- Les entrées venant de l’extérieur de l’app (payloads de push, deep links, médias téléchargés, état enregistré) sont bornées : profondeur d’imbrication et nombre de valeurs pour le JSON, longueur et segments des liens, taille des téléchargements, taille du fichier de la file enregistrée, et contrôles de plage avant qu’un `Double` ne devienne un `Int`.
- `NotificationKitAPNs` construit les requêtes sous forme de valeurs (`APNsRequest`), signe les jetons de fournisseur ES256 avec CryptoKit et envoie via un protocole `APNsTransport` reposant sur `URLSession`.

Lancez les tests en local :

```sh
swift test                                    # macOS
xcodebuild test -scheme NotificationKit-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Feuille de route

- Ajouter le paquet au Swift Package Index ; `.spi.yml` est déjà dans le dépôt.
- Canaux de push de diffusion pour les Live Activities (iOS 18) dans `NotificationKitAPNs`.
- Une version de `NotificationKitAPNs` compilable sous Linux, sur swift-crypto.

## Contribuer

Les contributions sont les bienvenues. Lisez le [guide de contribution](https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/CONTRIBUTING.md) et le [code de conduite](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) avant d’ouvrir une pull request. Signalez les problèmes de sécurité en privé, comme indiqué dans la [politique de sécurité](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licence

Publié sous licence MIT. Voir [LICENSE](LICENSE).
