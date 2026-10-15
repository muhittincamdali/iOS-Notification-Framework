<!-- i18n-source: README.md@3e5602b25e123d445fd60722eaff734a9354ff87 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg" alt="NotificationKit: Schedule local notifications past iOS's 64 limit, route taps and send pushes through APNs."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg" alt="Estado de CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg" alt="Última versión: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatibles: iOS 17+ · macOS 14+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg" alt="Versión del lenguaje: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg" alt="Licencia: MIT"></picture></a>
</p>

<p align="center">
<a href="#inicio-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-es-light.svg" alt="Empezar"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-es-light.svg" alt="Documentación"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-es-light.svg" alt="Ejemplos"></picture></a>
</p>

> Esta es una traducción del README en inglés. Si hay diferencias, la versión en inglés es la vigente.

<!-- brand:end -->

NotificationKit es un paquete de Swift para las apps que programan notificaciones en el dispositivo y para los servidores que les envían notificaciones push. Envuelve `UserNotifications` en tipos de valor y corrige las partes que fallan en silencio: iOS conserva solo las 64 notificaciones pendientes más próximas de una app y descarta el resto sin dar ningún error, algunos valores no válidos hacen que la app se cierre en lugar de lanzar un error, y las llamadas de retorno del delegate son difíciles de usar desde Swift concurrency. Una segunda biblioteca, `NotificationKitAPNs`, envía notificaciones push mediante el servicio APNs de Apple desde un servidor o un script, con el mismo tipo de payload que lee la app. Ninguna de las dos bibliotecas tiene dependencias fuera del SDK de Apple.

## Lo más destacado

- **Ninguna notificación se pierde más allá de las 64** — `NotificationScheduler` entrega a iOS las 64 notificaciones más próximas, guarda las demás en una cola persistente y las va adelantando a medida que se liberan huecos.
- **Horas de silencio y límite de frecuencia** — se comprueban con respecto al momento en que se dispara la notificación, de modo que un recordatorio creado a las 21:00 para las 23:00 espera a la mañana, y una cuarta notificación dentro de una misma hora pasa a la primera hora permitida.
- **Errores en lugar de cierres inesperados** — un intervalo de repetición inferior a 60 segundos, un relevance score NaN o la hora 25 lanzan un `NotificationValidationError` antes de que `UNUserNotificationCenter` los vea.
- **Toques, acciones y deep links como valores** — `NotificationEventHandler` convierte las llamadas de retorno del delegate en `AsyncStream`s, y `DeepLinkRouter` abre pantallas solo desde los esquemas y hosts que permitas.
- **Push en ambos lados** — un `PushPayload` tipado que respeta las reglas y los límites de tamaño de APNs, un `DeviceToken` que nunca se imprime completo, una Notification Service Extension que descarga contenido multimedia dentro de los límites de Apple y un cliente de APNs con autenticación por token.
- **Probado** — 109 pruebas de Swift Testing en macOS y en un simulador de iPhone, con un centro de notificaciones en memoria que tiene el límite de 64 notificaciones del sistema; tres pruebas de interfaz en un simulador tocan banners reales y abren un pedido desde un push real.

## Inicio rápido

**1. Añade el paquete**

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Añade la biblioteca `NotificationKit` al target de tu app.

**2. Importa el módulo**

```swift
import NotificationKit
```

**3. Úsalo**

Sustituye el `ContentView.swift` de una app de iOS nueva por esto:

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

Ejecuta la app, toca el botón, permite las notificaciones y ve a la pantalla de inicio: el recordatorio llega 10 segundos después. Para mostrar también las notificaciones con la app abierta, instala un `NotificationEventHandler` (consulta [Responder a toques y acciones](#responder-a-toques-y-acciones)).

## Instalación

### Swift Package Manager

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

O añádelo a las `dependencies` de tu `Package.swift`:

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

## Uso

Los ejemplos siguientes están copiados de
[`Examples/NotificationLab/NotificationLab/ReadmeSamples.swift`](Examples/NotificationLab/NotificationLab/ReadmeSamples.swift),
que compilan la app de ejemplo y las pruebas del paquete.

### Programación

Una `LocalNotification` es un valor con un `NotificationTrigger`: tras un retardo, en una fecha, en unos componentes de fecha coincidentes (`.daily`, `.weekly`, `.monthly`) o al entrar en una región. Programar otra notificación con el mismo identificador sustituye a la anterior.

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

Llama a `try await scheduler.refresh()` cuando se inicie la app y cuando vuelva a primer plano; descarta las notificaciones ya entregadas y mueve las de la cola a los huecos libres.

### Horas de silencio y límite de frecuencia

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

Las notificaciones de entrega urgente (time-sensitive) y las críticas atraviesan las horas de silencio de forma predeterminada. Las notificaciones repetitivas conservan la hora que eligió el usuario.

### Acciones

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

### Responder a toques y acciones

Crea un único `NotificationEventHandler` cuando se inicie la app y llama a `events.install()` antes de que termine el arranque (en el inicializador de tu `App`), para no perder el toque que abrió la app.

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

### Notificaciones push en el dispositivo

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

`print(token)` muestra `DeviceToken(3f2a…91bc, 32 bytes)`; la misma ofuscación se aplica a `dump`, a la interpolación de cadenas y al depurador.

### Envío desde un servidor

De [`Examples/PushSender`](Examples/PushSender), una herramienta de línea de comandos creada sobre `NotificationKitAPNs`:

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

Haz que la clase principal de un target de Notification Service Extension sea una subclase de `MediaAttachmentService`. Los push con `"mutable-content": 1` y un `"media-url"` mostrarán entonces la imagen, el audio o el vídeo. Las descargas son solo por `https` y se detienen en los límites de tamaño de Apple.

```swift
import NotificationKit

// The principal class of the extension. Pushes with "mutable-content": 1 and a "media-url"
// get the image, audio or video attached before they are shown.
final class NotificationService: MediaAttachmentService {}
```

### Pruebas

`InMemoryNotificationCenter` se comporta como el centro del sistema, incluido el límite de 64 notificaciones, así que la lógica de programación se ejecuta en pruebas unitarias normales:

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

| Banner                                                         | Cola más allá de 64                                         | Abierto desde un push                                                          |
| -------------------------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------ |
| ![Banner de recordatorio, claro](docs/images/banner-light.png) | ![Lista de programadas, claro](docs/images/queue-light.png) | ![Pedido abierto desde un push, claro](docs/images/push-destination-light.png) |
| ![Banner de recordatorio, oscuro](docs/images/banner-dark.png) | ![Lista de programadas, oscuro](docs/images/queue-dark.png) | ![Pedido abierto desde un push, oscuro](docs/images/push-destination-dark.png) |

Las capturas proceden de las pruebas de interfaz de la app de ejemplo en un simulador de iPhone, que ejecuta
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh). Las pruebas permiten las notificaciones, programan un recordatorio y tocan su banner, programan 70 recordatorios (64 van a iOS, el resto espera en la cola; uno más cae en las horas de silencio) y abren un pedido desde un push que el script construye con `PushPayload` y entrega con `xcrun simctl push`.

Para probarlo tú mismo, abre `NotificationLab.xcodeproj` en [`Examples/NotificationLab`](Examples/NotificationLab), elige un simulador de iPhone y pulsa **Run**. [Examples/README.md](Examples/README.md) tiene los detalles.

## Documentación

Referencia de la API y artículos:

- [Referencia de la API](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/)
  de `NotificationKit` y de
  [`NotificationKitAPNs`](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/)
  (DocC, publicada en GitHub Pages desde `main`)
- Compílala en local en Xcode con **Product › Build Documentation**, o desde la línea de comandos:

```sh
xcodebuild docbuild -scheme NotificationKit-Package -destination 'generic/platform=macOS'
```

## Guías

- [Getting Started](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/gettingstarted)
  — añadir el paquete, pedir permiso, programar y reaccionar a los toques
  ([código fuente](Sources/NotificationKit/NotificationKit.docc/GettingStarted.md)).
- [Scheduling Beyond the Limit](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/schedulingbeyondthelimit)
  — la cola, las horas de silencio, el límite de frecuencia y los valores que se comprueban antes de programar
  ([código fuente](Sources/NotificationKit/NotificationKit.docc/SchedulingBeyondTheLimit.md)).
- [Responding to Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/respondingtonotifications)
  — categorías, acciones, flujos de eventos y deep links
  ([código fuente](Sources/NotificationKit/NotificationKit.docc/RespondingToNotifications.md)).
- [Remote Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/remotenotifications)
  — tokens de dispositivo, payloads, contenido multimedia en una service extension y push en el simulador
  ([código fuente](Sources/NotificationKit/NotificationKit.docc/RemoteNotifications.md)).
- [Testing Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/testingnotifications)
  — el centro en memoria y un reloj controlable
  ([código fuente](Sources/NotificationKit/NotificationKit.docc/TestingNotifications.md)).
- [Sending Push Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/sendingpushnotifications)
  — claves de APNs, entornos, alertas, push en segundo plano y de Live Activity, gestión de errores
  ([código fuente](Sources/NotificationKitAPNs/NotificationKitAPNs.docc/SendingPushNotifications.md)).

## Requisitos

| Plataforma   | Versión mínima        |
| ------------ | --------------------- |
| iOS          | 17                    |
| macOS        | 14                    |
| watchOS      | 10                    |
| visionOS     | 1                     |
| Herramientas | Swift 6.2 · Xcode 26+ |

Los disparadores por ubicación funcionan en iOS y watchOS; los adjuntos no están disponibles en watchOS, donde además los sonidos con nombre reproducen el sonido predeterminado. `NotificationKitAPNs` necesita CryptoKit, así que no se compila en Linux. La CI compila con el Xcode predeterminado de la imagen de runner `macos-26` de GitHub. El paquete se desarrolla con Xcode 27.

## Arquitectura

- `NotificationKit` se divide por tareas: `Content/` (el valor de la notificación, los sonidos, el user info en JSON, los errores de validación), `Triggers/`, `Policy/` (horas de silencio, límite de frecuencia), `Scheduling/`, `Center/` (los centros del sistema y en memoria), `Categories/`, `Events/` (delegate, respuestas, deep links), `Push/` (payload, token) y `Extension/` (descargas de contenido multimedia).
- `NotificationScheduler` es un actor que ejecuta las llamadas de una en una. Decide con dos tipos puros: `FireDateResolver` aplica las horas de silencio y el límite, y `SlotPlanner` decide qué notificaciones conserva el sistema. Ambos se prueban sin dispositivo.
- Al sistema solo se llega a través del protocolo `NotificationCenterClient`; `UserNotificationCenterClient` convierte los valores en `UNNotificationRequest`, e `InMemoryNotificationCenter` lo sustituye en las pruebas y en las previsualizaciones.
- Los datos que llegan de fuera de la app (payloads de push, deep links, contenido multimedia descargado, estado guardado) tienen límites: profundidad de anidamiento y número de valores en el JSON, longitud y segmentos de los enlaces, tamaño de descarga, tamaño del archivo de la cola guardada y comprobaciones de rango antes de convertir cualquier `Double` en `Int`.
- `NotificationKitAPNs` construye las solicitudes como valores (`APNsRequest`), firma con CryptoKit los tokens de proveedor ES256 y envía a través de un protocolo `APNsTransport` respaldado por `URLSession`.

Ejecuta las pruebas en local:

```sh
swift test                                    # macOS
xcodebuild test -scheme NotificationKit-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Hoja de ruta

- Añadir el paquete al Swift Package Index; `.spi.yml` ya está en el repositorio.
- Canales de push de difusión para Live Activities (iOS 18) en `NotificationKitAPNs`.
- Una compilación de `NotificationKitAPNs` para Linux sobre swift-crypto.

## Contribuir

Las contribuciones son bienvenidas. Lee la [guía de contribución](https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/CONTRIBUTING.md) y el [código de conducta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir una pull request. Informa de los problemas de seguridad de forma privada, como se describe en la [política de seguridad](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licencia

Publicado bajo la licencia MIT. Consulta [LICENSE](LICENSE).
