# Responding to Notifications

Add action buttons, read the user's response and open the right screen.

## Register categories

A ``NotificationCategory`` groups the action buttons of one kind of notification. Register all
categories once, at launch:

```swift
let message = NotificationCategory(
    id: "message",
    actions: [
        .textInput(id: "reply", title: "Reply", buttonTitle: "Send", placeholder: "Message"),
        .button(id: "mark-read", title: "Mark as Read", systemImageName: "checkmark"),
        .button(id: "mute", title: "Mute Thread", options: .destructive),
    ]
)
await scheduler.register([message])
```

A local notification uses it through ``LocalNotification/categoryID``; a push through the
`category` key of ``APS``.

## Receive events

``NotificationEventHandler`` is the delegate of `UNUserNotificationCenter`. Install it while the
app launches: a tap that launches the app is delivered to whichever delegate is set when launch
finishes. The system holds its delegate weakly, so keep the handler alive for the whole run of
the app.

The handler reports two streams of values:

- ``NotificationEventHandler/responses``: taps, dismissals (for categories with
  ``NotificationCategory/Options/customDismissAction``) and action buttons, as
  ``NotificationResponse`` values;
- ``NotificationEventHandler/presentations``: notifications that arrived while the app was in
  the foreground.

Both streams keep only the newest ``NotificationEventHandler/bufferSize`` unread events, so a
stream nobody reads does not grow without bound.

```swift
for await response in events.responses {
    switch response.action {
    case .custom("reply"):
        send(response.textInput ?? "", to: response.notification.threadID)
    case .custom("mark-read"):
        markRead(response.notification.id)
    case .open, .dismiss, .custom:
        break
    }
}
```

Custom data arrives as ``ReceivedNotification/userInfo``, a `[String: JSONValue]` that can
cross actor boundaries. Values that JSON cannot represent are left out instead of failing the
whole conversion.

## Open the right screen

Put a URL in the notification (``LocalNotification/deepLink``, or the `deeplink` key of a push
payload) and route it with ``DeepLinkRouter``:

```swift
enum Screen: Hashable, Sendable { case order(String), inbox }

var router = DeepLinkRouter<Screen>(schemes: ["myapp", "https"], hosts: ["example.com"])
try router.register("orders/:id") { .order($0.parameters["id"]!) }
try router.register("inbox") { _ in .inbox }

if let screen = router.destination(for: response) { path.append(screen) }
```

For custom schemes the host is the first path segment, so `myapp://orders/42` matches
`orders/:id`. For `http` and `https` the host must be one of `hosts`.

A deep link in a push comes from a server and, if the server is compromised or a payload is
forged, from someone else. The router therefore rejects links with other schemes, other hosts,
user names or passwords, more than ``DeepLinkRouter/maximumSegmentCount`` segments or more than
``DeepLinkRouter/maximumLinkLength`` characters, and parameters that decode to `/`, `\`, `.`,
`..` or control characters. Treat the parameters as untrusted input in your own code too.
