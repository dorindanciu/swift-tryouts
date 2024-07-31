//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// Extension providing a way to check whether the size structure contains any NaN values.
//

import CoreGraphics

extension CGSize {

    /// A Boolean value that indicates whether the size structure contains any NaN values.
    public var isNaN: Bool {
        return width.isNaN || height.isNaN
    }
}
