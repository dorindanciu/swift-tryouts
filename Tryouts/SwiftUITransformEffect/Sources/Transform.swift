//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// A component that defines the scale, rotation, and translation of an effect.
//

import SwiftUI
import simd

/// A component that defines the scale, rotation, and translation of an effect.
public struct Transform {

    /// The scaling factor applied to the entity.
    public var scale: simd_double3

    /// The rotation of the entity specified as a unit quaternion.
    public var rotation: simd_quatd

    /// The position of the entity along the x, y, and z axes.
    public var translation: simd_double3

    /// Creates a transform with the values of the identity transform.
    public init() {
        self.init(
            scale: vector3(1, 1, 1),
            rotation: simd_quaternion(0, 0, 0, 1),
            translation: vector3(0, 0, 0)
        )
    }

    /// Creates a new transform using the given values.
    /// - Parameters:
    ///   - scale: A scale factor.
    ///   - rotation: The rotation given as a unit quaternion.
    ///   - translation: The translation, or position along the x, y, and z axes.
    public init(
        scale: simd_double3 = vector3(1, 1, 1),
        rotation: simd_quatd = simd_quaternion(0, 0, 0, 1),
        translation: simd_double3 = vector3(0, 0, 0)
    ) {
        self.scale = scale
        self.rotation = rotation
        self.translation = translation
    }
}

/// Type properties.
extension Transform {

    /// The identity transform.
    public static let identity: Self = Self()
}

/// Convenience initializers.
extension Transform {

    /// Creates a new transform from the specified Euler angles.
    /// - Parameters:
    ///   - x: The rotation around the x-axis in radians.
    ///   - y: The rotation around the y-axis in radians.
    ///   - z: The rotation around the z-axis in radians.
    public init(
        pitch x: Double = 0,
        yaw y: Double = 0,
        roll z: Double = 0
    ) {
        let x = simd_quatd(angle: x, axis: [1, 0, 0])
        let y = simd_quatd(angle: y, axis: [0, 1, 0])
        let z = simd_quatd(angle: z, axis: [0, 0, 1])

        self.init(rotation: x * y * z)
    }

    /// Creates a new transform from the specified rotation components.
    /// - Parameters:
    ///   - angle: The angle to rotate by.
    ///   - axis: The axis to rotate around.
    public init(angle: Angle, axis: simd_double3) {
        let rotation = simd_quatd(angle: angle.radians, axis: axis)
        self.init(rotation: rotation)
    }
}

/// Sendable conformance.
extension Transform: Sendable {}

/// Hashable conformance.
extension Transform: Hashable {}

/// Equatable conformance.
extension Transform: Equatable {}

/// Animatable conformance.
extension Transform: Animatable {
    public typealias AnimatableData = AnimatablePair<
        simd_double3.AnimatableData,
        AnimatablePair<
            simd_quatd.AnimatableData, simd_double3.AnimatableData
        >
    >

    public var animatableData: AnimatableData {
        get {
            let scale = scale.animatableData
            let rotation = rotation.animatableData
            let translation = translation.animatableData

            return AnimatablePair(scale, AnimatablePair(rotation, translation))
        }
        set {
            scale.animatableData = newValue.first
            rotation.animatableData = newValue.second.first
            translation.animatableData = newValue.second.second
        }
    }
}
