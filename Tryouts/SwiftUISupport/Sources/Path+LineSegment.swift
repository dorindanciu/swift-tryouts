//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// Path extension providing support to create a line segment path.
//

import SwiftUI

extension Path {

    /// Creates a line segment path with the given start and end points.
    /// - Parameters:
    ///  - startPoint: The start point of the line segment.
    ///  - endPoint: The end point of the line segment.
    ///
    /// - Note: The line segment is only added to the path if the start and end points are different.
    /// - Note: The line segment is drawn from the start point to the end point in the path.
    @inlinable public init(lineSegmentBetween startPoint: CGPoint, and endPoint: CGPoint) {
        self.init(lineSegment: (startPoint, endPoint))
    }

    /// Creates a line segment path with the given start and end points.
    /// - Parameter lineSegment: A tuple containing the start and end points of the line segment.
    ///
    /// - Note: The line segment is only added to the path if the start and end points are different.
    /// - Note: The line segment is drawn from the start point to the end point in the path.
    @inlinable public init(lineSegment: (startPoint: CGPoint, endPoint: CGPoint)) {
        self = Path { path in
            if lineSegment.startPoint != lineSegment.endPoint {
                path.move(to: lineSegment.startPoint)
                path.addLine(to: lineSegment.endPoint)
            }
        }
    }
}
