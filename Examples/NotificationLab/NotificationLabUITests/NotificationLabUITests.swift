import XCTest

/// End-to-end tests on a simulator: real UNUserNotificationCenter, real banners, real taps.
///
/// `scripts/capture-screenshots.sh` runs them with `SCREENSHOT_DIR` set to save the README
/// screenshots, and sends the push that `testPushOpensOrder` waits for.
@MainActor
final class NotificationLabUITests: XCTestCase {
    private var springboard: XCUIApplication!
    private var app: XCUIApplication!

    override func setUp() async throws {
        springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-reset"]
        app.launch()
        allowNotifications()
    }

    func testReminderBannerOpensTheReminder() throws {
        app.buttons["remind-5s"].tap()
        XCTAssertTrue(waitForText("1 with iOS", timeout: 5))
        save("schedule")

        XCUIDevice.shared.press(.home)
        let banner = springboard.descendants(matching: .any)
            .matching(NSPredicate(format: "label CONTAINS[c] 'Water break'")).firstMatch
        XCTAssertTrue(banner.waitForExistence(timeout: 30), "No banner appeared")
        Thread.sleep(forTimeInterval: 1) // let the banner finish sliding in
        save("banner", screen: true)

        banner.tap()
        XCTAssertTrue(waitForText("Reminder reminder-", timeout: 10))
        save("destination")

        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(waitForText("Opened: Water break", timeout: 5))
    }

    func testQueueKeepsNotificationsBeyondTheLimit() throws {
        app.buttons["batch"].tap()
        XCTAssertTrue(waitForText("64 with iOS · 6 queued", timeout: 10))

        app.switches["quiet-hours"].switches.firstMatch.tap()
        app.buttons["remind-5s"].tap()
        // The new reminder falls in quiet hours, so it waits for the end of the window. It is
        // still sooner than the batch, so it takes a slot and one more batch reminder is queued.
        XCTAssertTrue(waitForText("64 with iOS · 7 queued", timeout: 10))
        XCTAssertTrue(waitForText("Moved to the end of quiet hours", timeout: 5))
        // Scroll the scheduled list to the top of the screen for the README screenshot.
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.85))
        start.press(forDuration: 0.1, thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2)))
        save("queue")
        app.swipeDown()
        app.swipeDown()
        app.buttons["cancel-all"].tap()
        XCTAssertTrue(waitForText("0 with iOS · 0 queued", timeout: 10))
    }

    /// Waits for a push sent with `xcrun simctl push` (see scripts/capture-screenshots.sh).
    func testPushOpensOrder() throws {
        guard let marker = ProcessInfo.processInfo.environment["PUSH_READY_FILE"] else {
            throw XCTSkip("Run by scripts/capture-screenshots.sh, which sends the push.")
        }
        XCUIDevice.shared.press(.home)
        FileManager.default.createFile(atPath: marker, contents: Data("ready".utf8))
        let banner = springboard.descendants(matching: .any)
            .matching(NSPredicate(format: "label CONTAINS[c] 'Order shipped'")).firstMatch
        XCTAssertTrue(banner.waitForExistence(timeout: 60), "The push did not arrive")
        Thread.sleep(forTimeInterval: 1)
        save("push-banner", screen: true)
        banner.tap()
        XCTAssertTrue(waitForText("Order A-1042", timeout: 10))
        save("push-destination")
    }

    // MARK: - Helpers

    private func allowNotifications() {
        let allow = app.buttons["allow"]
        guard allow.waitForExistence(timeout: 3) else { return }
        // The permission prompt is a system alert. XCTest calls the monitor when the test next
        // interacts with the app while the alert is up.
        let monitor = addUIInterruptionMonitor(withDescription: "Notification permission") { alert in
            let button = alert.buttons["Allow"]
            guard button.exists else { return false }
            button.tap()
            return true
        }
        defer { removeUIInterruptionMonitor(monitor) }
        allow.tap()
        let deadline = Date().addingTimeInterval(20)
        while Date() < deadline {
            if app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Allowed'")).firstMatch.exists { return }
            app.navigationBars.firstMatch.tap()
            Thread.sleep(forTimeInterval: 0.5)
        }
        XCTFail("Permission was not granted\n\(springboard.debugDescription)")
    }

    /// Waits for any text in the app whose label contains `text`.
    private func waitForText(_ text: String, timeout: TimeInterval) -> Bool {
        let found = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", text)).firstMatch.waitForExistence(timeout: timeout)
        if !found { print("Text not found: \(text)\n\(app.debugDescription)") }
        return found
    }

    /// Saves a screenshot for the README when SCREENSHOT_DIR is set, and attaches it to the
    /// test result either way.
    private func save(_ name: String, screen: Bool = false) {
        let screenshot = screen ? XCUIScreen.main.screenshot() : app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
        let environment = ProcessInfo.processInfo.environment
        guard let directory = environment["SCREENSHOT_DIR"] else { return }
        let appearance = environment["APPEARANCE"] ?? "light"
        let url = URL(fileURLWithPath: directory).appendingPathComponent("\(name)-\(appearance).png")
        try? screenshot.pngRepresentation.write(to: url)
    }
}
