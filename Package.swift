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
      url: "https://github.com/MacPaw/Setapp-Framework/releases/download/0.0.3/Setapp.xcframework.zip",
      checksum: "a169e053c1ea96193c95ddc506120c98bb05a352340f9945b5d458150008680b"
    ),
  ]
)
