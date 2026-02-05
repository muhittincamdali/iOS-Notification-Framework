# Changelog

All notable changes to NotificationKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-02-05

### 🎉 Major Release - Complete Framework Overhaul

This release transforms NotificationKit into the most comprehensive notification framework for iOS, adding enterprise-grade features while maintaining simplicity.

### Added

#### Core Features
- **Global Configuration** - `NotificationKit.configure()` for app-wide settings
- **Provisional Authorization** - Quiet notification support for iOS 12+
- **Remote Push Support** - Full APNs integration with device token handling
- **Rich Attachments** - Helper methods for images, videos, GIFs, and audio
- **Advanced Triggers** - Monthly, yearly, and smart "next occurrence" triggers
- **visionOS Support** - Full support for Apple Vision Pro

#### Analytics Engine
- **Built-in Analytics** - Track scheduled, presented, interacted, and dismissed events
- **Engagement Metrics** - Open rate, delivery rate, dismiss rate calculations
- **Action Distribution** - Track which actions users tap most
- **Export Support** - Export analytics data as JSON
- **Persistent Stats** - Statistics survive app restarts

#### A/B Testing
- **Experiment Management** - Create and manage A/B tests
- **Variant Assignment** - Automatic weighted random assignment
- **Title/Body Variants** - Test different notification content
- **Integration** - Seamlessly applies variants to notifications

#### Quiet Hours
- **Configurable Windows** - Set custom quiet hour periods
- **Presets** - `.nightTime`, `.sleepTime`, `.workHoursOnly`
- **Day Filtering** - Enable only on specific days
- **Priority Override** - Time sensitive/critical can bypass
- **Deferred Queue** - Notifications queued until quiet hours end

#### Rate Limiting
- **Hourly/Daily Limits** - Prevent notification fatigue
- **Burst Protection** - Prevent rapid-fire notifications
- **Presets** - `.conservative`, `.moderate`, `.relaxed`
- **Bypass Option** - Priority notifications can bypass limits

#### Notification Channels
- **Android-style Channels** - Group notifications by type
- **Per-channel Settings** - Sound, badge, vibration per channel
- **Importance Levels** - None, low, default, high, urgent
- **Enable/Disable** - Users can control channels
- **Preset Channels** - General, promotions, social, alerts, reminders

#### Deep Linking
- **URL Handling** - Register handlers for deep link paths
- **Pattern Matching** - Wildcard and parameter support
- **Context Object** - Full access to URL, path, and query params
- **URL Building** - Helper methods to construct deep links

#### User Preferences
- **Global Toggle** - Master enable/disable
- **Frequency Control** - All, important, minimal, or critical only
- **Category Preferences** - Per-category enable/disable
- **Topic Subscriptions** - Subscribe/unsubscribe to topics
- **Blocked Senders** - Block specific senders
- **Sound/Vibration/Badge** - Individual toggles
- **Preview Mode** - Always, when unlocked, or never

#### Scheduling
- **Smart Scheduler** - Optimal time delivery
- **Batch Operations** - Schedule/cancel multiple at once
- **Recurring Notifications** - Daily, weekly, monthly, custom
- **Snooze Support** - Reschedule for later
- **Replace** - Update existing notifications
- **Conditional Scheduling** - Only if condition met

#### Delivery Optimization
- **Engagement Learning** - Tracks user interaction patterns
- **Optimal Time Prediction** - ML-powered best delivery time
- **Engagement Heatmap** - Hourly engagement scores
- **Response Time Analysis** - Track how fast users respond
- **Recommendations** - Actionable delivery insights

#### Location-Based
- **Geofence Manager** - Register location-triggered notifications
- **Entry/Exit Triggers** - Fire on enter or leave region
- **Distance Calculations** - Check distance from points
- **Preset Geofences** - Leaving home, arriving at work

#### Rich Notification Support
- **Attachment Download** - Async download from URLs
- **Image Processing** - Resize and optimize for notifications
- **Validation** - Check attachment compatibility
- **Service Extension Helper** - Base class for service extensions

### Changed
- **Minimum iOS version** raised to iOS 15.0
- **Swift version** raised to Swift 5.9
- **Notification model** now has many more builder methods
- **Trigger model** expanded with more options
- **Category model** now includes icons (iOS 15+)

### Improved
- Full Swift 6 strict concurrency compliance
- All public APIs now `@MainActor` or `Sendable`
- Comprehensive DocC documentation
- 40+ unit tests covering all features

---

## [1.0.0] - 2026-02-04

### Added
- Initial release
- Type-safe notification builder pattern
- Local notification scheduling
- Time interval and calendar triggers
- Interactive notification categories
- Basic action support
- iOS 15+ interruption levels
- Thread identifier for grouping
- Badge management

---

## Migration Guide

### From 1.x to 2.x

1. **Update minimum deployment target** to iOS 15.0
2. **Update Package.swift** to use Swift 5.9
3. **Add configuration** in app initialization:

```swift
NotificationKit.configure { config in
    config.enableAnalytics = true
}
```

4. **Update delegate methods** - new async signatures
5. **Optional**: Add channels, quiet hours, rate limiting as needed

Most existing code will continue to work unchanged.
