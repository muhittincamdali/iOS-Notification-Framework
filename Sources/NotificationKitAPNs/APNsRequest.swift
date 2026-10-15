import Foundation
import NotificationKit

/// Which APNs server to send to.
public enum APNsEnvironment: Sendable, Hashable {
    /// `api.push.apple.com`, for App Store and TestFlight builds.
    case production
    /// `api.sandbox.push.apple.com`, for builds signed for development.
    case development
    /// Another HTTPS endpoint with the same API, such as a test server.
    case custom(URL)

    public var baseURL: URL {
        switch self {
        case .production: URL(string: "https://api.push.apple.com")!
        case .development: URL(string: "https://api.sandbox.push.apple.com")!
        case .custom(let url): url
        }
    }
}

/// How urgently APNs delivers a push (`apns-priority`).
public enum APNsPriority: Int, Sendable, Hashable {
    /// Deliver immediately. Only for pushes that show an alert, play a sound or set a badge.
    case immediate = 10
    /// Deliver at a time that saves power. Required for background pushes.
    case conservePower = 5
    /// Deliver only when the device is awake anyway.
    case low = 1
}

/// How long APNs keeps trying to deliver a push to a device that is offline (`apns-expiration`).
public enum APNsExpiration: Sendable, Hashable {
    /// Try once; drop the push if the device is offline.
    case immediately
    /// Keep trying until the date.
    case at(Date)
}

/// One push to one device.
public struct APNsRequest: Sendable, Hashable {
    public var payload: PushPayload
    public var deviceToken: DeviceToken
    public var pushType: PushType
    /// Usually your app's bundle ID; see ``topic(forBundleID:pushType:)``.
    public var topic: String
    /// `nil` lets APNs pick: 10 for alerts, 5 for background pushes.
    public var priority: APNsPriority?
    /// `nil` lets APNs store the push for a period it chooses.
    public var expiration: APNsExpiration?
    /// Pushes with the same collapse ID replace each other on the device; at most 64 bytes.
    public var collapseID: String?
    /// Identifies the push in APNs' answer and in Apple's delivery logs.
    public var id: UUID

    public init(
        payload: PushPayload,
        deviceToken: DeviceToken,
        pushType: PushType = .alert,
        topic: String,
        priority: APNsPriority? = nil,
        expiration: APNsExpiration? = nil,
        collapseID: String? = nil,
        id: UUID = UUID()
    ) {
        self.payload = payload
        self.deviceToken = deviceToken
        self.pushType = pushType
        self.topic = topic
        self.priority = priority
        self.expiration = expiration
        self.collapseID = collapseID
        self.id = id
    }

    /// The topic APNs expects for `pushType`: the bundle ID with Apple's suffix where one is
    /// required (for example `.push-type.liveactivity` for Live Activities and `.voip` for VoIP).
    public static func topic(forBundleID bundleID: String, pushType: PushType) -> String {
        switch pushType {
        case .alert, .background, .mdm: bundleID
        case .liveActivity: bundleID + ".push-type.liveactivity"
        case .voip: bundleID + ".voip"
        case .complication: bundleID + ".complication"
        case .fileProvider: bundleID + ".pushkit.fileprovider"
        case .location: bundleID + ".location-query"
        case .pushToTalk: bundleID + ".voip-ptt"
        case .widgets: bundleID + ".push-type.widgets"
        }
    }
}

/// A request that APNs would reject, found before it is sent.
public enum APNsRequestError: Error, Hashable, Sendable {
    /// The topic is empty or has characters that cannot appear in a header.
    case invalidTopic
    /// The collapse ID is longer than 64 bytes or has characters that cannot appear in a header.
    case invalidCollapseID
    /// A background push must have priority 5.
    case invalidPriority
    /// The expiration date cannot be represented in whole seconds.
    case invalidExpiration
}

extension APNsRequest {
    /// The largest collapse ID APNs accepts, in bytes.
    public static let maximumCollapseIDLength = 64

    /// The HTTP request APNs expects, signed with `bearer`.
    func urlRequest(baseURL: URL, bearer: String) throws -> URLRequest {
        guard !topic.isEmpty, Self.isHeaderSafe(topic) else { throw APNsRequestError.invalidTopic }
        if let collapseID, collapseID.utf8.count > Self.maximumCollapseIDLength || !Self.isHeaderSafe(collapseID) {
            throw APNsRequestError.invalidCollapseID
        }
        if pushType == .background, let priority, priority != .conservePower { throw APNsRequestError.invalidPriority }
        let body = try payload.encoded(for: pushType)

        var request = URLRequest(url: baseURL.appending(path: "3/device/\(deviceToken.hexString)"))
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("bearer \(bearer)", forHTTPHeaderField: "authorization")
        request.setValue(pushType.rawValue, forHTTPHeaderField: "apns-push-type")
        request.setValue(topic, forHTTPHeaderField: "apns-topic")
        request.setValue(id.uuidString, forHTTPHeaderField: "apns-id")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        if let priority { request.setValue(String(priority.rawValue), forHTTPHeaderField: "apns-priority") }
        if let collapseID { request.setValue(collapseID, forHTTPHeaderField: "apns-collapse-id") }
        switch expiration {
        case nil:
            break
        case .immediately:
            request.setValue("0", forHTTPHeaderField: "apns-expiration")
        case .at(let date):
            guard let seconds = EpochTime.seconds(date) else { throw APNsRequestError.invalidExpiration }
            request.setValue(String(seconds), forHTTPHeaderField: "apns-expiration")
        }
        return request
    }

    /// Printable ASCII without line breaks, so a value cannot add a header of its own.
    static func isHeaderSafe(_ value: String) -> Bool {
        value.utf8.allSatisfy { (0x20...0x7E).contains($0) }
    }
}

/// Converts dates to whole seconds without the trap `Int(_:)` hits on values it cannot hold.
/// Dates from 1970 to the year 2400 are accepted.
enum EpochTime {
    static let latest: TimeInterval = 13_569_465_600

    static func seconds(_ date: Date) -> Int? {
        let seconds = date.timeIntervalSince1970
        guard seconds.isFinite, seconds >= 0, seconds <= latest else { return nil }
        return Int(seconds.rounded(.down))
    }
}
