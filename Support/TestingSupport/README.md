# TestingSupport

## Introduction

This particular `swift-tryouts` module introduces a collection of utilities, helpers, and other additions that can greatly benefit other test targets. By leveraging these functionalities, developers can effectively reduce duplication and consolidate boilerplate code in their projects. These additions are designed to enhance the testing experience and provide a more efficient and streamlined approach to writing tests.

## Using TestingSupport in your project

To use TestingSupport in a project where dependencies are managed via SwiftPM:

1. Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/dorindanciu/swift-tryouts", branch: "main"),
```

2. Add `TestingSupport` as a dependency for your test target:

```swift
.testTarget(name: "MyTargetTests", dependencies: [
  .product(name: "TestingSupport", package: "swift-tryouts"),
  "MyTarget"
]),
```

3. Add `import TestingSupport` in your source code.


## Approximate Equality

Knowing that `swift-testing` doesn't provide an equivalent of [`XCTAssertEqual(_:_:accuracy:_:file:line:)`](https://developer.apple.com/documentation/xctest/3551607-xctassertequal), in order to compare two numeric values within a specified accuracy, we have to rely on `isApproximatelyEqual()` from [swift-numerics](https://github.com/apple/swift-numerics). (Source: [swift-testing/MigratingFromXCTest](https://github.com/apple/swift-testing/blob/7b1fd7ec0ce8c48ab51416d3423edd7cf6061a61/Sources/Testing/Testing.docc/MigratingFromXCTest.md?plain=1#L360C1-L363C93))

This module introduces approximate equality support for several other types, leveraging `isApproximatelyEqual()` from [swift-numerics](https://github.com/apple/swift-numerics).
* [CGPoint+ApproximateEquality.swift](Sources/CGPoint+ApproximateEquality.swift)
