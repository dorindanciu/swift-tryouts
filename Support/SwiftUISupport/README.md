# SwiftUISupport

## Introduction

This `swift-tryouts` module is a collection of helpers, additions, and utilities that extend the capabilities of SwiftUI and CoreGraphics frameworks. It aims to facilitate the development of custom UI components by eliminating the need for duplicated support code typically required in these situations.

## Using SwiftUISupport in your project

To use SwiftUISupport in a project where dependencies are managed via SwiftPM:

1. Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/dorindanciu/swift-tryouts", branch: "main"),
```

2. Add `SwiftUISupport` as a dependency for your target:

```swift
.target(name: "MyTarget", dependencies: [
  .product(name: "SwiftUISupport", package: "swift-tryouts"),
  "AnotherModule"
]),
```

3. Add `import SwiftUISupport` in your source code.
