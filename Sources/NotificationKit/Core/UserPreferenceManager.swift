//
//  UserPreferenceManager.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation

/// Manager for user notification preferences
@MainActor
public final class UserPreferenceManager: Sendable {
    
    // MARK: - Properties
    
    private var preferences: UserNotificationPreferences
    private let userDefaultsKey = "NotificationKit.UserPreferences"
    
    // MARK: - Initialization
    
    init() {
        self.preferences = UserNotificationPreferences()
        loadPreferences()
    }
    
    // MARK: - General Preferences
    
    /// Whether notifications are globally enabled
    public var isEnabled: Bool {
        get { preferences.isEnabled }
        set {
            preferences.isEnabled = newValue
            savePreferences()
        }
    }
    
    /// Preferred notification time range
    public var preferredTimeRange: TimeRange? {
        get { preferences.preferredTimeRange }
        set {
            preferences.preferredTimeRange = newValue
            savePreferences()
        }
    }
    
    /// Frequency preference
    public var frequency: NotificationFrequency {
        get { preferences.frequency }
        set {
            preferences.frequency = newValue
            savePreferences()
        }
    }
    
    // MARK: - Category Preferences
    
    /// Sets preference for a category
    public func setCategoryEnabled(_ categoryId: String, enabled: Bool) {
        preferences.categoryPreferences[categoryId] = enabled
        savePreferences()
    }
    
    /// Gets preference for a category
    public func isCategoryEnabled(_ categoryId: String) -> Bool {
        preferences.categoryPreferences[categoryId] ?? true
    }
    
    /// Gets all category preferences
    public var categoryPreferences: [String: Bool] {
        preferences.categoryPreferences
    }
    
    // MARK: - Topic Preferences
    
    /// Subscribes to a topic
    public func subscribe(to topic: String) {
        preferences.subscribedTopics.insert(topic)
        savePreferences()
    }
    
    /// Unsubscribes from a topic
    public func unsubscribe(from topic: String) {
        preferences.subscribedTopics.remove(topic)
        savePreferences()
    }
    
    /// Checks if subscribed to a topic
    public func isSubscribed(to topic: String) -> Bool {
        preferences.subscribedTopics.contains(topic)
    }
    
    /// Gets all subscribed topics
    public var subscribedTopics: Set<String> {
        preferences.subscribedTopics
    }
    
    // MARK: - Blocked Senders
    
    /// Blocks a sender
    public func block(sender: String) {
        preferences.blockedSenders.insert(sender)
        savePreferences()
    }
    
    /// Unblocks a sender
    public func unblock(sender: String) {
        preferences.blockedSenders.remove(sender)
        savePreferences()
    }
    
    /// Checks if sender is blocked
    public func isBlocked(sender: String) -> Bool {
        preferences.blockedSenders.contains(sender)
    }
    
    // MARK: - Sound & Vibration
    
    /// Whether sound is enabled
    public var soundEnabled: Bool {
        get { preferences.soundEnabled }
        set {
            preferences.soundEnabled = newValue
            savePreferences()
        }
    }
    
    /// Whether vibration is enabled
    public var vibrationEnabled: Bool {
        get { preferences.vibrationEnabled }
        set {
            preferences.vibrationEnabled = newValue
            savePreferences()
        }
    }
    
    /// Whether badges are enabled
    public var badgesEnabled: Bool {
        get { preferences.badgesEnabled }
        set {
            preferences.badgesEnabled = newValue
            savePreferences()
        }
    }
    
    // MARK: - Preview & Privacy
    
    /// Preview mode for notifications
    public var previewMode: PreviewMode {
        get { preferences.previewMode }
        set {
            preferences.previewMode = newValue
            savePreferences()
        }
    }
    
    // MARK: - Delivery Check
    
    /// Checks if a notification should be delivered based on preferences
    func shouldDeliver(_ notification: Notification) -> Bool {
        // Check global enabled
        guard preferences.isEnabled else { return false }
        
        // Check category preference
        if let categoryId = notification.categoryIdentifier,
           let categoryEnabled = preferences.categoryPreferences[categoryId],
           !categoryEnabled {
            return false
        }
        
        // Check blocked senders
        if let sender = notification.userInfo["sender"] as? String,
           preferences.blockedSenders.contains(sender) {
            return false
        }
        
        // Check time range
        if let timeRange = preferences.preferredTimeRange,
           !isInTimeRange(timeRange) {
            // Only block low priority notifications outside preferred time
            if notification.interruptionLevel == .passive {
                return false
            }
        }
        
        // Check frequency
        return checkFrequency(notification)
    }
    
    private func isInTimeRange(_ range: TimeRange) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        
        let currentMinutes = currentHour * 60 + currentMinute
        let startMinutes = range.startHour * 60 + range.startMinute
        let endMinutes = range.endHour * 60 + range.endMinute
        
        if startMinutes < endMinutes {
            return currentMinutes >= startMinutes && currentMinutes < endMinutes
        } else {
            return currentMinutes >= startMinutes || currentMinutes < endMinutes
        }
    }
    
    private func checkFrequency(_ notification: Notification) -> Bool {
        // Frequency checking is simplified here
        // In production, would track actual notification counts
        switch preferences.frequency {
        case .all:
            return true
        case .important:
            return notification.interruptionLevel != .passive
        case .minimal:
            return notification.interruptionLevel == .critical ||
                   notification.interruptionLevel == .timeSensitive
        case .none:
            return notification.interruptionLevel == .critical
        }
    }
    
    // MARK: - Persistence
    
    private func loadPreferences() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode(UserNotificationPreferences.self, from: data) else {
            return
        }
        preferences = decoded
    }
    
    private func savePreferences() {
        if let data = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    /// Resets all preferences to defaults
    public func reset() {
        preferences = UserNotificationPreferences()
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    // MARK: - Export
    
    /// Exports preferences as dictionary
    public func export() -> [String: Any] {
        [
            "isEnabled": preferences.isEnabled,
            "frequency": preferences.frequency.rawValue,
            "soundEnabled": preferences.soundEnabled,
            "vibrationEnabled": preferences.vibrationEnabled,
            "badgesEnabled": preferences.badgesEnabled,
            "previewMode": preferences.previewMode.rawValue,
            "subscribedTopics": Array(preferences.subscribedTopics),
            "blockedSenders": Array(preferences.blockedSenders)
        ]
    }
}

// MARK: - User Notification Preferences

/// User notification preferences model
struct UserNotificationPreferences: Codable {
    var isEnabled: Bool = true
    var preferredTimeRange: TimeRange?
    var frequency: NotificationFrequency = .all
    var categoryPreferences: [String: Bool] = [:]
    var subscribedTopics: Set<String> = []
    var blockedSenders: Set<String> = []
    var soundEnabled: Bool = true
    var vibrationEnabled: Bool = true
    var badgesEnabled: Bool = true
    var previewMode: PreviewMode = .always
}

// MARK: - Time Range

/// A time range for preferred notification delivery
public struct TimeRange: Codable, Sendable {
    public let startHour: Int
    public let startMinute: Int
    public let endHour: Int
    public let endMinute: Int
    
    public init(startHour: Int, startMinute: Int = 0, endHour: Int, endMinute: Int = 0) {
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
    }
    
    /// Morning hours (8 AM - 12 PM)
    public static var morning: TimeRange {
        TimeRange(startHour: 8, endHour: 12)
    }
    
    /// Afternoon hours (12 PM - 6 PM)
    public static var afternoon: TimeRange {
        TimeRange(startHour: 12, endHour: 18)
    }
    
    /// Evening hours (6 PM - 10 PM)
    public static var evening: TimeRange {
        TimeRange(startHour: 18, endHour: 22)
    }
    
    /// Working hours (9 AM - 5 PM)
    public static var workHours: TimeRange {
        TimeRange(startHour: 9, endHour: 17)
    }
}

// MARK: - Notification Frequency

/// How frequently the user wants to receive notifications
public enum NotificationFrequency: String, Codable, Sendable, CaseIterable {
    /// All notifications
    case all
    
    /// Only important notifications
    case important
    
    /// Minimal notifications (critical/time-sensitive only)
    case minimal
    
    /// No notifications (except critical)
    case none
    
    public var displayName: String {
        switch self {
        case .all: return "All Notifications"
        case .important: return "Important Only"
        case .minimal: return "Minimal"
        case .none: return "Critical Only"
        }
    }
}

// MARK: - Preview Mode

/// How notification content should be previewed
public enum PreviewMode: String, Codable, Sendable, CaseIterable {
    /// Always show preview
    case always
    
    /// Show only when unlocked
    case whenUnlocked
    
    /// Never show preview
    case never
    
    public var displayName: String {
        switch self {
        case .always: return "Always"
        case .whenUnlocked: return "When Unlocked"
        case .never: return "Never"
        }
    }
}
