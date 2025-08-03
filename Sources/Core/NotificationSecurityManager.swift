import Foundation
import Security
import CryptoKit

/// Advanced security manager for notification framework
@available(iOS 15.0, *)
public final class NotificationSecurityManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var isEncryptionEnabled: Bool = true
    @Published public var securityLevel: SecurityLevel = .high
    @Published public var lastSecurityEvent: SecurityEvent?
    
    // MARK: - Private Properties
    private let keychain = KeychainWrapper()
    private let cryptoManager = CryptoManager()
    private let securityQueue = DispatchQueue(label: "com.notification.security", qos: .userInitiated)
    private var securityEvents: [SecurityEvent] = []
    
    // MARK: - Initialization
    public init() {
        setupSecurityMonitoring()
    }
    
    // MARK: - Public Methods
    
    /// Encrypt notification content
    /// - Parameter content: Content to encrypt
    /// - Returns: Encrypted content
    public func encryptContent(_ content: String) throws -> Data {
        guard isEncryptionEnabled else {
            return content.data(using: .utf8) ?? Data()
        }
        
        return try securityQueue.sync {
            let key = try getEncryptionKey()
            return try cryptoManager.encrypt(content, using: key)
        }
    }
    
    /// Decrypt notification content
    /// - Parameter encryptedData: Encrypted data to decrypt
    /// - Returns: Decrypted content
    public func decryptContent(_ encryptedData: Data) throws -> String {
        guard isEncryptionEnabled else {
            return String(data: encryptedData, encoding: .utf8) ?? ""
        }
        
        return try securityQueue.sync {
            let key = try getEncryptionKey()
            let decryptedData = try cryptoManager.decrypt(encryptedData, using: key)
            return String(data: decryptedData, encoding: .utf8) ?? ""
        }
    }
    
    /// Sign notification payload
    /// - Parameter payload: Payload to sign
    /// - Returns: Signed payload with signature
    public func signPayload(_ payload: NotificationPayload) throws -> SignedPayload {
        let payloadData = try JSONEncoder().encode(payload)
        let signature = try cryptoManager.sign(payloadData)
        
        let signedPayload = SignedPayload(
            payload: payload,
            signature: signature,
            timestamp: Date()
        )
        
        logSecurityEvent(.payloadSigned, details: ["payloadId": payload.id])
        return signedPayload
    }
    
    /// Verify signed payload
    /// - Parameter signedPayload: Signed payload to verify
    /// - Returns: Verification result
    public func verifyPayload(_ signedPayload: SignedPayload) throws -> Bool {
        let payloadData = try JSONEncoder().encode(signedPayload.payload)
        let isValid = try cryptoManager.verify(payloadData, signature: signedPayload.signature)
        
        if isValid {
            logSecurityEvent(.payloadVerified, details: ["payloadId": signedPayload.payload.id])
        } else {
            logSecurityEvent(.payloadVerificationFailed, details: ["payloadId": signedPayload.payload.id])
        }
        
        return isValid
    }
    
    /// Generate secure notification token
    /// - Parameter userId: User identifier
    /// - Returns: Secure notification token
    public func generateSecureToken(for userId: String) throws -> String {
        let tokenData = "\(userId)_\(Date().timeIntervalSince1970)_\(UUID().uuidString)".data(using: .utf8)!
        let hashedToken = SHA256.hash(data: tokenData)
        let token = hashedToken.compactMap { String(format: "%02x", $0) }.joined()
        
        try keychain.store(token, forKey: "notification_token_\(userId)")
        logSecurityEvent(.tokenGenerated, details: ["userId": userId])
        
        return token
    }
    
    /// Validate notification token
    /// - Parameters:
    ///   - token: Token to validate
    ///   - userId: User identifier
    /// - Returns: Validation result
    public func validateToken(_ token: String, for userId: String) -> Bool {
        guard let storedToken = try? keychain.retrieve(forKey: "notification_token_\(userId)") as? String else {
            logSecurityEvent(.tokenValidationFailed, details: ["userId": userId, "reason": "token_not_found"])
            return false
        }
        
        let isValid = token == storedToken
        logSecurityEvent(isValid ? .tokenValidated : .tokenValidationFailed, details: ["userId": userId])
        
        return isValid
    }
    
    /// Set security level
    /// - Parameter level: Security level to set
    public func setSecurityLevel(_ level: SecurityLevel) {
        securityLevel = level
        logSecurityEvent(.securityLevelChanged, details: ["newLevel": level.rawValue])
    }
    
    /// Enable/disable encryption
    /// - Parameter enabled: Whether encryption should be enabled
    public func setEncryptionEnabled(_ enabled: Bool) {
        isEncryptionEnabled = enabled
        logSecurityEvent(.encryptionToggled, details: ["enabled": enabled])
    }
    
    /// Get security statistics
    /// - Returns: Security statistics
    public func getSecurityStatistics() -> SecurityStatistics {
        let eventsByType = Dictionary(grouping: securityEvents, by: { $0.type })
            .mapValues { $0.count }
        
        let recentEvents = securityEvents.filter { 
            Date().timeIntervalSince($0.timestamp) < 3600 // Last hour
        }
        
        return SecurityStatistics(
            totalEvents: securityEvents.count,
            eventsByType: eventsByType,
            recentEvents: recentEvents.count,
            securityLevel: securityLevel,
            encryptionEnabled: isEncryptionEnabled
        )
    }
    
    /// Export security log
    /// - Returns: JSON string containing security log
    public func exportSecurityLog() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let securityLog = SecurityLog(
                events: securityEvents,
                exportDate: Date(),
                securityLevel: securityLevel
            )
            let data = try encoder.encode(securityLog)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to export security log: \(error)")
            return nil
        }
    }
    
    /// Clear security events
    public func clearSecurityEvents() {
        securityEvents.removeAll()
        lastSecurityEvent = nil
    }
    
    // MARK: - Private Methods
    
    private func setupSecurityMonitoring() {
        // Monitor for security threats
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            self?.performSecurityCheck()
        }
    }
    
    private func getEncryptionKey() throws -> SymmetricKey {
        if let existingKey = try? keychain.retrieve(forKey: "notification_encryption_key") as? Data {
            return SymmetricKey(data: existingKey)
        }
        
        let newKey = SymmetricKey(size: .bits256)
        try keychain.store(newKey.withUnsafeBytes { Data($0) }, forKey: "notification_encryption_key")
        return newKey
    }
    
    private func logSecurityEvent(_ type: SecurityEventType, details: [String: Any]? = nil) {
        let event = SecurityEvent(
            type: type,
            timestamp: Date(),
            details: details
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.securityEvents.append(event)
            self?.lastSecurityEvent = event
        }
    }
    
    private func performSecurityCheck() {
        // Perform periodic security checks
        let threatLevel = assessThreatLevel()
        
        if threatLevel > securityLevel.rawValue {
            logSecurityEvent(.securityThreatDetected, details: ["threatLevel": threatLevel])
            handleSecurityThreat(threatLevel: threatLevel)
        }
    }
    
    private func assessThreatLevel() -> Int {
        // Implement threat assessment logic
        let recentEvents = securityEvents.filter { 
            Date().timeIntervalSince($0.timestamp) < 3600 
        }
        
        let failedAttempts = recentEvents.filter { 
            $0.type == .tokenValidationFailed || $0.type == .payloadVerificationFailed 
        }.count
        
        return min(failedAttempts, 5) // Scale 0-5
    }
    
    private func handleSecurityThreat(threatLevel: Int) {
        switch threatLevel {
        case 3...4:
            // Moderate threat - increase logging
            setSecurityLevel(.high)
        case 5:
            // High threat - disable sensitive operations
            setSecurityLevel(.critical)
            NotificationCenter.default.post(name: .securityThreatDetected, object: nil)
        default:
            break
        }
    }
}

// MARK: - Supporting Types

/// Security levels
public enum SecurityLevel: Int, Codable, CaseIterable {
    case low = 1
    case medium = 2
    case high = 3
    case critical = 4
}

/// Security event types
public enum SecurityEventType: String, Codable, CaseIterable {
    case payloadSigned = "payload_signed"
    case payloadVerified = "payload_verified"
    case payloadVerificationFailed = "payload_verification_failed"
    case tokenGenerated = "token_generated"
    case tokenValidated = "token_validated"
    case tokenValidationFailed = "token_validation_failed"
    case securityLevelChanged = "security_level_changed"
    case encryptionToggled = "encryption_toggled"
    case securityThreatDetected = "security_threat_detected"
}

/// Security event
public struct SecurityEvent: Codable, Identifiable {
    public let id = UUID()
    public let type: SecurityEventType
    public let timestamp: Date
    public let details: [String: Any]?
    
    public init(type: SecurityEventType, timestamp: Date, details: [String: Any]?) {
        self.type = type
        self.timestamp = timestamp
        self.details = details
    }
    
    // MARK: - Codable Implementation
    
    private enum CodingKeys: String, CodingKey {
        case type, timestamp, details
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(SecurityEventType.self, forKey: .type)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        
        if let detailsData = try container.decodeIfPresent(Data.self, forKey: .details) {
            details = try JSONSerialization.jsonObject(with: detailsData) as? [String: Any]
        } else {
            details = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(timestamp, forKey: .timestamp)
        
        if let details = details {
            let detailsData = try JSONSerialization.data(withJSONObject: details)
            try container.encode(detailsData, forKey: .details)
        }
    }
}

/// Signed payload
public struct SignedPayload: Codable {
    public let payload: NotificationPayload
    public let signature: Data
    public let timestamp: Date
}

/// Security statistics
public struct SecurityStatistics {
    public let totalEvents: Int
    public let eventsByType: [SecurityEventType: Int]
    public let recentEvents: Int
    public let securityLevel: SecurityLevel
    public let encryptionEnabled: Bool
}

/// Security log
public struct SecurityLog: Codable {
    public let events: [SecurityEvent]
    public let exportDate: Date
    public let securityLevel: SecurityLevel
}

/// Crypto manager
private class CryptoManager {
    func encrypt(_ content: String, using key: SymmetricKey) throws -> Data {
        let contentData = content.data(using: .utf8)!
        let sealedBox = try AES.GCM.seal(contentData, using: key)
        return sealedBox.combined!
    }
    
    func decrypt(_ encryptedData: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: key)
    }
    
    func sign(_ data: Data) throws -> Data {
        let privateKey = try P256.Signing.PrivateKey()
        let signature = try privateKey.signature(for: data)
        return signature.rawRepresentation
    }
    
    func verify(_ data: Data, signature: Data) throws -> Bool {
        let publicKey = try P256.Signing.PublicKey()
        let signature = try P256.Signing.ECDSASignature(rawRepresentation: signature)
        return publicKey.isValidSignature(signature, for: data)
    }
}

/// Keychain wrapper
private class KeychainWrapper {
    func store(_ data: Data, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }
    
    func store(_ string: String, forKey key: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw KeychainError.invalidData
        }
        try store(data, forKey: key)
    }
    
    func retrieve(forKey key: String) throws -> Any {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.retrieveFailed(status)
        }
        
        return result as? Data ?? result as? String ?? ""
    }
}

/// Keychain errors
private enum KeychainError: Error {
    case saveFailed(OSStatus)
    case retrieveFailed(OSStatus)
    case invalidData
}

// MARK: - Notification Extensions

extension Notification.Name {
    static let securityThreatDetected = Notification.Name("securityThreatDetected")
} 