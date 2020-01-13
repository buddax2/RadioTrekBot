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

//let package = Package(
//    name: "RadioTrekBot",
//    products: [
//           // Products define the executables and libraries produced by a package, and make them visible to other packages.
//           .executable(
//               name: "RadioTrekBot",
//               targets: ["RadioTrekBot"]
//           ),
//    ],
//    dependencies: [
//        // Dependencies declare other packages that this package depends on.
//         .package(url: "https://github.com/rapierorg/telegram-bot-swift.git", from: "1.2.4"),
//    ],
//    targets: [
//        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
//        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
//        .target(
//            name: "RadioTrekBot",
//            dependencies: ["TelegramBotSDK"]),
//        .testTarget(
//            name: "RadioTrekBotTests",
//            dependencies: ["RadioTrekBot"]),
//    ]
//)
