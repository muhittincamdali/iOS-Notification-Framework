import CryptoKit
import Foundation

/// The APNs authentication key (`.p8` file) that signs provider tokens.
///
/// Create the key in Certificates, Identifiers & Profiles › Keys with the Apple Push
/// Notifications service enabled. The key's ID and your team ID are shown there.
///
/// ```swift
/// let key = try APNsSigningKey(
///     p8File: URL(filePath: "/run/secrets/AuthKey_ABC123DEFG.p8"),
///     keyID: "ABC123DEFG",
///     teamID: "DEF123GHIJ"
/// )
/// ```
///
/// The private key never appears in `description`, `dump` or the debugger.
public struct APNsSigningKey: Sendable {
    /// Why a key could not be loaded.
    public enum KeyError: Error, Hashable, Sendable {
        /// The key ID or team ID is not 10 uppercase letters and digits.
        case invalidIdentifier(String)
        /// The file is larger than a `.p8` key can be.
        case fileTooLarge(Int)
        /// The text is not a PEM-encoded P-256 private key.
        case invalidKey
    }

    /// A `.p8` file is about 250 bytes; anything above this is not a key.
    public static let maximumFileSize = 16 * 1024

    public let keyID: String
    public let teamID: String
    private let privateKey: P256.Signing.PrivateKey

    /// Loads the key from the PEM text of a `.p8` file.
    public init(pem: String, keyID: String, teamID: String) throws(KeyError) {
        guard Self.isIdentifier(keyID) else { throw .invalidIdentifier(keyID) }
        guard Self.isIdentifier(teamID) else { throw .invalidIdentifier(teamID) }
        guard pem.utf8.count <= Self.maximumFileSize else { throw .fileTooLarge(pem.utf8.count) }
        do {
            privateKey = try P256.Signing.PrivateKey(pemRepresentation: pem)
        } catch {
            throw .invalidKey
        }
        self.keyID = keyID
        self.teamID = teamID
    }

    /// Loads the key from a `.p8` file.
    public init(p8File url: URL, keyID: String, teamID: String) throws {
        let size = (try FileManager.default.attributesOfItem(atPath: url.path)[.size] as? NSNumber)?.intValue ?? 0
        guard size <= Self.maximumFileSize else { throw KeyError.fileTooLarge(size) }
        let pem = try String(contentsOf: url, encoding: .utf8)
        try self.init(pem: pem, keyID: keyID, teamID: teamID)
    }

    /// Creates a key from an existing CryptoKit key, for tests and key stores.
    public init(privateKey: P256.Signing.PrivateKey, keyID: String, teamID: String) throws(KeyError) {
        guard Self.isIdentifier(keyID) else { throw .invalidIdentifier(keyID) }
        guard Self.isIdentifier(teamID) else { throw .invalidIdentifier(teamID) }
        self.privateKey = privateKey
        self.keyID = keyID
        self.teamID = teamID
    }

    /// The public half, for checking signatures.
    public var publicKey: P256.Signing.PublicKey { privateKey.publicKey }

    /// A provider token (an ES256-signed JSON Web Token) issued at `date`.
    func providerToken(issuedAt seconds: Int) throws -> String {
        let header = #"{"alg":"ES256","kid":"\#(keyID)"}"#
        let claims = #"{"iss":"\#(teamID)","iat":\#(seconds)}"#
        let signingInput = Base64URL.encode(Data(header.utf8)) + "." + Base64URL.encode(Data(claims.utf8))
        let signature = try privateKey.signature(for: Data(signingInput.utf8))
        return signingInput + "." + Base64URL.encode(signature.rawRepresentation)
    }

    /// Apple's key and team IDs are 10 characters, uppercase letters and digits. Checking them
    /// also keeps them safe to place in the token's JSON without escaping.
    static func isIdentifier(_ value: String) -> Bool {
        value.utf8.count == 10 && value.utf8.allSatisfy { (48...57).contains($0) || (65...90).contains($0) }
    }
}

extension APNsSigningKey: CustomStringConvertible, CustomDebugStringConvertible, CustomReflectable {
    public var description: String { "APNsSigningKey(keyID: \(keyID), teamID: \(teamID))" }
    public var debugDescription: String { description }
    public var customMirror: Mirror {
        Mirror(self, children: ["keyID": keyID, "teamID": teamID], displayStyle: .struct)
    }
}

enum Base64URL {
    static func encode(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    static func decode(_ text: String) -> Data? {
        var base64 = text.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        base64 += String(repeating: "=", count: (4 - base64.count % 4) % 4)
        return Data(base64Encoded: base64)
    }
}
