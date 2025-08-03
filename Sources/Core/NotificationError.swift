//
//  NotificationError.swift
//  NotificationFramework
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// Errors that can occur during notification operations.
///
/// This enum provides comprehensive error handling for all notification-related
/// operations, including permission requests, scheduling, and content creation.
///
/// ## Example Usage
/// ```swift
/// do {
///     try await notificationManager.requestPermissions()
/// } catch NotificationError.permissionDenied {
///     print("User denied notification permissions")
/// } catch {
///     print("Other error: \(error)")
/// }
/// ```
@available(iOS 15.0, *)
public enum NotificationError: LocalizedError, CustomStringConvertible {
    
    // MARK: - Permission Errors
    
    /// Permission was denied by the user.
    case permissionDenied
    
    /// Permission request failed due to system error.
    case permissionRequestFailed(Error)
    
    /// Permission is not available on this device.
    case permissionNotAvailable
    
    /// Permission is temporarily unavailable.
    case permissionTemporarilyUnavailable
    
    // MARK: - Scheduling Errors
    
    /// Failed to schedule a notification.
    case schedulingFailed(Error)
    
    /// Invalid notification content.
    case invalidContent(String)
    
    /// Invalid notification date (past date).
    case invalidDate(Date)
    
    /// Too many notifications scheduled.
    case tooManyNotifications(Int)
    
    /// Notification identifier already exists.
    case duplicateIdentifier(String)
    
    /// Invalid notification identifier.
    case invalidIdentifier(String)
    
    // MARK: - Content Errors
    
    /// Failed to create notification content.
    case contentCreationFailed(Error)
    
    /// Invalid media attachment.
    case invalidMediaAttachment(String)
    
    /// Media file not found.
    case mediaFileNotFound(URL)
    
    /// Media file too large.
    case mediaFileTooLarge(Int64, Int64)
    
    /// Unsupported media type.
    case unsupportedMediaType(String)
    
    /// Failed to download media.
    case mediaDownloadFailed(Error)
    
    // MARK: - Action Errors
    
    /// Invalid notification action.
    case invalidAction(String)
    
    /// Action identifier already exists.
    case duplicateActionIdentifier(String)
    
    /// Action handler not found.
    case actionHandlerNotFound(String)
    
    /// Failed to register action handler.
    case actionHandlerRegistrationFailed(Error)
    
    // MARK: - Analytics Errors
    
    /// Failed to track analytics event.
    case analyticsTrackingFailed(Error)
    
    /// Failed to export analytics data.
    case exportFailed(Error)
    
    /// Analytics data corrupted.
    case analyticsDataCorrupted
    
    /// Analytics service unavailable.
    case analyticsServiceUnavailable
    
    // MARK: - System Errors
    
    /// System notification center unavailable.
    case notificationCenterUnavailable
    
    /// Device not supported.
    case deviceNotSupported
    
    /// iOS version not supported.
    case iOSVersionNotSupported(Int)
    
    /// Memory allocation failed.
    case memoryAllocationFailed
    
    /// Disk space insufficient.
    case diskSpaceInsufficient
    
    // MARK: - Network Errors
    
    /// Network connection failed.
    case networkConnectionFailed(Error)
    
    /// Server error.
    case serverError(Int)
    
    /// Request timeout.
    case requestTimeout(TimeInterval)
    
    /// Invalid server response.
    case invalidServerResponse
    
    // MARK: - Security Errors
    
    /// Authentication failed.
    case authenticationFailed
    
    /// Authorization denied.
    case authorizationDenied
    
    /// Certificate validation failed.
    case certificateValidationFailed
    
    /// Encryption failed.
    case encryptionFailed(Error)
    
    // MARK: - Custom Errors
    
    /// Custom error with message.
    case custom(String)
    
    /// Unknown error.
    case unknown(Error)
    
    // MARK: - LocalizedError
    
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Notification permissions were denied by the user"
        case .permissionRequestFailed(let error):
            return "Permission request failed: \(error.localizedDescription)"
        case .permissionNotAvailable:
            return "Notification permissions are not available on this device"
        case .permissionTemporarilyUnavailable:
            return "Notification permissions are temporarily unavailable"
        case .schedulingFailed(let error):
            return "Failed to schedule notification: \(error.localizedDescription)"
        case .invalidContent(let message):
            return "Invalid notification content: \(message)"
        case .invalidDate(let date):
            return "Invalid notification date: \(date) (must be in the future)"
        case .tooManyNotifications(let count):
            return "Too many notifications scheduled: \(count) (maximum allowed)"
        case .duplicateIdentifier(let identifier):
            return "Notification identifier already exists: \(identifier)"
        case .invalidIdentifier(let identifier):
            return "Invalid notification identifier: \(identifier)"
        case .contentCreationFailed(let error):
            return "Failed to create notification content: \(error.localizedDescription)"
        case .invalidMediaAttachment(let message):
            return "Invalid media attachment: \(message)"
        case .mediaFileNotFound(let url):
            return "Media file not found: \(url)"
        case .mediaFileTooLarge(let actual, let maximum):
            return "Media file too large: \(actual) bytes (maximum: \(maximum) bytes)"
        case .unsupportedMediaType(let type):
            return "Unsupported media type: \(type)"
        case .mediaDownloadFailed(let error):
            return "Failed to download media: \(error.localizedDescription)"
        case .invalidAction(let message):
            return "Invalid notification action: \(message)"
        case .duplicateActionIdentifier(let identifier):
            return "Action identifier already exists: \(identifier)"
        case .actionHandlerNotFound(let identifier):
            return "Action handler not found: \(identifier)"
        case .actionHandlerRegistrationFailed(let error):
            return "Failed to register action handler: \(error.localizedDescription)"
        case .analyticsTrackingFailed(let error):
            return "Failed to track analytics event: \(error.localizedDescription)"
        case .exportFailed(let error):
            return "Failed to export analytics data: \(error.localizedDescription)"
        case .analyticsDataCorrupted:
            return "Analytics data is corrupted"
        case .analyticsServiceUnavailable:
            return "Analytics service is unavailable"
        case .notificationCenterUnavailable:
            return "System notification center is unavailable"
        case .deviceNotSupported:
            return "This device does not support notifications"
        case .iOSVersionNotSupported(let version):
            return "iOS version \(version) is not supported (minimum: 15.0)"
        case .memoryAllocationFailed:
            return "Memory allocation failed"
        case .diskSpaceInsufficient:
            return "Insufficient disk space"
        case .networkConnectionFailed(let error):
            return "Network connection failed: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error: HTTP \(code)"
        case .requestTimeout(let timeout):
            return "Request timeout after \(timeout) seconds"
        case .invalidServerResponse:
            return "Invalid server response"
        case .authenticationFailed:
            return "Authentication failed"
        case .authorizationDenied:
            return "Authorization denied"
        case .certificateValidationFailed:
            return "Certificate validation failed"
        case .encryptionFailed(let error):
            return "Encryption failed: \(error.localizedDescription)"
        case .custom(let message):
            return message
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .permissionDenied:
            return "User explicitly denied notification permissions"
        case .permissionRequestFailed:
            return "System error during permission request"
        case .permissionNotAvailable:
            return "Device does not support notification permissions"
        case .permissionTemporarilyUnavailable:
            return "Permission service temporarily unavailable"
        case .schedulingFailed:
            return "System error during notification scheduling"
        case .invalidContent:
            return "Notification content does not meet requirements"
        case .invalidDate:
            return "Notification date must be in the future"
        case .tooManyNotifications:
            return "System limit exceeded for scheduled notifications"
        case .duplicateIdentifier:
            return "Notification identifier must be unique"
        case .invalidIdentifier:
            return "Notification identifier format is invalid"
        case .contentCreationFailed:
            return "Error creating notification content object"
        case .invalidMediaAttachment:
            return "Media attachment does not meet requirements"
        case .mediaFileNotFound:
            return "Media file does not exist at specified URL"
        case .mediaFileTooLarge:
            return "Media file exceeds size limits"
        case .unsupportedMediaType:
            return "Media type is not supported by the system"
        case .mediaDownloadFailed:
            return "Network error during media download"
        case .invalidAction:
            return "Action configuration is invalid"
        case .duplicateActionIdentifier:
            return "Action identifier must be unique within category"
        case .actionHandlerNotFound:
            return "No handler registered for action identifier"
        case .actionHandlerRegistrationFailed:
            return "Error registering action handler"
        case .analyticsTrackingFailed:
            return "Error during analytics data collection"
        case .exportFailed:
            return "Error writing analytics data to file"
        case .analyticsDataCorrupted:
            return "Analytics data structure is invalid"
        case .analyticsServiceUnavailable:
            return "Analytics service is not responding"
        case .notificationCenterUnavailable:
            return "System notification center is not accessible"
        case .deviceNotSupported:
            return "Device hardware does not support notifications"
        case .iOSVersionNotSupported:
            return "iOS version is below minimum requirement"
        case .memoryAllocationFailed:
            return "System memory is insufficient"
        case .diskSpaceInsufficient:
            return "Device storage is insufficient"
        case .networkConnectionFailed:
            return "Network connection is unavailable"
        case .serverError:
            return "Remote server returned error"
        case .requestTimeout:
            return "Network request exceeded time limit"
        case .invalidServerResponse:
            return "Server response format is invalid"
        case .authenticationFailed:
            return "User credentials are invalid"
        case .authorizationDenied:
            return "User lacks required permissions"
        case .certificateValidationFailed:
            return "SSL certificate is invalid"
        case .encryptionFailed:
            return "Data encryption process failed"
        case .custom:
            return "Custom error condition"
        case .unknown:
            return "Unexpected error occurred"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .permissionDenied:
            return "Request permissions again or guide user to Settings"
        case .permissionRequestFailed:
            return "Check system status and try again"
        case .permissionNotAvailable:
            return "Notifications are not supported on this device"
        case .permissionTemporarilyUnavailable:
            return "Wait and try again later"
        case .schedulingFailed:
            return "Check notification settings and try again"
        case .invalidContent:
            return "Review notification content requirements"
        case .invalidDate:
            return "Use a future date for notification scheduling"
        case .tooManyNotifications:
            return "Remove some existing notifications first"
        case .duplicateIdentifier:
            return "Use a unique identifier for each notification"
        case .invalidIdentifier:
            return "Use only alphanumeric characters and underscores"
        case .contentCreationFailed:
            return "Check content parameters and try again"
        case .invalidMediaAttachment:
            return "Verify media file format and size"
        case .mediaFileNotFound:
            return "Check file path and permissions"
        case .mediaFileTooLarge:
            return "Use a smaller media file"
        case .unsupportedMediaType:
            return "Use a supported media format"
        case .mediaDownloadFailed:
            return "Check network connection and try again"
        case .invalidAction:
            return "Review action configuration"
        case .duplicateActionIdentifier:
            return "Use unique identifiers for actions"
        case .actionHandlerNotFound:
            return "Register a handler for this action"
        case .actionHandlerRegistrationFailed:
            return "Check handler implementation and try again"
        case .analyticsTrackingFailed:
            return "Check analytics service status"
        case .exportFailed:
            return "Check file permissions and disk space"
        case .analyticsDataCorrupted:
            return "Reset analytics data"
        case .analyticsServiceUnavailable:
            return "Try again when service is available"
        case .notificationCenterUnavailable:
            return "Check system notification settings"
        case .deviceNotSupported:
            return "Use a device that supports notifications"
        case .iOSVersionNotSupported:
            return "Update to iOS 15.0 or later"
        case .memoryAllocationFailed:
            return "Close other apps and try again"
        case .diskSpaceInsufficient:
            return "Free up storage space"
        case .networkConnectionFailed:
            return "Check internet connection"
        case .serverError:
            return "Try again later or contact support"
        case .requestTimeout:
            return "Check network speed and try again"
        case .invalidServerResponse:
            return "Contact support for server issues"
        case .authenticationFailed:
            return "Check user credentials"
        case .authorizationDenied:
            return "Request appropriate permissions"
        case .certificateValidationFailed:
            return "Check SSL certificate configuration"
        case .encryptionFailed:
            return "Check encryption settings"
        case .custom:
            return "Review error details and try again"
        case .unknown:
            return "Contact support with error details"
        }
    }
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        return errorDescription ?? "Unknown notification error"
    }
    
    // MARK: - Error Code
    
    /// Returns the error code for this error.
    public var errorCode: Int {
        switch self {
        case .permissionDenied:
            return 1001
        case .permissionRequestFailed:
            return 1002
        case .permissionNotAvailable:
            return 1003
        case .permissionTemporarilyUnavailable:
            return 1004
        case .schedulingFailed:
            return 2001
        case .invalidContent:
            return 2002
        case .invalidDate:
            return 2003
        case .tooManyNotifications:
            return 2004
        case .duplicateIdentifier:
            return 2005
        case .invalidIdentifier:
            return 2006
        case .contentCreationFailed:
            return 3001
        case .invalidMediaAttachment:
            return 3002
        case .mediaFileNotFound:
            return 3003
        case .mediaFileTooLarge:
            return 3004
        case .unsupportedMediaType:
            return 3005
        case .mediaDownloadFailed:
            return 3006
        case .invalidAction:
            return 4001
        case .duplicateActionIdentifier:
            return 4002
        case .actionHandlerNotFound:
            return 4003
        case .actionHandlerRegistrationFailed:
            return 4004
        case .analyticsTrackingFailed:
            return 5001
        case .exportFailed:
            return 5002
        case .analyticsDataCorrupted:
            return 5003
        case .analyticsServiceUnavailable:
            return 5004
        case .notificationCenterUnavailable:
            return 6001
        case .deviceNotSupported:
            return 6002
        case .iOSVersionNotSupported:
            return 6003
        case .memoryAllocationFailed:
            return 6004
        case .diskSpaceInsufficient:
            return 6005
        case .networkConnectionFailed:
            return 7001
        case .serverError:
            return 7002
        case .requestTimeout:
            return 7003
        case .invalidServerResponse:
            return 7004
        case .authenticationFailed:
            return 8001
        case .authorizationDenied:
            return 8002
        case .certificateValidationFailed:
            return 8003
        case .encryptionFailed:
            return 8004
        case .custom:
            return 9001
        case .unknown:
            return 9999
        }
    }
}

// MARK: - Error Extensions

@available(iOS 15.0, *)
extension NotificationError {
    
    /// Checks if the error is related to permissions.
    public var isPermissionError: Bool {
        switch self {
        case .permissionDenied, .permissionRequestFailed, .permissionNotAvailable, .permissionTemporarilyUnavailable:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the error is related to scheduling.
    public var isSchedulingError: Bool {
        switch self {
        case .schedulingFailed, .invalidContent, .invalidDate, .tooManyNotifications, .duplicateIdentifier, .invalidIdentifier:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the error is related to content creation.
    public var isContentError: Bool {
        switch self {
        case .contentCreationFailed, .invalidMediaAttachment, .mediaFileNotFound, .mediaFileTooLarge, .unsupportedMediaType, .mediaDownloadFailed:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the error is related to actions.
    public var isActionError: Bool {
        switch self {
        case .invalidAction, .duplicateActionIdentifier, .actionHandlerNotFound, .actionHandlerRegistrationFailed:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the error is related to analytics.
    public var isAnalyticsError: Bool {
        switch self {
        case .analyticsTrackingFailed, .exportFailed, .analyticsDataCorrupted, .analyticsServiceUnavailable:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the error is related to system issues.
    public var isSystemError: Bool {
        switch self {
        case .notificationCenterUnavailable, .deviceNotSupported, .iOSVersionNotSupported, .memoryAllocationFailed, .diskSpaceInsufficient:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the error is related to network issues.
    public var isNetworkError: Bool {
        switch self {
        case .networkConnectionFailed, .serverError, .requestTimeout, .invalidServerResponse:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the error is related to security issues.
    public var isSecurityError: Bool {
        switch self {
        case .authenticationFailed, .authorizationDenied, .certificateValidationFailed, .encryptionFailed:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the error is recoverable.
    public var isRecoverable: Bool {
        switch self {
        case .permissionDenied, .permissionRequestFailed, .schedulingFailed, .invalidContent, .invalidDate, .duplicateIdentifier, .contentCreationFailed, .invalidMediaAttachment, .mediaFileNotFound, .mediaFileTooLarge, .unsupportedMediaType, .mediaDownloadFailed, .invalidAction, .duplicateActionIdentifier, .actionHandlerRegistrationFailed, .analyticsTrackingFailed, .exportFailed, .analyticsServiceUnavailable, .notificationCenterUnavailable, .memoryAllocationFailed, .diskSpaceInsufficient, .networkConnectionFailed, .serverError, .requestTimeout, .invalidServerResponse, .authenticationFailed, .authorizationDenied, .certificateValidationFailed, .encryptionFailed, .custom:
            return true
        case .permissionNotAvailable, .permissionTemporarilyUnavailable, .tooManyNotifications, .invalidIdentifier, .actionHandlerNotFound, .analyticsDataCorrupted, .deviceNotSupported, .iOSVersionNotSupported, .unknown:
            return false
        }
    }
} 