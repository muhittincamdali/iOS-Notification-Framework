# Examples

## NotificationLab

An iOS app that uses NotificationKit from this checkout (a local package reference to `../..`):

- asks for permission and shows the current status;
- schedules a reminder with three actions (mark as done, snooze, add a note) and a deep link;
- schedules 70 reminders at once, so you can see 64 handed to iOS and the rest queued;
- turns on quiet hours for the next hour, so you can see a reminder moved to their end;
- lists what arrived: notifications shown in the foreground, taps, actions and typed notes;
- opens the reminder or order a notification links to, through `DeepLinkRouter`;
- registers for pushes and shows the device token, redacted (a simulator build without the
  Push Notifications capability shows the registration error instead);
- includes a Notification Service Extension (`NotificationLabService`) built on
  `MediaAttachmentService`.

Run it:

1. Open `Examples/NotificationLab/NotificationLab.xcodeproj` in Xcode 26 or later.
2. Choose the **NotificationLab** scheme and an iPhone simulator.
3. Press **Run** (⌘R).

Send it a push on the simulator (the app's URL scheme is `notificationlab`):

```sh
cd Examples/PushSender
swift run nk-push payload --title "Order shipped" --body "A-1042 is on its way." \
  --deeplink notificationlab://orders/A-1042 \
  --bundle-id io.github.muhittincamdali.NotificationLab --output order.apns
xcrun simctl push booted order.apns
```

The UI tests in `NotificationLabUITests` run the same flows on a simulator: they allow
notifications, tap a reminder banner, fill the queue past 64 and, when run by
[`scripts/capture-screenshots.sh`](../scripts/capture-screenshots.sh), open an order from a push.

```sh
cd Examples/NotificationLab
xcodebuild test -scheme NotificationLab -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

The README samples live in
[`NotificationLab/ReadmeSamples.swift`](NotificationLab/NotificationLab/ReadmeSamples.swift). The
README copies its code from that file, and the package's test target compiles it through the
symlink `Tests/NotificationKitTests/ReadmeExamples.swift`.

The project file is made with [XcodeGen](https://github.com/yonaskolb/XcodeGen) from
[`project.yml`](NotificationLab/project.yml) and committed, so you only need XcodeGen after
editing `project.yml`.

## PushSender

`nk-push`, a command-line tool built on `NotificationKitAPNs`. It writes payload files for
`xcrun simctl push` and sends pushes to devices through APNs:

```sh
cd Examples/PushSender
swift run nk-push send --key AuthKey_ABC123DEFG.p8 --key-id ABC123DEFG --team-id DEF123GHIJ \
  --topic com.example.MyApp --token <hex token> --sandbox \
  --title "Hello" --body "Sent with NotificationKitAPNs"
```

`--sandbox` sends to the development server, which builds run from Xcode register with. Leave
it out for TestFlight and App Store builds.
