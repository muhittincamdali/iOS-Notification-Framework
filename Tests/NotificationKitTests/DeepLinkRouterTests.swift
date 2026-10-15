import Foundation
import Testing
@testable import NotificationKit

@Suite("Deep link router")
struct DeepLinkRouterTests {
    enum Screen: Sendable, Equatable {
        case order(String)
        case item(order: String, item: String)
        case inbox
        case help(String)
    }

    func makeRouter() throws -> DeepLinkRouter<Screen> {
        var router = DeepLinkRouter<Screen>(schemes: ["myapp", "https"], hosts: ["example.com"])
        try router.register("orders/:id") { .order($0.parameters["id"]!) }
        try router.register("orders/:id/items/:item") { .item(order: $0.parameters["id"]!, item: $0.parameters["item"]!) }
        try router.register("/inbox") { _ in .inbox }
        try router.register("help/*") { .help($0.parameters["*"]!) }
        return router
    }

    @Test("matches custom-scheme links, with the host as the first segment")
    func customScheme() throws {
        let router = try makeRouter()
        #expect(router.destination(for: URL(string: "myapp://orders/A-1042")!) == .order("A-1042"))
        #expect(router.destination(for: URL(string: "myapp://orders/7/items/3")!) == .item(order: "7", item: "3"))
        #expect(router.destination(for: URL(string: "MYAPP://inbox")!) == .inbox)
        #expect(router.destination(for: URL(string: "myapp://help/push/setup")!) == .help("push/setup"))
        #expect(router.destination(for: URL(string: "myapp://orders")!) == nil)
        #expect(router.destination(for: URL(string: "myapp://orders/1/extra")!) == nil)
    }

    @Test("accepts web links only from the listed hosts")
    func universalLinks() throws {
        let router = try makeRouter()
        #expect(router.destination(for: URL(string: "https://example.com/inbox")!) == .inbox)
        #expect(router.destination(for: URL(string: "https://EXAMPLE.com/orders/9")!) == .order("9"))
        #expect(router.destination(for: URL(string: "https://evil.example/inbox")!) == nil)
        #expect(router.destination(for: URL(string: "https://example.com.evil.example/inbox")!) == nil)
        #expect(router.destination(for: URL(string: "http://example.com/inbox")!) == nil)
    }

    @Test("rejects links that try to slip past the checks", arguments: [
        "javascript://inbox", "file:///inbox", "myapp://user:secret@orders/1", "https://user@example.com/inbox",
        "myapp://orders/..", "myapp://orders/%2E%2E", "myapp://orders/a%2Fb", "myapp://orders/a%5Cb",
        "myapp://orders/%00", "myapp://orders/%0Aheader", "myapp://orders/%7F"
    ])
    func rejectsUnsafeLinks(_ text: String) throws {
        let router = try makeRouter()
        if let url = URL(string: text) {
            #expect(router.destination(for: url) == nil)
        }
    }

    @Test("decodes parameters and reads the query")
    func parametersAndQuery() throws {
        var router = DeepLinkRouter<String>(schemes: ["myapp"])
        try router.register("search/:term") { "\($0.parameters["term"]!)|\($0.query["sort"] ?? "-")|\($0.query["page"] ?? "-")" }
        let url = URL(string: "myapp://search/caf%C3%A9%20au%20lait?sort=new&sort=old&page=2")!
        #expect(router.destination(for: url) == "café au lait|new|2")
    }

    @Test("rejects very long links and links with many segments")
    func limits() throws {
        var router = DeepLinkRouter<String>(schemes: ["myapp"])
        try router.register("a/*") { _ in "matched" }
        let long = URL(string: "myapp://a/" + String(repeating: "x", count: 3_000))!
        #expect(router.destination(for: long) == nil)
        let many = URL(string: "myapp://a/" + Array(repeating: "s", count: 40).joined(separator: "/"))!
        #expect(router.destination(for: many) == nil)
        #expect(router.destination(for: URL(string: "myapp://a/b/c")!) == "matched")
    }

    @Test("rejects invalid patterns")
    func invalidPatterns() {
        var router = DeepLinkRouter<String>(schemes: ["myapp"])
        for pattern in ["", "/", "a/*/b", "a/:", "a/:id/:id", "a/:*"] {
            #expect(throws: DeepLinkRouter<String>.PatternError.self) { try router.register(pattern) { _ in "" } }
        }
    }

    @Test("lets a later route answer when an earlier one returns nil")
    func fallsThrough() throws {
        var router = DeepLinkRouter<String>(schemes: ["myapp"])
        try router.register("orders/:id") { match in Int(match.parameters["id"]!).map { "number \($0)" } }
        try router.register("orders/:slug") { "slug \($0.parameters["slug"]!)" }
        #expect(router.destination(for: URL(string: "myapp://orders/12")!) == "number 12")
        #expect(router.destination(for: URL(string: "myapp://orders/latest")!) == "slug latest")
    }

    @Test("routes the deep link of a notification response")
    func notificationResponse() throws {
        let router = try makeRouter()
        let received = ReceivedNotification(id: "n", userInfo: ["deeplink": "myapp://orders/55"])
        #expect(router.destination(for: NotificationResponse(notification: received, action: .open)) == .order("55"))
        #expect(router.destination(for: ReceivedNotification(id: "none")) == nil)
        #expect(router.destination(for: ReceivedNotification(id: "n", userInfo: ["deeplink": 5])) == nil)
    }
}
