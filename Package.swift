// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NotificationKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "NotificationKit",
            targets: ["NotificationKit"]
        )
    ],
    targets: [
        .target(
            name: "NotificationKit",
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
