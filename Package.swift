// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-tryouts",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .macCatalyst(.v18)],
    products: [
        .library(name: "SwiftUISupport", targets: ["SwiftUISupport"]),
        .library(name: "TestingSupport", targets: ["TestingSupport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0")
    ],
    targets: [
        // SwiftUISupport module
        .tryoutTarget(name: "SwiftUISupport"),
        .tryoutTestTarget(
            name: "SwiftUISupportTests",
            dependencies: [
                .target(name: "SwiftUISupport"),
                .target(name: "TestingSupport"),
            ]
        ),

        // TestingSupport module
        .tryoutTarget(
            name: "TestingSupport",
            dependencies: [
                .product(name: "Numerics", package: "swift-numerics")
            ]
        ),
        .tryoutTestTarget(
            name: "TestingSupportTests",
            dependencies: [
                .target(name: "TestingSupport")
            ]
        ),
    ]
)

extension PackageDescription.Target {

    /// Creates a regular target.
    /// - Parameters:
    ///   - name: The name of the target. It will be used to derive the custom path for the target.
    ///   - dependencies: The dependencies of the target. A dependency can be another target in the package or a product from a package dependency.
    static func tryoutTarget(name: String, dependencies: [Target.Dependency] = []) -> Target {
        .target(name: name, dependencies: dependencies, path: sourcesPath(for: name))
    }

    /// Creates a test target.
    /// - Parameters:
    ///   - name: The name of the target. It will be used to derive the custom path for the target.
    ///   - dependencies: The dependencies of the target. A dependency can be another target in the package or a product from a package dependency.
    static func tryoutTestTarget(name: String, dependencies: [Target.Dependency] = []) -> Target {
        .testTarget(name: name, dependencies: dependencies, path: testsPath(for: name))
    }

    private static func sourcesPath(for name: String) -> String {
        return "Tryouts/\(name)/Sources"
    }

    private static func testsPath(for name: String) -> String {
        // Compute the name of the hosting folder from the target name.
        let name: String = {
            switch try? /(.*)Tests$/.wholeMatch(in: name) {
            case .none:
                // Default to the provided name.
                return name
            case .some(let match):
                // Return the extracted prefix.
                return String(match.output.1)
            }
        }()

        return "Tryouts/\(name)/Tests"
    }
}
