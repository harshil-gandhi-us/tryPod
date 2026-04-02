// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "keyboardpod",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "keyboardpod",
            targets: ["keyboardpod"]
        )
    ],
    targets: [
        .target(
            name: "keyboardpod",
            path: "Sources/keyboardpod"
        )
    ]
)
