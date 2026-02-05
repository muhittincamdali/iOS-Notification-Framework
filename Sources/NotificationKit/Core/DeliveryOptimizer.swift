//
//  DeliveryOptimizer.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation

/// Delivery optimizer for maximizing notification engagement
@MainActor
public final class DeliveryOptimizer {
    
    // MARK: - Properties
    
    /// Engagement history for learning optimal times
    private var engagementHistory: [EngagementRecord] = []
    
    /// User timezone
    public var userTimezone: TimeZone = .current
    
    /// Minimum sample size for predictions
    public var minSampleSize: Int = 10
    
    /// Storage key
    private let storageKey = "NotificationKit.DeliveryOptimizer"
    
    // MARK: - Initialization
    
    public init() {
        loadHistory()
    }
    
    // MARK: - Engagement Tracking
    
    /// Records a notification interaction
    public func recordEngagement(
        notificationId: String,
        interactionType: InteractionType,
        responseTime: TimeInterval? = nil
    ) {
        let record = EngagementRecord(
            notificationId: notificationId,
            timestamp: Date(),
            hourOfDay: currentHour(),
            dayOfWeek: currentDayOfWeek(),
            interactionType: interactionType,
            responseTime: responseTime
        )
        
        engagementHistory.append(record)
        
        // Keep only last 1000 records
        if engagementHistory.count > 1000 {
            engagementHistory = Array(engagementHistory.suffix(1000))
        }
        
        saveHistory()
    }
    
    // MARK: - Optimal Time Prediction
    
    /// Gets the optimal hour to send notifications
    public func optimalHour() -> Int {
        guard engagementHistory.count >= minSampleSize else {
            return 10 // Default to 10 AM
        }
        
        // Group by hour and calculate engagement rate
        var hourEngagement: [Int: (total: Int, engaged: Int)] = [:]
        
        for record in engagementHistory {
            let current = hourEngagement[record.hourOfDay] ?? (0, 0)
            let engaged = record.interactionType != .dismissed ? 1 : 0
            hourEngagement[record.hourOfDay] = (current.total + 1, current.engaged + engaged)
        }
        
        // Find hour with highest engagement rate
        var bestHour = 10
        var bestRate = 0.0
        
        for (hour, data) in hourEngagement {
            guard data.total >= 3 else { continue } // Minimum samples per hour
            let rate = Double(data.engaged) / Double(data.total)
            if rate > bestRate {
                bestRate = rate
                bestHour = hour
            }
        }
        
        return bestHour
    }
    
    /// Gets the optimal day to send notifications
    public func optimalDayOfWeek() -> Int {
        guard engagementHistory.count >= minSampleSize else {
            return 3 // Default to Tuesday
        }
        
        // Group by day and calculate engagement rate
        var dayEngagement: [Int: (total: Int, engaged: Int)] = [:]
        
        for record in engagementHistory {
            let current = dayEngagement[record.dayOfWeek] ?? (0, 0)
            let engaged = record.interactionType != .dismissed ? 1 : 0
            dayEngagement[record.dayOfWeek] = (current.total + 1, current.engaged + engaged)
        }
        
        // Find day with highest engagement rate
        var bestDay = 3
        var bestRate = 0.0
        
        for (day, data) in dayEngagement {
            guard data.total >= 3 else { continue }
            let rate = Double(data.engaged) / Double(data.total)
            if rate > bestRate {
                bestRate = rate
                bestDay = day
            }
        }
        
        return bestDay
    }
    
    /// Gets optimal delivery time
    public func optimalDeliveryTime() -> DateComponents {
        var components = DateComponents()
        components.hour = optimalHour()
        components.minute = 0
        components.weekday = optimalDayOfWeek()
        return components
    }
    
    /// Gets next optimal delivery date
    public func nextOptimalDeliveryDate() -> Date {
        let calendar = Calendar.current
        let components = optimalDeliveryTime()
        return calendar.nextDate(
            after: Date(),
            matching: components,
            matchingPolicy: .nextTime
        ) ?? Date().addingTimeInterval(3600)
    }
    
    // MARK: - Engagement Scoring
    
    /// Calculates engagement score for current time
    public func currentEngagementScore() -> Double {
        scoreForTime(hour: currentHour(), dayOfWeek: currentDayOfWeek())
    }
    
    /// Calculates engagement score for a specific time
    public func scoreForTime(hour: Int, dayOfWeek: Int) -> Double {
        guard engagementHistory.count >= minSampleSize else {
            return 0.5 // Default neutral score
        }
        
        let relevantRecords = engagementHistory.filter {
            $0.hourOfDay == hour && $0.dayOfWeek == dayOfWeek
        }
        
        guard !relevantRecords.isEmpty else { return 0.5 }
        
        let engaged = relevantRecords.filter { $0.interactionType != .dismissed }.count
        return Double(engaged) / Double(relevantRecords.count)
    }
    
    /// Gets engagement heatmap by hour
    public func engagementHeatmap() -> [Int: Double] {
        var heatmap: [Int: Double] = [:]
        
        for hour in 0..<24 {
            heatmap[hour] = scoreForHour(hour)
        }
        
        return heatmap
    }
    
    private func scoreForHour(_ hour: Int) -> Double {
        let relevant = engagementHistory.filter { $0.hourOfDay == hour }
        guard !relevant.isEmpty else { return 0.0 }
        
        let engaged = relevant.filter { $0.interactionType != .dismissed }.count
        return Double(engaged) / Double(relevant.count)
    }
    
    // MARK: - Response Time Analysis
    
    /// Gets average response time in seconds
    public var averageResponseTime: TimeInterval {
        let times = engagementHistory.compactMap { $0.responseTime }
        guard !times.isEmpty else { return 0 }
        return times.reduce(0, +) / Double(times.count)
    }
    
    /// Gets response time by hour
    public func responseTimeByHour() -> [Int: TimeInterval] {
        var byHour: [Int: [TimeInterval]] = [:]
        
        for record in engagementHistory {
            if let time = record.responseTime {
                byHour[record.hourOfDay, default: []].append(time)
            }
        }
        
        return byHour.mapValues { times in
            times.reduce(0, +) / Double(times.count)
        }
    }
    
    // MARK: - Recommendations
    
    /// Gets delivery recommendations
    public func getRecommendations() -> [DeliveryRecommendation] {
        var recommendations: [DeliveryRecommendation] = []
        
        // Optimal time recommendation
        let optimalHour = self.optimalHour()
        recommendations.append(.optimalTime(hour: optimalHour))
        
        // Avoid times recommendation
        let lowEngagementHours = engagementHeatmap()
            .filter { $0.value < 0.3 }
            .map { $0.key }
            .sorted()
        
        if !lowEngagementHours.isEmpty {
            recommendations.append(.avoidTimes(hours: lowEngagementHours))
        }
        
        // Frequency recommendation
        let dailyCount = engagementHistory.filter {
            Calendar.current.isDateInToday($0.timestamp)
        }.count
        
        if dailyCount > 5 {
            recommendations.append(.reduceFrequency)
        }
        
        return recommendations
    }
    
    // MARK: - Persistence
    
    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([EngagementRecord].self, from: data) else {
            return
        }
        engagementHistory = decoded
    }
    
    private func saveHistory() {
        if let data = try? JSONEncoder().encode(engagementHistory) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    /// Clears engagement history
    public func clearHistory() {
        engagementHistory.removeAll()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
    
    // MARK: - Helpers
    
    private func currentHour() -> Int {
        Calendar.current.component(.hour, from: Date())
    }
    
    private func currentDayOfWeek() -> Int {
        Calendar.current.component(.weekday, from: Date())
    }
}

// MARK: - Engagement Record

/// A record of notification engagement
struct EngagementRecord: Codable, Sendable {
    let notificationId: String
    let timestamp: Date
    let hourOfDay: Int
    let dayOfWeek: Int
    let interactionType: InteractionType
    let responseTime: TimeInterval?
}

// MARK: - Interaction Type

/// Type of interaction with a notification
public enum InteractionType: String, Codable, Sendable {
    case opened
    case actioned
    case replied
    case dismissed
    case expired
}

// MARK: - Delivery Recommendation

/// A delivery recommendation
public enum DeliveryRecommendation: Sendable {
    case optimalTime(hour: Int)
    case avoidTimes(hours: [Int])
    case reduceFrequency
    case increaseRelevance
    case useRichMedia
    
    public var description: String {
        switch self {
        case .optimalTime(let hour):
            return "Best delivery time is around \(hour):00"
        case .avoidTimes(let hours):
            let formatted = hours.map { "\($0):00" }.joined(separator: ", ")
            return "Avoid sending at: \(formatted)"
        case .reduceFrequency:
            return "Consider reducing notification frequency"
        case .increaseRelevance:
            return "Focus on more relevant content"
        case .useRichMedia:
            return "Rich media increases engagement"
        }
    }
}
