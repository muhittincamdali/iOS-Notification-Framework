//
//  DeepLinkHandler.swift
//  NotificationKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Handler for deep linking from notifications
@MainActor
public final class DeepLinkHandler: Sendable {
    
    // MARK: - Properties
    
    /// Registered deep link handlers
    private var handlers: [String: DeepLinkAction] = [:]
    
    /// Wildcard handlers for pattern matching
    private var wildcardHandlers: [(pattern: String, action: DeepLinkAction)] = []
    
    /// URL scheme for the app
    public var urlScheme: String?
    
    /// Universal link domain
    public var universalLinkDomain: String?
    
    /// Delegate for deep link events
    public weak var delegate: DeepLinkDelegate?
    
    // MARK: - Registration
    
    /// Registers a handler for a specific path
    /// - Parameters:
    ///   - path: The deep link path (e.g., "/product/123")
    ///   - handler: The action to perform
    public func register(path: String, handler: @escaping DeepLinkAction) {
        handlers[path] = handler
    }
    
    /// Registers a wildcard pattern handler
    /// - Parameters:
    ///   - pattern: The pattern (e.g., "/product/*" or "/user/{id}")
    ///   - handler: The action to perform
    public func register(pattern: String, handler: @escaping DeepLinkAction) {
        wildcardHandlers.append((pattern, handler))
    }
    
    /// Removes a handler
    public func unregister(path: String) {
        handlers.removeValue(forKey: path)
    }
    
    // MARK: - Handling
    
    /// Handles a deep link URL string
    /// - Parameters:
    ///   - url: The URL string
    ///   - notificationId: The notification that triggered this
    public func handle(url: String, from notificationId: String) {
        guard let parsedURL = URL(string: url) else {
            delegate?.deepLinkHandler(self, didFailWithError: .invalidURL(url))
            return
        }
        
        handle(url: parsedURL, from: notificationId)
    }
    
    /// Handles a deep link URL
    /// - Parameters:
    ///   - url: The URL
    ///   - notificationId: The notification that triggered this
    public func handle(url: URL, from notificationId: String) {
        let path = url.path
        let queryParams = parseQueryParameters(from: url)
        
        let context = DeepLinkContext(
            url: url,
            path: path,
            queryParameters: queryParams,
            notificationId: notificationId
        )
        
        // Check exact match first
        if let handler = handlers[path] {
            handler(context)
            NotificationKit.shared.analytics.trackEvent(
                .deepLinkOpened(url: url.absoluteString, from: notificationId)
            )
            delegate?.deepLinkHandler(self, didOpen: context)
            return
        }
        
        // Check wildcard patterns
        for (pattern, handler) in wildcardHandlers {
            if matchesPattern(path: path, pattern: pattern, context: context) {
                handler(context)
                NotificationKit.shared.analytics.trackEvent(
                    .deepLinkOpened(url: url.absoluteString, from: notificationId)
                )
                delegate?.deepLinkHandler(self, didOpen: context)
                return
            }
        }
        
        // No handler found
        delegate?.deepLinkHandler(self, didFailWithError: .noHandler(path))
    }
    
    // MARK: - URL Building
    
    /// Builds a deep link URL
    /// - Parameters:
    ///   - path: The path
    ///   - params: Query parameters
    /// - Returns: The deep link URL
    public func buildURL(path: String, params: [String: String] = [:]) -> URL? {
        guard let scheme = urlScheme else { return nil }
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = "app"
        components.path = path.hasPrefix("/") ? path : "/\(path)"
        
        if !params.isEmpty {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components.url
    }
    
    /// Builds a universal link URL
    /// - Parameters:
    ///   - path: The path
    ///   - params: Query parameters
    /// - Returns: The universal link URL
    public func buildUniversalLink(path: String, params: [String: String] = [:]) -> URL? {
        guard let domain = universalLinkDomain else { return nil }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = domain
        components.path = path.hasPrefix("/") ? path : "/\(path)"
        
        if !params.isEmpty {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components.url
    }
    
    // MARK: - Helpers
    
    private func parseQueryParameters(from url: URL) -> [String: String] {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }
        
        var params: [String: String] = [:]
        for item in queryItems {
            params[item.name] = item.value ?? ""
        }
        return params
    }
    
    private func matchesPattern(path: String, pattern: String, context: DeepLinkContext) -> Bool {
        // Simple wildcard matching
        let patternParts = pattern.split(separator: "/")
        let pathParts = path.split(separator: "/")
        
        guard patternParts.count == pathParts.count else { return false }
        
        for (patternPart, pathPart) in zip(patternParts, pathParts) {
            if patternPart == "*" {
                continue
            }
            if patternPart.hasPrefix("{") && patternPart.hasSuffix("}") {
                // Named parameter
                continue
            }
            if patternPart != pathPart {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - Opening External URLs
    
    #if canImport(UIKit) && !os(watchOS)
    /// Opens an external URL
    @MainActor
    public func openExternal(url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }
    
    /// Opens app settings
    @MainActor
    public func openSettings() async {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        await UIApplication.shared.open(url)
    }
    #endif
}

// MARK: - Deep Link Context

/// Context for a deep link navigation
public struct DeepLinkContext: Sendable {
    /// The original URL
    public let url: URL
    
    /// The URL path
    public let path: String
    
    /// Query parameters
    public let queryParameters: [String: String]
    
    /// The notification that triggered this
    public let notificationId: String
    
    /// Extracted path parameters (from patterns like /user/{id})
    public var pathParameters: [String: String] = [:]
    
    /// Gets a query parameter
    public func query(_ key: String) -> String? {
        queryParameters[key]
    }
    
    /// Gets a path parameter
    public func param(_ key: String) -> String? {
        pathParameters[key]
    }
}

// MARK: - Deep Link Action

/// Action to perform when a deep link is opened
public typealias DeepLinkAction = @MainActor (DeepLinkContext) -> Void

// MARK: - Deep Link Delegate

/// Delegate for deep link events
@MainActor
public protocol DeepLinkDelegate: AnyObject {
    /// Called when a deep link is successfully opened
    func deepLinkHandler(_ handler: DeepLinkHandler, didOpen context: DeepLinkContext)
    
    /// Called when a deep link fails
    func deepLinkHandler(_ handler: DeepLinkHandler, didFailWithError error: DeepLinkError)
}

// MARK: - Default Implementation

extension DeepLinkDelegate {
    public func deepLinkHandler(_ handler: DeepLinkHandler, didOpen context: DeepLinkContext) {}
    public func deepLinkHandler(_ handler: DeepLinkHandler, didFailWithError error: DeepLinkError) {}
}

// MARK: - Deep Link Error

/// Errors that can occur with deep linking
public enum DeepLinkError: Error, LocalizedError {
    case invalidURL(String)
    case noHandler(String)
    case navigationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid deep link URL: \(url)"
        case .noHandler(let path):
            return "No handler registered for path: \(path)"
        case .navigationFailed(let reason):
            return "Navigation failed: \(reason)"
        }
    }
}

// MARK: - Common Deep Link Paths

extension String {
    /// Home screen deep link
    public static let homeDeepLink = "/"
    
    /// Settings deep link
    public static let settingsDeepLink = "/settings"
    
    /// Profile deep link
    public static let profileDeepLink = "/profile"
    
    /// Notifications deep link
    public static let notificationsDeepLink = "/notifications"
}
