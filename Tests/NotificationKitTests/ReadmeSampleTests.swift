import Foundation
import Testing
@testable import NotificationKit

/// Runs the README samples (compiled from ReadmeExamples.swift) that do not need a device.
@Suite("README samples")
struct ReadmeSampleTests {
    @Test("the testing sample keeps 64 with the system")
    func testingSample() async throws {
        #expect(try await scheduledCount() == 64)
    }

    @Test("the router sample opens orders and rejects other hosts")
    func routerSample() throws {
        let router = try makeRouter()
        #expect(router.destination(for: URL(string: "myapp://orders/A-1042")!) == .order("A-1042"))
        #expect(router.destination(for: URL(string: "https://example.com/inbox")!) == .inbox)
        #expect(router.destination(for: URL(string: "https://example.org/inbox")!) == nil)
    }

    @Test("the policy and category samples are valid")
    func policySample() async throws {
        let scheduler = try makeScheduler()
        let policy = await scheduler.policy
        #expect(policy.quietHours?.end == TimeOfDay(hour: 7, minute: 30))
        #expect(policy.frequencyCap?.limit == 3)
        #expect(messageCategory.actions.map(\.id) == ["reply", "mark-read", "mute"])
    }

    @Test("the device token sample redacts the token")
    func tokenSample() throws {
        let token = try didRegisterForPushes(deviceToken: Data(repeating: 0xAB, count: 32))
        #expect(token.description == "DeviceToken(abab…abab, 32 bytes)")
    }
}
