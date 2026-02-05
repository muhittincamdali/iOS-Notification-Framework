//
//  ChannelManager.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications

/// Manager for notification channels (like Android notification channels)
@MainActor
public final class ChannelManager: Sendable {
    
    // MARK: - Properties
    
    private var channels: [String: NotificationChannel] = [:]
    private let userDefaultsKey = "NotificationKit.Channels"
    
    // MARK: - Initialization
    
    init() {
        loadChannels()
    }
    
    // MARK: - Channel Management
    
    /// Creates a new notification channel
    public func create(_ channel: NotificationChannel) {
        channels[channel.id] = channel
        saveChannels()
    }
    
    /// Creates multiple channels
    public func create(_ channels: [NotificationChannel]) {
        for channel in channels {
            self.channels[channel.id] = channel
        }
        saveChannels()
    }
    
    /// Gets a channel by ID
    public func channel(id: String) -> NotificationChannel? {
        channels[id]
    }
    
    /// Gets all channels
    public func allChannels() -> [NotificationChannel] {
        Array(channels.values).sorted { $0.name < $1.name }
    }
    
    /// Updates a channel
    public func update(_ channel: NotificationChannel) {
        channels[channel.id] = channel
        saveChannels()
    }
    
    /// Deletes a channel
    public func delete(id: String) {
        channels.removeValue(forKey: id)
        saveChannels()
    }
    
    /// Checks if a channel is enabled
    public func isChannelEnabled(_ id: String) -> Bool {
        guard let channel = channels[id] else { return true }
        return channel.isEnabled
    }
    
    /// Enables a channel
    public func enable(id: String) {
        if var channel = channels[id] {
            channel.isEnabled = true
            channels[id] = channel
            saveChannels()
        }
    }
    
    /// Disables a channel
    public func disable(id: String) {
        if var channel = channels[id] {
            channel.isEnabled = false
            channels[id] = channel
            saveChannels()
        }
    }
    
    // MARK: - Channel Groups
    
    /// Gets channels in a group
    public func channels(in group: String) -> [NotificationChannel] {
        channels.values.filter { $0.groupId == group }
    }
    
    // MARK: - Persistence
    
    private func loadChannels() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([String: NotificationChannel].self, from: data) else {
            return
        }
        channels = decoded
    }
    
    private func saveChannels() {
        if let data = try? JSONEncoder().encode(channels) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    /// Resets all channels
    public func reset() {
        channels.removeAll()
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}

// MARK: - Notification Channel

/// A notification channel for grouping related notifications
public struct NotificationChannel: Codable, Sendable, Identifiable {
    
    /// Unique channel identifier
    public let id: String
    
    /// Channel display name
    public var name: String
    
    /// Channel description
    public var description: String
    
    /// Channel group ID
    public var groupId: String?
    
    /// Whether the channel is enabled
    public var isEnabled: Bool
    
    /// Importance level
    public var importance: ChannelImportance
    
    /// Sound name (nil for default)
    public var sound: String?
    
    /// Whether to show badge
    public var showBadge: Bool
    
    /// Whether vibration is enabled
    public var vibrationEnabled: Bool
    
    /// LED color (hex)
    public var ledColor: String?
    
    /// Bypass DND
    public var bypassDND: Bool
    
    // MARK: - Initialization
    
    public init(
        id: String,
        name: String,
        description: String = "",
        importance: ChannelImportance = .default
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.importance = importance
        self.isEnabled = true
        self.showBadge = true
        self.vibrationEnabled = true
        self.bypassDND = false
    }
    
    // MARK: - Builder Methods
    
    /// Sets the channel group
    public func group(_ groupId: String) -> NotificationChannel {
        var copy = self
        copy.groupId = groupId
        return copy
    }
    
    /// Sets the sound
    public func sound(_ name: String) -> NotificationChannel {
        var copy = self
        copy.sound = name
        return copy
    }
    
    /// Disables badge
    public func noBadge() -> NotificationChannel {
        var copy = self
        copy.showBadge = false
        return copy
    }
    
    /// Disables vibration
    public func noVibration() -> NotificationChannel {
        var copy = self
        copy.vibrationEnabled = false
        return copy
    }
    
    /// Sets bypass DND
    public func bypassDoNotDisturb() -> NotificationChannel {
        var copy = self
        copy.bypassDND = true
        return copy
    }
}

// MARK: - Channel Importance

/// Importance level for notification channels
public enum ChannelImportance: String, Codable, Sendable, CaseIterable {
    /// No notification
    case none
    
    /// No sound or vibration
    case low
    
    /// Default importance
    case `default`
    
    /// Higher priority
    case high
    
    /// Urgent - makes sound and appears as heads-up
    case urgent
    
    /// Maps to UNNotificationInterruptionLevel
    @available(iOS 15.0, *)
    var interruptionLevel: UNNotificationInterruptionLevel {
        switch self {
        case .none: return .passive
        case .low: return .passive
        case .default: return .active
        case .high: return .timeSensitive
        case .urgent: return .critical
        }
    }
}

// MARK: - Channel Group

/// A group of related channels
public struct ChannelGroup: Codable, Sendable, Identifiable {
    public let id: String
    public var name: String
    public var description: String
    
    public init(id: String, name: String, description: String = "") {
        self.id = id
        self.name = name
        self.description = description
    }
}

// MARK: - Preset Channels

extension NotificationChannel {
    /// General channel for misc notifications
    public static var general: NotificationChannel {
        NotificationChannel(
            id: "general",
            name: "General",
            description: "General notifications",
            importance: .default
        )
    }
    
    /// Promotions channel
    public static var promotions: NotificationChannel {
        NotificationChannel(
            id: "promotions",
            name: "Promotions",
            description: "Sales and promotional offers",
            importance: .low
        )
    }
    
    /// Updates channel
    public static var updates: NotificationChannel {
        NotificationChannel(
            id: "updates",
            name: "Updates",
            description: "App updates and news",
            importance: .default
        )
    }
    
    /// Social channel
    public static var social: NotificationChannel {
        NotificationChannel(
            id: "social",
            name: "Social",
            description: "Social interactions",
            importance: .high
        )
    }
    
    /// Alerts channel
    public static var alerts: NotificationChannel {
        NotificationChannel(
            id: "alerts",
            name: "Alerts",
            description: "Important alerts",
            importance: .urgent
        ).bypassDoNotDisturb()
    }
    
    /// Reminders channel
    public static var reminders: NotificationChannel {
        NotificationChannel(
            id: "reminders",
            name: "Reminders",
            description: "Scheduled reminders",
            importance: .high
        )
    }
}
