import Foundation
import NotificationKit

/// The `reason` APNs gives for rejecting a push.
public struct APNsErrorReason: RawRepresentable, Sendable, Hashable, CustomStringConvertible {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let badCollapseID = APNsErrorReason(rawValue: "BadCollapseId")
    public static let badDeviceToken = APNsErrorReason(rawValue: "BadDeviceToken")
    public static let badExpirationDate = APNsErrorReason(rawValue: "BadExpirationDate")
    public static let badMessageID = APNsErrorReason(rawValue: "BadMessageId")
    public static let badPriority = APNsErrorReason(rawValue: "BadPriority")
    public static let badTopic = APNsErrorReason(rawValue: "BadTopic")
    public static let deviceTokenNotForTopic = APNsErrorReason(rawValue: "DeviceTokenNotForTopic")
    public static let duplicateHeaders = APNsErrorReason(rawValue: "DuplicateHeaders")
    public static let idleTimeout = APNsErrorReason(rawValue: "IdleTimeout")
    public static let invalidPushType = APNsErrorReason(rawValue: "InvalidPushType")
    public static let missingDeviceToken = APNsErrorReason(rawValue: "MissingDeviceToken")
    public static let missingTopic = APNsErrorReason(rawValue: "MissingTopic")
    public static let payloadEmpty = APNsErrorReason(rawValue: "PayloadEmpty")
    public static let topicDisallowed = APNsErrorReason(rawValue: "TopicDisallowed")
    public static let badCertificate = APNsErrorReason(rawValue: "BadCertificate")
    public static let badCertificateEnvironment = APNsErrorReason(rawValue: "BadCertificateEnvironment")
    public static let expiredProviderToken = APNsErrorReason(rawValue: "ExpiredProviderToken")
    public static let forbidden = APNsErrorReason(rawValue: "Forbidden")
    public static let invalidProviderToken = APNsErrorReason(rawValue: "InvalidProviderToken")
    public static let missingProviderToken = APNsErrorReason(rawValue: "MissingProviderToken")
    public static let unrelatedKeyIDInToken = APNsErrorReason(rawValue: "UnrelatedKeyIdInToken")
    public static let badPath = APNsErrorReason(rawValue: "BadPath")
    public static let methodNotAllowed = APNsErrorReason(rawValue: "MethodNotAllowed")
    public static let expiredToken = APNsErrorReason(rawValue: "ExpiredToken")
    public static let unregistered = APNsErrorReason(rawValue: "Unregistered")
    public static let payloadTooLarge = APNsErrorReason(rawValue: "PayloadTooLarge")
    public static let tooManyProviderTokenUpdates = APNsErrorReason(rawValue: "TooManyProviderTokenUpdates")
    public static let tooManyRequests = APNsErrorReason(rawValue: "TooManyRequests")
    public static let internalServerError = APNsErrorReason(rawValue: "InternalServerError")
    public static let serviceUnavailable = APNsErrorReason(rawValue: "ServiceUnavailable")
    public static let shutdown = APNsErrorReason(rawValue: "Shutdown")

    public var description: String { rawValue }
}

/// APNs rejected a push.
public struct APNsError: Error, Sendable, Hashable {
    /// The HTTP status: 400 bad request, 403 authentication, 404 bad path, 410 token no longer
    /// active, 413 payload too large, 429 too many requests, 500 or 503 server trouble.
    public let statusCode: Int
    /// The reason APNs gave, or `nil` if the answer had none.
    public let reason: APNsErrorReason?
    /// For 410 answers: when APNs learned that the token stopped being valid.
    public let timestamp: Date?
    /// The `apns-id` of the rejected push.
    public let apnsID: UUID?

    /// The token will never work again (the app was uninstalled, or the token belongs to another
    /// app or environment). Delete it from your database.
    public var isTokenInvalid: Bool {
        statusCode == 410 || [.badDeviceToken, .deviceTokenNotForTopic, .expiredToken, .unregistered].contains(reason)
    }

    /// Sending the same push again later can succeed.
    public var isRetryable: Bool {
        statusCode == 429 || statusCode >= 500 || [.tooManyRequests, .idleTimeout, .internalServerError, .serviceUnavailable, .shutdown].contains(reason)
    }
}

extension APNsError: LocalizedError {
    public var errorDescription: String? {
        "APNs rejected the push with status \(statusCode)" + (reason.map { ": \($0.rawValue)" } ?? "")
    }
}

extension APNsError {
    private struct Body: Decodable {
        let reason: String?
        let timestamp: Double?
    }

    /// Error answers are a few dozen bytes; larger bodies are not parsed.
    static let maximumBodySize = 64 * 1024

    init(statusCode: Int, body: Data, apnsID: UUID?) {
        let decoded = body.count <= Self.maximumBodySize ? try? JSONDecoder().decode(Body.self, from: body) : nil
        let reason = decoded?.reason.flatMap { $0.isEmpty || $0.count > 128 ? nil : APNsErrorReason(rawValue: $0) }
        var timestamp: Date?
        if let milliseconds = decoded?.timestamp, milliseconds.isFinite, milliseconds >= 0, milliseconds < 1e15 {
            timestamp = Date(timeIntervalSince1970: milliseconds / 1000)
        }
        self.init(statusCode: statusCode, reason: reason, timestamp: timestamp, apnsID: apnsID)
    }
}
