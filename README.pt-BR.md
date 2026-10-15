<!-- i18n-source: README.md@3e5602b25e123d445fd60722eaff734a9354ff87 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/banner-light.svg" alt="NotificationKit: Schedule local notifications past iOS's 64 limit, route taps and send pushes through APNs."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Notification-Framework/actions/workflows/ci.yml/badge.svg" alt="Status da CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-version-light.svg" alt="Versão mais recente: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatíveis: iOS 17+ · macOS 14+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-language-light.svg" alt="Versão da linguagem: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/badge-license-light.svg" alt="Licença: MIT"></picture></a>
</p>

<p align="center">
<a href="#início-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-start-pt-BR-light.svg" alt="Começar"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-docs-pt-BR-light.svg" alt="Documentação"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Notification-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Notification-Framework/main/.github/brand/button-examples-pt-BR-light.svg" alt="Exemplos"></picture></a>
</p>

> Esta é uma tradução do README em inglês. Se houver diferença, vale a versão em inglês.

<!-- brand:end -->

O NotificationKit é um pacote Swift para apps que agendam notificações no dispositivo e para os servidores que enviam pushes a eles. Ele envolve o `UserNotifications` em tipos de valor e corrige as partes que falham em silêncio: o iOS mantém apenas as 64 notificações pendentes mais próximas de um app e descarta o restante sem nenhum erro, alguns valores inválidos derrubam o app em vez de lançar um erro, e os callbacks do delegate são difíceis de usar com Swift concurrency. Uma segunda biblioteca, a `NotificationKitAPNs`, envia pushes pelo serviço APNs da Apple a partir de um servidor ou de um script, usando o mesmo tipo de payload que o app lê. Nenhuma das duas bibliotecas tem dependências fora do SDK da Apple.

## Destaques

- **Nenhuma notificação perdida além das 64** — o `NotificationScheduler` entrega ao iOS as 64 notificações mais próximas, guarda as demais em uma fila salva e as adianta à medida que surgem vagas.
- **Horário de silêncio e limite de frequência** — verificados em relação ao momento em que a notificação dispara: um lembrete criado às 21h para as 23h espera até a manhã, e uma quarta notificação dentro de uma hora passa para o primeiro horário permitido.
- **Erros em vez de travamentos** — um intervalo de repetição abaixo de 60 segundos, um relevance score NaN ou a hora 25 lançam um `NotificationValidationError` antes que o `UNUserNotificationCenter` os veja.
- **Toques, ações e deep links como valores** — o `NotificationEventHandler` transforma os callbacks do delegate em `AsyncStream`s, e o `DeepLinkRouter` abre telas somente a partir dos schemes e hosts que você permitir.
- **Push nos dois lados** — um `PushPayload` tipado, com as regras e os limites de tamanho do APNs, um `DeviceToken` que nunca é impresso por inteiro, uma Notification Service Extension que baixa mídia dentro dos limites da Apple e um cliente APNs com autenticação por token.
- **Testado** — 109 testes com Swift Testing no macOS e em um simulador de iPhone, com uma central de notificações em memória que tem o limite de 64 notificações do sistema; três testes de UI em um simulador tocam em banners reais e abrem um pedido a partir de um push real.

## Início rápido

**1. Adicione o pacote**

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Adicione a biblioteca `NotificationKit` ao target do seu app.

**2. Importe o módulo**

```swift
import NotificationKit
```

**3. Use**

Substitua o `ContentView.swift` de um novo app iOS por:

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

Execute o app, toque no botão, permita as notificações e vá para a Tela de Início: o lembrete chega 10 segundos depois. Para mostrar notificações também com o app aberto, instale um `NotificationEventHandler` (veja [Respondendo a toques e ações](#respondendo-a-toques-e-ações)).

## Instalação

### Swift Package Manager

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/iOS-Notification-Framework.git
```

Ou adicione-o às `dependencies` do seu `Package.swift`:

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

Os exemplos abaixo foram copiados de
[`Examples/NotificationLab/NotificationLab/ReadmeSamples.swift`](Examples/NotificationLab/NotificationLab/ReadmeSamples.swift),
que o app de exemplo e os testes do pacote compilam.

### Agendamento

Uma `LocalNotification` é um valor com um `NotificationTrigger`: após um atraso, em uma data, em componentes de data correspondentes (`.daily`, `.weekly`, `.monthly`) ou ao entrar em uma região. Agendar outra notificação com o mesmo identificador substitui a anterior.

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

Chame `try await scheduler.refresh()` quando o app iniciar e quando voltar ao primeiro plano; ele esquece as notificações já entregues e move as da fila para as vagas livres.

### Horário de silêncio e limite de frequência

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

Notificações urgentes (time-sensitive) e críticas passam pelo horário de silêncio por padrão. Notificações repetidas mantêm o horário escolhido pelo usuário.

### Ações

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

### Respondendo a toques e ações

Crie um único `NotificationEventHandler` quando o app iniciar e chame `events.install()` antes de a inicialização terminar (no inicializador do seu `App`), para não perder o toque que abriu o app.

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

### Notificações push no dispositivo

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

`print(token)` mostra `DeviceToken(3f2a…91bc, 32 bytes)`; a mesma ocultação vale para `dump`, interpolação de strings e o depurador.

### Envio a partir de um servidor

Em [`Examples/PushSender`](Examples/PushSender), uma ferramenta de linha de comando criada sobre a `NotificationKitAPNs`:

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

Faça da principal class de um target de Notification Service Extension uma subclasse de `MediaAttachmentService`. Os pushes com `"mutable-content": 1` e um `"media-url"` passam então a exibir a imagem, o áudio ou o vídeo. Os downloads são somente por `https` e param nos limites de tamanho da Apple.

```swift
import NotificationKit

// The principal class of the extension. Pushes with "mutable-content": 1 and a "media-url"
// get the image, audio or video attached before they are shown.
final class NotificationService: MediaAttachmentService {}
```

### Testes

O `InMemoryNotificationCenter` se comporta como a central do sistema, inclusive com o limite de 64 notificações, então a lógica de agendamento roda em testes unitários comuns:

```swift
func scheduledCount() async throws -> Int {
    let center = InMemoryNotificationCenter(authorizationStatus: .authorized)
    let scheduler = NotificationScheduler(center: center, store: InMemoryNotificationStore())
    let reminders = (1...70).map { LocalNotification(id: "r\($0)", title: "Reminder \($0)", trigger: .after(minutes: Double($0))) }
    try await scheduler.schedule(reminders)
    return await center.pending.count // 64: the other 6 wait in the scheduler's queue
}
```

## Demonstração

| Banner                                                     | Fila além de 64                                           | Aberto a partir de um push                                                          |
| ---------------------------------------------------------- | --------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| ![Banner de lembrete, claro](docs/images/banner-light.png) | ![Lista de agendadas, claro](docs/images/queue-light.png) | ![Pedido aberto a partir de um push, claro](docs/images/push-destination-light.png) |
| ![Banner de lembrete, escuro](docs/images/banner-dark.png) | ![Lista de agendadas, escuro](docs/images/queue-dark.png) | ![Pedido aberto a partir de um push, escuro](docs/images/push-destination-dark.png) |

As capturas de tela vêm dos testes de UI do app de exemplo em um simulador de iPhone, executados por
[`scripts/capture-screenshots.sh`](scripts/capture-screenshots.sh). Os testes permitem as notificações, agendam um lembrete e tocam no banner dele, agendam 70 lembretes (64 vão para o iOS, o restante espera na fila; mais um cai no horário de silêncio) e abrem um pedido a partir de um push que o script monta com `PushPayload` e entrega com `xcrun simctl push`.

Para experimentar, abra o `NotificationLab.xcodeproj` em [`Examples/NotificationLab`](Examples/NotificationLab), escolha um simulador de iPhone e pressione **Run**. O [Examples/README.md](Examples/README.md) traz os detalhes.

## Documentação

Referência da API e artigos:

- [Referência da API](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/)
  do `NotificationKit` e da
  [`NotificationKitAPNs`](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/)
  (DocC, publicada no GitHub Pages a partir da `main`)
- Gere-a localmente no Xcode com **Product › Build Documentation** ou pela linha de comando:

```sh
xcodebuild docbuild -scheme NotificationKit-Package -destination 'generic/platform=macOS'
```

## Guias

- [Getting Started](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/gettingstarted)
  — adicionar o pacote, pedir permissão, agendar e reagir aos toques
  ([código-fonte](Sources/NotificationKit/NotificationKit.docc/GettingStarted.md)).
- [Scheduling Beyond the Limit](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/schedulingbeyondthelimit)
  — a fila, o horário de silêncio, o limite de frequência e os valores verificados antes de agendar
  ([código-fonte](Sources/NotificationKit/NotificationKit.docc/SchedulingBeyondTheLimit.md)).
- [Responding to Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/respondingtonotifications)
  — categorias, ações, fluxos de eventos e deep links
  ([código-fonte](Sources/NotificationKit/NotificationKit.docc/RespondingToNotifications.md)).
- [Remote Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/remotenotifications)
  — tokens de dispositivo, payloads, mídia em uma service extension e pushes no simulador
  ([código-fonte](Sources/NotificationKit/NotificationKit.docc/RemoteNotifications.md)).
- [Testing Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkit/testingnotifications)
  — a central em memória e um relógio controlável
  ([código-fonte](Sources/NotificationKit/NotificationKit.docc/TestingNotifications.md)).
- [Sending Push Notifications](https://muhittincamdali.github.io/iOS-Notification-Framework/documentation/notificationkitapns/sendingpushnotifications)
  — chaves do APNs, ambientes, alertas, pushes em segundo plano e de Live Activity, tratamento de erros
  ([código-fonte](Sources/NotificationKitAPNs/NotificationKitAPNs.docc/SendingPushNotifications.md)).

## Requisitos

| Plataforma  | Versão mínima         |
| ----------- | --------------------- |
| iOS         | 17                    |
| macOS       | 14                    |
| watchOS     | 10                    |
| visionOS    | 1                     |
| Ferramentas | Swift 6.2 · Xcode 26+ |

Os gatilhos de localização funcionam no iOS e no watchOS; anexos não estão disponíveis no watchOS, onde os sons nomeados também tocam o som padrão. A `NotificationKitAPNs` precisa do CryptoKit, então não compila no Linux. A CI compila com o Xcode padrão da imagem de runner `macos-26` do GitHub. O pacote é desenvolvido com o Xcode 27.

## Arquitetura

- O `NotificationKit` é dividido por função: `Content/` (o valor da notificação, sons, user info em JSON, erros de validação), `Triggers/`, `Policy/` (horário de silêncio, limite de frequência), `Scheduling/`, `Center/` (as centrais do sistema e em memória), `Categories/`, `Events/` (delegate, respostas, deep links), `Push/` (payload, token) e `Extension/` (downloads de mídia).
- O `NotificationScheduler` é um actor que executa as chamadas uma de cada vez. Ele decide com dois tipos puros: o `FireDateResolver` aplica o horário de silêncio e o limite, e o `SlotPlanner` decide quais notificações o sistema mantém. Ambos são testados sem dispositivo.
- O sistema só é acessado pelo protocolo `NotificationCenterClient`; o `UserNotificationCenterClient` converte valores em `UNNotificationRequest`, e o `InMemoryNotificationCenter` o substitui em testes e previews.
- Entradas de fora do app (payloads de push, deep links, mídia baixada, estado salvo) têm limites: profundidade de aninhamento e quantidade de valores no JSON, comprimento e segmentos dos links, tamanho do download, tamanho do arquivo da fila salva e verificações de intervalo antes de qualquer `Double` virar `Int`.
- A `NotificationKitAPNs` monta as requisições como valores (`APNsRequest`), assina tokens de provedor ES256 com o CryptoKit e envia por meio de um protocolo `APNsTransport` baseado em `URLSession`.

Execute os testes localmente:

```sh
swift test                                    # macOS
xcodebuild test -scheme NotificationKit-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Roteiro

- Adicionar o pacote ao Swift Package Index; o `.spi.yml` já está no repositório.
- Canais de push de transmissão (broadcast) para Live Activities (iOS 18) na `NotificationKitAPNs`.
- Um build da `NotificationKitAPNs` para Linux, sobre o swift-crypto.

## Como contribuir

Contribuições são bem-vindas. Leia o [guia de contribuição](https://github.com/muhittincamdali/iOS-Notification-Framework/blob/main/CONTRIBUTING.md) e o [código de conduta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir um pull request. Relate problemas de segurança de forma privada, como descrito na [política de segurança](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licença

Publicado sob a licença MIT. Veja [LICENSE](LICENSE).
