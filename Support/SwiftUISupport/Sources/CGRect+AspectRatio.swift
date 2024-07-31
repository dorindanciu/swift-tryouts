//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// CGRect extension providing a way to obtain a new rect that fits
// within the bounding rectangle while maintaining the specified aspect ratio.
//

import CoreGraphics

extension CGRect {
    /// Adjusts the size of the rectangle to fit within a bounding rectangle while maintaining an optional aspect ratio.
    ///
    /// - Parameters:
    ///   - aspectRatio: The optional aspect ratio (width/height) to maintain, specified as a `CGFloat`. If nil, maintains the original aspect ratio.
    ///   - boundingRect: The rectangle within which the aspect ratio should fit.
    /// - Returns: A new `CGRect` that fits within the bounding rectangle while maintaining the specified or original aspect ratio.
    @inlinable public func aspectRatio(_ aspectRatio: CGFloat? = nil, insideRect boundingRect: CGRect) -> CGRect {
        let originalAspectRatio = self.width / self.height
        let targetAspectRatio = aspectRatio ?? originalAspectRatio
        let targetSize = CGSize(width: targetAspectRatio, height: 1)
        return self.aspectRatio(targetSize, insideRect: boundingRect)
    }

    /// Returns a new rectangle that fits within the bounding rectangle while maintaining the specified aspect ratio.
    ///
    /// - Parameters:
    ///   - aspectRatio: The desired aspect ratio, specified as a `CGSize`.
    ///   - boundingRect: The rectangle within which the aspect ratio should fit.
    /// - Returns: A new `CGRect` that fits within the bounding rectangle while maintaining the specified aspect ratio.
    @inlinable public func aspectRatio(_ aspectRatio: CGSize, insideRect boundingRect: CGRect) -> CGRect {
        // Calculate the aspect ratios
        let targetAspectRatio = aspectRatio.width / aspectRatio.height
        let boundingAspectRatio = boundingRect.width / boundingRect.height

        // Determine the scaling factor
        let scaleFactor: CGFloat
        if targetAspectRatio > boundingAspectRatio {
            scaleFactor = boundingRect.width / aspectRatio.width
        } else {
            scaleFactor = boundingRect.height / aspectRatio.height
        }

        // Calculate the new size
        let newWidth = aspectRatio.width * scaleFactor
        let newHeight = aspectRatio.height * scaleFactor

        // Calculate the new origin to center the rectangle
        let originX = boundingRect.origin.x + (boundingRect.width - newWidth) / 2
        let originY = boundingRect.origin.y + (boundingRect.height - newHeight) / 2

        return CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
    }
}
