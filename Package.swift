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
        .library(name: "NotificationKit", targets: ["NotificationKit"])
    ],
    targets: [
        .target(
            name: "NotificationKit",
            path: "Sources/NotificationKit"
        ),
        .testTarget(
            name: "NotificationKitTests",
            dependencies: ["NotificationKit"]
        )
    ]
)
