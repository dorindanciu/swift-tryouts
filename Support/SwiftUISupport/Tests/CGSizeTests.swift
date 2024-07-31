//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
// Unit tests covering CGSize extensions.
//

import CoreGraphics
import Testing

@testable import SwiftUISupport

@Suite("CGSize Extensions")
struct CGSizeTests {

    @Test("NaNCheck", arguments: checkNaNArguments)
    func checkNaN(sender: CGSize, expectedResult: Bool) async throws {
        let result = sender.isNaN
        #expect(result == expectedResult)
    }
}

extension CGSizeTests {

    /// List of tuples defining (sender, result) argument pairs, required to test CGSize's NaN check.
    fileprivate static var checkNaNArguments: [(CGSize, Bool)] {
        return [
            (CGSize(width: 0, height: 0), false),
            (CGSize(width: 0, height: 1), false),
            (CGSize(width: 1, height: 0), false),
            (CGSize(width: CGFloat.infinity, height: .infinity), false),
            (CGSize(width: CGFloat.nan, height: 0), true),
            (CGSize(width: 0, height: CGFloat.nan), true),
            (CGSize(width: CGFloat.nan, height: .nan), true),
        ]
    }
}
