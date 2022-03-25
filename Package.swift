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
            targets: ["DebugPane_Diagnostics"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/antranapp/DebugPane",
            .branch("master")
        ),
        .package(
            url: "https://github.com/WeTransfer/Diagnostics.git",
            .upToNextMajor(from: "3.0.0")
        )
    ],
    targets: [
        .target(
            name: "DebugPane_Diagnostics",
            dependencies: [
                "DebugPane",
                "Diagnostics"
            ]
        ),
        .testTarget(
            name: "DebugPane_DiagnosticsTests",
            dependencies: ["DebugPane_Diagnostics"]
        ),
    ]
)
