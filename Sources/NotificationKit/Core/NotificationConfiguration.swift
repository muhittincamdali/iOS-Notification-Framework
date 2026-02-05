//
//  NotificationConfiguration.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation

/// Global configuration for NotificationKit
public struct NotificationConfiguration: Sendable {
    
    // MARK: - Properties
    
    /// Enable analytics tracking
    public var enableAnalytics: Bool = true
    
    /// Quiet hours configuration
    public var quietHours: QuietHoursConfiguration?
    
    /// Rate limiting configuration
    public var rateLimiting: RateLimitingConfiguration?
    
    /// Default sound for notifications
    public var defaultSound: String?
    
    /// Whether to show notifications in foreground
    public var showInForeground: Bool = true
    
    /// Auto-increment badge on notification
    public var autoBadgeIncrement: Bool = false
    
    /// Default notification channel
    public var defaultChannelId: String?
    
    /// Enable delivery optimization
    public var enableDeliveryOptimization: Bool = false
    
    /// Maximum pending notifications
    public var maxPendingNotifications: Int = 64
    
    /// Custom URL scheme for deep links
    public var urlScheme: String?
    
    /// Enable notification grouping
    public var enableGrouping: Bool = true
    
    /// Log level
    public var logLevel: LogLevel = .info
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Builder
    
    /// Sets quiet hours
    public mutating func quietHours(from: String, to: String, days: Set<Int>? = nil) {
        self.quietHours = QuietHoursConfiguration(
            startTime: from,
            endTime: to,
            activeDays: days
        )
    }
    
    /// Sets rate limiting
    public mutating func rateLimit(maxPerHour: Int, maxPerDay: Int? = nil) {
        self.rateLimiting = RateLimitingConfiguration(
            maxPerHour: maxPerHour,
            maxPerDay: maxPerDay
        )
    }
}

// MARK: - Quiet Hours Configuration

/// Configuration for quiet hours (Do Not Disturb)
public struct QuietHoursConfiguration: Sendable {
    /// Start time in HH:mm format
    public let startTime: String
    
    /// End time in HH:mm format
    public let endTime: String
    
    /// Days when quiet hours are active (1=Sunday, 7=Saturday)
    /// nil means every day
    public let activeDays: Set<Int>?
    
    /// Allow time sensitive notifications through
    public var allowTimeSensitive: Bool = true
    
    /// Allow critical notifications through
    public var allowCritical: Bool = true
    
    public init(
        startTime: String,
        endTime: String,
        activeDays: Set<Int>? = nil
    ) {
        self.startTime = startTime
        self.endTime = endTime
        self.activeDays = activeDays
    }
    
    /// Creates quiet hours from hour values
    public static func hours(from startHour: Int, to endHour: Int, days: Set<Int>? = nil) -> QuietHoursConfiguration {
        QuietHoursConfiguration(
            startTime: String(format: "%02d:00", startHour),
            endTime: String(format: "%02d:00", endHour),
            activeDays: days
        )
    }
    
    /// Common preset: Night time (10 PM - 8 AM)
    public static var nightTime: QuietHoursConfiguration {
        .hours(from: 22, to: 8)
    }
    
    /// Common preset: Sleep time (11 PM - 7 AM)
    public static var sleepTime: QuietHoursConfiguration {
        .hours(from: 23, to: 7)
    }
    
    /// Common preset: Work hours only (9 AM - 6 PM)
    public static var workHoursOnly: QuietHoursConfiguration {
        .hours(from: 18, to: 9)
    }
}

// MARK: - Rate Limiting Configuration

/// Configuration for rate limiting notifications
public struct RateLimitingConfiguration: Sendable {
    /// Maximum notifications per hour
    public let maxPerHour: Int
    
    /// Maximum notifications per day
    public let maxPerDay: Int?
    
    /// Burst limit (max in short period)
    public var burstLimit: Int = 3
    
    /// Burst window in seconds
    public var burstWindowSeconds: Int = 60
    
    /// Priority notifications bypass rate limit
    public var bypassForPriority: Bool = true
    
    public init(maxPerHour: Int, maxPerDay: Int? = nil) {
        self.maxPerHour = maxPerHour
        self.maxPerDay = maxPerDay
    }
    
    /// Conservative rate limiting (2/hour, 10/day)
    public static var conservative: RateLimitingConfiguration {
        RateLimitingConfiguration(maxPerHour: 2, maxPerDay: 10)
    }
    
    /// Moderate rate limiting (5/hour, 20/day)
    public static var moderate: RateLimitingConfiguration {
        RateLimitingConfiguration(maxPerHour: 5, maxPerDay: 20)
    }
    
    /// Relaxed rate limiting (10/hour, 50/day)
    public static var relaxed: RateLimitingConfiguration {
        RateLimitingConfiguration(maxPerHour: 10, maxPerDay: 50)
    }
}

// MARK: - Log Level

/// Logging level for NotificationKit
public enum LogLevel: Int, Sendable, Comparable {
    case none = 0
    case error = 1
    case warning = 2
    case info = 3
    case debug = 4
    case verbose = 5
    
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
