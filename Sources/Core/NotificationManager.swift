import Foundation
import UserNotifications
import UIKit

/// Advanced notification management system for iOS applications
/// Provides comprehensive notification handling with rich media support,
/// custom actions, scheduling, and analytics tracking
@available(iOS 15.0, *)
public final class NotificationManager: NSObject {
    
    // MARK: - Singleton
    public static let shared = NotificationManager()
    
    // MARK: - Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private var analyticsDelegate: NotificationAnalyticsDelegate?
    private var customActions: [String: NotificationAction] = [:]
    private var scheduledNotifications: [String: NotificationRequest] = [:]
    
    // MARK: - Configuration
    public struct Configuration {
        public let appName: String
        public let defaultSound: UNNotificationSound?
        public let defaultBadge: Int
        public let enableAnalytics: Bool
        public let enableRichMedia: Bool
        public let enableCustomActions: Bool
        
        public init(
            appName: String,
            defaultSound: UNNotificationSound? = .default,
            defaultBadge: Int = 1,
            enableAnalytics: Bool = true,
            enableRichMedia: Bool = true,
            enableCustomActions: Bool = true
        ) {
            self.appName = appName
            self.defaultSound = defaultSound
            self.defaultBadge = defaultBadge
            self.enableAnalytics = enableAnalytics
            self.enableRichMedia = enableRichMedia
            self.enableCustomActions = enableCustomActions
        }
    }
    
    private var configuration: Configuration?
    
    // MARK: - Initialization
    private override init() {
        super.init()
        setupNotificationCenter()
    }
    
    // MARK: - Setup
    private func setupNotificationCenter() {
        notificationCenter.delegate = self
    }
    
    // MARK: - Configuration
    public func configure(with configuration: Configuration) {
        self.configuration = configuration
        setupCustomActions()
        setupAnalytics()
    }
    
    // MARK: - Permission Management
    public func requestNotificationPermissions(
        options: UNAuthorizationOptions = [.alert, .badge, .sound, .provisional],
        completion: @escaping (Bool, Error?) -> Void
    ) {
        notificationCenter.requestAuthorization(options: options) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    self?.registerForRemoteNotifications()
                    self?.analyticsDelegate?.trackPermissionGranted()
                } else {
                    self?.analyticsDelegate?.trackPermissionDenied()
                }
                completion(granted, error)
            }
        }
    }
    
    public func checkNotificationPermissions(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    // MARK: - Notification Scheduling
    public func scheduleNotification(
        _ request: NotificationRequest,
        completion: @escaping (Result<String, NotificationError>) -> Void
    ) {
        let content = createNotificationContent(from: request)
        let trigger = createNotificationTrigger(from: request)
        
        let notificationRequest = UNNotificationRequest(
            identifier: request.identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(notificationRequest) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.analyticsDelegate?.trackNotificationSchedulingFailed(error: error)
                    completion(.failure(.schedulingFailed(error)))
                } else {
                    self?.scheduledNotifications[request.identifier] = request
                    self?.analyticsDelegate?.trackNotificationScheduled(request: request)
                    completion(.success(request.identifier))
                }
            }
        }
    }
    
    public func scheduleMultipleNotifications(
        _ requests: [NotificationRequest],
        completion: @escaping (Result<[String], NotificationError>) -> Void
    ) {
        let group = DispatchGroup()
        var results: [String] = []
        var errors: [NotificationError] = []
        
        for request in requests {
            group.enter()
            scheduleNotification(request) { result in
                switch result {
                case .success(let identifier):
                    results.append(identifier)
                case .failure(let error):
                    errors.append(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if errors.isEmpty {
                completion(.success(results))
            } else {
                completion(.failure(.multipleSchedulingFailed(errors)))
            }
        }
    }
    
    // MARK: - Notification Cancellation
    public func cancelNotification(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        scheduledNotifications.removeValue(forKey: identifier)
        analyticsDelegate?.trackNotificationCancelled(identifier: identifier)
    }
    
    public func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        scheduledNotifications.removeAll()
        analyticsDelegate?.trackAllNotificationsCancelled()
    }
    
    public func cancelNotifications(withIdentifiers identifiers: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        identifiers.forEach { scheduledNotifications.removeValue(forKey: $0) }
        analyticsDelegate?.trackNotificationsCancelled(identifiers: identifiers)
    }
    
    // MARK: - Notification Content Creation
    private func createNotificationContent(from request: NotificationRequest) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = request.title
        content.body = request.body
        content.subtitle = request.subtitle
        content.sound = request.sound ?? configuration?.defaultSound
        content.badge = request.badge ?? configuration?.defaultBadge as NSNumber?
        content.categoryIdentifier = request.categoryIdentifier
        content.userInfo = request.userInfo
        
        // Rich media support
        if let imageURL = request.imageURL, configuration?.enableRichMedia == true {
            content.attachments = createAttachments(from: request)
        }
        
        // Deep linking
        if let deepLink = request.deepLink {
            content.userInfo["deepLink"] = deepLink
        }
        
        return content
    }
    
    private func createAttachments(from request: NotificationRequest) -> [UNNotificationAttachment] {
        var attachments: [UNNotificationAttachment] = []
        
        if let imageURL = request.imageURL {
            do {
                let attachment = try UNNotificationAttachment(
                    identifier: "image",
                    url: imageURL,
                    options: nil
                )
                attachments.append(attachment)
            } catch {
                analyticsDelegate?.trackAttachmentCreationFailed(error: error)
            }
        }
        
        return attachments
    }
    
    private func createNotificationTrigger(from request: NotificationRequest) -> UNNotificationTrigger? {
        switch request.trigger {
        case .immediate:
            return nil
            
        case .timeInterval(let interval):
            return UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            
        case .calendar(let dateComponents):
            return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
        case .location(let region):
            return UNLocationNotificationTrigger(region: region, repeats: false)
        }
    }
    
    // MARK: - Custom Actions
    public func registerCustomAction(_ action: NotificationAction) {
        customActions[action.identifier] = action
        setupCustomActions()
    }
    
    private func setupCustomActions() {
        guard configuration?.enableCustomActions == true else { return }
        
        let actions = customActions.values.map { action in
            UNNotificationAction(
                identifier: action.identifier,
                title: action.title,
                options: action.options
            )
        }
        
        let category = UNNotificationCategory(
            identifier: "custom_actions",
            actions: actions,
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([category])
    }
    
    // MARK: - Analytics
    private func setupAnalytics() {
        guard configuration?.enableAnalytics == true else { return }
        analyticsDelegate = NotificationAnalyticsDelegate()
    }
    
    // MARK: - Remote Notifications
    private func registerForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    public func handleRemoteNotificationRegistration(deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        analyticsDelegate?.trackDeviceTokenReceived(token: tokenString)
    }
    
    public func handleRemoteNotificationRegistrationFailed(error: Error) {
        analyticsDelegate?.trackDeviceTokenFailed(error: error)
    }
}

// MARK: - UNUserNotificationCenterDelegate
@available(iOS 15.0, *)
extension NotificationManager: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        analyticsDelegate?.trackNotificationReceived(notification: notification)
        
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        analyticsDelegate?.trackNotificationTapped(response: response)
        
        // Handle custom actions
        if let customAction = customActions[response.actionIdentifier] {
            customAction.handler?(response)
        }
        
        // Handle deep linking
        if let deepLink = response.notification.request.content.userInfo["deepLink"] as? String {
            handleDeepLink(deepLink)
        }
        
        completionHandler()
    }
    
    private func handleDeepLink(_ deepLink: String) {
        // Implement deep linking logic
        analyticsDelegate?.trackDeepLinkActivated(link: deepLink)
    }
}

// MARK: - Errors
public enum NotificationError: Error, LocalizedError {
    case schedulingFailed(Error)
    case multipleSchedulingFailed([NotificationError])
    case permissionDenied
    case invalidRequest
    
    public var errorDescription: String? {
        switch self {
        case .schedulingFailed(let error):
            return "Failed to schedule notification: \(error.localizedDescription)"
        case .multipleSchedulingFailed(let errors):
            return "Failed to schedule multiple notifications: \(errors.count) errors"
        case .permissionDenied:
            return "Notification permissions not granted"
        case .invalidRequest:
            return "Invalid notification request"
        }
    }
} 