// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogoraSDK",
    defaultLocalization: "en",
    products: [
        .library(
            name: "LogoraSDK",
            targets: ["LogoraSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.1"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "6.3.0"),
        .package(url: "https://github.com/mchoe/SwiftSVG", from: "2.3.2"),
    ],
    targets: [
        .target(
            name: "LogoraSDK",
            dependencies: []),
        .testTarget(
            name: "LogoraSDKTests",
            dependencies: ["LogoraSDK"]),
    ]
)
