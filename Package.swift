// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "NotificationKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "NotificationKit", targets: ["NotificationKit"]),
        .library(name: "NotificationKitAPNs", targets: ["NotificationKitAPNs"])
    ],
    targets: [
        .target(
            name: "NotificationKit",
            path: "Sources/NotificationKit"
        ),
        .target(
            name: "NotificationKitAPNs",
            dependencies: ["NotificationKit"],
            path: "Sources/NotificationKitAPNs"
        ),
        .testTarget(
            name: "NotificationKitTests",
            dependencies: ["NotificationKit"]
        ),
        .testTarget(
            name: "NotificationKitAPNsTests",
            dependencies: ["NotificationKitAPNs"]
        )
    ]
)
