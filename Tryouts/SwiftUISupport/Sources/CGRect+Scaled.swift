//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// CGRect extension providing a scaled(by:) modifier.
//

import CoreGraphics

extension CGRect {
    /// Returns a new rectangle by scaling the source around its center using the given scale factor.
    ///
    /// - Parameter scale: The scale factor by which to scale the rectangle.
    /// - Returns: A rectangle that is scaled around its center relative to the source.
    ///
    /// Scaling with a negative value produces no changes, returning the source rectangle.
    @inlinable public func scaled(by scale: CGFloat) -> CGRect {
        guard self != .infinite else {
            return self
        }

        guard scale >= 0 else {
            return self
        }

        // Calculate the new width and height.
        let newWidth = self.width * scale
        let newHeight = self.height * scale

        // Calculate the insets needed to keep the rectangle centered.
        let insetWidth = (self.width - newWidth) / 2
        let insetHeight = (self.height - newHeight) / 2

        // Use the insetBy function to adjust the size and origin.
        return self.insetBy(dx: insetWidth, dy: insetHeight)
    }
}
