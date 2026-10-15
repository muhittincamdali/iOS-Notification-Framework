import CryptoKit
import Foundation
import NotificationKit
import Testing
@testable import NotificationKitAPNs

/// Records requests and answers them from a list, in order.
actor MockTransport: APNsTransport {
    struct Answer: Sendable {
        var status: Int
        var body: String = ""
        var headers: [String: String] = [:]
    }

    private var answers: [Answer]
    private(set) var requests: [URLRequest] = []

    init(_ answers: [Answer]) {
        self.answers = answers
    }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requests.append(request)
        let answer = answers.isEmpty ? Answer(status: 200) : answers.removeFirst()
        let response = HTTPURLResponse(url: request.url!, statusCode: answer.status, httpVersion: "HTTP/2", headerFields: answer.headers)!
        return (Data(answer.body.utf8), response)
    }
}

final class Clock: @unchecked Sendable {
    private let lock = NSLock()
    private var current = Date(timeIntervalSince1970: 1_800_000_000)
    var now: Date { lock.withLock { current } }
    func advance(by seconds: TimeInterval) { lock.withLock { current += seconds } }
}

enum APNsFixtures {
    static let privateKey = P256.Signing.PrivateKey()
    static let key = try! APNsSigningKey(privateKey: privateKey, keyID: "ABC123DEFG", teamID: "DEF123GHIJ")
    static let token = try! DeviceToken(hexString: String(repeating: "ab", count: 32))

    static func request(_ payload: PushPayload = .alert(title: "Hi", body: "There"), pushType: PushType = .alert) -> APNsRequest {
        APNsRequest(payload: payload, deviceToken: token, pushType: pushType, topic: "com.example.App")
    }

    /// Splits a JWT and checks its ES256 signature with the key's public half.
    static func verify(_ jwt: String, with publicKey: P256.Signing.PublicKey) throws -> (header: [String: Any], claims: [String: Any]) {
        let parts = jwt.split(separator: ".").map(String.init)
        guard parts.count == 3,
              let header = Base64URL.decode(parts[0]), let claims = Base64URL.decode(parts[1]), let signature = Base64URL.decode(parts[2])
        else { throw CocoaError(.coderReadCorrupt) }
        let ecdsa = try P256.Signing.ECDSASignature(rawRepresentation: signature)
        guard publicKey.isValidSignature(ecdsa, for: Data("\(parts[0]).\(parts[1])".utf8)) else { throw CocoaError(.coderInvalidValue) }
        return (
            try JSONSerialization.jsonObject(with: header) as! [String: Any],
            try JSONSerialization.jsonObject(with: claims) as! [String: Any]
        )
    }
}

@Suite("APNs signing key")
struct SigningKeyTests {
    @Test("loads the PEM text of a .p8 key")
    func loadsPEM() throws {
        let pem = APNsFixtures.privateKey.pemRepresentation
        let key = try APNsSigningKey(pem: pem, keyID: "ABC123DEFG", teamID: "DEF123GHIJ")
        #expect(key.publicKey.rawRepresentation == APNsFixtures.privateKey.publicKey.rawRepresentation)
    }

    @Test("rejects bad identifiers, keys and files")
    func rejectsBadInput() throws {
        let pem = APNsFixtures.privateKey.pemRepresentation
        for id in ["", "abc123defg", "ABC123DEF", "ABC123DEFGH", "ABC\"23DEFG", "ABC123DEF\n"] {
            #expect(throws: APNsSigningKey.KeyError.invalidIdentifier(id)) { try APNsSigningKey(pem: pem, keyID: id, teamID: "DEF123GHIJ") }
        }
        #expect(throws: APNsSigningKey.KeyError.invalidKey) { try APNsSigningKey(pem: "not a key", keyID: "ABC123DEFG", teamID: "DEF123GHIJ") }
        let large = String(repeating: "A", count: APNsSigningKey.maximumFileSize + 1)
        #expect(throws: APNsSigningKey.KeyError.fileTooLarge(large.utf8.count)) { try APNsSigningKey(pem: large, keyID: "ABC123DEFG", teamID: "DEF123GHIJ") }

        let file = FileManager.default.temporaryDirectory.appendingPathComponent("AuthKey_\(UUID().uuidString).p8")
        defer { try? FileManager.default.removeItem(at: file) }
        try Data(pem.utf8).write(to: file)
        _ = try APNsSigningKey(p8File: file, keyID: "ABC123DEFG", teamID: "DEF123GHIJ")
    }

    @Test("signs a provider token Apple can verify")
    func providerToken() throws {
        let jwt = try APNsFixtures.key.providerToken(issuedAt: 1_800_000_000)
        let (header, claims) = try APNsFixtures.verify(jwt, with: APNsFixtures.privateKey.publicKey)
        #expect(header["alg"] as? String == "ES256")
        #expect(header["kid"] as? String == "ABC123DEFG")
        #expect(claims["iss"] as? String == "DEF123GHIJ")
        #expect(claims["iat"] as? Int == 1_800_000_000)
        #expect(!jwt.contains("=") && !jwt.contains("+") && !jwt.contains("/"))
    }

    @Test("never shows the private key")
    func redaction() {
        var dumped = ""
        dump(APNsFixtures.key, to: &dumped)
        let pemBody = APNsFixtures.privateKey.pemRepresentation.split(separator: "\n")[1]
        for text in [APNsFixtures.key.description, String(reflecting: APNsFixtures.key), dumped, "\(APNsFixtures.key)"] {
            #expect(!text.contains(pemBody))
            #expect(!text.lowercased().contains("privatekey"))
        }
        #expect(APNsFixtures.key.description == "APNsSigningKey(keyID: ABC123DEFG, teamID: DEF123GHIJ)")
    }
}

@Suite("APNs request")
struct APNsRequestTests {
    @Test("builds the path and headers APNs expects")
    func headers() throws {
        var request = APNsFixtures.request()
        request.priority = .immediate
        request.expiration = .at(Date(timeIntervalSince1970: 1_800_003_600))
        request.collapseID = "score-update"
        let urlRequest = try request.urlRequest(baseURL: APNsEnvironment.development.baseURL, bearer: "TOKEN")
        #expect(urlRequest.url?.absoluteString == "https://api.sandbox.push.apple.com/3/device/" + String(repeating: "ab", count: 32))
        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "authorization") == "bearer TOKEN")
        #expect(urlRequest.value(forHTTPHeaderField: "apns-push-type") == "alert")
        #expect(urlRequest.value(forHTTPHeaderField: "apns-topic") == "com.example.App")
        #expect(urlRequest.value(forHTTPHeaderField: "apns-priority") == "10")
        #expect(urlRequest.value(forHTTPHeaderField: "apns-expiration") == "1800003600")
        #expect(urlRequest.value(forHTTPHeaderField: "apns-collapse-id") == "score-update")
        #expect(urlRequest.value(forHTTPHeaderField: "apns-id") == request.id.uuidString)
        #expect(try PushPayload(json: urlRequest.httpBody!) == request.payload)
        #expect(APNsEnvironment.production.baseURL.host() == "api.push.apple.com")
    }

    @Test("adds Apple's topic suffix per push type")
    func topics() {
        #expect(APNsRequest.topic(forBundleID: "com.example.App", pushType: .alert) == "com.example.App")
        #expect(APNsRequest.topic(forBundleID: "com.example.App", pushType: .liveActivity) == "com.example.App.push-type.liveactivity")
        #expect(APNsRequest.topic(forBundleID: "com.example.App", pushType: .voip) == "com.example.App.voip")
        #expect(APNsRequest.topic(forBundleID: "com.example.App", pushType: .complication) == "com.example.App.complication")
        #expect(APNsRequest.topic(forBundleID: "com.example.App", pushType: .fileProvider) == "com.example.App.pushkit.fileprovider")
    }

    @Test("rejects requests APNs would refuse, before sending")
    func rejections() {
        var request = APNsFixtures.request()
        request.collapseID = String(repeating: "c", count: 65)
        #expect(throws: APNsRequestError.invalidCollapseID) { try request.urlRequest(baseURL: APNsEnvironment.production.baseURL, bearer: "t") }
        request.collapseID = "ok\r\napns-priority: 10"
        #expect(throws: APNsRequestError.invalidCollapseID) { try request.urlRequest(baseURL: APNsEnvironment.production.baseURL, bearer: "t") }
        request = APNsFixtures.request()
        request.topic = "com.example.App\nx: y"
        #expect(throws: APNsRequestError.invalidTopic) { try request.urlRequest(baseURL: APNsEnvironment.production.baseURL, bearer: "t") }
        request = APNsFixtures.request(.background(), pushType: .background)
        request.priority = .immediate
        #expect(throws: APNsRequestError.invalidPriority) { try request.urlRequest(baseURL: APNsEnvironment.production.baseURL, bearer: "t") }
        for date in [Date(timeIntervalSince1970: .nan), Date(timeIntervalSince1970: -5), .distantFuture] {
            request = APNsFixtures.request()
            request.expiration = .at(date)
            #expect(throws: APNsRequestError.invalidExpiration) { try request.urlRequest(baseURL: APNsEnvironment.production.baseURL, bearer: "t") }
        }
        request = APNsFixtures.request(.alert(body: String(repeating: "x", count: 5_000)))
        #expect(throws: PushPayloadError.self) { try request.urlRequest(baseURL: APNsEnvironment.production.baseURL, bearer: "t") }
    }
}

@Suite("APNs client")
struct APNsClientTests {
    @Test("sends a push and returns APNs' identifiers")
    func success() async throws {
        let apnsID = UUID()
        let uniqueID = UUID()
        let transport = MockTransport([.init(status: 200, headers: ["apns-id": apnsID.uuidString, "apns-unique-id": uniqueID.uuidString])])
        let client = APNsClient(key: APNsFixtures.key, environment: .development, transport: transport)
        let delivery = try await client.send(APNsFixtures.request())
        #expect(delivery.apnsID == apnsID)
        #expect(delivery.uniqueID == uniqueID)
        let sent = try #require(await transport.requests.first)
        let bearer = try #require(sent.value(forHTTPHeaderField: "authorization")?.dropFirst("bearer ".count))
        _ = try APNsFixtures.verify(String(bearer), with: APNsFixtures.privateKey.publicKey)
    }

    @Test("reuses the provider token for 50 minutes, then signs a new one")
    func tokenCache() async throws {
        let clock = Clock()
        let client = APNsClient(key: APNsFixtures.key, environment: .production, transport: MockTransport([]), now: { clock.now })
        let first = try await client.providerToken()
        clock.advance(by: 49 * 60)
        #expect(try await client.providerToken() == first)
        clock.advance(by: 60)
        let second = try await client.providerToken()
        #expect(second != first)
        clock.advance(by: -3_600)
        #expect(try await client.providerToken() != second)
    }

    @Test("signs a new token and retries once when APNs says the token expired")
    func expiredTokenRetry() async throws {
        let expired = MockTransport.Answer(status: 403, body: #"{"reason":"ExpiredProviderToken"}"#)
        let transport = MockTransport([expired, .init(status: 200)])
        let client = APNsClient(key: APNsFixtures.key, environment: .production, transport: transport)
        try await client.send(APNsFixtures.request())
        let tokens = await transport.requests.map { $0.value(forHTTPHeaderField: "authorization") }
        #expect(tokens.count == 2)
        #expect(tokens[0] != tokens[1])

        let alwaysExpired = MockTransport([expired, expired, expired])
        let failing = APNsClient(key: APNsFixtures.key, environment: .production, transport: alwaysExpired)
        await #expect(throws: APNsError.self) { try await failing.send(APNsFixtures.request()) }
        #expect(await alwaysExpired.requests.count == 2)
    }

    @Test("reports a token that is no longer valid")
    func unregistered() async throws {
        let transport = MockTransport([.init(status: 410, body: #"{"reason":"Unregistered","timestamp":1800000000123}"#)])
        let client = APNsClient(key: APNsFixtures.key, environment: .production, transport: transport)
        do {
            try await client.send(APNsFixtures.request())
            Issue.record("Expected an error")
        } catch let error as APNsError {
            #expect(error.reason == .unregistered)
            #expect(error.isTokenInvalid)
            #expect(!error.isRetryable)
            #expect(error.timestamp == Date(timeIntervalSince1970: 1_800_000_000.123))
        }
    }

    @Test("classifies errors and survives bodies that are not what APNs sends")
    func errorBodies() {
        #expect(APNsError(statusCode: 429, body: Data(#"{"reason":"TooManyRequests"}"#.utf8), apnsID: nil).isRetryable)
        #expect(APNsError(statusCode: 503, body: Data(), apnsID: nil).isRetryable)
        #expect(APNsError(statusCode: 400, body: Data(#"{"reason":"BadDeviceToken"}"#.utf8), apnsID: nil).isTokenInvalid)
        let garbage = APNsError(statusCode: 500, body: Data("<html>".utf8), apnsID: nil)
        #expect(garbage.reason == nil)
        let huge = APNsError(statusCode: 400, body: Data(count: 1_000_000), apnsID: nil)
        #expect(huge.reason == nil)
        let badTimestamp = APNsError(statusCode: 410, body: Data(#"{"reason":"Unregistered","timestamp":1e300}"#.utf8), apnsID: nil)
        #expect(badTimestamp.timestamp == nil)
        let longReason = APNsError(statusCode: 400, body: Data(#"{"reason":"\#(String(repeating: "x", count: 500))"}"#.utf8), apnsID: nil)
        #expect(longReason.reason == nil)
    }
}

final class APNsStubProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var status = 200
    nonisolated(unsafe) static var body = Data()

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        let response = HTTPURLResponse(url: request.url!, statusCode: Self.status, httpVersion: "HTTP/2", headerFields: ["apns-id": "8D3A4C1E-0F2B-4A55-9C1D-2E3F4A5B6C7D"])!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.body)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

@Suite("URLSession transport", .serialized)
struct URLSessionTransportTests {
    func session() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [APNsStubProtocol.self]
        return URLSession(configuration: configuration)
    }

    @Test("sends through URLSession end to end")
    func endToEnd() async throws {
        APNsStubProtocol.status = 200
        APNsStubProtocol.body = Data()
        let client = APNsClient(key: APNsFixtures.key, environment: .development, transport: URLSessionAPNsTransport(session: session()))
        let delivery = try await client.send(APNsFixtures.request())
        #expect(delivery.apnsID == UUID(uuidString: "8D3A4C1E-0F2B-4A55-9C1D-2E3F4A5B6C7D"))
    }

    @Test("reads at most 64 KB of an answer")
    func boundedBody() async throws {
        APNsStubProtocol.status = 400
        APNsStubProtocol.body = Data(count: 2_000_000)
        let transport = URLSessionAPNsTransport(session: session())
        let (body, response) = try await transport.send(URLRequest(url: URL(string: "https://api.push.apple.com/3/device/ab")!))
        #expect(response.statusCode == 400)
        #expect(body.count == APNsError.maximumBodySize)
    }
}
