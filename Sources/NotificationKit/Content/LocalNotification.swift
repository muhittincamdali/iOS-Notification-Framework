import Foundation

/// A notification that the app schedules on the device.
///
/// `LocalNotification` is a value type: build it, change it, compare it, store it. It becomes a
/// `UNNotificationRequest` only when ``NotificationScheduler`` hands it to the system.
///
/// ```swift
/// var reminder = LocalNotification(
///     id: "water",
///     title: "Time for a glass of water",
///     body: "You set this reminder an hour ago.",
///     trigger: .after(hours: 1)
/// )
/// reminder.sound = .default
/// reminder.deepLink = URL(string: "myapp://reminders/water")
/// ```
public struct LocalNotification: Sendable, Hashable, Codable, Identifiable {
    /// The longest identifier accepted.
    public static let maximumIdentifierLength = 256
    /// The `userInfo` key that holds ``deepLink``. Push payloads use the same key, so one
    /// ``DeepLinkRouter`` handles both.
    public static let deepLinkKey = "deeplink"

    /// Identifies the notification. Scheduling another notification with the same identifier
    /// replaces this one.
    public var id: String
    public var title: String
    public var subtitle: String
    public var body: String
    /// The number on the app icon after delivery; `nil` leaves it unchanged, `0` clears it.
    public var badge: Int?
    /// `nil` delivers the notification silently.
    public var sound: NotificationSound?
    /// The identifier of a registered ``NotificationCategory``, which adds action buttons.
    public var categoryID: String?
    /// Notifications with the same thread identifier are grouped together.
    public var threadID: String?
    /// Custom data, delivered back in ``ReceivedNotification/userInfo``.
    public var userInfo: [String: JSONValue]
    public var interruptionLevel: InterruptionLevel
    /// How the system ranks this notification in a summary, from 0 to 1.
    public var relevanceScore: Double
    /// Which scene the system brings forward when the user opens the notification.
    public var targetContentID: String?
    /// Which Focus filter shows the notification (iOS 16 and later).
    public var filterCriteria: String?
    /// Images, audio or video shown with the notification (not available on watchOS).
    public var attachments: [NotificationAttachment]
    public var trigger: NotificationTrigger

    public init(
        id: String,
        title: String = "",
        subtitle: String = "",
        body: String = "",
        badge: Int? = nil,
        sound: NotificationSound? = .default,
        categoryID: String? = nil,
        threadID: String? = nil,
        userInfo: [String: JSONValue] = [:],
        interruptionLevel: InterruptionLevel = .active,
        relevanceScore: Double = 0,
        targetContentID: String? = nil,
        filterCriteria: String? = nil,
        attachments: [NotificationAttachment] = [],
        trigger: NotificationTrigger = .immediately
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.badge = badge
        self.sound = sound
        self.categoryID = categoryID
        self.threadID = threadID
        self.userInfo = userInfo
        self.interruptionLevel = interruptionLevel
        self.relevanceScore = relevanceScore
        self.targetContentID = targetContentID
        self.filterCriteria = filterCriteria
        self.attachments = attachments
        self.trigger = trigger
    }

    /// A URL that ``DeepLinkRouter`` opens when the user taps the notification. Stored in
    /// ``userInfo`` under ``deepLinkKey``.
    public var deepLink: URL? {
        get { userInfo[Self.deepLinkKey]?.stringValue.flatMap(URL.init(string:)) }
        set { userInfo[Self.deepLinkKey] = newValue.map { .string($0.absoluteString) } }
    }

    /// Checks every value the system would reject, silently drop or crash on.
    public func validate(calendar: Calendar = .current) throws(NotificationValidationError) {
        guard !id.isEmpty, id.count <= Self.maximumIdentifierLength else { throw .invalidIdentifier }
        if title.isEmpty, subtitle.isEmpty, body.isEmpty, badge == nil, sound == nil {
            throw .emptyContent
        }
        if let badge, badge < 0 { throw .negativeBadge(badge) }
        try sound?.validate()
        guard relevanceScore.isFinite, (0...1).contains(relevanceScore) else {
            throw .invalidRelevanceScore(relevanceScore)
        }
        try trigger.validate(calendar: calendar)
        guard JSONValue.object(userInfo).isWithinLimits(.default) else { throw .invalidUserInfo }
        for attachment in attachments where !attachment.url.isFileURL {
            throw .invalidAttachment(attachment.url)
        }
    }
}

/// A file shown with a notification.
///
/// The system moves the file into its own store when the notification is scheduled.
/// ``NotificationScheduler`` gives the system a copy, so the original stays where it is and a
/// notification that waits in the queue can still be scheduled later.
public struct NotificationAttachment: Sendable, Hashable, Codable, Identifiable {
    public var id: String
    /// A local file URL: an image (up to 10 MB), audio (5 MB) or video (50 MB).
    public var url: URL
    /// A uniform type identifier, such as `public.jpeg`, when the file name has no extension.
    public var typeHint: String?
    public var hidesThumbnail: Bool

    public init(id: String, url: URL, typeHint: String? = nil, hidesThumbnail: Bool = false) {
        self.id = id
        self.url = url
        self.typeHint = typeHint
        self.hidesThumbnail = hidesThumbnail
    }
}

extension JSONValue {
    /// Whether the value nests no deeper and holds no more values than `limits` allow, and every
    /// number is finite. The walk stops at the depth limit, so it is bounded for any input.
    public func isWithinLimits(_ limits: Limits) -> Bool {
        var budget = limits.maximumValueCount
        return isWithinLimits(depth: 0, limits: limits, budget: &budget)
    }

    private func isWithinLimits(depth: Int, limits: Limits, budget: inout Int) -> Bool {
        budget -= 1
        guard budget >= 0, depth <= limits.maximumDepth else { return false }
        switch self {
        case .null, .bool, .string:
            return true
        case .number(let value):
            return value.isFinite
        case .array(let values):
            return values.allSatisfy { $0.isWithinLimits(depth: depth + 1, limits: limits, budget: &budget) }
        case .object(let values):
            return values.values.allSatisfy { $0.isWithinLimits(depth: depth + 1, limits: limits, budget: &budget) }
        }
    }
}
