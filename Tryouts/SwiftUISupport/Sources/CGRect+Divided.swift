//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// CGRect extension providing a way to obtain dividing segments formed between
// the rectangle's sides and the lines that pass trough its center at a given
// angle, or slice it at a given distance from an edge.
//

import CoreGraphics

extension CGRect {

    /// Returns a tuple containing the start and end points of the segment formed between
    /// the intersection of the rectangle's edges and the line that passes through its center
    /// at the given angle.
    ///
    /// - Parameters:
    ///    - angle: The angle at which the line passes through the center of the rectangle.
    /// - Returns: A tuple containing the start and end points of the segment.
    ///
    /// - Note: The angle is measured in radians relative to the positive x-axis.
    ///
    /// - Complexity: O(1)
    ///
    /// - SeeAlso: `segment(dividingAt:from:)`
    @inlinable public func segment(
        dividingAt angle: CGFloat
    ) -> (startPoint: CGPoint, endPoint: CGPoint) {

        // Check if the source rectangle is empty.
        guard isEmpty == false else {
            return (startPoint: .zero, endPoint: .zero)
        }

        // Check if the source rectangle is infinite.
        guard isInfinite == false else {
            return (startPoint: .zero, endPoint: .zero)
        }

        // Check if the angle is NaN, where tan is undefined.
        guard angle.isNaN == false else {
            return (startPoint: .zero, endPoint: .zero)
        }

        // Check if the angle is infinite, where tan is undefined.
        guard angle.isInfinite == false else {
            return (startPoint: .zero, endPoint: .zero)
        }

        // Check if the angle is zero, where tan is zero.
        guard angle != 0 else {
            return (startPoint: CGPoint(x: minX, y: midY), endPoint: CGPoint(x: maxX, y: midY))
        }

        // Check if the angle is an odd multiple of π, where tan is zero.
        guard !angle.isOddMultiple(of: .pi) else {
            return (startPoint: CGPoint(x: minX, y: midY), endPoint: CGPoint(x: maxX, y: midY))
        }

        // Check if the angle is an even multiple of π/2, where tan is zero.
        // In general, any number in the form kπ (where k is an integer), is an even multiple of π/2.
        guard !angle.isEvenMultiple(of: .pi / 2) else {
            return (startPoint: CGPoint(x: minX, y: midY), endPoint: CGPoint(x: maxX, y: midY))
        }

        // Check if the angle is an odd multiple of π/2, where tan is undefined.
        // In general, any number in the form (2k + 1) * π/2 (where k is an integer), is an odd multiple of π/2.
        guard !angle.isOddMultiple(of: .pi / 2) else {
            return (startPoint: CGPoint(x: midX, y: minY), endPoint: CGPoint(x: midX, y: maxY))
        }

        // Use the equation of a straight line to find the intersection points of the line that passes
        // through the center of the rectangle at the given angle with its sides.
        //
        // The equation of a straight line with gradient m, passing through the point (x1, y1), is:
        // ```
        // y - y1 = m(x - x1)
        // ```

        // Initialize an array to store the intersection points.
        var points: [CGPoint] = []

        // Calculate the gradient of the straight line.
        let m = tan(angle)

        // Calculate the intersection with the leading edge.
        // ```
        // x = rect.minX
        // y = m(x - x1) + y1
        // ```
        do {
            let x = minX
            let y = m * (x - midX) + midY

            if (minY...maxY).contains(y), !points.map(\.y).contains(y) {
                points.append(CGPoint(x: x, y: y))
            }
        }

        // Calculate the intersection with the trailing edge.
        // ```
        // x = rect.maxX
        // y = m(x - x1) + y1
        // ```
        do {
            let x = maxX
            let y = m * (x - midX) + midY

            if (minY...maxY).contains(y), !points.map(\.y).contains(y) {
                points.append(CGPoint(x: x, y: y))
            }
        }

        // Calculate the intersection with the top edge.
        // ```
        // y = rect.minY
        // x = (y - y1) / m + x1
        // ```
        do {
            let y = minY
            let x = (y - midY) / m + midX

            if (minX...maxX).contains(x), !points.map(\.x).contains(x) {
                points.append(CGPoint(x: x, y: y))
            }
        }

        // Calculate the intersection with the bottom edge
        // ```
        // y = rect.maxY
        // x = (y - y1) / m + x1
        // `
        do {
            let y = maxY
            let x = (y - midY) / m + midX

            if (minX...maxX).contains(x), !points.map(\.x).contains(x) {
                points.append(CGPoint(x: x, y: y))
            }
        }

        // Check if the intersection points are valid.
        assert(points.count == 2, "There should be exactly two intersections.")

        // Return the intersection points.
        return (points[0].flushingNaNs, points[1].flushingNaNs)
    }

    /// Returns the start and end points of the segment that divides the rectangle at a specified distance from the specified edge.
    ///
    /// - Parameters:
    ///   - distance: The distance from the edge at which to divide the rectangle.
    ///   - edge: The edge from which to divide the rectangle.
    /// - Returns: A tuple containing the start and end points of the dividing segment.
    @inlinable public func segment(
        dividingAt distance: CGFloat,
        from edge: CGRectEdge
    ) -> (startPoint: CGPoint, endPoint: CGPoint) {

        // Determine the slice dividing the rectangle at distance from edge.
        let slice = divided(atDistance: distance, from: edge).slice

        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero

        // Switch trough the edges and compute the segment points.
        switch edge {
        case .minXEdge:
            startPoint = CGPoint(x: slice.maxX, y: slice.minY)
            endPoint = CGPoint(x: slice.maxX, y: slice.maxY)

        case .minYEdge:
            startPoint = CGPoint(x: slice.minX, y: slice.maxY)
            endPoint = CGPoint(x: slice.maxX, y: slice.maxY)

        case .maxXEdge:
            startPoint = CGPoint(x: slice.minX, y: slice.minY)
            endPoint = CGPoint(x: slice.minX, y: slice.maxY)

        case .maxYEdge:
            startPoint = CGPoint(x: slice.minX, y: slice.minY)
            endPoint = CGPoint(x: slice.maxX, y: slice.minY)
        }

        return (startPoint.flushingNaNs, endPoint.flushingNaNs)
    }
}
