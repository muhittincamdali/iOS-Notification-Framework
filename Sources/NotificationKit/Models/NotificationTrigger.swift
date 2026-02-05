//
//  NotificationTrigger.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications
#if canImport(CoreLocation)
@preconcurrency import CoreLocation
#endif

/// Defines when a notification should be triggered
public enum NotificationTrigger: Sendable {
    /// Trigger immediately (or as soon as possible)
    case immediate
    
    /// Trigger after a time interval
    case timeInterval(TimeInterval, repeats: Bool = false)
    
    /// Trigger at a specific date
    case date(DateComponents, repeats: Bool = false)
    
    /// Trigger based on location
    #if canImport(CoreLocation) && os(iOS)
    case location(CLCircularRegion, repeats: Bool = false)
    #endif
    
    /// Trigger at next occurrence of time (smart scheduling)
    case nextOccurrence(hour: Int, minute: Int)
    
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
    
    /// Creates a time interval trigger from days
    public static func after(days: Int, repeats: Bool = false) -> NotificationTrigger {
        .timeInterval(TimeInterval(days * 86400), repeats: repeats)
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
    
    /// Creates a monthly trigger
    public static func monthly(
        on day: Int,
        at hour: Int,
        minute: Int = 0,
        repeats: Bool = true
    ) -> NotificationTrigger {
        var components = DateComponents()
        components.day = day
        components.hour = hour
        components.minute = minute
        return .date(components, repeats: repeats)
    }
    
    /// Creates a yearly trigger
    public static func yearly(
        month: Int,
        day: Int,
        at hour: Int,
        minute: Int = 0,
        repeats: Bool = true
    ) -> NotificationTrigger {
        var components = DateComponents()
        components.month = month
        components.day = day
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
    
    /// Creates a trigger for the next occurrence of a time
    public static func next(hour: Int, minute: Int = 0) -> NotificationTrigger {
        .nextOccurrence(hour: hour, minute: minute)
    }
    
    // MARK: - Location Triggers
    
    #if canImport(CoreLocation) && os(iOS)
    /// Creates a trigger for entering a region
    public static func onEnter(
        region: CLCircularRegion,
        repeats: Bool = false
    ) -> NotificationTrigger {
        var mutableRegion = region
        mutableRegion.notifyOnEntry = true
        mutableRegion.notifyOnExit = false
        return .location(mutableRegion, repeats: repeats)
    }
    
    /// Creates a trigger for exiting a region
    public static func onExit(
        region: CLCircularRegion,
        repeats: Bool = false
    ) -> NotificationTrigger {
        var mutableRegion = region
        mutableRegion.notifyOnEntry = false
        mutableRegion.notifyOnExit = true
        return .location(mutableRegion, repeats: repeats)
    }
    
    /// Creates a geofence trigger
    public static func geofence(
        latitude: Double,
        longitude: Double,
        radius: Double,
        identifier: String,
        onEntry: Bool = true,
        onExit: Bool = false,
        repeats: Bool = false
    ) -> NotificationTrigger {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        region.notifyOnEntry = onEntry
        region.notifyOnExit = onExit
        return .location(region, repeats: repeats)
    }
    #endif
    
    // MARK: - Smart Scheduling
    
    /// Gets the next fire date for this trigger
    public var nextFireDate: Date? {
        switch self {
        case .immediate:
            return Date()
            
        case let .timeInterval(interval, _):
            return Date().addingTimeInterval(interval)
            
        case let .date(components, _):
            return Calendar.current.nextDate(
                after: Date(),
                matching: components,
                matchingPolicy: .nextTime
            )
            
        case let .nextOccurrence(hour, minute):
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            return Calendar.current.nextDate(
                after: Date(),
                matching: components,
                matchingPolicy: .nextTime
            )
            
        #if canImport(CoreLocation) && os(iOS)
        case .location:
            return nil // Location-based, no specific date
        #endif
        }
    }
    
    /// Whether this trigger repeats
    public var isRepeating: Bool {
        switch self {
        case .immediate:
            return false
        case let .timeInterval(_, repeats):
            return repeats
        case let .date(_, repeats):
            return repeats
        case .nextOccurrence:
            return false
        #if canImport(CoreLocation) && os(iOS)
        case let .location(_, repeats):
            return repeats
        #endif
        }
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
            
        case let .nextOccurrence(hour, minute):
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            return UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )
            
        #if canImport(CoreLocation) && os(iOS)
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
    /// Creates a time interval from seconds
    public static func seconds(_ value: Int) -> TimeInterval {
        TimeInterval(value)
    }
    
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
    
    /// Creates a time interval from weeks
    public static func weeks(_ value: Int) -> TimeInterval {
        TimeInterval(value * 604800)
    }
}

// MARK: - Weekday Constants

extension Int {
    public static let sunday = 1
    public static let monday = 2
    public static let tuesday = 3
    public static let wednesday = 4
    public static let thursday = 5
    public static let friday = 6
    public static let saturday = 7
}
