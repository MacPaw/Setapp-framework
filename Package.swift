// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Setapp",
  platforms: [
    .iOS(.v11),
    .macOS(.v10_13),
  ],
  products: [
    .library(
        name: "Setapp",
        targets: [
            "SetappWrapper"
        ]
    ),
  ],
  targets: [
    .target(
        name: "SetappWrapper",
        dependencies: [
            .target(
                name: "Setapp"
            ),
            .target(
                name: "SetappResources-iOS",
                condition: .when(platforms: [.iOS])
            )
        ]
    ),
    .binaryTarget(
        name: "Setapp",
        path: "Setapp.xcframework"
    ),
    .target(
        name: "SetappResources-iOS",
        resources: [
            .copy("Resources/Bundles/SetappFramework-Resources-iOS.bundle")
        ]
    ),
  ]
)
