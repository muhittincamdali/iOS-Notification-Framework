//
//  NotificationAnalytics.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation

/// Analytics engine for notification tracking
@MainActor
public final class NotificationAnalytics: Sendable {
    
    // MARK: - Properties
    
    /// Whether analytics is enabled
    public var isEnabled: Bool = true
    
    /// Analytics event handlers
    private var eventHandlers: [AnalyticsEventHandler] = []
    
    /// In-memory event buffer
    private var eventBuffer: [AnalyticsEvent] = []
    
    /// Maximum buffer size before flush
    public var maxBufferSize: Int = 100
    
    /// Statistics
    public private(set) var stats: NotificationStats
    
    // MARK: - Initialization
    
    public init() {
        self.stats = NotificationStats()
        loadStats()
    }
    
    // MARK: - Event Tracking
    
    /// Tracks an analytics event
    public func trackEvent(_ event: AnalyticsEvent) {
        guard isEnabled else { return }
        
        // Update stats
        updateStats(for: event)
        
        // Buffer event
        eventBuffer.append(event)
        
        // Flush if buffer is full
        if eventBuffer.count >= maxBufferSize {
            flush()
        }
        
        // Notify handlers
        for handler in eventHandlers {
            handler.handle(event)
        }
    }
    
    /// Registers an event handler
    public func addHandler(_ handler: AnalyticsEventHandler) {
        eventHandlers.append(handler)
    }
    
    /// Flushes buffered events
    public func flush() {
        guard !eventBuffer.isEmpty else { return }
        
        // Process buffered events (send to analytics service, etc.)
        eventBuffer.removeAll()
        saveStats()
    }
    
    // MARK: - Statistics
    
    private func updateStats(for event: AnalyticsEvent) {
        switch event {
        case .permissionRequested(let granted):
            stats.permissionRequestCount += 1
            if granted { stats.permissionGrantedCount += 1 }
            
        case .notificationScheduled:
            stats.scheduledCount += 1
            
        case .notificationPresented:
            stats.presentedCount += 1
            
        case .notificationInteracted(_, let action):
            stats.interactedCount += 1
            stats.actionCounts[action, default: 0] += 1
            
        case .notificationDismissed:
            stats.dismissedCount += 1
            
        case .notificationDeferred:
            stats.deferredCount += 1
            
        case .notificationSuppressed:
            stats.suppressedCount += 1
            
        case .notificationCancelled:
            stats.cancelledCount += 1
            
        default:
            break
        }
        
        stats.lastUpdated = Date()
    }
    
    // MARK: - Metrics
    
    /// Calculates open rate
    public var openRate: Double {
        guard stats.presentedCount > 0 else { return 0 }
        return Double(stats.interactedCount) / Double(stats.presentedCount)
    }
    
    /// Calculates delivery rate
    public var deliveryRate: Double {
        guard stats.scheduledCount > 0 else { return 0 }
        return Double(stats.presentedCount) / Double(stats.scheduledCount)
    }
    
    /// Calculates dismiss rate
    public var dismissRate: Double {
        guard stats.presentedCount > 0 else { return 0 }
        return Double(stats.dismissedCount) / Double(stats.presentedCount)
    }
    
    /// Gets action distribution
    public var actionDistribution: [String: Double] {
        guard stats.interactedCount > 0 else { return [:] }
        
        var distribution: [String: Double] = [:]
        for (action, count) in stats.actionCounts {
            distribution[action] = Double(count) / Double(stats.interactedCount)
        }
        return distribution
    }
    
    // MARK: - Persistence
    
    private func loadStats() {
        if let data = UserDefaults.standard.data(forKey: "NotificationKit.Stats"),
           let savedStats = try? JSONDecoder().decode(NotificationStats.self, from: data) {
            stats = savedStats
        }
    }
    
    private func saveStats() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: "NotificationKit.Stats")
        }
    }
    
    /// Resets all statistics
    public func resetStats() {
        stats = NotificationStats()
        UserDefaults.standard.removeObject(forKey: "NotificationKit.Stats")
    }
    
    // MARK: - Export
    
    /// Exports analytics data as JSON
    public func exportAsJSON() throws -> Data {
        let export = AnalyticsExport(
            stats: stats,
            events: eventBuffer,
            exportedAt: Date()
        )
        return try JSONEncoder().encode(export)
    }
}

// MARK: - Analytics Event

/// Events that can be tracked
public enum AnalyticsEvent: Sendable {
    case permissionRequested(granted: Bool)
    case deviceTokenReceived(token: String)
    case deviceTokenFailed(error: Error)
    case notificationScheduled(notification: Notification)
    case notificationPresented(id: String)
    case notificationInteracted(id: String, action: String)
    case notificationDismissed(id: String)
    case notificationDeferred(id: String, reason: DeferReason)
    case notificationSuppressed(id: String, reason: SuppressReason)
    case notificationCancelled(id: String)
    case allNotificationsCancelled
    case channelCreated(id: String)
    case channelUpdated(id: String)
    case channelDeleted(id: String)
    case abTestVariantAssigned(testId: String, variant: String)
    case deepLinkOpened(url: String, from: String)
    
    var name: String {
        switch self {
        case .permissionRequested: return "permission_requested"
        case .deviceTokenReceived: return "device_token_received"
        case .deviceTokenFailed: return "device_token_failed"
        case .notificationScheduled: return "notification_scheduled"
        case .notificationPresented: return "notification_presented"
        case .notificationInteracted: return "notification_interacted"
        case .notificationDismissed: return "notification_dismissed"
        case .notificationDeferred: return "notification_deferred"
        case .notificationSuppressed: return "notification_suppressed"
        case .notificationCancelled: return "notification_cancelled"
        case .allNotificationsCancelled: return "all_notifications_cancelled"
        case .channelCreated: return "channel_created"
        case .channelUpdated: return "channel_updated"
        case .channelDeleted: return "channel_deleted"
        case .abTestVariantAssigned: return "ab_test_variant_assigned"
        case .deepLinkOpened: return "deep_link_opened"
        }
    }
}

// MARK: - Defer Reason

public enum DeferReason: String, Sendable, Codable {
    case quietHours
    case rateLimited
    case networkUnavailable
}

// MARK: - Suppress Reason

public enum SuppressReason: String, Sendable, Codable {
    case channelDisabled
    case userPreference
    case duplicateFiltering
    case frequencyCapping
}

// MARK: - Notification Stats

/// Aggregated notification statistics
public struct NotificationStats: Codable, Sendable {
    public var permissionRequestCount: Int = 0
    public var permissionGrantedCount: Int = 0
    public var scheduledCount: Int = 0
    public var presentedCount: Int = 0
    public var interactedCount: Int = 0
    public var dismissedCount: Int = 0
    public var deferredCount: Int = 0
    public var suppressedCount: Int = 0
    public var cancelledCount: Int = 0
    public var actionCounts: [String: Int] = [:]
    public var lastUpdated: Date = Date()
    
    public init() {}
}

// MARK: - Analytics Event Handler

/// Protocol for handling analytics events
public protocol AnalyticsEventHandler {
    func handle(_ event: AnalyticsEvent)
}

// MARK: - Console Handler

/// Logs events to console
public struct ConsoleAnalyticsHandler: AnalyticsEventHandler {
    public init() {}
    
    public func handle(_ event: AnalyticsEvent) {
        print("[NotificationKit] Analytics: \(event.name)")
    }
}

// MARK: - Export Model

struct AnalyticsExport: Codable {
    let stats: NotificationStats
    let events: [String]
    let exportedAt: Date
    
    init(stats: NotificationStats, events: [AnalyticsEvent], exportedAt: Date) {
        self.stats = stats
        self.events = events.map { $0.name }
        self.exportedAt = exportedAt
    }
}
