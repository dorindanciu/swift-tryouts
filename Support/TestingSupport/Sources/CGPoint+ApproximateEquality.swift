//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// CGPoint extension introducing approximate equality support.
//

import CoreGraphics
import Numerics

extension CGPoint {

    /// Returns a Boolean value indicating whether the two points are approximately equal.
    ///
    /// - Parameters:
    ///    - other: The point to compare with the source point.
    ///    - tolerance: The maximum difference allowed between the two points.
    /// - Returns: `true` if the two points are approximately equal, `false` otherwise.
    ///
    /// - Complexity: O(1)
    ///
    /// - SeeAlso: `isApproximatelyEqual(to:tolerance:)`
    @inlinable public func isApproximatelyEqual(
        to other: CGPoint,
        tolerance: CGFloat = .zero
    ) -> Bool {
        guard
            x.isApproximatelyEqual(to: other.x, absoluteTolerance: tolerance),
            y.isApproximatelyEqual(to: other.y, absoluteTolerance: tolerance)
        else {
            return false
        }

        return true
    }

    /// Returns a Boolean value indicating whether the point is approximately equal to the given value.
    ///
    /// - Parameters:
    ///    - value: The value to compare with the source point.
    ///    - tolerance: The maximum difference allowed between the point and the value.
    /// - Returns: `true` if the point is approximately equal to the value, `false` otherwise.
    ///
    /// - Complexity: O(1)
    ///
    /// - SeeAlso: `isApproximatelyEqual(to:tolerance:)`
    @inlinable public func isApproximatelyEqual(
        to value: CGFloat,
        tolerance: CGFloat = .zero
    ) -> Bool {
        let candidate = CGPoint(x: value, y: value)
        return isApproximatelyEqual(to: candidate, tolerance: tolerance)
    }
}
