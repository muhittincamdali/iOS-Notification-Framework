# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-15

A rebuild of the package around a testable notification center. The 1.x API (`NotificationKit`
singleton, `Notification` builder) is gone; see "Removed" for what replaces it.

### Added

- `NotificationScheduler`, an actor that schedules past iOS's 64 pending notifications: it hands
  the system the soonest ones, keeps the rest in a queue saved by a `NotificationStore`
  (`FileNotificationStore` in Application Support, or `InMemoryNotificationStore`) and moves
  queued notifications up on `refresh()`. Calls run one at a time. `RefreshReport` lists what
  was delivered, promoted, demoted or expired.
- `SchedulingPolicy` with `QuietHours` (windows over midnight, weekdays, exceptions for
  time-sensitive and critical notifications) and `FrequencyCap` (at most N one-time
  notifications in any interval, counting recent deliveries). Both apply to the fire date.
- `LocalNotification`, `NotificationTrigger` (interval, date, calendar, daily, weekly, monthly,
  region), `NotificationSound`, `InterruptionLevel`, `NotificationAttachment` and `JSONValue`
  user info, all `Sendable`, `Hashable` and `Codable`.
- Validation before the system sees a value (`NotificationValidationError`): repeating intervals
  under 60 seconds and non-positive or NaN intervals (which raise an Objective-C exception in
  `UNTimeIntervalNotificationTrigger`), out-of-range date components, past one-time dates,
  relevance scores and volumes outside 0...1, invalid regions, deep or non-finite user info.
- `NotificationCenterClient` with `UserNotificationCenterClient` and `InMemoryNotificationCenter`,
  a test double that keeps the 64 soonest pending notifications like the system.
- `NotificationCategory` and `NotificationAction` (buttons, text input, SF Symbol icons).
- `NotificationEventHandler`: the `UNUserNotificationCenter` delegate as two bounded
  `AsyncStream`s, `responses` and `presentations`, of `NotificationResponse` and
  `ReceivedNotification` values.
- `DeepLinkRouter` with `:parameter` and `*` patterns, scheme and host allowlists and limits on
  link length and segments.
- `PushPayload` and `APS` with Apple's key names, critical sounds, Live Activity fields, per
  `PushType` validation and size limits; `DeviceToken` with hex parsing and redacted text forms.
- `MediaAttachmentService` and `AttachmentDownloader` for Notification Service Extensions.
- `NotificationKitAPNs`: `APNsClient` (HTTP/2 through `URLSession`, ES256 provider tokens from
  CryptoKit, reused for 50 minutes, one retry on `ExpiredProviderToken`), `APNsRequest` with
  topic suffixes per push type, `APNsSigningKey`, `APNsError` with `isTokenInvalid` and
  `isRetryable`.
- watchOS 10 and visionOS 1 support next to iOS 17 and macOS 14.
- Example app `Examples/NotificationLab` with a Notification Service Extension and UI tests that
  tap real banners and open an order from a simulator push; `Examples/PushSender` (`nk-push`).
- DocC catalogs for both modules with six articles, published to GitHub Pages.
- `scripts/capture-screenshots.sh`, which produces the README screenshots from the UI tests.
- 109 Swift Testing tests, run on macOS and an iPhone simulator.

### Changed

- Swift tools version 6.2 and the Swift 6 language mode; minimum iOS 17 and macOS 14.
- CI, documentation, link and wording checks run through the shared workflows of
  `muhittincamdali/.github`.

### Removed

- The `NotificationKit` singleton, `Notification` builder and `NotificationKitDelegate`. Use
  `NotificationScheduler`, `LocalNotification` and `NotificationEventHandler`.
- `RateLimiter` and `QuietHoursManager`, which checked the time of scheduling instead of
  delivery and never rescheduled deferred notifications. Use `FrequencyCap` and `QuietHours`.
- Analytics, A/B testing, channels, user preferences, the predictive push engine and the
  Live Activity manager, which stored data the app could not act on or returned fixed values.
- The CocoaPods spec, which was never published to trunk.

### Security

- The device token is no longer written in full to the analytics log; `DeviceToken` redacts it
  in every text form meant for logs.
- Push payloads, deep links, downloaded media and the saved queue are bounded in size, nesting
  and length, and dates are range-checked before conversion to whole seconds.

## [1.0.0] - 2026-02-02

### Added

- Local notification scheduling with a builder, time interval and calendar triggers.
- Interactive categories and actions, interruption levels, thread identifiers and badges.

[Unreleased]: https://github.com/muhittincamdali/iOS-Notification-Framework/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/muhittincamdali/iOS-Notification-Framework/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/muhittincamdali/iOS-Notification-Framework/releases/tag/v1.0.0
