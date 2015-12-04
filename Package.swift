import PackageDescription

let package = Package(
    name: "SwiftFoundation",
    dependencies: [
        .Package(url: "../JSON", majorVersion: 1),
        .Package(url: "../b64", majorVersion: 1)
    ]
)