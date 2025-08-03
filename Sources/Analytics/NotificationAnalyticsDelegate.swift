import Foundation
import UserNotifications

/// Analytics delegate for tracking notification events and user engagement
@available(iOS 15.0, *)
public protocol NotificationAnalyticsDelegate: AnyObject {
    
    // MARK: - Permission Events
    func trackPermissionGranted()
    func trackPermissionDenied()
    func trackPermissionRequested()
    
    // MARK: - Notification Events
    func trackNotificationScheduled(request: NotificationRequest)
    func trackNotificationSchedulingFailed(error: Error)
    func trackNotificationReceived(notification: UNNotification)
    func trackNotificationTapped(response: UNNotificationResponse)
    func trackNotificationCancelled(identifier: String)
    func trackNotificationsCancelled(identifiers: [String])
    func trackAllNotificationsCancelled()
    
    // MARK: - Device Token Events
    func trackDeviceTokenReceived(token: String)
    func trackDeviceTokenFailed(error: Error)
    
    // MARK: - Custom Action Events
    func trackCustomActionTriggered(actionIdentifier: String, notificationIdentifier: String)
    func trackDeepLinkActivated(link: String)
    
    // MARK: - Attachment Events
    func trackAttachmentCreationFailed(error: Error)
    func trackAttachmentCreated(identifier: String, size: Int)
    
    // MARK: - Performance Events
    func trackNotificationDeliveryTime(identifier: String, deliveryTime: TimeInterval)
    func trackNotificationProcessingTime(identifier: String, processingTime: TimeInterval)
}

/// Default implementation of NotificationAnalyticsDelegate
@available(iOS 15.0, *)
public class DefaultNotificationAnalyticsDelegate: NotificationAnalyticsDelegate {
    
    // MARK: - Properties
    private let analyticsService: NotificationAnalyticsService
    private let eventQueue = DispatchQueue(label: "notification.analytics.queue", qos: .utility)
    
    // MARK: - Initialization
    public init(analyticsService: NotificationAnalyticsService = DefaultNotificationAnalyticsService()) {
        self.analyticsService = analyticsService
    }
    
    // MARK: - Permission Events
    public func trackPermissionGranted() {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_permission_granted",
                properties: ["timestamp": Date().timeIntervalSince1970]
            )
        }
    }
    
    public func trackPermissionDenied() {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_permission_denied",
                properties: ["timestamp": Date().timeIntervalSince1970]
            )
        }
    }
    
    public func trackPermissionRequested() {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_permission_requested",
                properties: ["timestamp": Date().timeIntervalSince1970]
            )
        }
    }
    
    // MARK: - Notification Events
    public func trackNotificationScheduled(request: NotificationRequest) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_scheduled",
                properties: [
                    "identifier": request.identifier,
                    "title": request.title,
                    "priority": request.priority.rawValue,
                    "has_image": request.imageURL != nil,
                    "has_deep_link": request.deepLink != nil,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackNotificationSchedulingFailed(error: Error) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_scheduling_failed",
                properties: [
                    "error": error.localizedDescription,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackNotificationReceived(notification: UNNotification) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_received",
                properties: [
                    "identifier": notification.request.identifier,
                    "title": notification.request.content.title,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackNotificationTapped(response: UNNotificationResponse) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_tapped",
                properties: [
                    "identifier": response.notification.request.identifier,
                    "action_identifier": response.actionIdentifier,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackNotificationCancelled(identifier: String) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_cancelled",
                properties: [
                    "identifier": identifier,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackNotificationsCancelled(identifiers: [String]) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notifications_cancelled",
                properties: [
                    "identifiers": identifiers,
                    "count": identifiers.count,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackAllNotificationsCancelled() {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "all_notifications_cancelled",
                properties: ["timestamp": Date().timeIntervalSince1970]
            )
        }
    }
    
    // MARK: - Device Token Events
    public func trackDeviceTokenReceived(token: String) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "device_token_received",
                properties: [
                    "token_length": token.count,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackDeviceTokenFailed(error: Error) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "device_token_failed",
                properties: [
                    "error": error.localizedDescription,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    // MARK: - Custom Action Events
    public func trackCustomActionTriggered(actionIdentifier: String, notificationIdentifier: String) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "custom_action_triggered",
                properties: [
                    "action_identifier": actionIdentifier,
                    "notification_identifier": notificationIdentifier,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackDeepLinkActivated(link: String) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "deep_link_activated",
                properties: [
                    "link": link,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    // MARK: - Attachment Events
    public func trackAttachmentCreationFailed(error: Error) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "attachment_creation_failed",
                properties: [
                    "error": error.localizedDescription,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackAttachmentCreated(identifier: String, size: Int) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "attachment_created",
                properties: [
                    "identifier": identifier,
                    "size_bytes": size,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    // MARK: - Performance Events
    public func trackNotificationDeliveryTime(identifier: String, deliveryTime: TimeInterval) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_delivery_time",
                properties: [
                    "identifier": identifier,
                    "delivery_time_seconds": deliveryTime,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
    
    public func trackNotificationProcessingTime(identifier: String, processingTime: TimeInterval) {
        eventQueue.async { [weak self] in
            self?.analyticsService.trackEvent(
                "notification_processing_time",
                properties: [
                    "identifier": identifier,
                    "processing_time_seconds": processingTime,
                    "timestamp": Date().timeIntervalSince1970
                ]
            )
        }
    }
}

// MARK: - Analytics Service Protocol
@available(iOS 15.0, *)
public protocol NotificationAnalyticsService {
    func trackEvent(_ eventName: String, properties: [String: Any])
    func setUserProperty(_ property: String, value: Any)
    func setUserId(_ userId: String)
}

// MARK: - Default Analytics Service
@available(iOS 15.0, *)
public class DefaultNotificationAnalyticsService: NotificationAnalyticsService {
    
    private let queue = DispatchQueue(label: "analytics.service", qos: .utility)
    private var events: [[String: Any]] = []
    
    public func trackEvent(_ eventName: String, properties: [String: Any]) {
        queue.async { [weak self] in
            var event: [String: Any] = [
                "event": eventName,
                "timestamp": Date().timeIntervalSince1970
            ]
            event.merge(properties) { _, new in new }
            self?.events.append(event)
            
            // In a real implementation, you would send this to your analytics service
            print("📊 Analytics Event: \(eventName) - \(properties)")
        }
    }
    
    public func setUserProperty(_ property: String, value: Any) {
        queue.async { [weak self] in
            // In a real implementation, you would set user properties
            print("📊 User Property: \(property) = \(value)")
        }
    }
    
    public func setUserId(_ userId: String) {
        queue.async { [weak self] in
            // In a real implementation, you would set user ID
            print("📊 User ID: \(userId)")
        }
    }
} 