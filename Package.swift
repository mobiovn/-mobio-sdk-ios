// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "MobioSDK",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "MobioSDK",
            targets: ["MobioSDK"]),
    ],
    targets: [
        .target(
            name: "MobioSDK",
            path: "Sources")
    ]
)
