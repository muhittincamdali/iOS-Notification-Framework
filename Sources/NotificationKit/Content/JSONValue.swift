import Foundation

/// A JSON value that is `Sendable`, `Codable` and `Hashable`.
///
/// Notification payloads (`userInfo`) are `[AnyHashable: Any]` dictionaries, which cannot cross
/// actor boundaries in Swift 6. NotificationKit stores custom data as `JSONValue` instead and
/// converts at the edge, where the system hands over or receives a dictionary.
///
/// ```swift
/// let info: JSONValue = ["orderID": "A-1042", "items": 3, "express": true]
/// info["orderID"]?.stringValue // "A-1042"
/// ```
public enum JSONValue: Sendable, Hashable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([JSONValue])
    case object([String: JSONValue])

    /// Limits that bound how much work converting an untrusted value can do.
    public struct Limits: Sendable, Hashable {
        /// Deepest nesting of arrays and objects accepted.
        public var maximumDepth: Int
        /// Largest number of values (including nested ones) accepted.
        public var maximumValueCount: Int

        public init(maximumDepth: Int = 32, maximumValueCount: Int = 10_000) {
            self.maximumDepth = max(1, maximumDepth)
            self.maximumValueCount = max(1, maximumValueCount)
        }

        /// The limits used when no others are given.
        public static let `default` = Limits()
    }

    /// Why a value could not be converted.
    public enum ConversionError: Error, Hashable, Sendable {
        /// The value nests deeper than ``Limits/maximumDepth``.
        case tooDeep
        /// The value holds more than ``Limits/maximumValueCount`` values.
        case tooManyValues
        /// A number is not finite (NaN or infinity), which JSON cannot represent.
        case nonFiniteNumber
        /// A dictionary key is not a string.
        case nonStringKey
        /// A value has a type that JSON cannot represent, such as `Date` or `Data`.
        case unsupportedType(String)
    }

    /// Converts a property-list style value (`userInfo`, `JSONSerialization` output).
    ///
    /// Conversion stops with an error instead of recursing without bound, so a payload that
    /// nests thousands of levels deep cannot exhaust the stack.
    public init(any value: Any, limits: Limits = .default) throws(ConversionError) {
        var budget = limits.maximumValueCount
        self = try JSONValue.convert(value, depth: 0, limits: limits, budget: &budget)
    }

    /// Converts a `userInfo` dictionary into a JSON object.
    public init(userInfo: [AnyHashable: Any], limits: Limits = .default) throws(ConversionError) {
        try self.init(any: userInfo as [AnyHashable: Any], limits: limits)
    }

    private static func convert(_ value: Any, depth: Int, limits: Limits, budget: inout Int) throws(ConversionError) -> JSONValue {
        budget -= 1
        guard budget >= 0 else { throw .tooManyValues }
        guard depth <= limits.maximumDepth else { throw .tooDeep }
        switch value {
        case is NSNull:
            return .null
        case let string as String:
            return .string(string)
        case let number as NSNumber:
            return try convert(number)
        case let array as [Any]:
            var result: [JSONValue] = []
            result.reserveCapacity(array.count)
            for element in array {
                result.append(try convert(element, depth: depth + 1, limits: limits, budget: &budget))
            }
            return .array(result)
        case let dictionary as [AnyHashable: Any]:
            var result: [String: JSONValue] = [:]
            for (key, element) in dictionary {
                guard let key = key.base as? String else { throw .nonStringKey }
                result[key] = try convert(element, depth: depth + 1, limits: limits, budget: &budget)
            }
            return .object(result)
        default:
            throw .unsupportedType(String(describing: type(of: value)))
        }
    }

    private static func convert(_ number: NSNumber) throws(ConversionError) -> JSONValue {
        // CFBoolean is the only NSNumber that reports this type id; checking it keeps `true`
        // from turning into `1`.
        if CFGetTypeID(number) == CFBooleanGetTypeID() {
            return .bool(number.boolValue)
        }
        let double = number.doubleValue
        guard double.isFinite else { throw .nonFiniteNumber }
        return .number(double)
    }

    /// The value as `Any`, ready for `userInfo` or `JSONSerialization`.
    public var anyValue: Any {
        switch self {
        case .null: NSNull()
        case .bool(let value): value
        case .number(let value): Self.integerIfExact(value).map { $0 as Any } ?? value
        case .string(let value): value
        case .array(let values): values.map(\.anyValue)
        case .object(let values): values.mapValues(\.anyValue)
        }
    }

    /// The value as a `userInfo` dictionary; empty unless the value is an object.
    public var userInfo: [AnyHashable: Any] {
        guard case .object(let values) = self else { return [:] }
        var result: [AnyHashable: Any] = [:]
        for (key, value) in values { result[key] = value.anyValue }
        return result
    }

    /// Whole numbers that fit in `Int` are handed to the system as integers, so a badge or an
    /// identifier read back with `as? Int` keeps working. The range check comes first because
    /// `Int(_:)` traps on values it cannot represent.
    static func integerIfExact(_ value: Double) -> Int? {
        guard value.isFinite, value.rounded() == value else { return nil }
        guard value >= -9_007_199_254_740_992, value <= 9_007_199_254_740_992 else { return nil }
        return Int(value)
    }
}

// MARK: - Accessors

extension JSONValue {
    /// The string, if the value is a string.
    public var stringValue: String? {
        if case .string(let value) = self { return value }
        return nil
    }

    /// The number, if the value is a number.
    public var doubleValue: Double? {
        if case .number(let value) = self { return value }
        return nil
    }

    /// The number as `Int`, if the value is a whole number that `Int` can hold.
    public var intValue: Int? {
        guard case .number(let value) = self else { return nil }
        return Self.integerIfExact(value)
    }

    /// The Boolean, if the value is a Boolean.
    public var boolValue: Bool? {
        if case .bool(let value) = self { return value }
        return nil
    }

    /// The elements, if the value is an array.
    public var arrayValue: [JSONValue]? {
        if case .array(let value) = self { return value }
        return nil
    }

    /// The members, if the value is an object.
    public var objectValue: [String: JSONValue]? {
        if case .object(let value) = self { return value }
        return nil
    }

    /// The member for `key`, if the value is an object that has it.
    public subscript(key: String) -> JSONValue? {
        objectValue?[key]
    }
}

// MARK: - Codable

extension JSONValue: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([JSONValue].self) {
            self = .array(value)
        } else {
            self = .object(try container.decode([String: JSONValue].self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:
            try container.encodeNil()
        case .bool(let value):
            try container.encode(value)
        case .number(let value):
            if let integer = Self.integerIfExact(value) {
                try container.encode(integer)
            } else {
                try container.encode(value)
            }
        case .string(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        }
    }
}

// MARK: - Literals

extension JSONValue: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral,
    ExpressibleByBooleanLiteral, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral, ExpressibleByNilLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
    public init(integerLiteral value: Int) { self = .number(Double(value)) }
    public init(floatLiteral value: Double) { self = .number(value) }
    public init(booleanLiteral value: Bool) { self = .bool(value) }
    public init(arrayLiteral elements: JSONValue...) { self = .array(elements) }
    public init(nilLiteral: ()) { self = .null }

    public init(dictionaryLiteral elements: (String, JSONValue)...) {
        var object: [String: JSONValue] = [:]
        for (key, value) in elements { object[key] = value }
        self = .object(object)
    }
}
