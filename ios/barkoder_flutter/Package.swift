// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "barkoder_flutter",
    platforms: [
        .iOS("15.0"),
    ],
    products: [
        .library(name: "barkoder-flutter", targets: ["barkoder_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "barkoder_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .target(name: "Barkoder"),
                .target(name: "BarkoderSDK"),
            ],
            resources: [
            ]
        ),
        
            .binaryTarget(
                name: "Barkoder",
                path: "Barkoder.xcframework"
            ),

            .binaryTarget(
                name: "BarkoderSDK",
                path: "BarkoderSDK.xcframework"
            )
    ]
)
