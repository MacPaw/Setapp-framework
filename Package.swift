// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Setapp",
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
        .macCatalyst(.v15)
    ],
    products: [
        .library(
            name: "Setapp",
            targets: [
                "SetappWrapper"
            ]
        )
    ],
    targets: [
        .target(
            name: "SetappWrapper",
            dependencies: [
                .target(
                    name: "Setapp"
                ),
                .target(
                    name: "SetappResources"
                )
            ]
        ),
        .binaryTarget(
            name: "Setapp",
            path: "Setapp.xcframework"
        ),
        .target(
            name: "SetappResources",
            resources: [
                .copy("Resources/Bundles/SetappFramework-Resources.bundle")
            ]
        )
    ]
)
