import PackageDescription

let package = Package(
    name: "SwiftFoundation",
    targets: [
        Target(
            name: "UnitTests",
            dependencies: [.Target(name: "SwiftFoundation")]),
        Target(
            name: "SwiftFoundation")
    ],
    dependencies: [
        .Package(url: "https://github.com/PureSwift/CStatfs.git", majorVersion: 1),
        .Package(url: "https://github.com/PureSwift/CJSONC.git", majorVersion: 1)
    ],
    exclude: ["Xcode", "Carthage"]
)
