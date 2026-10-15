import Foundation
@testable import NotificationKit

/// A clock that tests move by hand.
final class TestClock: @unchecked Sendable {
    private let lock = NSLock()
    private var current: Date

    init(_ start: Date) {
        current = start
    }

    var now: Date {
        lock.withLock { current }
    }

    func advance(by seconds: TimeInterval) {
        lock.withLock { current = current.addingTimeInterval(seconds) }
    }

    func set(_ date: Date) {
        lock.withLock { current = date }
    }
}

enum Fixtures {
    /// Gregorian calendar in a fixed time zone, so results do not depend on the machine.
    static func calendar(_ identifier: String = "Europe/Istanbul") -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: identifier)!
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }

    static func date(_ text: String, in calendar: Calendar = calendar()) -> Date {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = calendar.timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: text)!
    }

    static func notification(_ id: String, after seconds: TimeInterval, level: InterruptionLevel = .active) -> LocalNotification {
        LocalNotification(id: id, title: "Title \(id)", trigger: .after(seconds: seconds)).with(level: level)
    }
}

extension LocalNotification {
    func with(level: InterruptionLevel) -> LocalNotification {
        var copy = self
        copy.interruptionLevel = level
        return copy
    }
}

/// A `URLProtocol` that answers from a handler, for download and transport tests.
final class StubURLProtocol: URLProtocol, @unchecked Sendable {
    struct Response: Sendable {
        var status = 200
        var headers: [String: String] = [:]
        var body = Data()
        var redirect: URL?
    }

    /// Handlers by session, so suites that run in parallel do not answer each other's requests.
    nonisolated(unsafe) private static var handlers: [String: @Sendable (URLRequest) -> Response] = [:]
    private static let lock = NSLock()
    private static let sessionHeader = "X-Stub-Session"

    static func session(_ handler: @escaping @Sendable (URLRequest) -> Response) -> URLSession {
        let id = UUID().uuidString
        lock.withLock { handlers[id] = handler }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        configuration.httpAdditionalHeaders = [sessionHeader: id]
        return URLSession(configuration: configuration)
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let id = request.value(forHTTPHeaderField: Self.sessionHeader) ?? ""
        guard let handler = Self.lock.withLock({ Self.handlers[id] }), let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        let answer = handler(request)
        if let redirect = answer.redirect {
            let response = HTTPURLResponse(url: url, statusCode: 302, httpVersion: "HTTP/1.1", headerFields: ["Location": redirect.absoluteString])!
            var next = URLRequest(url: redirect)
            next.setValue(id, forHTTPHeaderField: Self.sessionHeader)
            client?.urlProtocol(self, wasRedirectedTo: next, redirectResponse: response)
            return
        }
        let response = HTTPURLResponse(url: url, statusCode: answer.status, httpVersion: "HTTP/1.1", headerFields: answer.headers)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: answer.body)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
