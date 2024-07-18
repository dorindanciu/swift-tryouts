//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// CGRect extension providing support to:
//  - access rectangle's center point
//  - use centered(at:) modifier to create a re-centered copy
//

import CoreGraphics

extension CGRect {
    /// Returns the center point of the rectangle.
    ///
    /// The center point is calculated as the midpoint of the rectangle's width and height relative to origin.
    ///
    /// - Returns: The center point of the rectangle.
    @inlinable public var center: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }

    /// Returns a rectangle with a center that is shifted from the source.
    ///
    /// - Parameter point: The center point coordinates of the resulting rectangle.
    /// - Returns: A rectangle that is the same size as the source, but with its center shifted from the source.
    ///
    /// - Note: If the source rectangle is `.infinite`, the function returns the same rectangle without any changes.
    ///
    /// - Complexity: O(1)
    @inlinable public func centered(at point: CGPoint) -> CGRect {
        guard self != .infinite else {
            return self
        }

        // Calculate the offsets.
        let offsetX = point.x - self.midX
        let offsetY = point.y - self.midY

        return self.offsetBy(dx: offsetX, dy: offsetY)
    }
}
