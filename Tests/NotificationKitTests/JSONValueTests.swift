import Foundation
import Testing
@testable import NotificationKit

@Suite("JSONValue")
struct JSONValueTests {
    @Test("keeps Booleans apart from numbers when converting userInfo")
    func booleansStayBooleans() throws {
        let value = try JSONValue(userInfo: ["flag": true, "count": 1, "ratio": 0.5, "name": "x", "none": NSNull()])
        #expect(value["flag"] == .bool(true))
        #expect(value["count"] == .number(1))
        #expect(value["ratio"] == .number(0.5))
        #expect(value["name"] == .string("x"))
        #expect(value["none"] == .null)
    }

    @Test("stops at the depth limit instead of recursing without bound")
    func rejectsDeepNesting() {
        var nested: Any = "leaf"
        for _ in 0..<200 { nested = [nested] }
        #expect(throws: JSONValue.ConversionError.tooDeep) {
            try JSONValue(any: nested)
        }
    }

    @Test("stops at the value limit")
    func rejectsTooManyValues() {
        let large = Array(repeating: 1, count: 20_000)
        #expect(throws: JSONValue.ConversionError.tooManyValues) {
            try JSONValue(any: large)
        }
        let limits = JSONValue.Limits(maximumDepth: 4, maximumValueCount: 3)
        #expect(throws: JSONValue.ConversionError.tooManyValues) {
            try JSONValue(any: [1, 2, 3], limits: limits)
        }
    }

    @Test("rejects numbers JSON cannot hold and types it does not know")
    func rejectsUnrepresentableValues() {
        #expect(throws: JSONValue.ConversionError.nonFiniteNumber) { try JSONValue(any: Double.nan) }
        #expect(throws: JSONValue.ConversionError.nonFiniteNumber) { try JSONValue(any: Double.infinity) }
        #expect(throws: JSONValue.ConversionError.nonStringKey) { try JSONValue(any: [1: "one"] as [AnyHashable: Any]) }
        #expect(throws: (any Error).self) { try JSONValue(any: Date()) }
    }

    @Test("turns whole numbers into Int only when Int can hold them")
    func integerConversionHasNoTrap() {
        #expect(JSONValue.number(42).intValue == 42)
        #expect(JSONValue.number(-3).intValue == -3)
        #expect(JSONValue.number(1.5).intValue == nil)
        #expect(JSONValue.number(1e300).intValue == nil)
        #expect(JSONValue.number(-1e300).intValue == nil)
        #expect(JSONValue.number(.nan).intValue == nil)
        #expect(JSONValue.number(.infinity).intValue == nil)
        #expect(JSONValue.number(9_007_199_254_740_992).intValue == 9_007_199_254_740_992)
    }

    @Test("round-trips through userInfo and JSON")
    func roundTrips() throws {
        let value: JSONValue = ["id": "A-1", "items": [1, 2.5, true, nil], "meta": ["n": 3]]
        let back = try JSONValue(userInfo: value.userInfo)
        #expect(back == value)
        let data = try JSONEncoder().encode(value)
        #expect(try JSONDecoder().decode(JSONValue.self, from: data) == value)
        #expect(value.userInfo["id"] as? String == "A-1")
        #expect((value.userInfo["meta"] as? [String: Any])?["n"] as? Int == 3)
    }

    @Test("checks limits of values built in code")
    func limitsOfBuiltValues() {
        var deep: JSONValue = "leaf"
        for _ in 0..<100 { deep = [deep] }
        #expect(!deep.isWithinLimits(.default))
        #expect(!JSONValue.object(["x": .number(.nan)]).isWithinLimits(.default))
        #expect(JSONValue.object(["x": 1]).isWithinLimits(.default))
    }

    @Test("leaves out unconvertible userInfo values but keeps the others")
    func lenientConversion() {
        let info: [AnyHashable: Any] = ["date": Date(), "name": "kept", 7: "numeric key", "nan": Double.nan]
        let object = JSONValue.lenientObject(from: info)
        #expect(object == ["name": "kept"])
    }
}
