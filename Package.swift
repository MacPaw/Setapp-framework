// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Setapp",
  platforms: [
    .iOS("10.0"),
  ],
  products: [
    .library(name: "Setapp", targets: ["Setapp"]),
  ],
  targets: [
    .binaryTarget(
      name: "Setapp",
      url: "https://github.com/MacPaw/Setapp-Framework/releases/download/0.1.0/Setapp.xcframework.zip",
      checksum: "cd1b0ac645c38d3463a59ad23eaa3a591a465f4554eaa3e5c5c59cbc3fda1298"
    ),
  ]
)
