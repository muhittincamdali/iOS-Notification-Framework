//
//  RateLimiter.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation

/// Rate limiter for controlling notification frequency
@MainActor
final class RateLimiter: Sendable {
    
    // MARK: - Properties
    
    private var configuration: RateLimitingConfiguration?
    private var hourlyTimestamps: [Date] = []
    private var dailyTimestamps: [Date] = []
    private var burstTimestamps: [Date] = []
    
    private let userDefaultsKey = "NotificationKit.RateLimiter"
    
    // MARK: - Initialization
    
    init() {
        loadState()
    }
    
    // MARK: - Configuration
    
    func configure(_ config: RateLimitingConfiguration) {
        self.configuration = config
    }
    
    // MARK: - Rate Limiting
    
    /// Checks if a new notification can be scheduled
    func canSchedule() -> Bool {
        guard let config = configuration else { return true }
        
        cleanupOldTimestamps()
        
        // Check burst limit
        if burstTimestamps.count >= config.burstLimit {
            return false
        }
        
        // Check hourly limit
        if hourlyTimestamps.count >= config.maxPerHour {
            return false
        }
        
        // Check daily limit
        if let maxDaily = config.maxPerDay,
           dailyTimestamps.count >= maxDaily {
            return false
        }
        
        return true
    }
    
    /// Records a scheduled notification
    func recordScheduled() {
        let now = Date()
        hourlyTimestamps.append(now)
        dailyTimestamps.append(now)
        burstTimestamps.append(now)
        saveState()
    }
    
    /// Gets remaining notifications for current hour
    func remainingThisHour() -> Int {
        guard let config = configuration else { return Int.max }
        cleanupOldTimestamps()
        return max(0, config.maxPerHour - hourlyTimestamps.count)
    }
    
    /// Gets remaining notifications for today
    func remainingToday() -> Int? {
        guard let config = configuration,
              let maxDaily = config.maxPerDay else { return nil }
        cleanupOldTimestamps()
        return max(0, maxDaily - dailyTimestamps.count)
    }
    
    /// Gets time until next notification is allowed
    func timeUntilNextAllowed() -> TimeInterval? {
        guard !canSchedule() else { return nil }
        guard let config = configuration else { return nil }
        
        // Check burst first
        if burstTimestamps.count >= config.burstLimit,
           let oldest = burstTimestamps.first {
            let burstEnd = oldest.addingTimeInterval(TimeInterval(config.burstWindowSeconds))
            return burstEnd.timeIntervalSinceNow
        }
        
        // Check hourly
        if hourlyTimestamps.count >= config.maxPerHour,
           let oldest = hourlyTimestamps.first {
            let hourEnd = oldest.addingTimeInterval(3600)
            return hourEnd.timeIntervalSinceNow
        }
        
        // Check daily
        if let maxDaily = config.maxPerDay,
           dailyTimestamps.count >= maxDaily,
           let oldest = dailyTimestamps.first {
            let calendar = Calendar.current
            if let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: oldest)) {
                return tomorrow.timeIntervalSinceNow
            }
        }
        
        return nil
    }
    
    // MARK: - Cleanup
    
    private func cleanupOldTimestamps() {
        let now = Date()
        let calendar = Calendar.current
        
        // Clean burst timestamps (older than burst window)
        let burstCutoff = now.addingTimeInterval(-TimeInterval(configuration?.burstWindowSeconds ?? 60))
        burstTimestamps.removeAll { $0 < burstCutoff }
        
        // Clean hourly timestamps (older than 1 hour)
        let hourCutoff = now.addingTimeInterval(-3600)
        hourlyTimestamps.removeAll { $0 < hourCutoff }
        
        // Clean daily timestamps (not today)
        let startOfToday = calendar.startOfDay(for: now)
        dailyTimestamps.removeAll { $0 < startOfToday }
    }
    
    /// Resets all rate limiting counters
    func reset() {
        hourlyTimestamps.removeAll()
        dailyTimestamps.removeAll()
        burstTimestamps.removeAll()
        saveState()
    }
    
    // MARK: - Persistence
    
    private func loadState() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let state = try? JSONDecoder().decode(RateLimiterState.self, from: data) else {
            return
        }
        
        hourlyTimestamps = state.hourlyTimestamps
        dailyTimestamps = state.dailyTimestamps
        burstTimestamps = state.burstTimestamps
        cleanupOldTimestamps()
    }
    
    private func saveState() {
        let state = RateLimiterState(
            hourlyTimestamps: hourlyTimestamps,
            dailyTimestamps: dailyTimestamps,
            burstTimestamps: burstTimestamps
        )
        
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}

// MARK: - State Model

private struct RateLimiterState: Codable {
    let hourlyTimestamps: [Date]
    let dailyTimestamps: [Date]
    let burstTimestamps: [Date]
}

// MARK: - Public Rate Limit Info

/// Public information about current rate limit status
public struct RateLimitStatus: Sendable {
    /// Remaining notifications this hour
    public let remainingThisHour: Int
    
    /// Remaining notifications today
    public let remainingToday: Int?
    
    /// Seconds until next notification allowed (nil if allowed now)
    public let secondsUntilNextAllowed: TimeInterval?
    
    /// Whether a notification can be scheduled now
    public var canSchedule: Bool {
        secondsUntilNextAllowed == nil
    }
}
