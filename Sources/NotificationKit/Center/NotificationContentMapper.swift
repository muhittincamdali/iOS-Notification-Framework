import Foundation
@preconcurrency import UserNotifications
#if os(iOS) || os(watchOS)
import CoreLocation
#endif

/// Converts NotificationKit values into the UserNotifications types.
enum NotificationContentMapper {
    static func content(for notification: LocalNotification) throws -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.subtitle = notification.subtitle
        content.body = notification.body
        content.badge = notification.badge.map { NSNumber(value: $0) }
        content.sound = notification.sound.map(sound(for:))
        content.categoryIdentifier = notification.categoryID ?? ""
        content.threadIdentifier = notification.threadID ?? ""
        content.userInfo = JSONValue.object(notification.userInfo).userInfo
        content.interruptionLevel = notification.interruptionLevel.unLevel
        content.relevanceScore = notification.relevanceScore
        content.targetContentIdentifier = notification.targetContentID
        content.filterCriteria = notification.filterCriteria
        #if !os(watchOS)
        content.attachments = try notification.attachments.map(attachment(for:))
        #endif
        return content
    }

    static func sound(for sound: NotificationSound) -> UNNotificationSound {
        switch sound {
        case .default:
            return .default
        case .named(let name):
            #if os(watchOS)
            // watchOS plays only the default sound for local notifications.
            _ = name
            return .default
            #else
            return UNNotificationSound(named: UNNotificationSoundName(name))
            #endif
        case .defaultCritical(let volume):
            #if os(iOS) || os(watchOS) || os(visionOS)
            return .defaultCriticalSound(withAudioVolume: Float(volume))
            #else
            return .default
            #endif
        case .critical(let name, let volume):
            #if os(iOS) || os(visionOS)
            return .criticalSoundNamed(UNNotificationSoundName(name), withAudioVolume: Float(volume))
            #elseif os(watchOS)
            _ = name
            return .defaultCriticalSound(withAudioVolume: Float(volume))
            #else
            return UNNotificationSound(named: UNNotificationSoundName(name))
            #endif
        }
    }

    static func trigger(for trigger: NotificationTrigger, calendar: Calendar) throws -> UNNotificationTrigger? {
        switch trigger {
        case .immediately:
            return nil
        case .timeInterval(let interval, let repeats):
            return UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        case .date(let date):
            let components = calendar.dateComponents(
                [.calendar, .timeZone, .year, .month, .day, .hour, .minute, .second],
                from: date
            )
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        case .calendar(let components, let repeats):
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        case .region(let region, let repeats):
            #if os(iOS) || os(watchOS)
            let circular = CLCircularRegion(
                center: CLLocationCoordinate2D(latitude: region.latitude, longitude: region.longitude),
                radius: region.radius,
                identifier: region.identifier
            )
            circular.notifyOnEntry = region.notifyOnEntry
            circular.notifyOnExit = region.notifyOnExit
            return UNLocationNotificationTrigger(region: circular, repeats: repeats)
            #else
            _ = (region, repeats)
            throw NotificationValidationError.unsupportedTrigger
            #endif
        }
    }

    #if !os(watchOS)
    /// The system moves an attachment's file into its own store, so it gets a copy and the
    /// original stays available for scheduling the notification again.
    static func attachment(for attachment: NotificationAttachment) throws -> UNNotificationAttachment {
        guard attachment.url.isFileURL else { throw NotificationValidationError.invalidAttachment(attachment.url) }
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("NotificationKitAttachments", isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let copy = directory.appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(attachment.url.pathExtension)
        try FileManager.default.copyItem(at: attachment.url, to: copy)
        var options: [String: Any] = [UNNotificationAttachmentOptionsThumbnailHiddenKey: attachment.hidesThumbnail]
        if let typeHint = attachment.typeHint {
            options[UNNotificationAttachmentOptionsTypeHintKey] = typeHint
        }
        do {
            return try UNNotificationAttachment(identifier: attachment.id, url: copy, options: options)
        } catch {
            try? FileManager.default.removeItem(at: copy)
            throw error
        }
    }
    #endif

    static func category(for category: NotificationCategory) -> UNNotificationCategory {
        var options: UNNotificationCategoryOptions = []
        if category.options.contains(.customDismissAction) { options.insert(.customDismissAction) }
        #if os(iOS) || os(visionOS)
        if category.options.contains(.hiddenPreviewsShowTitle) { options.insert(.hiddenPreviewsShowTitle) }
        if category.options.contains(.hiddenPreviewsShowSubtitle) { options.insert(.hiddenPreviewsShowSubtitle) }
        #endif
        let actions = category.actions.map(action(for:))
        #if os(iOS) || os(visionOS) || os(macOS)
        if let placeholder = category.hiddenPreviewsBodyPlaceholder {
            return UNNotificationCategory(
                identifier: category.id,
                actions: actions,
                intentIdentifiers: [],
                hiddenPreviewsBodyPlaceholder: placeholder,
                options: options
            )
        }
        #endif
        return UNNotificationCategory(identifier: category.id, actions: actions, intentIdentifiers: [], options: options)
    }

    static func action(for action: NotificationAction) -> UNNotificationAction {
        var options: UNNotificationActionOptions = []
        if action.options.contains(.foreground) { options.insert(.foreground) }
        if action.options.contains(.destructive) { options.insert(.destructive) }
        if action.options.contains(.authenticationRequired) { options.insert(.authenticationRequired) }
        let icon = action.systemImageName.map { UNNotificationActionIcon(systemImageName: $0) }
        switch action.kind {
        case .button:
            return UNNotificationAction(identifier: action.id, title: action.title, options: options, icon: icon)
        case .textInput(let buttonTitle, let placeholder):
            return UNTextInputNotificationAction(
                identifier: action.id,
                title: action.title,
                options: options,
                icon: icon,
                textInputButtonTitle: buttonTitle,
                textInputPlaceholder: placeholder
            )
        }
    }
}
