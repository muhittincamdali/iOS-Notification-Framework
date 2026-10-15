import Foundation

/// A notification as the app sees it when it arrives in the foreground or the user acts on it.
public struct ReceivedNotification: Sendable, Hashable, Identifiable {
    public var id: String
    public var title: String
    public var subtitle: String
    public var body: String
    public var categoryID: String
    public var threadID: String
    /// Custom data. Values that JSON cannot represent are left out.
    public var userInfo: [String: JSONValue]
    public var date: Date
    /// Whether the notification came from a push rather than from the app.
    public var isRemote: Bool

    public init(
        id: String,
        title: String = "",
        subtitle: String = "",
        body: String = "",
        categoryID: String = "",
        threadID: String = "",
        userInfo: [String: JSONValue] = [:],
        date: Date = Date(),
        isRemote: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.categoryID = categoryID
        self.threadID = threadID
        self.userInfo = userInfo
        self.date = date
        self.isRemote = isRemote
    }

    /// The URL stored under ``LocalNotification/deepLinkKey``, if any.
    public var deepLink: URL? {
        userInfo[LocalNotification.deepLinkKey]?.stringValue.flatMap(URL.init(string:))
    }
}

/// The user's answer to a notification: a tap, a dismissal or an action button.
public struct NotificationResponse: Sendable, Hashable {
    /// What the user did.
    public enum Action: Sendable, Hashable {
        /// Tapped the notification, which opened the app.
        case open
        /// Dismissed it. Reported only for categories with
        /// ``NotificationCategory/Options/customDismissAction``.
        case dismiss
        /// Picked the action button with this identifier.
        case custom(String)
    }

    public var notification: ReceivedNotification
    public var action: Action
    /// The text typed into a ``NotificationAction/textInput(id:title:buttonTitle:placeholder:options:systemImageName:)``
    /// action.
    public var textInput: String?

    public init(notification: ReceivedNotification, action: Action, textInput: String? = nil) {
        self.notification = notification
        self.action = action
        self.textInput = textInput
    }
}

/// How a notification that arrives while the app is in the foreground is shown.
public struct PresentationOptions: OptionSet, Sendable, Hashable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let banner = PresentationOptions(rawValue: 1 << 0)
    public static let list = PresentationOptions(rawValue: 1 << 1)
    public static let sound = PresentationOptions(rawValue: 1 << 2)
    public static let badge = PresentationOptions(rawValue: 1 << 3)

    /// Banner, list, sound and badge: shown as if the app were in the background.
    public static let standard: PresentationOptions = [.banner, .list, .sound, .badge]
}

extension JSONValue {
    /// Converts each `userInfo` value on its own and leaves out the ones JSON cannot represent,
    /// so one `Date` in a payload does not hide the rest of it.
    static func lenientObject(from userInfo: [AnyHashable: Any], limits: Limits = .default) -> [String: JSONValue] {
        var result: [String: JSONValue] = [:]
        var remaining = limits.maximumValueCount
        for (key, value) in userInfo {
            guard let key = key.base as? String, remaining > 0 else { continue }
            let perValue = Limits(maximumDepth: limits.maximumDepth, maximumValueCount: remaining)
            guard let converted = try? JSONValue(any: value, limits: perValue) else { continue }
            remaining -= converted.valueCount
            result[key] = converted
        }
        return result
    }

    /// The number of values, counting nested ones. Only called on values that passed a
    /// conversion with limits, so the recursion is bounded.
    var valueCount: Int {
        switch self {
        case .null, .bool, .number, .string: 1
        case .array(let values): values.reduce(1) { $0 + $1.valueCount }
        case .object(let values): values.values.reduce(1) { $0 + $1.valueCount }
        }
    }
}
