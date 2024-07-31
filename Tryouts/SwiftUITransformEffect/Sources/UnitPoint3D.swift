//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// A normalized 3D point in a view’s coordinate space.
//

import SwiftUI
import simd

/// A normalized 3D point in a view’s coordinate space.
///
/// Use a 3D unit point to represent a three-dimensional location in a view without having to know the view’s rendered size.
/// The point stores a value in each dimension that indicates the fraction of the view’s size in that dimension — measured
/// from the view’s origin — where the point appears. For example, you can create a unit point that represents the center
/// of any view by using the value 0.5 for each dimension:
///
/// ```swift
/// let unitPoint = UnitPoint3D(x: 0.5, y: 0.5, z: 0.5)
/// ```
public struct UnitPoint3D {

    /// The normalized distance from the origin to the point in the horizontal direction.
    public var x: Double

    /// The normalized distance from the origin to the point in the vertical dimension.
    public var y: Double

    /// The normalized distance from the origin to the point in the depth dimension.
    public var z: Double

    /// A simd three-element vector that contains the x-, y-, and z-coordinate values.
    public var vector: simd_double3 {
        get { simd_double3(x: x, y: y, z: z) }
        set { (x, y, z) = (newValue.x, newValue.y, newValue.z) }
    }

    /// Creates a point with all components equal to zero.
    public init() {
        self.init(vector: .zero)
    }

    /// Creates a point from the specified double-precision vector.
    /// - Parameter vector: A double-precision vector that specifies the coordinates.
    public init(vector: simd_double3) {
        self.x = vector.x
        self.y = vector.y
        self.z = vector.z
    }
}

/// Type properties.
extension UnitPoint3D {

    /// A 3D unit point with all components equal to zero.
    public static let zero: Self = .init(vector: .zero)

    /// A point that’s centered in a view.
    public static let center: Self = .init(vector: simd_double3(x: 0.5, y: 0.5, z: 0.5))

    /// A point that’s centered horizontally and vertically on the front face of a view.
    public static let front: Self = .init(vector: simd_double3(x: 0.5, y: 0.5, z: 0.0))
}

/// Convenience initializers.
extension UnitPoint3D {

    /// Creates a 3D unit point with the specified offsets.
    /// - Parameters:
    ///   - x: The normalized distance from the origin to the point in the horizontal dimension.
    ///   - y: The normalized distance from the origin to the point in the vertical dimension.
    ///   - z: The normalized distance from the origin to the point in the depth dimension.
    ///
    /// Values outside the range [0, 1] project to points outside of a view.
    init(x: Double, y: Double, z: Double) {
        self.init(vector: simd_double3(x: x, y: y, z: z))
    }

    /// Creates a 3D unit point with specified floating-point values.
    /// - Parameters:
    ///   - x: A floating-point value that specifies distance from the origin to the point in the horizontal dimension.
    ///   - y: A floating-point value that specifies distance from the origin to the point in the horizontal dimension.
    ///   - z: A floating-point value that specifies distance from the origin to the point in the horizontal dimension.
    public init<T>(x: T, y: T, z: T) where T: BinaryFloatingPoint {
        self.init(vector: simd_double3(x: Double(x), y: Double(y), z: Double(z)))
    }

    /// Creates a 3D unit point with the specified components.
    /// - Parameters:
    ///   - xy: A 2D unit point value, representing the normalized distance from origin in the horizontal and vertical dimensions.
    ///   - z: The normalized distance from the origin to the point in the depth dimension.
    public init(xy: UnitPoint, z: Double) {
        self.init(vector: simd_double3(x: xy.x, y: xy.y, z: z))
    }
}

/// Sendable conformance.
extension UnitPoint3D: Sendable {}

/// Hashable conformance.
extension UnitPoint3D: Hashable {}

/// Equatable conformance.
extension UnitPoint3D: Equatable {}

/// Animatable conformance.
extension UnitPoint3D: Animatable {

    public typealias AnimatableData = SIMD3<Double>.AnimatableData

    public var animatableData: AnimatableData {
        get { vector.animatableData }
        set { vector.animatableData = newValue }
    }
}
