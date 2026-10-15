import Foundation

/// A reason a notification, trigger or payload was rejected before it reached the system.
///
/// `UNUserNotificationCenter` raises an Objective-C exception (which ends the app) for some
/// invalid values, such as a repeating time interval shorter than 60 seconds, and silently drops
/// others. NotificationKit checks those values first and throws one of these errors instead.
public enum NotificationValidationError: Error, Hashable, Sendable {
    /// The identifier is empty or longer than ``LocalNotification/maximumIdentifierLength``.
    case invalidIdentifier
    /// The title, subtitle and body are all empty, so the system would show nothing.
    case emptyContent
    /// The badge is negative.
    case negativeBadge(Int)
    /// A sound name is empty.
    case emptySoundName
    /// A critical-alert volume is outside 0...1 or not finite.
    case invalidVolume(Double)
    /// The relevance score is outside 0...1 or not finite.
    case invalidRelevanceScore(Double)
    /// A time interval is not finite or not greater than zero.
    case invalidTimeInterval(TimeInterval)
    /// A repeating time interval is shorter than the 60 seconds the system accepts.
    case repeatingIntervalTooShort(TimeInterval)
    /// The date components cannot produce a date (for example hour 25).
    case invalidDateComponents
    /// A date is not finite or too far from the present to be represented.
    case invalidDate
    /// A one-time trigger has no fire date after now, so the system would never deliver it.
    case fireDateInPast
    /// A location region has an invalid coordinate or radius, or notifies on neither entry nor exit.
    case invalidRegion
    /// The trigger is not available on this platform (location triggers on macOS and visionOS).
    case unsupportedTrigger
    /// The custom data nests too deeply, holds too many values or contains a number that is
    /// not finite.
    case invalidUserInfo
    /// The custom data uses a key that NotificationKit reserves.
    case reservedUserInfoKey(String)
    /// An attachment is not a local file URL.
    case invalidAttachment(URL)
}

extension NotificationValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidIdentifier: "The notification identifier must contain 1 to \(LocalNotification.maximumIdentifierLength) characters."
        case .emptyContent: "The notification has no title, subtitle or body."
        case .negativeBadge(let badge): "The badge \(badge) is negative."
        case .emptySoundName: "The sound name is empty."
        case .invalidVolume(let volume): "The critical-alert volume \(volume) is not between 0 and 1."
        case .invalidRelevanceScore(let score): "The relevance score \(score) is not between 0 and 1."
        case .invalidTimeInterval(let interval): "The time interval \(interval) is not a positive number of seconds."
        case .repeatingIntervalTooShort(let interval): "A repeating time interval must be at least 60 seconds, not \(interval)."
        case .invalidDateComponents: "The date components do not describe a valid date or time."
        case .invalidDate: "The date cannot be represented."
        case .fireDateInPast: "The trigger does not fire again after now."
        case .invalidRegion: "The region needs a valid coordinate, a positive radius and entry or exit notifications."
        case .unsupportedTrigger: "This trigger is not available on this platform."
        case .invalidUserInfo: "The custom data is too large, too deeply nested or contains a number that is not finite."
        case .reservedUserInfoKey(let key): "The custom data key \"\(key)\" is reserved."
        case .invalidAttachment(let url): "The attachment \(url.lastPathComponent) is not a local file."
        }
    }
}
