// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "IRStickerSwift",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "IRStickerSwift",
            targets: ["IRStickerSwift"]
        )
    ],
    targets: [
        .target(
            name: "IRStickerSwift",
            path: "IRSticker-swift/IRSticker-swift",
            resources: [
                .process("IRSticker.bundle")
            ]
        ),
        .testTarget(
            name: "IRStickerSwiftTests",
            dependencies: ["IRStickerSwift"],
            path: "IRSticker-swift/IRSticker-swiftTests"
        )
    ]
)
