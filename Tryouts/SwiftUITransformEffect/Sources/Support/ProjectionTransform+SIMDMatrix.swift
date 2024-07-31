//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// Extension providing support to create a projection transform from a 4 x 4 double-precision matrix.
//

import SwiftUI
import simd

extension ProjectionTransform {

    /// Creates a projection transform from the specified 4 x 4 double-precision matrix.
    /// - Parameter matrix: The source double-precision matrix.
    internal init(_ matrix: simd_double4x4) {
        self.init(CATransform3D(matrix))
    }
}

extension CATransform3D {

    /// Creates a Core Animation transform from the specified 4 x 4 double-precision matrix.
    /// - Parameter m: The source double-precision matrix.
    internal init(_ m: simd_double4x4) {
        self.init(
            m11: m[0][0],
            m12: m[0][1],
            m13: m[0][2],
            m14: m[0][3],
            m21: m[1][0],
            m22: m[1][1],
            m23: m[1][2],
            m24: m[1][3],
            m31: m[2][0],
            m32: m[2][1],
            m33: m[2][2],
            m34: m[2][3],
            m41: m[3][0],
            m42: m[3][1],
            m43: m[3][2],
            m44: m[3][3]
        )
    }
}
