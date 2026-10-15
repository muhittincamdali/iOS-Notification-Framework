# Sending Push Notifications

Create an APNs key, send alerts, background pushes and Live Activity updates, and handle
APNs' answers.

## Create a key

1. In [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/authkeys/list),
   create a key with **Apple Push Notifications service (APNs)** enabled and download the
   `.p8` file. Apple lets you download it only once.
2. Note the key ID (shown with the key) and your team ID (in the membership details).
3. Keep the file out of the repository; load it from a secret store or a mounted file.

```swift
let key = try APNsSigningKey(p8File: keyURL, keyID: "ABC123DEFG", teamID: "DEF123GHIJ")
```

``APNsSigningKey`` checks that both IDs are 10 uppercase letters and digits and that the file
is a P-256 private key. Its `description`, `dump` and debugger view show only the IDs.

## Choose the environment

Builds signed for development (run from Xcode) register with the sandbox server; TestFlight and
App Store builds with the production server. A token sent to the wrong server is rejected with
`BadDeviceToken`.

```swift
let client = APNsClient(key: key, environment: .development) // api.sandbox.push.apple.com
```

``APNsClient`` signs a provider token and reuses it for 50 minutes. Apple rejects tokens older
than an hour and answers `TooManyProviderTokenUpdates` to tokens refreshed more often than every
20 minutes. If APNs still answers `ExpiredProviderToken`, the client signs a new token and sends
once more.

## Send

An ``APNsRequest`` combines the payload, the token and the headers:

```swift
var request = APNsRequest(
    payload: .alert(title: "Order shipped", body: "A-1042 is on its way."),
    deviceToken: token,
    topic: "com.example.MyApp"
)
request.collapseID = "order-A-1042"      // a newer push replaces this one on the device
request.expiration = .at(.now + 3600)    // keep trying for an hour if the device is offline
let delivery = try await client.send(request)
print(delivery.apnsID)
```

Background pushes need priority 5 and must not show anything:

```swift
let refresh = APNsRequest(
    payload: .background(custom: ["sync": "inbox"]),
    deviceToken: token,
    pushType: .background,
    topic: "com.example.MyApp",
    priority: .conservePower
)
```

Live Activity pushes go to the activity's own push token, with the topic suffix that
``APNsRequest/topic(forBundleID:pushType:)`` adds:

```swift
let update = APNsRequest(
    payload: PushPayload(aps: APS(
        timestamp: .now,
        event: .update,
        contentState: ["minutesLeft": 12, "status": "On the way"]
    )),
    deviceToken: activityToken,
    pushType: .liveActivity,
    topic: APNsRequest.topic(forBundleID: "com.example.MyApp", pushType: .liveActivity)
)
```

Before anything is sent, the request is checked: the payload against APNs' rules and size limit
(`NotificationKit/PushPayloadError`), the topic and collapse ID for length and for characters
that cannot appear in an HTTP header, the priority of background pushes, and the expiration date
(``APNsRequestError``).

## Handle the answer

APNs answers each push separately. ``APNsError`` carries the status, the reason and, for 410
answers, when the token stopped being valid:

```swift
do {
    try await client.send(request)
} catch let error as APNsError where error.isTokenInvalid {
    try await database.deleteToken(token)     // Unregistered, BadDeviceToken, ...
} catch let error as APNsError where error.isRetryable {
    try await queue.retryLater(request)       // 429, 500, 503
}
```

Error answers are a few dozen bytes; the transport reads at most 64 KB of any answer, so an
unexpected endpoint cannot make the client hold a large body.

## Try it from the command line

`Examples/PushSender` is a small command-line tool built on this module:

```sh
cd Examples/PushSender
swift run nk-push send --key AuthKey_ABC123DEFG.p8 --key-id ABC123DEFG --team-id DEF123GHIJ \
  --topic com.example.MyApp --token <hex token> --sandbox \
  --title "Hello" --body "Sent with NotificationKitAPNs"
```
