import Foundation
import NotificationKit
import Observation

/// Where a notification can take the user.
enum LabDestination: Hashable, Sendable {
    case reminder(String)
    case order(String)
}

/// Something the app received: a notification shown in the foreground or a user's response.
struct InboxEntry: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let detail: String
}

/// The app's notification state. One instance, shared by the app delegate and the views.
@MainActor
@Observable
final class LabModel {
    static let shared = LabModel(arguments: ProcessInfo.processInfo.arguments)

    static let reminderCategory = NotificationCategory(
        id: "reminder",
        actions: [
            .button(id: "done", title: "Mark as Done", systemImageName: "checkmark"),
            .button(id: "snooze", title: "Snooze 10 Minutes", systemImageName: "clock"),
            .textInput(id: "note", title: "Add Note", buttonTitle: "Save", placeholder: "Note"),
        ]
    )

    let scheduler: NotificationScheduler
    let events: NotificationEventHandler
    private let router: DeepLinkRouter<LabDestination>
    private var counter = 0

    var status: AuthorizationStatus = .notDetermined
    var scheduled: [ScheduledNotification] = []
    var inbox: [InboxEntry] = []
    var path: [LabDestination] = []
    var quietHoursEnabled = false
    var message: String?
    var deviceToken: DeviceToken?

    init(arguments: [String]) {
        let store = FileNotificationStore.applicationSupport()
        scheduler = NotificationScheduler(store: store)
        events = NotificationEventHandler()
        var router = DeepLinkRouter<LabDestination>(schemes: ["notificationlab"])
        try? router.register("reminders/:id") { .reminder($0.parameters["id"]!) }
        try? router.register("orders/:id") { .order($0.parameters["id"]!) }
        self.router = router
        // Installed while the app is launching, so a tap that launched the app is delivered.
        events.install()
        if arguments.contains("-reset") {
            Task { try? await scheduler.cancelAll() }
        }
    }

    /// Registers categories, reads the current state and listens for events until the app quits.
    func start() async {
        await scheduler.register([Self.reminderCategory])
        await refresh()
        async let responses: Void = listenForResponses()
        async let presentations: Void = listenForPresentations()
        _ = await (responses, presentations)
    }

    func refresh() async {
        status = await scheduler.settings().authorizationStatus
        do {
            try await scheduler.refresh()
            scheduled = try await scheduler.scheduled()
        } catch {
            message = error.localizedDescription
        }
    }

    func requestPermission() async {
        do {
            try await scheduler.requestAuthorization()
        } catch {
            message = error.localizedDescription
        }
        await refresh()
    }

    func scheduleReminder(after seconds: TimeInterval) async {
        counter += 1
        let id = "reminder-\(counter)"
        var reminder = LocalNotification(
            id: id,
            title: "Water break",
            body: "Stand up and drink a glass of water.",
            categoryID: Self.reminderCategory.id,
            trigger: .after(seconds: seconds)
        )
        reminder.deepLink = URL(string: "notificationlab://reminders/\(id)")
        await schedule([reminder])
    }

    /// More notifications than iOS keeps: the scheduler queues the latest ones.
    func scheduleBatch(count: Int) async {
        let batch = (1...count).map { index in
            LocalNotification(
                id: "batch-\(index)",
                title: "Batch reminder \(index)",
                body: "Scheduled in a batch of \(count).",
                sound: nil,
                trigger: .after(minutes: 60 + Double(index))
            )
        }
        await schedule(batch)
    }

    func setQuietHours(_ enabled: Bool) async {
        quietHoursEnabled = enabled
        var policy = await scheduler.policy
        policy.quietHours = enabled ? Self.quietHoursForNextHour() : nil
        await scheduler.updatePolicy(policy)
    }

    func cancelAll() async {
        do {
            try await scheduler.cancelAll()
        } catch {
            message = error.localizedDescription
        }
        await refresh()
    }

    func didRegister(deviceToken data: Data) {
        deviceToken = try? DeviceToken(data: data)
        message = deviceToken.map { "Registered for pushes: \($0)" }
    }

    func didFailToRegister(_ error: any Error) {
        message = "Push registration failed: \(error.localizedDescription)"
    }

    private func schedule(_ notifications: [LocalNotification]) async {
        do {
            try await scheduler.schedule(notifications)
            message = nil
        } catch {
            message = error.localizedDescription
        }
        await refresh()
    }

    private func listenForResponses() async {
        for await response in events.responses {
            let action = switch response.action {
            case .open: "Opened"
            case .dismiss: "Dismissed"
            case .custom(let id): "Action \"\(id)\""
            }
            let note = response.textInput.map { " with note \"\($0)\"" } ?? ""
            inbox.insert(InboxEntry(title: "\(action): \(response.notification.title)", detail: response.notification.id + note), at: 0)
            if response.action == .open, let destination = router.destination(for: response) {
                path = [destination]
            }
            await refresh()
        }
    }

    private func listenForPresentations() async {
        for await notification in events.presentations {
            inbox.insert(InboxEntry(title: "Shown in the app: \(notification.title)", detail: notification.id), at: 0)
            await refresh()
        }
    }

    /// A window from the current minute to one hour later, so its effect shows right away.
    private static func quietHoursForNextHour() -> QuietHours? {
        let calendar = Calendar.current
        let now = Date()
        let end = now.addingTimeInterval(3600)
        guard let start = TimeOfDay(hour: calendar.component(.hour, from: now), minute: calendar.component(.minute, from: now)),
              let finish = TimeOfDay(hour: calendar.component(.hour, from: end), minute: calendar.component(.minute, from: end))
        else { return nil }
        return try? QuietHours(start: start, end: finish)
    }
}
