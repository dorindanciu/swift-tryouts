//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
// Unit tests covering FloatingPoint extensions.
//

import Testing

@testable import SwiftUISupport

@Suite("FloatingPoint Extensions")
struct FloatingPointTests {

    @Test("Odd multiple", arguments: isOddMultipleArguments)
    func isOddMultiple(sender: Double, argument: Double, expectedResult: Bool) async throws {
        let result = sender.isOddMultiple(of: argument)
        #expect(result == expectedResult)
    }

    @Test("Even multiple", arguments: isEvenMultipleArguments)
    func isEvenMultiple(sender: Double, argument: Double, expectedResult: Bool) async throws {
        let result = sender.isEvenMultiple(of: argument)
        #expect(result == expectedResult)
    }
}

extension FloatingPointTests {

    /// List of tuples (sender - argument - result) argument pairs, required to test Double's odd multiple check.
    fileprivate static var isOddMultipleArguments: [(Double, Double, Bool)] {
        let result: [(Double, Double, Bool)] = [
            (1 * .pi / 2, .pi / 2, true),
            (2 * .pi / 2, .pi / 2, false),
            (3 * .pi / 2, .pi / 2, true),
            (4 * .pi / 2, .pi / 2, false),
            (5 * .pi / 2, .pi / 2, true),
            (6 * .pi / 2, .pi / 2, false),
            (7 * .pi / 2, .pi / 2, true),
            (6 * .pi / 2, .pi / 2, false),
            (9 * .pi / 2, .pi / 2, true),
            (10 * .pi / 2, .pi / 2, false),
            (-1 * .pi / 2, .pi / 2, true),
            (-2 * .pi / 2, .pi / 2, false),
            (-3 * .pi / 2, .pi / 2, true),
            (-4 * .pi / 2, .pi / 2, false),
            (-5 * .pi / 2, .pi / 2, true),
            (-6 * .pi / 2, .pi / 2, false),
            (-7 * .pi / 2, .pi / 2, true),
        ]

        return result
    }

    /// List of tuples (sender - argument - result) argument pairs, required to test Double's even multiple check.
    fileprivate static var isEvenMultipleArguments: [(Double, Double, Bool)] {
        let result: [(Double, Double, Bool)] = [
            (1 * .pi / 2, .pi / 2, false),
            (2 * .pi / 2, .pi / 2, true),
            (3 * .pi / 2, .pi / 2, false),
            (4 * .pi / 2, .pi / 2, true),
            (5 * .pi / 2, .pi / 2, false),
            (6 * .pi / 2, .pi / 2, true),
            (7 * .pi / 2, .pi / 2, false),
            (6 * .pi / 2, .pi / 2, true),
            (9 * .pi / 2, .pi / 2, false),
            (10 * .pi / 2, .pi / 2, true),
            (-1 * .pi / 2, .pi / 2, false),
            (-2 * .pi / 2, .pi / 2, true),
            (-3 * .pi / 2, .pi / 2, false),
            (-4 * .pi / 2, .pi / 2, true),
            (-5 * .pi / 2, .pi / 2, false),
            (-6 * .pi / 2, .pi / 2, true),
            (-7 * .pi / 2, .pi / 2, false),
        ]

        return result
    }
}
