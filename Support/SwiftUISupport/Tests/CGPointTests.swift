//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
// Unit tests covering CGPoint extensions.
//

import CoreGraphics
import Testing

@testable import SwiftUISupport

@Suite("CGPoint Extensions")
struct CGPointTests {

    @Test("Flushing NaNs modifier", arguments: flushingNaNsArguments)
    func flushingNaNs(source: CGPoint, expectedResult: CGPoint) async throws {
        let result = source.flushingNaNs
        #expect(result == expectedResult)
    }
}

extension CGPointTests {

    /// List of tuples defining (source, result) argument pairs, required to test CGPoint's flushingNaNs modifier.
    fileprivate static var flushingNaNsArguments: [(CGPoint, CGPoint)] {
        var result: [(CGPoint, CGPoint)] = [
            (CGPoint.zero, CGPoint.zero)
        ]

        result += {
            let source = CGPoint(x: CGFloat.nan, y: .nan)
            let result = CGPoint(x: CGFloat.zero, y: .zero)
            return [(source, result)]
        }()

        result += {
            let source = CGPoint(x: CGFloat.infinity, y: -.infinity)
            let result = CGPoint(x: CGFloat.infinity, y: -.infinity)
            return [(source, result)]
        }()

        return result
    }
}
