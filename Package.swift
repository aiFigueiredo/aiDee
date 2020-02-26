// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aiDee",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "aiDee", targets: ["aiDee"]),
    ],
    targets: [
        .target(name: "aiDee", dependencies: [], path: "aiDee/aiDee"),
        .testTarget(name: "aiDeeTests", dependencies: ["aiDee"], path: "aiDee/aiDeeTests"),
    ]
)
