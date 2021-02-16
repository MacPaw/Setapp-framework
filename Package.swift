// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Setapp",
  platforms: [
    .iOS("10.0"),
  ],
  products: [
    .library(name: "Setapp", type: .dynamic, targets: ["Setapp"]),
  ],
  targets: [
    .binaryTarget(
      name: "Setapp",
      path: "Setapp.xcframework"
    ),
  ]
)
