import Foundation
import NotificationKit

/// Sends pushes to APNs over HTTP/2 with token-based authentication.
///
/// ```swift
/// let client = APNsClient(key: key, environment: .development)
/// let token = try DeviceToken(hexString: tokenFromDatabase)
/// var payload = PushPayload.alert(title: "Order shipped", body: "A-1042 is on its way.")
/// payload.deepLink = URL(string: "myapp://orders/A-1042")
///
/// let delivery = try await client.send(APNsRequest(
///     payload: payload, deviceToken: token, topic: "com.example.MyApp"
/// ))
/// ```
///
/// The client signs a provider token and reuses it for ``tokenLifetime`` (Apple accepts tokens
/// up to an hour old and rejects refreshes more often than every 20 minutes). If APNs still
/// answers `ExpiredProviderToken`, the client signs a new token and sends once more.
///
/// It uses `URLSession` and CryptoKit, so it runs on macOS servers, command-line tools and in
/// apps without extra dependencies.
public actor APNsClient {
    /// How long a provider token is reused: 50 minutes.
    public static let tokenLifetime: TimeInterval = 50 * 60

    private let key: APNsSigningKey
    private let environment: APNsEnvironment
    private let transport: any APNsTransport
    private let now: @Sendable () -> Date
    private var cachedToken: (value: String, issuedAt: Date)?

    public init(
        key: APNsSigningKey,
        environment: APNsEnvironment,
        transport: any APNsTransport = URLSessionAPNsTransport(),
        now: @escaping @Sendable () -> Date = Date.init
    ) {
        self.key = key
        self.environment = environment
        self.transport = transport
        self.now = now
    }

    /// Sends one push.
    ///
    /// - Returns: The identifiers APNs gave the push.
    /// - Throws: ``APNsRequestError`` or `PushPayloadError` before sending,
    ///   ``APNsError`` when APNs rejects the push, or a transport error.
    @discardableResult
    public func send(_ request: APNsRequest) async throws -> APNsDelivery {
        do {
            return try await perform(request)
        } catch let error as APNsError where error.reason == .expiredProviderToken {
            cachedToken = nil
            return try await perform(request)
        }
    }

    private func perform(_ request: APNsRequest) async throws -> APNsDelivery {
        let urlRequest = try request.urlRequest(baseURL: environment.baseURL, bearer: try providerToken())
        let (body, response) = try await transport.send(urlRequest)
        let apnsID = response.value(forHTTPHeaderField: "apns-id").flatMap(UUID.init(uuidString:))
        guard response.statusCode == 200 else {
            throw APNsError(statusCode: response.statusCode, body: body, apnsID: apnsID)
        }
        return APNsDelivery(
            apnsID: apnsID ?? request.id,
            uniqueID: response.value(forHTTPHeaderField: "apns-unique-id").flatMap(UUID.init(uuidString:))
        )
    }

    /// The cached provider token, or a new one when it is older than ``tokenLifetime`` or the
    /// clock moved backwards.
    func providerToken() throws -> String {
        let date = now()
        if let cachedToken, date >= cachedToken.issuedAt, date.timeIntervalSince(cachedToken.issuedAt) < Self.tokenLifetime {
            return cachedToken.value
        }
        guard let seconds = EpochTime.seconds(date) else { throw APNsRequestError.invalidExpiration }
        let token = try key.providerToken(issuedAt: seconds)
        cachedToken = (token, date)
        return token
    }
}

/// What APNs answered for an accepted push.
public struct APNsDelivery: Sendable, Hashable {
    /// The `apns-id` of the push.
    public let apnsID: UUID
    /// An ID for looking up the push in the Push Notifications Console (development only).
    public let uniqueID: UUID?
}

/// Sends an HTTP request to APNs. ``URLSessionAPNsTransport`` is the real one; tests pass their own.
public protocol APNsTransport: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

/// Sends requests with `URLSession`, which negotiates HTTP/2 with APNs.
public struct URLSessionAPNsTransport: APNsTransport {
    public let session: URLSession

    public init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }

    public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (bytes, response) = try await session.bytes(for: request)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        // APNs answers with at most a small JSON object; reading stops at the limit so an
        // unexpected endpoint cannot make the client hold a large body.
        var body = Data()
        for try await byte in bytes {
            guard body.count < APNsError.maximumBodySize else { break }
            body.append(byte)
        }
        return (body, http)
    }
}
