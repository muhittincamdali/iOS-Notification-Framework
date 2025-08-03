import Foundation
import iOSNotificationFramework

/// Basic notification example demonstrating simple notification usage
@available(iOS 15.0, *)
public class BasicNotificationExample {
    
    private let notificationManager = NotificationManager.shared
    
    public init() {
        setupNotificationManager()
    }
    
    // MARK: - Setup
    private func setupNotificationManager() {
        let config = NotificationManager.Configuration(
            appName: "BasicNotificationExample",
            enableAnalytics: true,
            enableRichMedia: true,
            enableCustomActions: true
        )
        
        notificationManager.configure(with: config)
    }
    
    // MARK: - Basic Notification Examples
    
    /// Example: Simple notification
    public func showSimpleNotification() {
        let request = NotificationRequest.simple(
            title: "Welcome!",
            body: "Thank you for using our app"
        )
        
        notificationManager.scheduleNotification(request) { result in
            switch result {
            case .success(let identifier):
                print("✅ Simple notification scheduled: \(identifier)")
            case .failure(let error):
                print("❌ Failed to schedule simple notification: \(error)")
            }
        }
    }
    
    /// Example: Notification with subtitle
    public func showNotificationWithSubtitle() {
        let request = NotificationRequest.builder()
            .title("New Message")
            .body("You have a new message from John")
            .subtitle("Message from John")
            .build()
        
        notificationManager.scheduleNotification(request) { result in
            switch result {
            case .success(let identifier):
                print("✅ Notification with subtitle scheduled: \(identifier)")
            case .failure(let error):
                print("❌ Failed to schedule notification with subtitle: \(error)")
            }
        }
    }
    
    /// Example: Scheduled notification
    public func showScheduledNotification() {
        let request = NotificationRequest.scheduled(
            title: "Reminder",
            body: "Don't forget your meeting in 5 minutes!",
            timeInterval: 300 // 5 minutes
        )
        
        notificationManager.scheduleNotification(request) { result in
            switch result {
            case .success(let identifier):
                print("✅ Scheduled notification: \(identifier)")
            case .failure(let error):
                print("❌ Failed to schedule notification: \(error)")
            }
        }
    }
    
    /// Example: Notification with custom sound
    public func showNotificationWithCustomSound() {
        let request = NotificationRequest.builder()
            .title("Custom Sound")
            .body("This notification has a custom sound")
            .sound(.default)
            .build()
        
        notificationManager.scheduleNotification(request) { result in
            switch result {
            case .success(let identifier):
                print("✅ Custom sound notification scheduled: \(identifier)")
            case .failure(let error):
                print("❌ Failed to schedule custom sound notification: \(error)")
            }
        }
    }
    
    /// Example: Notification with badge
    public func showNotificationWithBadge() {
        let request = NotificationRequest.builder()
            .title("New Badge")
            .body("You have 5 new notifications")
            .badge(NSNumber(value: 5))
            .build()
        
        notificationManager.scheduleNotification(request) { result in
            switch result {
            case .success(let identifier):
                print("✅ Badge notification scheduled: \(identifier)")
            case .failure(let error):
                print("❌ Failed to schedule badge notification: \(error)")
            }
        }
    }
    
    // MARK: - Permission Examples
    
    /// Example: Request notification permissions
    public func requestPermissions() {
        notificationManager.requestNotificationPermissions { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Notification permissions granted")
                } else {
                    print("❌ Notification permissions denied")
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    /// Example: Check notification permissions
    public func checkPermissions() {
        notificationManager.checkNotificationPermissions { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("✅ Notifications authorized")
                case .denied:
                    print("❌ Notifications denied")
                case .notDetermined:
                    print("❓ Notifications not determined")
                case .provisional:
                    print("📱 Provisional notifications")
                case .ephemeral:
                    print("⚡ Ephemeral notifications")
                @unknown default:
                    print("❓ Unknown notification status")
                }
            }
        }
    }
    
    // MARK: - Cancellation Examples
    
    /// Example: Cancel specific notification
    public func cancelSpecificNotification(identifier: String) {
        notificationManager.cancelNotification(withIdentifier: identifier)
        print("🗑️ Cancelled notification: \(identifier)")
    }
    
    /// Example: Cancel multiple notifications
    public func cancelMultipleNotifications(identifiers: [String]) {
        notificationManager.cancelNotifications(withIdentifiers: identifiers)
        print("🗑️ Cancelled \(identifiers.count) notifications")
    }
    
    /// Example: Cancel all notifications
    public func cancelAllNotifications() {
        notificationManager.cancelAllNotifications()
        print("🗑️ Cancelled all notifications")
    }
    
    // MARK: - Batch Operations
    
    /// Example: Schedule multiple notifications
    public func scheduleMultipleNotifications() {
        let requests = [
            NotificationRequest.simple(title: "Reminder 1", body: "First reminder"),
            NotificationRequest.simple(title: "Reminder 2", body: "Second reminder"),
            NotificationRequest.simple(title: "Reminder 3", body: "Third reminder")
        ]
        
        notificationManager.scheduleMultipleNotifications(requests) { result in
            switch result {
            case .success(let identifiers):
                print("✅ Scheduled \(identifiers.count) notifications")
                for identifier in identifiers {
                    print("  - \(identifier)")
                }
            case .failure(let error):
                print("❌ Failed to schedule multiple notifications: \(error)")
            }
        }
    }
    
    // MARK: - Validation Examples
    
    /// Example: Validate notification request
    public func validateNotificationRequest() {
        let validRequest = NotificationRequest.simple(
            title: "Valid Request",
            body: "This is a valid notification request"
        )
        
        if validRequest.isValid {
            print("✅ Valid notification request")
        } else {
            print("❌ Invalid notification request")
            for error in validRequest.validationErrors {
                print("  - \(error)")
            }
        }
        
        let invalidRequest = NotificationRequest(
            identifier: "",
            title: "",
            body: ""
        )
        
        if invalidRequest.isValid {
            print("✅ Valid notification request")
        } else {
            print("❌ Invalid notification request")
            for error in invalidRequest.validationErrors {
                print("  - \(error)")
            }
        }
    }
}

// MARK: - Usage Example
@available(iOS 15.0, *)
public class BasicNotificationExampleUsage {
    
    public static func runExamples() {
        let example = BasicNotificationExample()
        
        // Request permissions first
        example.requestPermissions()
        
        // Wait a moment for permissions
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Run examples
            example.showSimpleNotification()
            example.showNotificationWithSubtitle()
            example.showScheduledNotification()
            example.showNotificationWithCustomSound()
            example.showNotificationWithBadge()
            example.scheduleMultipleNotifications()
            example.validateNotificationRequest()
        }
    }
} 