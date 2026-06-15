#if os(iOS) && canImport(ActivityKit)
import ActivityKit
import Foundation

/// A high-integrity wrapper for Live Activities (Dynamic Island / Lock Screen).
/// 
/// Reduces the boilerplate of `ActivityKit` down to a single line of code,
/// fully compliant with Swift 6 strict concurrency.
@available(iOS 16.1, *)
public actor LiveActivityManager<Attributes: ActivityAttributes> {
    
    private var currentActivity: Activity<Attributes>?
    
    public init() {}
    
    /// Starts a new Live Activity.
    public func start(attributes: Attributes, initialState: Attributes.ContentState) throws {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            throw LiveActivityError.notAuthorized
        }
        
        let content = ActivityContent(state: initialState, staleDate: nil)
        currentActivity = try Activity.request(attributes: attributes, content: content)
    }
    
    /// Updates the existing Live Activity with new state.
    public func update(state: Attributes.ContentState) async {
        guard let activity = currentActivity else { return }
        let content = ActivityContent(state: state, staleDate: nil)
        await activity.update(content)
    }
    
    /// Ends the Live Activity.
    public func end(finalState: Attributes.ContentState) async {
        guard let activity = currentActivity else { return }
        let content = ActivityContent(state: finalState, staleDate: nil)
        await activity.end(content, dismissalPolicy: .default)
        currentActivity = nil
    }
}

public enum LiveActivityError: Error {
    case notAuthorized
    case activityFailedToStart
}
#endif
