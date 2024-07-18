//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// CGPoint extension providing a modifier that returns a copy from the source,
// sanitizing its coordinates by replacing any NaN values with zero.
//

import CoreGraphics

extension CGPoint {
    /// Returns a new CGPoint, replacing any NaN values with zero.
    ///
    /// This implementation effectively handles scenarios where `CGPoint`
    /// might inadvertently contain NaN values, ensuring that graphical computations
    /// and renderings that depend on valid coordinates don't fail.
    @inlinable public var flushingNaNs: CGPoint {
        CGPoint(x: x.isNaN ? .zero : x, y: y.isNaN ? .zero : y)
    }
}
