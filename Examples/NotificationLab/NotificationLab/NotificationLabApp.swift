import NotificationKit
import SwiftUI
import UIKit

@main
struct NotificationLabApp: App {
    @UIApplicationDelegateAdaptor(LabAppDelegate.self) private var appDelegate
    @State private var model = LabModel.shared

    var body: some Scene {
        WindowGroup {
            LabView(model: model)
                .task { await model.start() }
        }
    }
}

final class LabAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Creating the model installs the notification delegate before launch finishes.
        _ = LabModel.shared
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        LabModel.shared.didRegister(deviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        LabModel.shared.didFailToRegister(error)
    }
}
