import Foundation

/// A rule of APNs that a payload breaks.
public enum PushPayloadError: Error, Hashable, Sendable {
    /// The encoded payload is larger than APNs accepts for the push type.
    case tooLarge(size: Int, limit: Int)
    /// A custom key is `aps`, which belongs to the system.
    case reservedKey(String)
    /// An alert push has no alert, sound or badge, so the user would see nothing.
    case nothingToShow
    /// A background push must set `content-available` and must not show anything.
    case invalidBackgroundPush
    /// The badge is negative.
    case negativeBadge(Int)
    /// A relevance score or critical-alert volume is not finite or out of range.
    case invalidNumber(String)
    /// A date cannot be represented in whole seconds since 1970.
    case invalidDate(String)
    /// A Live Activity push lacks a field its event needs.
    case missingLiveActivityField(String)
    /// The custom data nests too deeply, holds too many values or has a number that is not finite.
    case invalidCustomData
}

extension PushPayloadError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .tooLarge(size, limit): "The payload is \(size) bytes; APNs accepts at most \(limit)."
        case .reservedKey(let key): "The custom key \"\(key)\" is reserved."
        case .nothingToShow: "An alert push needs an alert, a sound or a badge."
        case .invalidBackgroundPush: "A background push needs content-available and no alert, sound or badge."
        case .negativeBadge(let badge): "The badge \(badge) is negative."
        case .invalidNumber(let field): "\(field) is not a valid number."
        case .invalidDate(let field): "\(field) is not a valid date."
        case .missingLiveActivityField(let field): "The Live Activity push needs \(field)."
        case .invalidCustomData: "The custom data is too large, too deeply nested or has a number that is not finite."
        }
    }
}

extension PushPayload {
    /// Checks the payload against APNs' rules for `pushType` (the size is checked by
    /// ``encoded(for:)``, which needs the encoded form).
    public func validate(for pushType: PushType) throws(PushPayloadError) {
        if custom["aps"] != nil { throw .reservedKey("aps") }
        guard JSONValue.object(custom).isWithinLimits(.default) else { throw .invalidCustomData }
        if let badge = aps.badge, badge < 0 { throw .negativeBadge(badge) }
        if let volume = aps.sound?.criticalVolume, !(volume.isFinite && (0...1).contains(volume)) {
            throw .invalidNumber("volume")
        }
        try validateDates()
        switch pushType {
        case .alert:
            if aps.alert == nil, aps.sound == nil, aps.badge == nil { throw .nothingToShow }
            try validateRelevance(range: 0...1)
        case .background:
            guard aps.contentAvailable, aps.alert == nil, aps.sound == nil, aps.badge == nil else {
                throw .invalidBackgroundPush
            }
        case .liveActivity:
            try validateLiveActivity()
        default:
            try validateRelevance(range: 0...1)
        }
    }

    private func validateRelevance(range: ClosedRange<Double>) throws(PushPayloadError) {
        guard let score = aps.relevanceScore else { return }
        guard score.isFinite, range.contains(score) else { throw .invalidNumber("relevance-score") }
    }

    private func validateDates() throws(PushPayloadError) {
        let dates: [(String, Date?)] = [
            ("timestamp", aps.timestamp), ("stale-date", aps.staleDate), ("dismissal-date", aps.dismissalDate)
        ]
        for (name, date) in dates {
            if let date, EpochSeconds.seconds(for: date) == nil { throw .invalidDate(name) }
        }
    }

    private func validateLiveActivity() throws(PushPayloadError) {
        guard let event = aps.event else { throw .missingLiveActivityField("event") }
        guard aps.timestamp != nil else { throw .missingLiveActivityField("timestamp") }
        if let score = aps.relevanceScore, !score.isFinite { throw .invalidNumber("relevance-score") }
        for value in [aps.contentState, aps.attributes].compactMap({ $0 }) where !value.isWithinLimits(.default) {
            throw .invalidCustomData
        }
        if event != .end, aps.contentState == nil { throw .missingLiveActivityField("content-state") }
        if event == .start {
            guard aps.attributesType != nil else { throw .missingLiveActivityField("attributes-type") }
            guard aps.attributes != nil else { throw .missingLiveActivityField("attributes") }
            guard aps.alert != nil else { throw .missingLiveActivityField("alert") }
        }
    }
}
