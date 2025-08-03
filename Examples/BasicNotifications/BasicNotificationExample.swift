//
//  BasicNotificationExample.swift
//  NotificationFramework
//
//  Created by Muhittin Camdali on 2024-01-15.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import SwiftUI
import NotificationFramework

/// A comprehensive example demonstrating basic notification functionality.
@available(iOS 15.0, *)
public class BasicNotificationExample: ObservableObject {
    
    @Published public var isPermissionGranted = false
    @Published public var scheduledNotifications: [UNNotificationRequest] = []
    @Published public var deliveredNotifications: [UNNotification] = []
    @Published public var lastNotificationResponse: String?
    
    private let notificationManager = NotificationManager.shared
    
    public init() {
        setupNotificationHandlers()
    }
    
    @MainActor
    public func runExample() async {
        print("🚀 Starting Basic Notification Example")
        await requestPermissions()
        await scheduleBasicNotifications()
        await demonstrateNotificationManagement()
        await showAnalytics()
        print("✅ Basic Notification Example Completed")
    }
    
    @MainActor
    public func requestPermissions() async {
        print("📱 Requesting notification permissions...")
        
        do {
            let granted = try await notificationManager.requestPermissions()
            isPermissionGranted = granted
            
            if granted {
                print("✅ Notification permissions granted")
            } else {
                print("❌ Notification permissions denied")
            }
        } catch {
            print("❌ Permission request failed: \(error)")
        }
    }
    
    @MainActor
    public func scheduleBasicNotifications() async {
        print("📅 Scheduling basic notifications...")
        
        guard isPermissionGranted else {
            print("⚠️ Cannot schedule notifications without permissions")
            return
        }
        
        await scheduleImmediateNotification()
        await scheduleDelayedNotification()
        await scheduleNotificationWithActions()
        await scheduleNotificationWithBadge()
        await scheduleNotificationWithCustomSound()
        
        print("✅ Basic notifications scheduled")
    }
    
    @MainActor
    public func demonstrateNotificationManagement() async {
        print("🔧 Demonstrating notification management...")
        await loadPendingNotifications()
        await loadDeliveredNotifications()
        await removeSpecificNotification()
        await removeAllNotifications()
        print("✅ Notification management demonstration completed")
    }
    
    @MainActor
    public func showAnalytics() async {
        print("📊 Showing analytics data...")
        let analytics = notificationManager.getAnalytics()
        print("📈 Analytics: \(analytics)")
        await exportAnalytics()
        print("✅ Analytics demonstration completed")
    }
    
    private func setupNotificationHandlers() {
        notificationManager.registerActionHandler(for: "VIEW_ACTION") { identifier, notification in
            print("👆 User tapped view action for notification: \(notification.request.identifier)")
            DispatchQueue.main.async {
                self.lastNotificationResponse = "View action tapped"
            }
        }
        
        notificationManager.registerActionHandler(for: "DISMISS_ACTION") { identifier, notification in
            print("👆 User tapped dismiss action for notification: \(notification.request.identifier)")
            DispatchQueue.main.async {
                self.lastNotificationResponse = "Dismiss action tapped"
            }
        }
    }
    
    private func scheduleImmediateNotification() async {
        let content = NotificationContent(
            title: "Welcome!",
            body: "Thank you for using our notification framework",
            category: "welcome",
            sound: .default,
            badge: 1
        )
        
        do {
            let request = try await notificationManager.schedule(content, at: Date().addingTimeInterval(5))
            print("✅ Immediate notification scheduled: \(request.identifier)")
        } catch {
            print("❌ Failed to schedule immediate notification: \(error)")
        }
    }
    
    private func scheduleDelayedNotification() async {
        let content = NotificationContent(
            title: "Reminder",
            body: "Don't forget to check your notifications!",
            category: "reminder",
            sound: .default
        )
        
        do {
            let request = try await notificationManager.schedule(content, at: Date().addingTimeInterval(30))
            print("✅ Delayed notification scheduled: \(request.identifier)")
        } catch {
            print("❌ Failed to schedule delayed notification: \(error)")
        }
    }
    
    private func scheduleNotificationWithActions() async {
        let content = NotificationContent(
            title: "Action Required",
            body: "Please take action on this notification",
            category: "action",
            sound: .default,
            actions: [
                NotificationAction(title: "View", identifier: "VIEW_ACTION", options: [.foreground]),
                NotificationAction(title: "Dismiss", identifier: "DISMISS_ACTION", options: [.destructive])
            ]
        )
        
        do {
            let request = try await notificationManager.schedule(content, at: Date().addingTimeInterval(60))
            print("✅ Action notification scheduled: \(request.identifier)")
        } catch {
            print("❌ Failed to schedule action notification: \(error)")
        }
    }
    
    private func scheduleNotificationWithBadge() async {
        let content = NotificationContent(
            title: "New Message",
            body: "You have a new message waiting",
            category: "message",
            sound: .default,
            badge: 5
        )
        
        do {
            let request = try await notificationManager.schedule(content, at: Date().addingTimeInterval(90))
            print("✅ Badge notification scheduled: \(request.identifier)")
        } catch {
            print("❌ Failed to schedule badge notification: \(error)")
        }
    }
    
    private func scheduleNotificationWithCustomSound() async {
        let content = NotificationContent(
            title: "Custom Sound",
            body: "This notification has a custom sound",
            category: "custom",
            sound: UNNotificationSound(named: UNNotificationSoundName("custom_sound")),
            badge: 1
        )
        
        do {
            let request = try await notificationManager.schedule(content, at: Date().addingTimeInterval(120))
            print("✅ Custom sound notification scheduled: \(request.identifier)")
        } catch {
            print("❌ Failed to schedule custom sound notification: \(error)")
        }
    }
    
    private func loadPendingNotifications() async {
        let requests = await notificationManager.pendingRequests
        scheduledNotifications = requests
        print("📋 Pending notifications: \(requests.count)")
    }
    
    private func loadDeliveredNotifications() async {
        let notifications = await notificationManager.deliveredNotifications
        deliveredNotifications = notifications
        print("📨 Delivered notifications: \(notifications.count)")
    }
    
    private func removeSpecificNotification() async {
        guard let firstNotification = scheduledNotifications.first else {
            print("⚠️ No notifications to remove")
            return
        }
        
        await notificationManager.removePendingNotification(withIdentifier: firstNotification.identifier)
        print("🗑️ Removed notification: \(firstNotification.identifier)")
        await loadPendingNotifications()
    }
    
    private func removeAllNotifications() async {
        await notificationManager.removeAllPendingNotifications()
        await notificationManager.removeAllDeliveredNotifications()
        print("🗑️ Removed all notifications")
        await loadPendingNotifications()
        await loadDeliveredNotifications()
    }
    
    private func exportAnalytics() async {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("notification_analytics.json")
        
        do {
            try notificationManager.exportAnalytics(to: fileURL)
            print("📊 Analytics exported to: \(fileURL.path)")
        } catch {
            print("❌ Failed to export analytics: \(error)")
        }
    }
}

@available(iOS 15.0, *)
public struct BasicNotificationExampleView: View {
    
    @StateObject private var example = BasicNotificationExample()
    @State private var isRunning = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Basic Notification Example")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Demonstrates core notification functionality")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: example.isPermissionGranted ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(example.isPermissionGranted ? .green : .red)
                        Text("Permissions: \(example.isPermissionGranted ? "Granted" : "Denied")")
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.orange)
                        Text("Scheduled: \(example.scheduledNotifications.count)")
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.purple)
                        Text("Delivered: \(example.deliveredNotifications.count)")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                VStack(spacing: 15) {
                    Button(action: {
                        Task {
                            isRunning = true
                            await example.runExample()
                            isRunning = false
                        }
                    }) {
                        HStack {
                            if isRunning {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "play.fill")
                            }
                            Text(isRunning ? "Running..." : "Run Example")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(isRunning)
                    
                    Button(action: {
                        Task {
                            await example.requestPermissions()
                        }
                    }) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                            Text("Request Permissions")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        Task {
                            await example.scheduleBasicNotifications()
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Schedule Notifications")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                
                if let lastResponse = example.lastNotificationResponse {
                    VStack {
                        Text("Last Action:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(lastResponse)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Basic Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

@available(iOS 15.0, *)
struct BasicNotificationExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BasicNotificationExampleView()
    }
} 