// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSNotificationFramework",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "iOSNotificationFramework",
            targets: ["iOSNotificationFramework"]
        ),
        .library(
            name: "NotificationAnalytics",
            targets: ["NotificationAnalytics"]
        ),
        .library(
            name: "RichNotifications",
            targets: ["RichNotifications"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.0.0")
    ],
    targets: [
        .target(
            name: "iOSNotificationFramework",
            dependencies: ["Alamofire"],
            path: "Sources/Core",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release))
            ]
        ),
        .target(
            name: "NotificationAnalytics",
            dependencies: ["iOSNotificationFramework"],
            path: "Sources/Analytics",
            swiftSettings: [
                .define("ANALYTICS_ENABLED", .when(configuration: .debug))
            ]
        ),
        .target(
            name: "RichNotifications",
            dependencies: ["iOSNotificationFramework"],
            path: "Sources/RichNotifications",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "iOSNotificationFrameworkTests",
            dependencies: [
                "iOSNotificationFramework",
                "Quick",
                "Nimble"
            ],
            path: "Tests/Unit"
        ),
        .testTarget(
            name: "NotificationAnalyticsTests",
            dependencies: [
                "NotificationAnalytics",
                "Quick",
                "Nimble"
            ],
            path: "Tests/Analytics"
        ),
        .testTarget(
            name: "RichNotificationsTests",
            dependencies: [
                "RichNotifications",
                "Quick",
                "Nimble"
            ],
            path: "Tests/RichNotifications"
        )
    ],
    swiftSettings: [
        .enableUpcomingFeature("BareSlashRegexLiterals"),
        .enableUpcomingFeature("ConciseMagicFile"),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("ForwardTrailingClosures"),
        .enableUpcomingFeature("ImplicitOpenExistentials"),
        .enableUpcomingFeature("StrictConcurrency")
    ]
) 