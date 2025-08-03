import Foundation
import UserNotifications

/// Advanced notification scheduler with sophisticated scheduling capabilities
@available(iOS 15.0, *)
public final class NotificationScheduler {
    
    // MARK: - Properties
    private let notificationManager = NotificationManager.shared
    private var scheduledNotifications: [String: NotificationRequest] = [:]
    private let queue = DispatchQueue(label: "notification.scheduler", qos: .utility)
    
    // MARK: - Singleton
    public static let shared = NotificationScheduler()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Advanced Scheduling
    
    /// Schedule a notification with advanced options
    public func scheduleAdvancedNotification(
        _ request: NotificationRequest,
        options: SchedulingOptions = SchedulingOptions(),
        completion: @escaping (Result<String, NotificationError>) -> Void
    ) {
        queue.async { [weak self] in
            // Validate request
            guard request.isValid else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidRequest))
                }
                return
            }
            
            // Apply scheduling options
            let modifiedRequest = self?.applySchedulingOptions(request, options: options) ?? request
            
            // Schedule notification
            self?.notificationManager.scheduleNotification(modifiedRequest) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// Schedule recurring notifications
    public func scheduleRecurringNotification(
        _ request: NotificationRequest,
        recurrence: RecurrencePattern,
        completion: @escaping (Result<[String], NotificationError>) -> Void
    ) {
        queue.async { [weak self] in
            let identifiers = self?.createRecurringNotifications(request, recurrence: recurrence) ?? []
            
            self?.notificationManager.scheduleMultipleNotifications(identifiers) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// Schedule location-based notifications
    public func scheduleLocationNotification(
        _ request: NotificationRequest,
        region: CLCircularRegion,
        completion: @escaping (Result<String, NotificationError>) -> Void
    ) {
        let locationRequest = NotificationRequest.builder()
            .identifier(request.identifier)
            .title(request.title)
            .body(request.body)
            .subtitle(request.subtitle)
            .sound(request.sound)
            .badge(request.badge)
            .categoryIdentifier(request.categoryIdentifier)
            .userInfo(request.userInfo)
            .trigger(.location(region))
            .imageURL(request.imageURL)
            .deepLink(request.deepLink)
            .priority(request.priority)
            .expirationDate(request.expirationDate)
            .customData(request.customData)
            .build()
        
        notificationManager.scheduleNotification(locationRequest, completion: completion)
    }
    
    /// Schedule smart notifications based on user behavior
    public func scheduleSmartNotification(
        _ request: NotificationRequest,
        userBehavior: UserBehavior,
        completion: @escaping (Result<String, NotificationError>) -> Void
    ) {
        queue.async { [weak self] in
            let optimizedRequest = self?.optimizeForUserBehavior(request, behavior: userBehavior) ?? request
            
            self?.notificationManager.scheduleNotification(optimizedRequest) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    // MARK: - Batch Operations
    
    /// Schedule multiple notifications with different strategies
    public func scheduleBatchNotifications(
        _ requests: [NotificationRequest],
        strategy: BatchStrategy = .sequential,
        completion: @escaping (Result<[String], NotificationError>) -> Void
    ) {
        queue.async { [weak self] in
            switch strategy {
            case .sequential:
                self?.scheduleSequentially(requests, completion: completion)
            case .parallel:
                self?.scheduleInParallel(requests, completion: completion)
            case .smart:
                self?.scheduleWithSmartStrategy(requests, completion: completion)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func applySchedulingOptions(
        _ request: NotificationRequest,
        options: SchedulingOptions
    ) -> NotificationRequest {
        var modifiedRequest = request
        
        if let delay = options.delay {
            modifiedRequest = NotificationRequest.builder()
                .identifier(request.identifier)
                .title(request.title)
                .body(request.body)
                .subtitle(request.subtitle)
                .sound(request.sound)
                .badge(request.badge)
                .categoryIdentifier(request.categoryIdentifier)
                .userInfo(request.userInfo)
                .trigger(.timeInterval(delay))
                .imageURL(request.imageURL)
                .deepLink(request.deepLink)
                .priority(options.priority ?? request.priority)
                .expirationDate(options.expirationDate ?? request.expirationDate)
                .customData(request.customData)
                .build()
        }
        
        return modifiedRequest
    }
    
    private func createRecurringNotifications(
        _ request: NotificationRequest,
        recurrence: RecurrencePattern
    ) -> [NotificationRequest] {
        var notifications: [NotificationRequest] = []
        
        switch recurrence {
        case .daily(let count):
            for i in 0..<count {
                let date = Calendar.current.date(byAdding: .day, value: i, to: Date()) ?? Date()
                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                
                let recurringRequest = NotificationRequest.builder()
                    .identifier("\(request.identifier)_\(i)")
                    .title(request.title)
                    .body(request.body)
                    .subtitle(request.subtitle)
                    .sound(request.sound)
                    .badge(request.badge)
                    .categoryIdentifier(request.categoryIdentifier)
                    .userInfo(request.userInfo)
                    .trigger(.calendar(components))
                    .imageURL(request.imageURL)
                    .deepLink(request.deepLink)
                    .priority(request.priority)
                    .expirationDate(request.expirationDate)
                    .customData(request.customData)
                    .build()
                
                notifications.append(recurringRequest)
            }
            
        case .weekly(let count, let weekday):
            for i in 0..<count {
                let date = Calendar.current.date(byAdding: .weekOfYear, value: i, to: Date()) ?? Date()
                var components = Calendar.current.dateComponents([.hour, .minute], from: date)
                components.weekday = weekday
                
                let recurringRequest = NotificationRequest.builder()
                    .identifier("\(request.identifier)_week_\(i)")
                    .title(request.title)
                    .body(request.body)
                    .subtitle(request.subtitle)
                    .sound(request.sound)
                    .badge(request.badge)
                    .categoryIdentifier(request.categoryIdentifier)
                    .userInfo(request.userInfo)
                    .trigger(.calendar(components))
                    .imageURL(request.imageURL)
                    .deepLink(request.deepLink)
                    .priority(request.priority)
                    .expirationDate(request.expirationDate)
                    .customData(request.customData)
                    .build()
                
                notifications.append(recurringRequest)
            }
            
        case .monthly(let count, let day):
            for i in 0..<count {
                let date = Calendar.current.date(byAdding: .month, value: i, to: Date()) ?? Date()
                var components = Calendar.current.dateComponents([.hour, .minute], from: date)
                components.day = day
                
                let recurringRequest = NotificationRequest.builder()
                    .identifier("\(request.identifier)_month_\(i)")
                    .title(request.title)
                    .body(request.body)
                    .subtitle(request.subtitle)
                    .sound(request.sound)
                    .badge(request.badge)
                    .categoryIdentifier(request.categoryIdentifier)
                    .userInfo(request.userInfo)
                    .trigger(.calendar(components))
                    .imageURL(request.imageURL)
                    .deepLink(request.deepLink)
                    .priority(request.priority)
                    .expirationDate(request.expirationDate)
                    .customData(request.customData)
                    .build()
                
                notifications.append(recurringRequest)
            }
        }
        
        return notifications
    }
    
    private func optimizeForUserBehavior(
        _ request: NotificationRequest,
        behavior: UserBehavior
    ) -> NotificationRequest {
        var optimizedRequest = request
        
        // Adjust timing based on user behavior
        if let optimalTime = behavior.optimalNotificationTime {
            let components = Calendar.current.dateComponents([.hour, .minute], from: optimalTime)
            
            optimizedRequest = NotificationRequest.builder()
                .identifier(request.identifier)
                .title(request.title)
                .body(request.body)
                .subtitle(request.subtitle)
                .sound(request.sound)
                .badge(request.badge)
                .categoryIdentifier(request.categoryIdentifier)
                .userInfo(request.userInfo)
                .trigger(.calendar(components))
                .imageURL(request.imageURL)
                .deepLink(request.deepLink)
                .priority(behavior.preferredPriority ?? request.priority)
                .expirationDate(request.expirationDate)
                .customData(request.customData)
                .build()
        }
        
        return optimizedRequest
    }
    
    private func scheduleSequentially(
        _ requests: [NotificationRequest],
        completion: @escaping (Result<[String], NotificationError>) -> Void
    ) {
        let group = DispatchGroup()
        var results: [String] = []
        var errors: [NotificationError] = []
        
        for request in requests {
            group.enter()
            notificationManager.scheduleNotification(request) { result in
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
    
    private func scheduleInParallel(
        _ requests: [NotificationRequest],
        completion: @escaping (Result<[String], NotificationError>) -> Void
    ) {
        notificationManager.scheduleMultipleNotifications(requests, completion: completion)
    }
    
    private func scheduleWithSmartStrategy(
        _ requests: [NotificationRequest],
        completion: @escaping (Result<[String], NotificationError>) -> Void
    ) {
        // Smart scheduling based on notification priority and user behavior
        let sortedRequests = requests.sorted { $0.priority.rawValue > $1.priority.rawValue }
        scheduleInParallel(sortedRequests, completion: completion)
    }
}

// MARK: - Supporting Types

@available(iOS 15.0, *)
public struct SchedulingOptions {
    public let delay: TimeInterval?
    public let priority: NotificationPriority?
    public let expirationDate: Date?
    public let retryCount: Int
    
    public init(
        delay: TimeInterval? = nil,
        priority: NotificationPriority? = nil,
        expirationDate: Date? = nil,
        retryCount: Int = 0
    ) {
        self.delay = delay
        self.priority = priority
        self.expirationDate = expirationDate
        self.retryCount = retryCount
    }
}

@available(iOS 15.0, *)
public enum RecurrencePattern {
    case daily(count: Int)
    case weekly(count: Int, weekday: Int)
    case monthly(count: Int, day: Int)
}

@available(iOS 15.0, *)
public struct UserBehavior {
    public let optimalNotificationTime: Date?
    public let preferredPriority: NotificationPriority?
    public let engagementRate: Double
    public let responseTime: TimeInterval
    
    public init(
        optimalNotificationTime: Date? = nil,
        preferredPriority: NotificationPriority? = nil,
        engagementRate: Double = 0.5,
        responseTime: TimeInterval = 300
    ) {
        self.optimalNotificationTime = optimalNotificationTime
        self.preferredPriority = preferredPriority
        self.engagementRate = engagementRate
        self.responseTime = responseTime
    }
}

@available(iOS 15.0, *)
public enum BatchStrategy {
    case sequential
    case parallel
    case smart
} 