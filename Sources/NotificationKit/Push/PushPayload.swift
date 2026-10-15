import Foundation

/// The kind of push, sent to APNs in the `apns-push-type` header.
public enum PushType: String, Sendable, Hashable, Codable, CaseIterable {
    case alert
    case background
    case liveActivity = "liveactivity"
    case voip
    case complication
    case fileProvider = "fileprovider"
    case mdm
    case location
    case pushToTalk = "pushtotalk"
    case widgets

    /// The largest payload APNs accepts for this type, in bytes.
    public var maximumPayloadSize: Int {
        self == .voip ? 5_120 : 4_096
    }
}

/// A remote notification payload: the `aps` dictionary plus your own keys.
///
/// The same type builds payloads on a server (with `NotificationKitAPNs`) and reads them on the
/// device, so both sides agree on the format:
///
/// ```swift
/// // Server
/// var payload = PushPayload.alert(title: "Order shipped", body: "A-1042 is on its way.")
/// payload.custom["deeplink"] = "myapp://orders/A-1042"
/// let body = try payload.encoded(for: .alert)
///
/// // Device
/// let payload = try PushPayload(userInfo: response.notification.request.content.userInfo)
/// ```
public struct PushPayload: Sendable, Hashable {
    public var aps: APS
    /// Keys next to `aps`. The key `aps` itself is rejected by ``validate(for:)``.
    public var custom: [String: JSONValue]

    public init(aps: APS = APS(), custom: [String: JSONValue] = [:]) {
        self.aps = aps
        self.custom = custom
    }

    /// A visible notification.
    public static func alert(
        title: String? = nil,
        subtitle: String? = nil,
        body: String,
        sound: NotificationSound? = .default,
        badge: Int? = nil,
        category: String? = nil,
        threadID: String? = nil
    ) -> PushPayload {
        PushPayload(aps: APS(
            alert: APS.Alert(title: title, subtitle: subtitle, body: body),
            badge: badge,
            sound: sound,
            threadID: threadID,
            category: category
        ))
    }

    /// A silent push that wakes the app in the background. Send it with ``PushType/background``
    /// and priority 5.
    public static func background(custom: [String: JSONValue] = [:]) -> PushPayload {
        PushPayload(aps: APS(contentAvailable: true), custom: custom)
    }

    /// The deep link under ``LocalNotification/deepLinkKey``, if any.
    public var deepLink: URL? {
        get { custom[LocalNotification.deepLinkKey]?.stringValue.flatMap(URL.init(string:)) }
        set { custom[LocalNotification.deepLinkKey] = newValue.map { .string($0.absoluteString) } }
    }

    /// Reads a payload that arrived on the device.
    public init(userInfo: [AnyHashable: Any]) throws {
        let value = try JSONValue(userInfo: userInfo)
        try self.init(json: JSONEncoder().encode(value))
    }

    /// Reads a payload from JSON, such as a request body or an `.apns` file.
    public init(json data: Data) throws {
        self = try JSONDecoder().decode(PushPayload.self, from: data)
    }

    /// Validates the payload for `pushType` and encodes it as compact JSON with sorted keys.
    ///
    /// - Throws: ``PushPayloadError`` when the payload breaks one of APNs' rules, including
    ///   its size limit.
    public func encoded(for pushType: PushType) throws -> Data {
        try validate(for: pushType)
        let data = try Self.encoder.encode(self)
        guard data.count <= pushType.maximumPayloadSize else {
            throw PushPayloadError.tooLarge(size: data.count, limit: pushType.maximumPayloadSize)
        }
        return data
    }

    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        return encoder
    }
}

extension PushPayload: Codable {
    private struct Key: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }
        init(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { nil }
        static let aps = Key(stringValue: "aps")
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        aps = try container.decodeIfPresent(APS.self, forKey: .aps) ?? APS()
        custom = [:]
        for key in container.allKeys where key.stringValue != Key.aps.stringValue {
            custom[key.stringValue] = try container.decode(JSONValue.self, forKey: key)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(aps, forKey: .aps)
        for (key, value) in custom where key != Key.aps.stringValue {
            try container.encode(value, forKey: Key(stringValue: key))
        }
    }
}
