// swift-tools-version:5.1
import PackageDescription

let libraryType: PackageDescription.Product.Library.LibraryType
#if os(Linux)
libraryType = .dynamic
#else
libraryType = .static
#endif

let package = Package(
    name: "SwiftFoundation",
    products: [
        .library(
            name: "SwiftFoundation",
            type: libraryType,
            targets: ["SwiftFoundation"]
        )
    ],
    targets: [
        .target(name: "SwiftFoundation"),
        .testTarget(name: "SwiftFoundationTests", dependencies: ["SwiftFoundation"])
    ]
)
