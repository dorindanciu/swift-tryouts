//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// Path extension providing support to create a circle path.
//

import SwiftUI

extension Path {

    /// Creates a circle path with the given center and radius.
    /// - Parameters:
    ///  - center: The center of the circle.
    ///  - radius: The radius of the circle.
    ///
    /// - Note: The circle is inscribed in a square with sides equal to the diameter of the circle.
    @inlinable public init(circleAt center: CGPoint, radius: CGFloat) {
        // Determine the square circumscribing the circle.
        let boundingRect = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )

        self.init(ellipseIn: boundingRect)
    }
}
