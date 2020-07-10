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
      url: "https://github.com/MacPaw/Setapp-Framework/releases/download/0.0.2/Setapp.xcframework.zip",
      checksum: "4611a8dbc0f758bdc3808f79b730b167ca5401c3032626c97b16ec2bc1d1f1f3"
    ),
  ]
)
