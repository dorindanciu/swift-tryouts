// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-tryouts",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .macCatalyst(.v18)],
    products: [
        // Support
        .library(name: "TestingSupport", targets: ["TestingSupport"]),
        .library(name: "SwiftUISupport", targets: ["SwiftUISupport"]),
        .library(name: "PreviewSupport", targets: ["PreviewSupport"]),

        // Tryouts
        .library(name: "SwiftUIOffsetEffect", targets: ["SwiftUIOffsetEffect"]),
        .library(name: "SwiftUITransformEffect", targets: ["SwiftUITransformEffect"]),
        .library(name: "SwiftUICartesianSystem", targets: ["SwiftUICartesianSystem"]),
        .library(name: "SwiftUIStackedTextRenderer", targets: ["SwiftUIStackedTextRenderer"]),
        .library(name: "SwiftUICircularTextRenderer", targets: ["SwiftUICircularTextRenderer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0")
    ],
    targets: [
        // TestingSupport
        .supportTarget(name: "TestingSupport", dependencies: [
            .product(name: "Numerics", package: "swift-numerics")
        ]),
        .supportTestTarget(name: "TestingSupportTests", dependencies: [
            .target(name: "TestingSupport")
        ]),

        // SwiftUISupport
        .supportTarget(name: "SwiftUISupport", dependencies: []),
        .supportTestTarget(name: "SwiftUISupportTests", dependencies: [
            .target(name: "SwiftUISupport"),
            .target(name: "TestingSupport")
        ]),

        // PreviewSupport
        .supportTarget(name: "PreviewSupport", dependencies: [
            .target(name: "SwiftUISupport")
        ]),

        // SwiftUICartesianSystem
        .tryoutTarget(
            name: "SwiftUICartesianSystem",
            dependencies: [
                .target(name: "SwiftUISupport"),
                .target(name: "PreviewSupport")
            ]
        ),

        // SwiftUIOffsetEffect
        .tryoutTarget(
            name: "SwiftUIOffsetEffect",
            dependencies: [
                .target(name: "SwiftUISupport"),
                .target(name: "PreviewSupport")
            ]
        ),

        // SwiftUITransformEffect
        .tryoutTarget(
            name: "SwiftUITransformEffect",
            dependencies: [
                .target(name: "PreviewSupport")
            ]
        ),

        // SwiftUIStackedTextRenderer
        .tryoutTarget(
            name: "SwiftUIStackedTextRenderer",
            dependencies: [
                .target(name: "PreviewSupport")
            ]
        ),

        // SwiftUICircularTextRenderer
        .tryoutTarget(
            name: "SwiftUICircularTextRenderer",
            dependencies: [
                .target(name: "PreviewSupport")
            ]
        ),

    ]
)

extension PackageDescription.Target {

    /// Creates a regular target.
    /// - Parameters:
    ///   - name: The name of the target. It will be used to derive the custom path for the target.
    ///   - dependencies: The dependencies of the target. A dependency can be another target in the package or a product from a package dependency.
    static func supportTarget(name: String, dependencies: [Target.Dependency] = []) -> Target {
        .target(name: name, dependencies: dependencies, path: supportSourcesPath(for: name))
    }

    /// Creates a test target.
    /// - Parameters:
    ///   - name: The name of the target. It will be used to derive the custom path for the target.
    ///   - dependencies: The dependencies of the target. A dependency can be another target in the package or a product from a package dependency.
    static func supportTestTarget(name: String, dependencies: [Target.Dependency] = []) -> Target {
        .testTarget(name: name, dependencies: dependencies, path: supportTestsPath(for: name))
    }

    /// Creates a regular target.
    /// - Parameters:
    ///   - name: The name of the target. It will be used to derive the custom path for the target.
    ///   - dependencies: The dependencies of the target. A dependency can be another target in the package or a product from a package dependency.
    static func tryoutTarget(name: String, dependencies: [Target.Dependency] = []) -> Target {
        .target(name: name, dependencies: dependencies, path: tryoutSourcesPath(for: name))
    }

    /// Creates a test target.
    /// - Parameters:
    ///   - name: The name of the target. It will be used to derive the custom path for the target.
    ///   - dependencies: The dependencies of the target. A dependency can be another target in the package or a product from a package dependency.
    static func tryoutTestTarget(name: String, dependencies: [Target.Dependency] = []) -> Target {
        .testTarget(name: name, dependencies: dependencies, path: tryoutTestsPath(for: name))
    }

    /// Returns the custom path to the target's tests folder.
    /// - Parameter targetName: Value representing the name of the target.
    private static func supportSourcesPath(for targetName: String) -> String {
        return path(for: targetName, relativeTo: "Support").appending("/Sources")
    }

    /// Returns the custom path to the target's sources folder.
    /// - Parameter targetName: Value representing the name of the target.
    private static func supportTestsPath(for targetName: String) -> String {
        return path(for: targetName, relativeTo: "Support").appending("/Tests")
    }

    /// Returns the custom path to the target's tests folder.
    /// - Parameter targetName: Value representing the name of the target.
    private static func tryoutSourcesPath(for targetName: String) -> String {
        return path(for: targetName, relativeTo: "Tryouts").appending("/Sources")
    }

    /// Returns the custom path to the target's sources folder.
    /// - Parameter targetName: Value representing the name of the target.
    private static func tryoutTestsPath(for targetName: String) -> String {
        return path(for: targetName, relativeTo: "Tryouts").appending("/Tests")
    }

    /// Returns the custom path for a target in the form of [PackageRoot]/[TargetName].
    /// - Parameters:
    ///   - targetName: Value representing the name of the target.
    ///   - packageRoot: Value representing the base of the path.
    private static func path(for targetName: String, relativeTo packageRoot: String) -> String {
        // Compute the name of the hosting folder from the target name.
        let targetName: String = {
            switch try? /(.*)Tests$/.wholeMatch(in: targetName) {
            case .none:
                // Default to the provided name.
                return targetName
            case .some(let match):
                // Return the extracted prefix.
                return String(match.output.1)
            }
        }()

        return "\(packageRoot)/\(targetName)"
    }
}
