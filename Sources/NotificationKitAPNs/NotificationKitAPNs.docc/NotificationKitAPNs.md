# ``NotificationKitAPNs``

Send push notifications to Apple devices from a server, a command-line tool or a script, with
token-based authentication and no dependencies outside Apple's SDK.

## Overview

`NotificationKitAPNs` talks to the Apple Push Notification service over HTTP/2 with `URLSession`
and signs provider tokens with CryptoKit. It uses the same `NotificationKit/PushPayload` type
the app reads, so both sides agree on the payload.

```swift
import NotificationKit
import NotificationKitAPNs

let key = try APNsSigningKey(
    p8File: URL(filePath: "AuthKey_ABC123DEFG.p8"),
    keyID: "ABC123DEFG",
    teamID: "DEF123GHIJ"
)
let client = APNsClient(key: key, environment: .development)

var payload = PushPayload.alert(title: "Order shipped", body: "A-1042 is on its way.")
payload.deepLink = URL(string: "myapp://orders/A-1042")

try await client.send(APNsRequest(
    payload: payload,
    deviceToken: try DeviceToken(hexString: storedToken),
    topic: "com.example.MyApp"
))
```

The module runs on macOS 14 and later (and on Apple's other platforms). It does not build on
Linux, where CryptoKit is not available.

## Topics

### Essentials

- <doc:SendingPushNotifications>

### Sending

- ``APNsClient``
- ``APNsRequest``
- ``APNsEnvironment``
- ``APNsPriority``
- ``APNsExpiration``
- ``APNsDelivery``

### Authentication

- ``APNsSigningKey``

### Errors

- ``APNsError``
- ``APNsErrorReason``
- ``APNsRequestError``

### Transport

- ``APNsTransport``
- ``URLSessionAPNsTransport``
