// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "FilenameToStatToJson",
  dependencies: [
    .package(path: "../../..")
  ],
  targets: [
    .executableTarget(
      name: "FilenameToStatToJson",
      dependencies: [
        .product(name: "FileStatToJson", package: "sw-fstat2json")
      ],
    )
  ]
)
