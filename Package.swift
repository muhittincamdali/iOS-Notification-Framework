// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotificationFramework",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NotificationFramework",
            targets: ["NotificationFramework"]),
        .library(
            name: "NotificationFrameworkUI",
            targets: ["NotificationFrameworkUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NotificationFramework",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
            ],
            path: "Sources/Core",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
            ]
        ),
        .target(
            name: "NotificationFrameworkUI",
            dependencies: ["NotificationFramework"],
            path: "Sources/UI",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
            ]
        ),
        .testTarget(
            name: "NotificationFrameworkTests",
            dependencies: ["NotificationFramework"],
            path: "Tests/Core",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "NotificationFrameworkUITests",
            dependencies: ["NotificationFrameworkUI"],
            path: "Tests/UI",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "NotificationFrameworkIntegrationTests",
            dependencies: ["NotificationFramework", "NotificationFrameworkUI"],
            path: "Tests/Integration",
            resources: [
                .process("Resources")
            ]
        ),
    ]
) 