import Foundation

/// The `aps` dictionary of a push payload: what the system reads.
///
/// Field names follow Apple's payload keys (`thread-id` is ``threadID``, and so on). Dates are
/// sent as whole seconds since 1970.
public struct APS: Sendable, Hashable, Codable {
    public var alert: Alert?
    public var badge: Int?
    public var sound: NotificationSound?
    public var threadID: String?
    public var category: String?
    /// Wakes the app in the background (`content-available: 1`).
    public var contentAvailable: Bool
    /// Lets a Notification Service Extension change the content before it is shown
    /// (`mutable-content: 1`), for example to download an image.
    public var mutableContent: Bool
    public var targetContentID: String?
    public var interruptionLevel: InterruptionLevel?
    /// 0...1 for notifications; any number for Live Activities.
    public var relevanceScore: Double?
    public var filterCriteria: String?

    // Live Activities

    /// When the update was created; the system ignores updates older than the current one.
    public var timestamp: Date?
    public var event: LiveActivityEvent?
    /// The activity's `ContentState`, encoded the way your `ActivityAttributes` decodes it.
    public var contentState: JSONValue?
    public var staleDate: Date?
    public var dismissalDate: Date?
    /// The name of the `ActivityAttributes` type, for push-to-start.
    public var attributesType: String?
    public var attributes: JSONValue?

    public init(
        alert: Alert? = nil,
        badge: Int? = nil,
        sound: NotificationSound? = nil,
        threadID: String? = nil,
        category: String? = nil,
        contentAvailable: Bool = false,
        mutableContent: Bool = false,
        targetContentID: String? = nil,
        interruptionLevel: InterruptionLevel? = nil,
        relevanceScore: Double? = nil,
        filterCriteria: String? = nil,
        timestamp: Date? = nil,
        event: LiveActivityEvent? = nil,
        contentState: JSONValue? = nil,
        staleDate: Date? = nil,
        dismissalDate: Date? = nil,
        attributesType: String? = nil,
        attributes: JSONValue? = nil
    ) {
        self.alert = alert
        self.badge = badge
        self.sound = sound
        self.threadID = threadID
        self.category = category
        self.contentAvailable = contentAvailable
        self.mutableContent = mutableContent
        self.targetContentID = targetContentID
        self.interruptionLevel = interruptionLevel
        self.relevanceScore = relevanceScore
        self.filterCriteria = filterCriteria
        self.timestamp = timestamp
        self.event = event
        self.contentState = contentState
        self.staleDate = staleDate
        self.dismissalDate = dismissalDate
        self.attributesType = attributesType
        self.attributes = attributes
    }

    /// The visible part of a notification.
    public struct Alert: Sendable, Hashable, Codable {
        public var title: String?
        public var subtitle: String?
        public var body: String?
        public var launchImage: String?
        public var titleLocKey: String?
        public var titleLocArgs: [String]?
        public var subtitleLocKey: String?
        public var subtitleLocArgs: [String]?
        public var locKey: String?
        public var locArgs: [String]?

        public init(
            title: String? = nil,
            subtitle: String? = nil,
            body: String? = nil,
            launchImage: String? = nil,
            titleLocKey: String? = nil,
            titleLocArgs: [String]? = nil,
            subtitleLocKey: String? = nil,
            subtitleLocArgs: [String]? = nil,
            locKey: String? = nil,
            locArgs: [String]? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.body = body
            self.launchImage = launchImage
            self.titleLocKey = titleLocKey
            self.titleLocArgs = titleLocArgs
            self.subtitleLocKey = subtitleLocKey
            self.subtitleLocArgs = subtitleLocArgs
            self.locKey = locKey
            self.locArgs = locArgs
        }

        enum CodingKeys: String, CodingKey {
            case title, subtitle, body
            case launchImage = "launch-image"
            case titleLocKey = "title-loc-key"
            case titleLocArgs = "title-loc-args"
            case subtitleLocKey = "subtitle-loc-key"
            case subtitleLocArgs = "subtitle-loc-args"
            case locKey = "loc-key"
            case locArgs = "loc-args"
        }

        /// Apple also accepts a plain string, which is the body.
        public init(from decoder: any Decoder) throws {
            if let body = try? decoder.singleValueContainer().decode(String.self) {
                self.init(body: body)
                return
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.init(
                title: try container.decodeIfPresent(String.self, forKey: .title),
                subtitle: try container.decodeIfPresent(String.self, forKey: .subtitle),
                body: try container.decodeIfPresent(String.self, forKey: .body),
                launchImage: try container.decodeIfPresent(String.self, forKey: .launchImage),
                titleLocKey: try container.decodeIfPresent(String.self, forKey: .titleLocKey),
                titleLocArgs: try container.decodeIfPresent([String].self, forKey: .titleLocArgs),
                subtitleLocKey: try container.decodeIfPresent(String.self, forKey: .subtitleLocKey),
                subtitleLocArgs: try container.decodeIfPresent([String].self, forKey: .subtitleLocArgs),
                locKey: try container.decodeIfPresent(String.self, forKey: .locKey),
                locArgs: try container.decodeIfPresent([String].self, forKey: .locArgs)
            )
        }
    }
}

/// What a Live Activity push does.
public enum LiveActivityEvent: String, Sendable, Hashable, Codable {
    case start
    case update
    case end
}
