// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DebugPane_Diagnostics",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "DebugPane_Diagnostics",
            targets: ["DebugPane_Diagnostics"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/antranapp/DebugPane",
            .branch("master")
        ),
        .package(
            url: "https://github.com/WeTransfer/Diagnostics",
            .upToNextMajor(from: "4.0.0")
        ),
        .package(
            url: "https://github.com/apple/swift-log",
            .upToNextMajor(from: "1.4.2")
        ),
    ],
    targets: [
        .target(
            name: "DebugPane_Diagnostics",
            dependencies: [
                "DebugPane",
                "Diagnostics",
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .testTarget(
            name: "DebugPane_DiagnosticsTests",
            dependencies: ["DebugPane_Diagnostics"]
        ),
    ]
)
