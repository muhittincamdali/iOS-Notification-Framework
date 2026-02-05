//
//  LocationNotificationManager.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
import UserNotifications
#if canImport(CoreLocation) && os(iOS)
@preconcurrency import CoreLocation

/// Manager for location-based notifications
@MainActor
public final class LocationNotificationManager: NSObject, Sendable {
    
    // MARK: - Properties
    
    /// Shared instance
    public static let shared = LocationNotificationManager()
    
    /// Location manager
    private let locationManager = CLLocationManager()
    
    /// Registered geofences
    private var geofences: [String: GeofenceNotification] = [:]
    
    /// Current location
    public private(set) var currentLocation: CLLocation?
    
    /// Authorization status
    public var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    /// Delegate
    public weak var delegate: LocationNotificationDelegate?
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Authorization
    
    /// Requests location authorization
    public func requestAuthorization(always: Bool = false) {
        if always {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// Checks if location services are available
    public var isLocationAvailable: Bool {
        CLLocationManager.locationServicesEnabled() &&
        (authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse)
    }
    
    // MARK: - Geofence Registration
    
    /// Registers a geofence notification
    public func register(_ geofence: GeofenceNotification) throws {
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            throw LocationNotificationError.monitoringNotAvailable
        }
        
        guard geofences.count < 20 else {
            throw LocationNotificationError.maxGeofencesReached
        }
        
        let region = geofence.toRegion()
        locationManager.startMonitoring(for: region)
        geofences[geofence.identifier] = geofence
    }
    
    /// Unregisters a geofence
    public func unregister(identifier: String) {
        guard let geofence = geofences[identifier] else { return }
        
        let region = geofence.toRegion()
        locationManager.stopMonitoring(for: region)
        geofences.removeValue(forKey: identifier)
    }
    
    /// Unregisters all geofences
    public func unregisterAll() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        geofences.removeAll()
    }
    
    /// Gets all registered geofences
    public var registeredGeofences: [GeofenceNotification] {
        Array(geofences.values)
    }
    
    // MARK: - Location Updates
    
    /// Starts location updates
    public func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    /// Stops location updates
    public func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Gets current location
    public func getCurrentLocation() async throws -> CLLocation {
        if let location = currentLocation {
            return location
        }
        
        locationManager.requestLocation()
        
        // Wait for location
        return try await withCheckedThrowingContinuation { continuation in
            // This would need a proper callback mechanism
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if let location = self.currentLocation {
                    continuation.resume(returning: location)
                } else {
                    continuation.resume(throwing: LocationNotificationError.locationUnavailable)
                }
            }
        }
    }
    
    // MARK: - Distance Calculations
    
    /// Calculates distance from current location to a point
    public func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance? {
        guard let currentLocation = currentLocation else { return nil }
        
        let targetLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        return currentLocation.distance(from: targetLocation)
    }
    
    /// Checks if within a radius of a point
    public func isWithin(
        radius: CLLocationDistance,
        of coordinate: CLLocationCoordinate2D
    ) -> Bool {
        guard let distance = distance(to: coordinate) else { return false }
        return distance <= radius
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationNotificationManager: CLLocationManagerDelegate {
    
    public nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        Task { @MainActor in
            currentLocation = locations.last
        }
    }
    
    public nonisolated func locationManager(
        _ manager: CLLocationManager,
        didEnterRegion region: CLRegion
    ) {
        Task { @MainActor in
            handleRegionEvent(region: region, isEntering: true)
        }
    }
    
    public nonisolated func locationManager(
        _ manager: CLLocationManager,
        didExitRegion region: CLRegion
    ) {
        Task { @MainActor in
            handleRegionEvent(region: region, isEntering: false)
        }
    }
    
    @MainActor
    private func handleRegionEvent(region: CLRegion, isEntering: Bool) {
        guard let geofence = geofences[region.identifier] else { return }
        
        // Check if this trigger type is wanted
        if isEntering && !geofence.triggerOnEntry { return }
        if !isEntering && !geofence.triggerOnExit { return }
        
        // Schedule the notification
        Task {
            try? await NotificationKit.shared.schedule(geofence.notification)
        }
        
        // Notify delegate
        delegate?.locationNotificationManager(
            self,
            didTriggerGeofence: geofence,
            entering: isEntering
        )
    }
    
    public nonisolated func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        Task { @MainActor in
            delegate?.locationNotificationManager(self, didFailWithError: error)
        }
    }
    
    public nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            delegate?.locationNotificationManagerDidChangeAuthorization(self)
        }
    }
}

// MARK: - Geofence Notification

/// A geofence-triggered notification
public struct GeofenceNotification: Sendable, Identifiable {
    
    /// Unique identifier
    public let identifier: String
    
    /// Center coordinate
    public let center: CLLocationCoordinate2D
    
    /// Radius in meters
    public let radius: CLLocationDistance
    
    /// The notification to trigger
    public let notification: Notification
    
    /// Trigger on entry
    public var triggerOnEntry: Bool = true
    
    /// Trigger on exit
    public var triggerOnExit: Bool = false
    
    /// Display name for the location
    public var locationName: String?
    
    // MARK: - Initialization
    
    public init(
        identifier: String,
        latitude: Double,
        longitude: Double,
        radius: CLLocationDistance = 100,
        notification: Notification
    ) {
        self.identifier = identifier
        self.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.radius = radius
        self.notification = notification
    }
    
    public var id: String { identifier }
    
    // MARK: - Builder
    
    /// Sets trigger on entry
    public func onEntry(_ trigger: Bool = true) -> GeofenceNotification {
        var copy = self
        copy.triggerOnEntry = trigger
        return copy
    }
    
    /// Sets trigger on exit
    public func onExit(_ trigger: Bool = true) -> GeofenceNotification {
        var copy = self
        copy.triggerOnExit = trigger
        return copy
    }
    
    /// Sets location name
    public func name(_ name: String) -> GeofenceNotification {
        var copy = self
        copy.locationName = name
        return copy
    }
    
    // MARK: - Conversion
    
    func toRegion() -> CLCircularRegion {
        let region = CLCircularRegion(
            center: center,
            radius: min(radius, CLLocationManager().maximumRegionMonitoringDistance),
            identifier: identifier
        )
        region.notifyOnEntry = triggerOnEntry
        region.notifyOnExit = triggerOnExit
        return region
    }
}

// MARK: - Location Notification Delegate

/// Delegate for location notification events
@MainActor
public protocol LocationNotificationDelegate: AnyObject {
    /// Called when a geofence is triggered
    func locationNotificationManager(
        _ manager: LocationNotificationManager,
        didTriggerGeofence geofence: GeofenceNotification,
        entering: Bool
    )
    
    /// Called when location manager fails
    func locationNotificationManager(
        _ manager: LocationNotificationManager,
        didFailWithError error: Error
    )
    
    /// Called when authorization changes
    func locationNotificationManagerDidChangeAuthorization(
        _ manager: LocationNotificationManager
    )
}

// Default implementation
extension LocationNotificationDelegate {
    public func locationNotificationManager(
        _ manager: LocationNotificationManager,
        didTriggerGeofence geofence: GeofenceNotification,
        entering: Bool
    ) {}
    
    public func locationNotificationManager(
        _ manager: LocationNotificationManager,
        didFailWithError error: Error
    ) {}
    
    public func locationNotificationManagerDidChangeAuthorization(
        _ manager: LocationNotificationManager
    ) {}
}

// MARK: - Location Notification Error

/// Errors for location notifications
public enum LocationNotificationError: Error, LocalizedError {
    case monitoringNotAvailable
    case maxGeofencesReached
    case locationUnavailable
    case authorizationDenied
    
    public var errorDescription: String? {
        switch self {
        case .monitoringNotAvailable:
            return "Geofence monitoring is not available on this device"
        case .maxGeofencesReached:
            return "Maximum number of geofences (20) reached"
        case .locationUnavailable:
            return "Current location is unavailable"
        case .authorizationDenied:
            return "Location authorization was denied"
        }
    }
}

// MARK: - Preset Locations

extension GeofenceNotification {
    /// Creates a "leaving home" geofence
    public static func leavingHome(
        latitude: Double,
        longitude: Double,
        radius: CLLocationDistance = 100,
        notification: Notification
    ) -> GeofenceNotification {
        GeofenceNotification(
            identifier: "home-exit",
            latitude: latitude,
            longitude: longitude,
            radius: radius,
            notification: notification
        )
        .onEntry(false)
        .onExit(true)
        .name("Home")
    }
    
    /// Creates an "arriving at work" geofence
    public static func arrivingAtWork(
        latitude: Double,
        longitude: Double,
        radius: CLLocationDistance = 100,
        notification: Notification
    ) -> GeofenceNotification {
        GeofenceNotification(
            identifier: "work-entry",
            latitude: latitude,
            longitude: longitude,
            radius: radius,
            notification: notification
        )
        .onEntry(true)
        .onExit(false)
        .name("Work")
    }
}

#endif // canImport(CoreLocation) && os(iOS)
