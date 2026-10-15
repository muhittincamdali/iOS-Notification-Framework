// swift-tools-version: 6.2
import PackageDescription

// A command-line push sender that uses NotificationKitAPNs from this checkout.
let package = Package(
    name: "PushSender",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(name: "NotificationKit", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "nk-push",
            dependencies: [.product(name: "NotificationKitAPNs", package: "NotificationKit")]
        )
    ]
)
