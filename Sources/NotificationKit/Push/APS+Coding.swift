import Foundation

extension APS {
    enum CodingKeys: String, CodingKey {
        case alert, badge, sound, category, timestamp, event, attributes
        case threadID = "thread-id"
        case contentAvailable = "content-available"
        case mutableContent = "mutable-content"
        case targetContentID = "target-content-id"
        case interruptionLevel = "interruption-level"
        case relevanceScore = "relevance-score"
        case filterCriteria = "filter-criteria"
        case contentState = "content-state"
        case staleDate = "stale-date"
        case dismissalDate = "dismissal-date"
        case attributesType = "attributes-type"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            alert: try container.decodeIfPresent(Alert.self, forKey: .alert),
            badge: try container.decodeIfPresent(Int.self, forKey: .badge),
            sound: try container.decodeIfPresent(PayloadSound.self, forKey: .sound)?.sound,
            threadID: try container.decodeIfPresent(String.self, forKey: .threadID),
            category: try container.decodeIfPresent(String.self, forKey: .category),
            contentAvailable: Self.decodeFlag(container, .contentAvailable),
            mutableContent: Self.decodeFlag(container, .mutableContent),
            targetContentID: try container.decodeIfPresent(String.self, forKey: .targetContentID),
            interruptionLevel: try container.decodeIfPresent(InterruptionLevel.self, forKey: .interruptionLevel),
            relevanceScore: try container.decodeIfPresent(Double.self, forKey: .relevanceScore),
            filterCriteria: try container.decodeIfPresent(String.self, forKey: .filterCriteria),
            timestamp: try EpochSeconds.decode(container, .timestamp),
            event: try container.decodeIfPresent(LiveActivityEvent.self, forKey: .event),
            contentState: try container.decodeIfPresent(JSONValue.self, forKey: .contentState),
            staleDate: try EpochSeconds.decode(container, .staleDate),
            dismissalDate: try EpochSeconds.decode(container, .dismissalDate),
            attributesType: try container.decodeIfPresent(String.self, forKey: .attributesType),
            attributes: try container.decodeIfPresent(JSONValue.self, forKey: .attributes)
        )
    }

    /// Apple documents `1`; some servers send `true`. Both turn the flag on.
    private static func decodeFlag(_ container: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys) -> Bool {
        if let value = try? container.decodeIfPresent(Int.self, forKey: key) { return value == 1 }
        return (try? container.decodeIfPresent(Bool.self, forKey: key)) == true
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(alert, forKey: .alert)
        try container.encodeIfPresent(badge, forKey: .badge)
        try container.encodeIfPresent(sound.map(PayloadSound.init), forKey: .sound)
        try container.encodeIfPresent(threadID, forKey: .threadID)
        try container.encodeIfPresent(category, forKey: .category)
        if contentAvailable { try container.encode(1, forKey: .contentAvailable) }
        if mutableContent { try container.encode(1, forKey: .mutableContent) }
        try container.encodeIfPresent(targetContentID, forKey: .targetContentID)
        try container.encodeIfPresent(interruptionLevel, forKey: .interruptionLevel)
        try container.encodeIfPresent(relevanceScore, forKey: .relevanceScore)
        try container.encodeIfPresent(filterCriteria, forKey: .filterCriteria)
        try EpochSeconds.encode(timestamp, &container, .timestamp)
        try container.encodeIfPresent(event, forKey: .event)
        try container.encodeIfPresent(contentState, forKey: .contentState)
        try EpochSeconds.encode(staleDate, &container, .staleDate)
        try EpochSeconds.encode(dismissalDate, &container, .dismissalDate)
        try container.encodeIfPresent(attributesType, forKey: .attributesType)
        try container.encodeIfPresent(attributes, forKey: .attributes)
    }
}

/// Dates in payloads are whole seconds since 1970. Converting a `Double` to `Int` traps when the
/// value is not finite or out of range, so dates are checked against ``DateBounds`` first and
/// turned into coding errors instead.
enum EpochSeconds {
    static func seconds(for date: Date) -> Int? {
        guard DateBounds.contains(date) else { return nil }
        return Int(date.timeIntervalSince1970.rounded(.down))
    }

    static func encode<Key: CodingKey>(_ date: Date?, _ container: inout KeyedEncodingContainer<Key>, _ key: Key) throws {
        guard let date else { return }
        guard let seconds = seconds(for: date) else {
            throw EncodingError.invalidValue(date, .init(codingPath: container.codingPath + [key], debugDescription: "Date out of range"))
        }
        try container.encode(seconds, forKey: key)
    }

    static func decode<Key: CodingKey>(_ container: KeyedDecodingContainer<Key>, _ key: Key) throws -> Date? {
        guard let seconds = try container.decodeIfPresent(Double.self, forKey: key) else { return nil }
        let date = Date(timeIntervalSince1970: seconds)
        guard DateBounds.contains(date) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Date out of range")
        }
        return date
    }
}

/// The payload form of a sound: a file name, or a dictionary for critical alerts.
struct PayloadSound: Codable {
    let sound: NotificationSound

    init(_ sound: NotificationSound) {
        self.sound = sound
    }

    private enum CodingKeys: String, CodingKey {
        case critical, name, volume
    }

    private static let defaultName = "default"

    init(from decoder: any Decoder) throws {
        if let name = try? decoder.singleValueContainer().decode(String.self) {
            sound = name == Self.defaultName ? .default : .named(name)
            return
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? Self.defaultName
        guard try container.decodeIfPresent(Int.self, forKey: .critical) == 1 else {
            sound = name == Self.defaultName ? .default : .named(name)
            return
        }
        let volume = try container.decodeIfPresent(Double.self, forKey: .volume) ?? 1
        sound = name == Self.defaultName ? .defaultCritical(volume: volume) : .critical(name: name, volume: volume)
    }

    func encode(to encoder: any Encoder) throws {
        switch sound {
        case .default:
            var container = encoder.singleValueContainer()
            try container.encode(Self.defaultName)
        case .named(let name):
            var container = encoder.singleValueContainer()
            try container.encode(name)
        case .defaultCritical(let volume):
            try encodeCritical(name: Self.defaultName, volume: volume, to: encoder)
        case .critical(let name, let volume):
            try encodeCritical(name: name, volume: volume, to: encoder)
        }
    }

    private func encodeCritical(name: String, volume: Double, to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(1, forKey: .critical)
        try container.encode(name, forKey: .name)
        try container.encode(volume, forKey: .volume)
    }
}
