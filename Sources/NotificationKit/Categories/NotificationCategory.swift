import Foundation

/// A type of notification with its own action buttons.
///
/// ```swift
/// let message = NotificationCategory(
///     id: "message",
///     actions: [
///         .textInput(id: "reply", title: "Reply", buttonTitle: "Send", placeholder: "Message"),
///         .button(id: "mark-read", title: "Mark as Read"),
///     ]
/// )
/// await scheduler.register([message])
/// ```
///
/// A notification shows the buttons when its ``LocalNotification/categoryID`` (or the `category`
/// of a push payload) names the category.
public struct NotificationCategory: Sendable, Hashable, Identifiable {
    public var id: String
    public var actions: [NotificationAction]
    public var options: Options
    /// Shown instead of the body when the user hides previews, for example "%u new messages".
    public var hiddenPreviewsBodyPlaceholder: String?

    public init(
        id: String,
        actions: [NotificationAction] = [],
        options: Options = [],
        hiddenPreviewsBodyPlaceholder: String? = nil
    ) {
        self.id = id
        self.actions = actions
        self.options = options
        self.hiddenPreviewsBodyPlaceholder = hiddenPreviewsBodyPlaceholder
    }

    /// Category behaviour.
    public struct Options: OptionSet, Sendable, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        /// Report dismissals as ``NotificationResponse/Action/dismiss`` responses.
        public static let customDismissAction = Options(rawValue: 1 << 0)
        /// Show the title when previews are hidden.
        public static let hiddenPreviewsShowTitle = Options(rawValue: 1 << 1)
        /// Show the subtitle when previews are hidden.
        public static let hiddenPreviewsShowSubtitle = Options(rawValue: 1 << 2)
    }
}

/// A button shown with a notification.
public struct NotificationAction: Sendable, Hashable, Identifiable {
    /// What happens when the user picks the action.
    public enum Kind: Sendable, Hashable {
        case button
        /// Shows a text field; the text arrives in ``NotificationResponse/textInput``.
        case textInput(buttonTitle: String, placeholder: String)
    }

    /// Action behaviour.
    public struct Options: OptionSet, Sendable, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        /// Opens the app.
        public static let foreground = Options(rawValue: 1 << 0)
        /// Shown in red.
        public static let destructive = Options(rawValue: 1 << 1)
        /// Asks to unlock the device first.
        public static let authenticationRequired = Options(rawValue: 1 << 2)
    }

    public var id: String
    public var title: String
    public var kind: Kind
    public var options: Options
    /// An SF Symbol shown next to the title.
    public var systemImageName: String?

    public init(id: String, title: String, kind: Kind = .button, options: Options = [], systemImageName: String? = nil) {
        self.id = id
        self.title = title
        self.kind = kind
        self.options = options
        self.systemImageName = systemImageName
    }

    /// A plain button.
    public static func button(
        id: String,
        title: String,
        options: Options = [],
        systemImageName: String? = nil
    ) -> NotificationAction {
        NotificationAction(id: id, title: title, options: options, systemImageName: systemImageName)
    }

    /// A button that asks for text, such as a quick reply.
    public static func textInput(
        id: String,
        title: String,
        buttonTitle: String,
        placeholder: String = "",
        options: Options = [],
        systemImageName: String? = nil
    ) -> NotificationAction {
        NotificationAction(
            id: id,
            title: title,
            kind: .textInput(buttonTitle: buttonTitle, placeholder: placeholder),
            options: options,
            systemImageName: systemImageName
        )
    }
}
