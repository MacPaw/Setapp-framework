// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Setapp",
  platforms: [
    .iOS("10.3"),
  ],
  products: [
    .library(name: "Setapp", targets: ["Setapp"]),
  ],
  targets: [
    .binaryTarget(
      name: "Setapp",
      url: "https://github.com/MacPaw/Setapp-Framework/releases/download/0.0.1/Setapp.xcframework.zip",
      checksum: "d180df1dc04b349338751a256d0da81c0cde260a3916bb598f0af5c019960867"
    ),
  ]
)
