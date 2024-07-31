//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// Extension providing support to create a 4 x 4 double-precision matrix for several transform types.
//

import simd

extension simd_double4x4 {

    /// Construct a 4x4 rotation matrix from the specified `quaternion`.
    public static func rotation(_ quaternion: simd_quatd) -> Self {
        .init(quaternion.normalized)
    }

    /// Construct a 4x4 scale matrix from the specified `vector`.
    public static func scale(_ vector: simd_double3) -> Self {
        scale(vector.x, vector.y, vector.z)
    }

    /// Construct a 4x4 scale matrix from the specified scalar values.
    public static func scale(_ x: Double, _ y: Double, _ z: Double) -> Self {
        simd_double4x4(
            simd_double4(x, 0, 0, 0),
            simd_double4(0, y, 0, 0),
            simd_double4(0, 0, z, 0),
            simd_double4(0, 0, 0, 1)
        )
    }

    /// Construct a 4x4 translation matrix from the specified`vector`
    public static func translation(_ vector: simd_double3) -> Self {
        translation(vector.x, vector.y, vector.z)
    }

    /// Construct a 4x4 translation matrix from the specified scalar values.
    public static func translation(_ x: Double, _ y: Double, _ z: Double) -> Self {
        simd_double4x4(
            simd_double4(1, 0, 0, 0),
            simd_double4(0, 1, 0, 0),
            simd_double4(0, 0, 1, 0),
            simd_double4(x, y, z, 1)
        )
    }

    /// Construct a 4x4 translation matrix from the specified `vector`.
    public static func perspective(_ vector: simd_double3) -> Self {
        perspective(vector.x, vector.y, vector.z)
    }

    /// Construct a 4x4 translation matrix from the specified scalar values.
    public static func perspective(_ x: Double, _ y: Double, _ z: Double) -> Self {
        simd_double4x4(
            simd_double4(1, 0, 0, x),
            simd_double4(0, 1, 0, y),
            simd_double4(0, 0, 1, z),
            simd_double4(0, 0, 0, 1)
        )
    }
}

/// Construct a 4x4 transform matrix from the specified rotation structure.
public func matrix4x4(rotation q: simd_quatd) -> simd_double4x4 {
    simd_double4x4.rotation(q)
}

/// Construct a 4x4 transform matrix from the specified scale structure.
public func matrix4x4(scale s: simd_double3) -> simd_double4x4 {
    simd_double4x4.scale(s)
}

/// Construct a 4x4 transform matrix from the specified translation structure.
public func matrix4x4(translation t: simd_double3) -> simd_double4x4 {
    simd_double4x4.translation(t)
}

/// Construct a 4x4 transform matrix from the specified perspective structure.
public func matrix4x4(perspective d: simd_double3) -> simd_double4x4 {
    simd_double4x4.perspective(d)
}
