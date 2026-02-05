// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotificationKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "NotificationKit",
            targets: ["NotificationKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NotificationKit",
            dependencies: [],
            path: "Sources/NotificationKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "NotificationKitTests",
            dependencies: ["NotificationKit"],
            path: "Tests/NotificationKitTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
