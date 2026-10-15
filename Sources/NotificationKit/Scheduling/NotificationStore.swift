import Foundation

/// What ``NotificationScheduler`` remembers between launches: the notifications it manages
/// (including the queued ones the system does not know about) and recent delivery dates for the
/// frequency cap.
public struct SchedulerState: Sendable, Hashable, Codable {
    public var entries: [ScheduledNotification]
    public var deliveryHistory: [Date]

    public init(entries: [ScheduledNotification] = [], deliveryHistory: [Date] = []) {
        self.entries = entries
        self.deliveryHistory = deliveryHistory
    }
}

/// Where ``NotificationScheduler`` keeps its ``SchedulerState``.
public protocol NotificationStore: Sendable {
    /// The saved state, or `nil` if nothing was saved yet.
    func load() async throws -> SchedulerState?
    func save(_ state: SchedulerState) async throws
}

/// Keeps the state in memory. Queued notifications are lost when the app quits, so use it for
/// tests and previews; apps use ``FileNotificationStore``.
public actor InMemoryNotificationStore: NotificationStore {
    private var state: SchedulerState?

    public init(state: SchedulerState? = nil) {
        self.state = state
    }

    public func load() async throws -> SchedulerState? { state }

    public func save(_ state: SchedulerState) async throws {
        self.state = state
    }
}

/// Keeps the state in a JSON file, by default in Application Support.
///
/// The file is written atomically. On iOS, watchOS and visionOS it is protected until the
/// device is first unlocked after a restart, so a background refresh can still read it.
public struct FileNotificationStore: NotificationStore {
    /// Why the file could not be read.
    public enum StoreError: Error, Hashable, Sendable {
        /// The file is larger than ``maximumFileSize``; it was not read.
        case fileTooLarge(Int)
    }

    /// Larger files are not read, so a corrupted or replaced file cannot exhaust memory.
    public static let maximumFileSize = 8 * 1024 * 1024

    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    /// `Application Support/NotificationKit/scheduler.json` in the app's container.
    public static func applicationSupport(fileName: String = "scheduler.json") -> FileNotificationStore {
        let directory = URL.applicationSupportDirectory.appendingPathComponent("NotificationKit", isDirectory: true)
        return FileNotificationStore(url: directory.appendingPathComponent(fileName))
    }

    public func load() async throws -> SchedulerState? {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let size = (try FileManager.default.attributesOfItem(atPath: url.path)[.size] as? NSNumber)?.intValue ?? 0
        guard size <= Self.maximumFileSize else { throw StoreError.fileTooLarge(size) }
        let data = try Data(contentsOf: url)
        guard data.count <= Self.maximumFileSize else { throw StoreError.fileTooLarge(data.count) }
        return try JSONDecoder().decode(SchedulerState.self, from: data)
    }

    public func save(_ state: SchedulerState) async throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(state)
        #if os(iOS) || os(watchOS) || os(visionOS)
        try data.write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
        #else
        try data.write(to: url, options: .atomic)
        #endif
    }
}
