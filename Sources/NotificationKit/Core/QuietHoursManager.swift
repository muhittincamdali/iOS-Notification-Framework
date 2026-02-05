//
//  QuietHoursManager.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation

/// Manager for quiet hours (Do Not Disturb) functionality
@MainActor
final class QuietHoursManager: Sendable {
    
    // MARK: - Properties
    
    private var configuration: QuietHoursConfiguration?
    private var deferredNotifications: [Notification] = []
    private var startHour: Int = 0
    private var startMinute: Int = 0
    private var endHour: Int = 0
    private var endMinute: Int = 0
    
    // MARK: - Configuration
    
    func configure(_ config: QuietHoursConfiguration) {
        self.configuration = config
        parseTimeStrings(config)
    }
    
    private func parseTimeStrings(_ config: QuietHoursConfiguration) {
        // Parse start time
        let startComponents = config.startTime.split(separator: ":")
        if startComponents.count >= 2 {
            startHour = Int(startComponents[0]) ?? 0
            startMinute = Int(startComponents[1]) ?? 0
        }
        
        // Parse end time
        let endComponents = config.endTime.split(separator: ":")
        if endComponents.count >= 2 {
            endHour = Int(endComponents[0]) ?? 0
            endMinute = Int(endComponents[1]) ?? 0
        }
    }
    
    // MARK: - Quiet Hours Check
    
    /// Checks if current time is within quiet hours
    func isInQuietHours() -> Bool {
        guard configuration != nil else { return false }
        
        let now = Date()
        let calendar = Calendar.current
        
        // Check active days
        if let activeDays = configuration?.activeDays {
            let weekday = calendar.component(.weekday, from: now)
            if !activeDays.contains(weekday) {
                return false
            }
        }
        
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        
        let currentMinutes = currentHour * 60 + currentMinute
        let startMinutes = startHour * 60 + startMinute
        let endMinutes = endHour * 60 + endMinute
        
        // Handle overnight quiet hours (e.g., 22:00 - 08:00)
        if startMinutes > endMinutes {
            // Quiet hours span midnight
            return currentMinutes >= startMinutes || currentMinutes < endMinutes
        } else {
            // Normal case (e.g., 08:00 - 18:00)
            return currentMinutes >= startMinutes && currentMinutes < endMinutes
        }
    }
    
    /// Gets time until quiet hours end
    func timeUntilQuietHoursEnd() -> TimeInterval? {
        guard isInQuietHours() else { return nil }
        
        let now = Date()
        let calendar = Calendar.current
        
        var endComponents = DateComponents()
        endComponents.hour = endHour
        endComponents.minute = endMinute
        
        // Get today's end time
        var endDate = calendar.nextDate(
            after: now,
            matching: endComponents,
            matchingPolicy: .nextTime
        )
        
        // If we're past midnight and end time is tomorrow morning
        if let end = endDate {
            return end.timeIntervalSince(now)
        }
        
        return nil
    }
    
    /// Gets next quiet hours start time
    func nextQuietHoursStart() -> Date? {
        guard configuration != nil else { return nil }
        guard !isInQuietHours() else { return nil }
        
        let now = Date()
        let calendar = Calendar.current
        
        var startComponents = DateComponents()
        startComponents.hour = startHour
        startComponents.minute = startMinute
        
        return calendar.nextDate(
            after: now,
            matching: startComponents,
            matchingPolicy: .nextTime
        )
    }
    
    // MARK: - Deferred Notifications
    
    /// Defers a notification until quiet hours end
    func `defer`(_ notification: Notification) {
        deferredNotifications.append(notification)
    }
    
    /// Gets and clears deferred notifications
    func popDeferredNotifications() -> [Notification] {
        let notifications = deferredNotifications
        deferredNotifications.removeAll()
        return notifications
    }
    
    /// Gets count of deferred notifications
    var deferredCount: Int {
        deferredNotifications.count
    }
    
    /// Clears all deferred notifications
    func clearDeferred() {
        deferredNotifications.removeAll()
    }
    
    // MARK: - Override
    
    /// Checks if a notification should bypass quiet hours
    func shouldBypass(_ notification: Notification) -> Bool {
        guard let config = configuration else { return true }
        
        // Critical notifications always bypass
        if notification.interruptionLevel == .critical && config.allowCritical {
            return true
        }
        
        // Time sensitive may bypass
        if notification.interruptionLevel == .timeSensitive && config.allowTimeSensitive {
            return true
        }
        
        // Explicit bypass flag
        return notification.bypassQuietHours
    }
}

// MARK: - Public Status

/// Public information about quiet hours status
public struct QuietHoursStatus: Sendable {
    /// Whether quiet hours are currently active
    public let isActive: Bool
    
    /// Time until quiet hours end (if active)
    public let secondsUntilEnd: TimeInterval?
    
    /// Next quiet hours start time (if not active)
    public let nextStart: Date?
    
    /// Number of notifications deferred
    public let deferredCount: Int
}
