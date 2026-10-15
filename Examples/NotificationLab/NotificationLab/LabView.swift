import NotificationKit
import SwiftUI
import UIKit

struct LabView: View {
    @Bindable var model: LabModel

    var body: some View {
        NavigationStack(path: $model.path) {
            List {
                permissionSection
                scheduleSection
                scheduledSection
                inboxSection
            }
            .navigationTitle("Notification Lab")
            .navigationDestination(for: LabDestination.self) { DestinationView(destination: $0) }
            .refreshable { await model.refresh() }
        }
    }

    private var permissionSection: some View {
        Section {
            LabeledContent("Status", value: model.status.label)
                .accessibilityIdentifier("status")
            if model.status == .notDetermined {
                Button("Allow Notifications") { Task { await model.requestPermission() } }
                    .accessibilityIdentifier("allow")
            }
            Button("Register for Pushes") { UIApplication.shared.registerForRemoteNotifications() }
            if let message = model.message {
                Text(message).font(.footnote).foregroundStyle(.secondary)
                    .accessibilityIdentifier("message")
            }
        } header: {
            Text("Permission")
        }
    }

    private var scheduleSection: some View {
        Section {
            Button("Reminder in 5 Seconds") { Task { await model.scheduleReminder(after: 5) } }
                .accessibilityIdentifier("remind-5s")
            Button("Reminder in 1 Minute") { Task { await model.scheduleReminder(after: 60) } }
            Button("70 Reminders in an Hour") { Task { await model.scheduleBatch(count: 70) } }
                .accessibilityIdentifier("batch")
            Toggle("Quiet Hours for the Next Hour", isOn: Binding(
                get: { model.quietHoursEnabled },
                set: { enabled in Task { await model.setQuietHours(enabled) } }
            ))
            .accessibilityIdentifier("quiet-hours")
            Button("Cancel All", role: .destructive) { Task { await model.cancelAll() } }
                .accessibilityIdentifier("cancel-all")
        } header: {
            Text("Schedule")
        } footer: {
            Text("iOS keeps 64 pending notifications per app. The rest wait in the scheduler's queue and move up as slots free.")
        }
    }

    private var scheduledSection: some View {
        Section {
            if model.scheduled.isEmpty {
                Text("Nothing scheduled").foregroundStyle(.secondary)
            }
            ForEach(model.scheduled.prefix(30)) { entry in
                ScheduledRow(entry: entry)
            }
        } header: {
            let system = model.scheduled.filter { $0.placement == .system }.count
            Text("Scheduled · \(system) with iOS · \(model.scheduled.count - system) queued")
                .accessibilityIdentifier("scheduled-header")
        }
    }

    private var inboxSection: some View {
        Section("Received") {
            if model.inbox.isEmpty {
                Text("Nothing received yet").foregroundStyle(.secondary)
            }
            ForEach(model.inbox.prefix(10)) { entry in
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.title)
                    Text(entry.detail).font(.caption).foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityIdentifier("inbox-entry")
            }
        }
    }
}

struct ScheduledRow: View {
    let entry: ScheduledNotification

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.notification.title)
                if let fireDate = entry.fireDate {
                    Text(fireDate, format: .dateTime.hour().minute().second())
                        .font(.caption).foregroundStyle(.secondary)
                }
                if entry.adjustments.contains(.quietHours) {
                    Text("Moved to the end of quiet hours").font(.caption).foregroundStyle(.tint)
                }
            }
            Spacer()
            Text(entry.placement == .system ? "iOS" : "Queued")
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(entry.placement == .system ? Color.accentColor.opacity(0.15) : Color.secondary.opacity(0.15), in: Capsule())
        }
    }
}

struct DestinationView: View {
    let destination: LabDestination

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 48)).foregroundStyle(.tint)
            Text(title).font(.title2.weight(.semibold)).accessibilityIdentifier("destination-title")
            Text("Opened from a notification through DeepLinkRouter.").foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var title: String {
        switch destination {
        case .reminder(let id): "Reminder \(id)"
        case .order(let id): "Order \(id)"
        }
    }

    private var icon: String {
        switch destination {
        case .reminder: "drop"
        case .order: "shippingbox"
        }
    }
}

extension AuthorizationStatus {
    var label: String {
        switch self {
        case .notDetermined: "Not asked yet"
        case .denied: "Denied"
        case .authorized: "Allowed"
        case .provisional: "Provisional"
        case .ephemeral: "Ephemeral"
        }
    }
}
