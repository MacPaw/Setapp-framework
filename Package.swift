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
      url: "https://github.com/MacPaw/Setapp-Framework/releases/download/0.0.4/Setapp.xcframework.zip",
      checksum: "6b2101b443b546987369760873a1557df9e6ecef71ec492fa67eefb83bdcda7f"
    ),
  ]
)
