// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SecureTextField",
    platforms: [
           .iOS(.v12),
       ],
    products: [
        .library(
            name: "SecureTextField",
            targets: ["SecureTextField"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SecureTextField",
            dependencies: []),
    ],
    swiftLanguageVersions: [.v5]
)
