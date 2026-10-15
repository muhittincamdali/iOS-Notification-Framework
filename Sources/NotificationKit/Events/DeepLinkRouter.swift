import Foundation

/// Turns the deep link of a notification into a destination in the app.
///
/// ```swift
/// enum Screen: Sendable { case order(String), inbox }
///
/// var router = DeepLinkRouter<Screen>(schemes: ["myapp"], hosts: ["example.com"])
/// try router.register("orders/:id") { .order($0.parameters["id"]!) }
/// try router.register("inbox") { _ in .inbox }
///
/// router.destination(for: URL(string: "myapp://orders/A-1042")!)   // .order("A-1042")
/// router.destination(for: URL(string: "https://example.com/inbox")!) // .inbox
/// router.destination(for: URL(string: "https://evil.example/inbox")!) // nil: host not allowed
/// ```
///
/// A deep link in a push payload comes from a server, so the router checks it before matching:
/// only the listed schemes and (for `http` and `https`) hosts are accepted, and links that are
/// very long, have many segments, or whose parameters decode to `/`, `.`, `..` or control
/// characters are rejected.
public struct DeepLinkRouter<Destination: Sendable>: Sendable {
    /// The values a matched link provides.
    public struct Match: Sendable, Hashable {
        public let url: URL
        /// Values of `:name` segments, percent-decoded. A trailing `*` puts the rest of the path
        /// under `"*"`.
        public let parameters: [String: String]
        /// Query items; the first value wins when a name repeats.
        public let query: [String: String]
    }

    /// Why a pattern was not registered.
    public enum PatternError: Error, Hashable, Sendable {
        case invalidPattern(String)
    }

    /// Longest link accepted, in characters.
    public static var maximumLinkLength: Int { 2_048 }
    /// Most path segments (including a custom scheme's host) accepted.
    public static var maximumSegmentCount: Int { 32 }

    private struct Route: Sendable {
        let segments: [Segment]
        let make: @Sendable (Match) -> Destination?
    }

    private enum Segment: Sendable, Hashable {
        case literal(String)
        case parameter(String)
        case rest
    }

    public let schemes: Set<String>
    public let hosts: Set<String>
    private var routes: [Route] = []

    /// - Parameters:
    ///   - schemes: Accepted URL schemes, such as your app's custom scheme and `https`.
    ///   - hosts: Accepted hosts for `http` and `https` links (universal links).
    public init(schemes: Set<String>, hosts: Set<String> = []) {
        self.schemes = Set(schemes.map { $0.lowercased() })
        self.hosts = Set(hosts.map { $0.lowercased() })
    }

    /// Adds a route. Patterns are matched in the order they were registered.
    ///
    /// - Parameter pattern: Segments separated by `/`: literals, `:name` parameters, and an
    ///   optional `*` at the end that matches the rest of the path. For custom schemes the
    ///   host is the first segment (`myapp://orders/42` matches `orders/:id`).
    /// - Parameter make: Builds the destination from the match, or returns `nil` to let later
    ///   routes try.
    public mutating func register(_ pattern: String, _ make: @escaping @Sendable (Match) -> Destination?) throws(PatternError) {
        let parts = pattern.split(separator: "/").map(String.init)
        guard !parts.isEmpty, parts.count <= Self.maximumSegmentCount else { throw .invalidPattern(pattern) }
        var names = Set<String>()
        var segments: [Segment] = []
        for (index, part) in parts.enumerated() {
            if part == "*" {
                guard index == parts.count - 1 else { throw .invalidPattern(pattern) }
                segments.append(.rest)
            } else if part.hasPrefix(":") {
                let name = String(part.dropFirst())
                guard !name.isEmpty, name != "*", names.insert(name).inserted else { throw .invalidPattern(pattern) }
                segments.append(.parameter(name))
            } else {
                segments.append(.literal(part))
            }
        }
        routes.append(Route(segments: segments, make: make))
    }

    /// The destination for `url`, or `nil` if the link is not allowed or matches no route.
    public func destination(for url: URL) -> Destination? {
        guard let path = allowedSegments(of: url) else { return nil }
        let query = Self.queryItems(of: url)
        for route in routes {
            guard let parameters = Self.match(route.segments, path) else { continue }
            if let destination = route.make(Match(url: url, parameters: parameters, query: query)) {
                return destination
            }
        }
        return nil
    }

    /// The destination for the deep link of a received notification.
    public func destination(for notification: ReceivedNotification) -> Destination? {
        notification.deepLink.flatMap(destination(for:))
    }

    /// The destination for the notification a user responded to.
    public func destination(for response: NotificationResponse) -> Destination? {
        destination(for: response.notification)
    }

    /// The decoded path segments of an allowed link, or `nil` if the link is not allowed.
    private func allowedSegments(of url: URL) -> [String]? {
        guard url.absoluteString.count <= Self.maximumLinkLength,
              let scheme = url.scheme?.lowercased(), schemes.contains(scheme),
              url.user == nil, url.password == nil
        else { return nil }
        var raw = url.path(percentEncoded: true).split(separator: "/").map(String.init)
        let host = url.host(percentEncoded: false)?.lowercased()
        if scheme == "http" || scheme == "https" {
            guard let host, hosts.contains(host) else { return nil }
        } else if let host = url.host(percentEncoded: true), !host.isEmpty {
            raw.insert(host, at: 0)
        }
        guard raw.count <= Self.maximumSegmentCount else { return nil }
        var decoded: [String] = []
        for segment in raw {
            guard let value = segment.removingPercentEncoding, Self.isSafe(value) else { return nil }
            decoded.append(value)
        }
        return decoded
    }

    private static func isSafe(_ segment: String) -> Bool {
        guard !segment.isEmpty, segment != ".", segment != ".." else { return false }
        return !segment.unicodeScalars.contains { $0 == "/" || $0 == "\\" || $0.properties.generalCategory == .control }
    }

    private static func match(_ pattern: [Segment], _ path: [String]) -> [String: String]? {
        var parameters: [String: String] = [:]
        for (index, segment) in pattern.enumerated() {
            switch segment {
            case .rest:
                parameters["*"] = path.dropFirst(index).joined(separator: "/")
                return parameters
            case .literal(let literal):
                guard index < path.count, path[index] == literal else { return nil }
            case .parameter(let name):
                guard index < path.count else { return nil }
                parameters[name] = path[index]
            }
        }
        return pattern.count == path.count ? parameters : nil
    }

    private static func queryItems(of url: URL) -> [String: String] {
        let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        var query: [String: String] = [:]
        for item in items.prefix(maximumSegmentCount) where query[item.name] == nil {
            query[item.name] = item.value ?? ""
        }
        return query
    }
}
