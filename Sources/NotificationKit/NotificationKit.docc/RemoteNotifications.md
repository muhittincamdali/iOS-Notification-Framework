# Remote Notifications

Register for pushes, keep the device token out of logs, read payloads and attach media in a
Notification Service Extension.

## Register and handle the token

Remote notifications need the Push Notifications capability (the `aps-environment`
entitlement). Register after permission is granted and pass the token to your server:

```swift
final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken data: Data) {
        guard let token = try? DeviceToken(data: data) else { return }
        print("Registered:", token)       // DeviceToken(3f2a…91bc, 32 bytes)
        Task { try await upload(token.hexString) }
    }
}
```

The token identifies the device to anyone who can send it pushes. ``DeviceToken`` shows only
its first and last four hex digits in `description`, `debugDescription`, string interpolation,
`dump` and the debugger's view; ``DeviceToken/hexString`` and `Codable` give the full value for
your server. APNs tokens have no fixed length, so the type accepts 1 to 255 bytes.

## Read a payload

``PushPayload`` is the same type a server encodes with (see `NotificationKitAPNs`), so both
sides agree on key names:

```swift
let payload = try PushPayload(userInfo: response.notification.request.content.userInfo)
payload.aps.alert?.title
payload.deepLink
payload.custom["orderID"]?.stringValue
```

When you only need the custom data and the deep link, ``ReceivedNotification`` (from
``NotificationEventHandler``) already has them.

``PushPayload/validate(for:)`` and ``PushPayload/encoded(for:)`` check APNs' rules for each
``PushType``: the size limit (4 KB, 5 KB for VoIP), background pushes that must not show
anything, alert pushes that must show something, Live Activity fields per event, ranges of
numbers and dates. Dates are converted to whole seconds only after a range check, so a date
such as `Date(timeIntervalSince1970: .nan)` becomes an error instead of a crash.

## Attach images, audio and video

A push with `mutable-content: 1` passes through your Notification Service Extension before it is
shown. Make the extension's principal class a subclass of ``MediaAttachmentService``:

```swift
import NotificationKit

final class NotificationService: MediaAttachmentService {}
```

and send the media URL under `media-url`:

```json
{
  "aps": { "alert": { "title": "New photo" }, "mutable-content": 1 },
  "media-url": "https://example.com/photo.jpg"
}
```

The service downloads the file with ``AttachmentDownloader`` and attaches it. The downloader
accepts only `https` (also after redirects), only the types the system can attach, and stops as
soon as the file exceeds Apple's limit for its kind (10 MB images, 5 MB audio, 50 MB video),
whether or not the server announced the size. It streams to disk, because an extension has
little memory. If the download fails or the extension runs out of time, the notification is
shown without the attachment; the content handler is called exactly once either way.

## Test pushes on a simulator

`xcrun simctl push` delivers a payload file to an app on a booted simulator. The example
`nk-push` tool in `Examples/PushSender` writes such a file:

```sh
cd Examples/PushSender
swift run nk-push payload --title "Order shipped" --body "A-1042 is on its way." \
  --deeplink myapp://orders/A-1042 --bundle-id com.example.MyApp --output order.apns
xcrun simctl push booted order.apns
```
