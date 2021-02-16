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
      url: "https://raw.githubusercontent.com/MacPaw/Setapp-framework/adguard/Setapp.xcframework.zip",
      checksum: "2838a1a373ec02deda30070cb113fed6acff187f812dfa15877ce8ead8635754"
    ),
  ]
)
