import Foundation

/// The sound a notification plays.
public enum NotificationSound: Sendable, Hashable, Codable {
    /// The system's default notification sound.
    case `default`
    /// A sound file in the app bundle or in `Library/Sounds`, at most 30 seconds long.
    /// watchOS plays the default sound instead.
    case named(String)
    /// The default critical-alert sound, played even when the device is muted.
    ///
    /// Critical alerts need the `com.apple.developer.usernotifications.critical-alerts`
    /// entitlement, which Apple grants on request.
    case defaultCritical(volume: Double)
    /// A sound file played as a critical alert.
    case critical(name: String, volume: Double)

    /// The critical-alert volume, if this is a critical sound.
    public var criticalVolume: Double? {
        switch self {
        case .default, .named: nil
        case .defaultCritical(let volume), .critical(_, let volume): volume
        }
    }

    /// Checks the volume of critical sounds, which must be a finite value from 0 to 1.
    public func validate() throws(NotificationValidationError) {
        if case .named(let name) = self, name.isEmpty {
            throw .emptySoundName
        }
        if case .critical(let name, _) = self, name.isEmpty {
            throw .emptySoundName
        }
        if let volume = criticalVolume, !(volume.isFinite && (0...1).contains(volume)) {
            throw .invalidVolume(volume)
        }
    }
}

/// How urgently the system presents a notification (iOS 15 and later).
public enum InterruptionLevel: String, Sendable, Hashable, Codable, CaseIterable {
    /// Added to the notification list without lighting up the screen or playing a sound.
    case passive
    /// Presented immediately, lights up the screen and can play a sound. The default.
    case active
    /// Presented immediately and breaks through Focus. Needs the Time Sensitive Notifications
    /// capability.
    case timeSensitive = "time-sensitive"
    /// Presented immediately, breaks through Focus and the mute switch. Needs the
    /// critical-alerts entitlement.
    case critical
}
