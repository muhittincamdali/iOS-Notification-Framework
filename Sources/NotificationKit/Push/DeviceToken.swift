import Foundation

/// The token APNs gives an app install, which a server needs to send it pushes.
///
/// ```swift
/// func application(_ application: UIApplication,
///                  didRegisterForRemoteNotificationsWithDeviceToken data: Data) {
///     let token = try? DeviceToken(data: data)
///     print(token)            // DeviceToken(3f2a…91bc, 32 bytes): safe to log
///     upload(token.hexString) // the full value, only for your server
/// }
/// ```
///
/// The token identifies a device to anyone who can send it pushes, so every textual form that
/// can end up in a log (`description`, `debugDescription`, string interpolation, `dump`, and
/// the reflection used by debuggers) shows only the first and last four hex digits. Read
/// ``hexString`` or encode the token to get the full value.
public struct DeviceToken: Sendable, Hashable, Codable {
    /// Why a token was rejected.
    public enum FormatError: Error, Hashable, Sendable {
        /// The token is empty or longer than ``maximumByteCount`` bytes.
        case invalidLength(Int)
        /// The hex string has an odd length or a character that is not a hex digit.
        case invalidHex
    }

    /// APNs tokens are variable in length (32 bytes today); longer values are rejected.
    public static let maximumByteCount = 255

    private let bytes: Data

    /// - Throws: ``FormatError/invalidLength(_:)`` for an empty or overlong token.
    public init(data: Data) throws(FormatError) {
        guard !data.isEmpty, data.count <= Self.maximumByteCount else { throw .invalidLength(data.count) }
        bytes = data
    }

    /// Parses a hex string, upper or lower case, as servers usually store it.
    public init(hexString: String) throws(FormatError) {
        let utf8 = Array(hexString.utf8)
        guard !utf8.isEmpty, utf8.count <= Self.maximumByteCount * 2 else { throw .invalidLength(utf8.count / 2) }
        guard utf8.count.isMultiple(of: 2) else { throw .invalidHex }
        var data = Data(capacity: utf8.count / 2)
        var index = 0
        while index < utf8.count {
            guard let high = Self.nibble(utf8[index]), let low = Self.nibble(utf8[index + 1]) else { throw .invalidHex }
            data.append(high << 4 | low)
            index += 2
        }
        try self.init(data: data)
    }

    /// The raw token.
    public var data: Data { bytes }

    /// The full token as lowercase hex, the form APNs expects in the request path.
    public var hexString: String {
        let digits = Array("0123456789abcdef".utf8)
        var result = [UInt8]()
        result.reserveCapacity(bytes.count * 2)
        for byte in bytes {
            result.append(digits[Int(byte >> 4)])
            result.append(digits[Int(byte & 0x0F)])
        }
        return String(decoding: result, as: UTF8.self)
    }

    /// The first and last four hex digits, for logs and support screens.
    public var redacted: String {
        let hex = hexString
        guard hex.count > 8 else { return String(repeating: "•", count: hex.count) }
        return "\(hex.prefix(4))…\(hex.suffix(4))"
    }

    public init(from decoder: any Decoder) throws {
        let text = try decoder.singleValueContainer().decode(String.self)
        do {
            try self.init(hexString: text)
        } catch {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Not a device token in hex"))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(hexString)
    }

    private static func nibble(_ character: UInt8) -> UInt8? {
        switch character {
        case UInt8(ascii: "0")...UInt8(ascii: "9"): character - UInt8(ascii: "0")
        case UInt8(ascii: "a")...UInt8(ascii: "f"): character - UInt8(ascii: "a") + 10
        case UInt8(ascii: "A")...UInt8(ascii: "F"): character - UInt8(ascii: "A") + 10
        default: nil
        }
    }
}

extension DeviceToken: CustomStringConvertible, CustomDebugStringConvertible, CustomReflectable {
    public var description: String { "DeviceToken(\(redacted), \(bytes.count) bytes)" }
    public var debugDescription: String { description }
    public var customMirror: Mirror {
        Mirror(self, children: ["redacted": redacted, "byteCount": bytes.count], displayStyle: .struct)
    }
}
