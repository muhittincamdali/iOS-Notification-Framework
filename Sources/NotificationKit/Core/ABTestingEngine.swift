//
//  ABTestingEngine.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation

/// A/B testing engine for notification optimization
@MainActor
public final class ABTestingEngine: Sendable {
    
    // MARK: - Properties
    
    private var experiments: [String: ABExperiment] = [:]
    private var assignments: [String: String] = [:] // testId -> variantId
    private let userDefaultsKey = "NotificationKit.ABTests"
    
    // MARK: - Initialization
    
    init() {
        loadAssignments()
    }
    
    // MARK: - Experiment Management
    
    /// Creates a new A/B experiment
    public func createExperiment(_ experiment: ABExperiment) {
        experiments[experiment.id] = experiment
    }
    
    /// Gets an experiment by ID
    public func experiment(id: String) -> ABExperiment? {
        experiments[id]
    }
    
    /// Removes an experiment
    public func removeExperiment(id: String) {
        experiments.removeValue(forKey: id)
        assignments.removeValue(forKey: id)
        saveAssignments()
    }
    
    /// Gets all active experiments
    public func activeExperiments() -> [ABExperiment] {
        experiments.values.filter { $0.isActive }
    }
    
    // MARK: - Variant Assignment
    
    /// Gets the assigned variant for an experiment
    public func assignedVariant(for experimentId: String) -> ABVariant? {
        guard let experiment = experiments[experimentId] else { return nil }
        
        // Check existing assignment
        if let variantId = assignments[experimentId] {
            return experiment.variants.first { $0.id == variantId }
        }
        
        // Assign new variant
        let variant = assignVariant(for: experiment)
        assignments[experimentId] = variant.id
        saveAssignments()
        
        return variant
    }
    
    private func assignVariant(for experiment: ABExperiment) -> ABVariant {
        // Weighted random selection
        let totalWeight = experiment.variants.reduce(0) { $0 + $1.weight }
        let random = Double.random(in: 0..<totalWeight)
        
        var cumulative = 0.0
        for variant in experiment.variants {
            cumulative += variant.weight
            if random < cumulative {
                return variant
            }
        }
        
        return experiment.variants.first!
    }
    
    /// Resets assignment for an experiment (for testing)
    public func resetAssignment(for experimentId: String) {
        assignments.removeValue(forKey: experimentId)
        saveAssignments()
    }
    
    /// Resets all assignments
    public func resetAllAssignments() {
        assignments.removeAll()
        saveAssignments()
    }
    
    // MARK: - Apply to Notification
    
    /// Applies A/B test variant to a notification
    func applyVariant(to notification: Notification) -> Notification {
        guard let testId = notification.abTestId,
              let variant = assignedVariant(for: testId) else {
            return notification
        }
        
        var modified = notification
        
        // Apply title variant
        if let title = variant.overrides["title"] as? String {
            modified = modified.title(title)
        }
        
        // Apply body variant
        if let body = variant.overrides["body"] as? String {
            modified = modified.body(body)
        }
        
        // Apply subtitle variant
        if let subtitle = variant.overrides["subtitle"] as? String {
            modified = modified.subtitle(subtitle)
        }
        
        // Track assignment
        NotificationKit.shared.analytics.trackEvent(
            .abTestVariantAssigned(testId: testId, variant: variant.id)
        )
        
        return modified
    }
    
    // MARK: - Persistence
    
    private func loadAssignments() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([String: String].self, from: data) else {
            return
        }
        assignments = decoded
    }
    
    private func saveAssignments() {
        if let data = try? JSONEncoder().encode(assignments) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}

// MARK: - AB Experiment

/// An A/B test experiment
public struct ABExperiment: Sendable, Identifiable {
    /// Unique experiment ID
    public let id: String
    
    /// Experiment name
    public var name: String
    
    /// Experiment description
    public var description: String
    
    /// Variants in this experiment
    public var variants: [ABVariant]
    
    /// Whether the experiment is active
    public var isActive: Bool
    
    /// Start date
    public var startDate: Date?
    
    /// End date
    public var endDate: Date?
    
    // MARK: - Initialization
    
    public init(
        id: String,
        name: String,
        description: String = "",
        variants: [ABVariant] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.variants = variants
        self.isActive = true
    }
    
    // MARK: - Builder
    
    /// Adds a variant to the experiment
    public func addVariant(_ variant: ABVariant) -> ABExperiment {
        var copy = self
        copy.variants.append(variant)
        return copy
    }
    
    /// Sets the experiment active state
    public func active(_ isActive: Bool) -> ABExperiment {
        var copy = self
        copy.isActive = isActive
        return copy
    }
    
    /// Sets experiment dates
    public func dates(start: Date?, end: Date?) -> ABExperiment {
        var copy = self
        copy.startDate = start
        copy.endDate = end
        return copy
    }
}

// MARK: - AB Variant

/// A variant in an A/B test
public struct ABVariant: Sendable, Identifiable {
    /// Unique variant ID
    public let id: String
    
    /// Variant name
    public var name: String
    
    /// Weight for random assignment (higher = more likely)
    public var weight: Double
    
    /// Override values for notification properties
    public var overrides: [String: Any]
    
    // MARK: - Initialization
    
    public init(
        id: String,
        name: String,
        weight: Double = 1.0
    ) {
        self.id = id
        self.name = name
        self.weight = weight
        self.overrides = [:]
    }
    
    // MARK: - Builder
    
    /// Sets the title override
    public func title(_ title: String) -> ABVariant {
        var copy = self
        copy.overrides["title"] = title
        return copy
    }
    
    /// Sets the body override
    public func body(_ body: String) -> ABVariant {
        var copy = self
        copy.overrides["body"] = body
        return copy
    }
    
    /// Sets the subtitle override
    public func subtitle(_ subtitle: String) -> ABVariant {
        var copy = self
        copy.overrides["subtitle"] = subtitle
        return copy
    }
    
    /// Sets a custom override
    public func override(key: String, value: Any) -> ABVariant {
        var copy = self
        copy.overrides[key] = value
        return copy
    }
}

// MARK: - Common Experiments

extension ABExperiment {
    /// Creates a simple 50/50 title test
    public static func titleTest(
        id: String,
        name: String,
        titleA: String,
        titleB: String
    ) -> ABExperiment {
        ABExperiment(id: id, name: name, variants: [
            ABVariant(id: "A", name: "Control").title(titleA),
            ABVariant(id: "B", name: "Variant").title(titleB)
        ])
    }
    
    /// Creates a simple 50/50 body test
    public static func bodyTest(
        id: String,
        name: String,
        bodyA: String,
        bodyB: String
    ) -> ABExperiment {
        ABExperiment(id: id, name: name, variants: [
            ABVariant(id: "A", name: "Control").body(bodyA),
            ABVariant(id: "B", name: "Variant").body(bodyB)
        ])
    }
}
