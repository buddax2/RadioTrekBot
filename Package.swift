// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RadioTrekBot",
    dependencies: [
        .package(url: "https://github.com/givip/Telegrammer.git", from: "0.5.0")
        ],
    targets: [
        .target( name: "RadioTrekBot", dependencies: ["Telegrammer"])
        ]
)
