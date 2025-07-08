// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "FileStatToJson",
  products: [
    .library(
      name: "FileStatToJson",
      targets: ["FileStatToJson"])
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.59.1")
  ],
  targets: [
    .target(
      name: "FileStatToJson"),
    .testTarget(
      name: "FileStatToJsonTests",
      dependencies: ["FileStatToJson"]
    ),
  ]
)
