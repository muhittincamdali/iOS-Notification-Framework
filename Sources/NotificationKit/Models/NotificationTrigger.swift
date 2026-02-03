//
//  NotificationTrigger.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// Defines when a notification should be triggered
public enum NotificationTrigger: Sendable {
    /// Trigger immediately (or as soon as possible)
    case immediate
    
    /// Trigger after a time interval
    case timeInterval(TimeInterval, repeats: Bool = false)
    
    /// Trigger at a specific date
    case date(DateComponents, repeats: Bool = false)
    
    /// Trigger based on location
    #if canImport(CoreLocation)
    case location(CLRegion, repeats: Bool = false)
    #endif
    
    // MARK: - Convenience Factories
    
    /// Creates a time interval trigger
    /// - Parameters:
    ///   - interval: The time interval in seconds
    ///   - repeats: Whether the notification should repeat
    /// - Returns: A time interval trigger
    public static func after(seconds: TimeInterval, repeats: Bool = false) -> NotificationTrigger {
        .timeInterval(seconds, repeats: repeats)
    }
    
    /// Creates a time interval trigger from minutes
    /// - Parameters:
    ///   - minutes: The number of minutes
    ///   - repeats: Whether the notification should repeat
    /// - Returns: A time interval trigger
    public static func after(minutes: Int, repeats: Bool = false) -> NotificationTrigger {
        .timeInterval(TimeInterval(minutes * 60), repeats: repeats)
    }
    
    /// Creates a time interval trigger from hours
    /// - Parameters:
    ///   - hours: The number of hours
    ///   - repeats: Whether the notification should repeat
    /// - Returns: A time interval trigger
    public static func after(hours: Int, repeats: Bool = false) -> NotificationTrigger {
        .timeInterval(TimeInterval(hours * 3600), repeats: repeats)
    }
    
    /// Creates a calendar trigger for a specific time of day
    /// - Parameters:
    ///   - hour: The hour (0-23)
    ///   - minute: The minute (0-59)
    ///   - repeats: Whether the notification should repeat daily
    /// - Returns: A calendar trigger
    public static func daily(at hour: Int, minute: Int = 0, repeats: Bool = true) -> NotificationTrigger {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return .date(components, repeats: repeats)
    }
    
    /// Creates a calendar trigger for a specific day of the week
    /// - Parameters:
    ///   - weekday: The weekday (1 = Sunday, 7 = Saturday)
    ///   - hour: The hour (0-23)
    ///   - minute: The minute (0-59)
    ///   - repeats: Whether the notification should repeat weekly
    /// - Returns: A calendar trigger
    public static func weekly(
        on weekday: Int,
        at hour: Int,
        minute: Int = 0,
        repeats: Bool = true
    ) -> NotificationTrigger {
        var components = DateComponents()
        components.weekday = weekday
        components.hour = hour
        components.minute = minute
        return .date(components, repeats: repeats)
    }
    
    /// Creates a calendar trigger for a specific date
    /// - Parameters:
    ///   - date: The target date
    ///   - repeats: Whether the notification should repeat
    /// - Returns: A calendar trigger
    public static func on(date: Date, repeats: Bool = false) -> NotificationTrigger {
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        return .date(components, repeats: repeats)
    }
    
    // MARK: - Conversion
    
    /// Converts to a UNNotificationTrigger
    func toUNTrigger() -> UNNotificationTrigger? {
        switch self {
        case .immediate:
            return nil
            
        case let .timeInterval(interval, repeats):
            return UNTimeIntervalNotificationTrigger(
                timeInterval: max(1, interval),
                repeats: repeats
            )
            
        case let .date(components, repeats):
            return UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: repeats
            )
            
        #if canImport(CoreLocation)
        case let .location(region, repeats):
            return UNLocationNotificationTrigger(
                region: region,
                repeats: repeats
            )
        #endif
        }
    }
}

// MARK: - Time Interval Extensions

extension TimeInterval {
    /// Creates a time interval from minutes
    public static func minutes(_ value: Int) -> TimeInterval {
        TimeInterval(value * 60)
    }
    
    /// Creates a time interval from hours
    public static func hours(_ value: Int) -> TimeInterval {
        TimeInterval(value * 3600)
    }
    
    /// Creates a time interval from days
    public static func days(_ value: Int) -> TimeInterval {
        TimeInterval(value * 86400)
    }
}

#if canImport(CoreLocation)
import CoreLocation
#endif
