import Foundation
import Testing
@testable import NotificationKit

@Suite("Device token")
struct DeviceTokenTests {
    let hex = "3f2a00ff9a8b7c6d5e4f30211203f4e5d6c7b8a9900112233445566778891bc0"

    @Test("parses hex in either case and prints lowercase")
    func hexRoundTrip() throws {
        let token = try DeviceToken(hexString: hex.uppercased())
        #expect(token.hexString == hex)
        #expect(token.data.count == 32)
        #expect(try DeviceToken(data: token.data) == token)
    }

    @Test("rejects malformed tokens", arguments: ["", "abc", "zz", "0g", "12 34", "+1", String(repeating: "ab", count: 256)])
    func rejectsMalformedHex(_ text: String) {
        #expect(throws: DeviceToken.FormatError.self) { try DeviceToken(hexString: text) }
    }

    @Test("rejects empty and overlong data")
    func rejectsBadLengths() {
        #expect(throws: DeviceToken.FormatError.invalidLength(0)) { try DeviceToken(data: Data()) }
        #expect(throws: DeviceToken.FormatError.invalidLength(256)) { try DeviceToken(data: Data(count: 256)) }
    }

    @Test("never shows the full token in text meant for logs")
    func redaction() throws {
        let token = try DeviceToken(hexString: hex)
        var dumped = ""
        dump(token, to: &dumped)
        let texts = [
            token.description, token.debugDescription, "\(token)", String(describing: token),
            String(reflecting: token), dumped, String(describing: Mirror(reflecting: token).children.map(\.value)),
            String(describing: [token]), String(describing: Optional(token))
        ]
        for text in texts {
            #expect(!text.contains(hex), "full token in: \(text)")
            #expect(!text.contains(String(hex.dropFirst(4).dropLast(4))), "middle of token in: \(text)")
        }
        #expect(token.description == "DeviceToken(3f2a…1bc0, 32 bytes)")
        #expect(try DeviceToken(hexString: "abcd").redacted == "••••")
    }

    @Test("encodes the full token for the server")
    func codable() throws {
        let token = try DeviceToken(hexString: hex)
        let data = try JSONEncoder().encode(["token": token])
        #expect(String(decoding: data, as: UTF8.self) == #"{"token":"\#(hex)"}"#)
        #expect(try JSONDecoder().decode([String: DeviceToken].self, from: data)["token"] == token)
        #expect(throws: (any Error).self) { try JSONDecoder().decode([String: DeviceToken].self, from: Data(#"{"token":"xyz"}"#.utf8)) }
    }
}

@Suite("Push payload")
struct PushPayloadTests {
    @Test("encodes Apple's key names")
    func encoding() throws {
        var payload = PushPayload.alert(title: "Shipped", body: "On its way", badge: 2, category: "order", threadID: "orders")
        payload.aps.mutableContent = true
        payload.aps.interruptionLevel = .timeSensitive
        payload.aps.relevanceScore = 0.5
        payload.deepLink = URL(string: "myapp://orders/1")
        let json = String(decoding: try payload.encoded(for: .alert), as: UTF8.self)
        #expect(json == #"{"aps":{"alert":{"body":"On its way","title":"Shipped"},"badge":2,"category":"order","interruption-level":"time-sensitive","mutable-content":1,"relevance-score":0.5,"sound":"default","thread-id":"orders"},"deeplink":"myapp://orders/1"}"#)
    }

    @Test("encodes critical sounds as a dictionary and reads them back")
    func criticalSound() throws {
        var payload = PushPayload.alert(body: "Smoke detected", sound: .critical(name: "alarm.caf", volume: 0.8))
        let data = try payload.encoded(for: .alert)
        #expect(String(decoding: data, as: UTF8.self).contains(#""sound":{"critical":1,"name":"alarm.caf","volume":0.8}"#))
        #expect(try PushPayload(json: data).aps.sound == .critical(name: "alarm.caf", volume: 0.8))
        payload.aps.sound = .defaultCritical(volume: 1)
        #expect(try PushPayload(json: payload.encoded(for: .alert)).aps.sound == .defaultCritical(volume: 1))
    }

    @Test("reads a payload as the device receives it")
    func decodingUserInfo() throws {
        let userInfo: [AnyHashable: Any] = [
            "aps": ["alert": "Plain body", "badge": 1, "content-available": true, "sound": "chime.caf"],
            "deeplink": "myapp://inbox", "count": 3
        ]
        let payload = try PushPayload(userInfo: userInfo)
        #expect(payload.aps.alert?.body == "Plain body")
        #expect(payload.aps.contentAvailable)
        #expect(payload.aps.sound == .named("chime.caf"))
        #expect(payload.deepLink == URL(string: "myapp://inbox"))
        #expect(payload.custom["count"] == 3)
    }

    @Test("round-trips every field")
    func roundTrip() throws {
        let payload = PushPayload(aps: APS(
            alert: APS.Alert(title: "T", subtitle: "S", body: "B", launchImage: "L", titleLocKey: "tk", titleLocArgs: ["a"],
                             subtitleLocKey: "sk", subtitleLocArgs: ["b"], locKey: "k", locArgs: ["c"]),
            badge: 0, sound: .default, threadID: "t", category: "c", mutableContent: true, targetContentID: "x",
            interruptionLevel: .passive, relevanceScore: 1, filterCriteria: "work"
        ), custom: ["nested": ["a": [1, 2]]])
        #expect(try PushPayload(json: payload.encoded(for: .alert)) == payload)
    }

    @Test("enforces the size limit per push type")
    func sizeLimit() throws {
        let body = String(repeating: "x", count: 4_100)
        #expect(throws: PushPayloadError.self) { try PushPayload.alert(body: body).encoded(for: .alert) }
        _ = try PushPayload.alert(body: body).encoded(for: .voip)
        let exactlyAtLimit = try PushPayload.alert(body: String(repeating: "y", count: 4_096 - 50), sound: nil).encoded(for: .alert)
        #expect(exactlyAtLimit.count <= 4_096)
    }

    @Test("checks the rules of each push type")
    func rules() throws {
        #expect(throws: PushPayloadError.nothingToShow) { try PushPayload().validate(for: .alert) }
        #expect(throws: PushPayloadError.invalidBackgroundPush) { try PushPayload.alert(body: "x").validate(for: .background) }
        #expect(throws: PushPayloadError.invalidBackgroundPush) { try PushPayload().validate(for: .background) }
        try PushPayload.background(custom: ["sync": true]).validate(for: .background)
        #expect(throws: PushPayloadError.reservedKey("aps")) { try PushPayload.alert(body: "x").with(custom: ["aps": 1]).validate(for: .alert) }
        #expect(throws: PushPayloadError.negativeBadge(-2)) { try PushPayload(aps: APS(badge: -2)).validate(for: .alert) }
        for score in [Double.nan, 2, -1] {
            #expect(throws: PushPayloadError.invalidNumber("relevance-score")) {
                try PushPayload(aps: APS(alert: .init(body: "x"), relevanceScore: score)).validate(for: .alert)
            }
        }
        #expect(throws: PushPayloadError.invalidNumber("volume")) {
            try PushPayload.alert(body: "x", sound: .defaultCritical(volume: .infinity)).validate(for: .alert)
        }
        #expect(throws: PushPayloadError.invalidCustomData) {
            try PushPayload.alert(body: "x").with(custom: ["n": .number(.nan)]).validate(for: .alert)
        }
    }

    @Test("checks Live Activity fields for each event")
    func liveActivity() throws {
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        var update = PushPayload(aps: APS(timestamp: now, event: .update, contentState: ["eta": 5]))
        try update.validate(for: .liveActivity)
        update.aps.relevanceScore = 50 // any finite number is fine for Live Activities
        try update.validate(for: .liveActivity)

        #expect(throws: PushPayloadError.missingLiveActivityField("timestamp")) {
            try PushPayload(aps: APS(event: .update, contentState: [:])).validate(for: .liveActivity)
        }
        #expect(throws: PushPayloadError.missingLiveActivityField("content-state")) {
            try PushPayload(aps: APS(timestamp: now, event: .update)).validate(for: .liveActivity)
        }
        try PushPayload(aps: APS(timestamp: now, event: .end, dismissalDate: now)).validate(for: .liveActivity)
        #expect(throws: PushPayloadError.missingLiveActivityField("attributes-type")) {
            try PushPayload(aps: APS(timestamp: now, event: .start, contentState: [:])).validate(for: .liveActivity)
        }
        let start = PushPayload(aps: APS(alert: .init(title: "Delivery", body: "Started"), timestamp: now, event: .start,
                                         contentState: ["eta": 30], attributesType: "DeliveryAttributes", attributes: ["order": "A-1"]))
        let json = String(decoding: try start.encoded(for: .liveActivity), as: UTF8.self)
        #expect(json.contains(#""timestamp":1800000000"#))
        #expect(json.contains(#""attributes-type":"DeliveryAttributes""#))
    }

    @Test("turns dates that cannot be sent into errors instead of crashing", arguments: [
        Date(timeIntervalSince1970: .nan), Date(timeIntervalSince1970: .infinity), Date(timeIntervalSince1970: -1), .distantFuture
    ])
    func unrepresentableDates(_ date: Date) {
        let payload = PushPayload(aps: APS(timestamp: date, event: .end))
        #expect(throws: PushPayloadError.invalidDate("timestamp")) { try payload.validate(for: .liveActivity) }
        #expect(throws: EncodingError.self) { try JSONEncoder().encode(payload) }
    }

    @Test("rejects incoming dates that are out of range and deeply nested JSON")
    func hostileInput() {
        let date = Data(#"{"aps":{"timestamp":1e300}}"#.utf8)
        #expect(throws: DecodingError.self) { try PushPayload(json: date) }
        let deep = Data((String(repeating: "[", count: 100_000) + String(repeating: "]", count: 100_000)).utf8)
        #expect(throws: (any Error).self) { try PushPayload(json: deep) }
    }
}

extension PushPayload {
    func with(custom: [String: JSONValue]) -> PushPayload {
        var copy = self
        copy.custom.merge(custom) { _, new in new }
        return copy
    }
}
