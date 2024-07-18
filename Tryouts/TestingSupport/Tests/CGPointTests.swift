//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
// Unit tests covering CGPoint extensions.
//

import CoreGraphics
import Testing
import TestingSupport

@Suite("CGPoint Extensions")
struct CGPointTests {

    @Test("Approximate equality with point", arguments: approximateEqualityWithPointArguments)
    func approximateEquality(
        between sender: CGPoint,
        candidate: CGPoint,
        within tolerance: CGFloat,
        expectedResult: Bool
    ) async throws {
        let result = sender.isApproximatelyEqual(to: candidate, tolerance: tolerance)
        #expect(result == expectedResult)
    }

    @Test("Approximate equality with value", arguments: approximateEqualityWithValueArguments)
    func approximateEquality(
        between sender: CGPoint,
        value: CGFloat,
        within tolerance: CGFloat,
        expectedResult: Bool
    ) async throws {
        let result = sender.isApproximatelyEqual(to: value, tolerance: tolerance)
        #expect(result == expectedResult)
    }
}

extension CGPointTests {

    /// List of tuples defining (sender - candidate - tolerance - result) argument pairs, required to test CGPoint's approximate equality.
    fileprivate static var approximateEqualityWithPointArguments: [(CGPoint, CGPoint, CGFloat, Bool)] {
        var result: [(CGPoint, CGPoint, CGFloat, Bool)] = [
            (.zero, .zero, .zero, true),
            (CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0), 1, true),
            (CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0), 0, false),
        ]

        result += {
            let e = CGFloat.ulpOfOne.squareRoot()
            let sender = CGPoint(x: 1, y: 1)
            let candidate = CGPoint(x: sender.x + e, y: sender.y + e)

            return [(sender, candidate, e, true)]
        }()

        result += {
            let e = CGFloat.ulpOfOne.squareRoot()
            let sender = CGPoint(x: 1, y: 1)
            let candidate = CGPoint(x: sender.x - e / 2, y: sender.y - e / 2)

            return [(sender, candidate, e, true)]
        }()

        result += {
            let e = CGFloat.ulpOfOne.squareRoot()
            let sender = CGPoint(x: 1, y: 1)
            let candidate = CGPoint(x: sender.x + 2 * e, y: sender.y + 2 * e)

            return [(sender, candidate, e, false)]
        }()

        result += {
            let e = CGFloat.ulpOfOne.squareRoot()
            let sender = CGPoint(x: 1, y: 1)
            let candidate = CGPoint(x: sender.x - 3 * e / 2, y: sender.y - 3 * e / 2)

            return [(sender, candidate, e, false)]
        }()

        return result
    }

    /// List of tuples defining (sender - value - tolerance - result) argument pairs, required to test CGPoint's approximate equality.
    fileprivate static var approximateEqualityWithValueArguments: [(CGPoint, CGFloat, CGFloat, Bool)] {
        var result: [(CGPoint, CGFloat, CGFloat, Bool)] = [
            (.zero, .zero, .zero, true)
        ]

        result += {
            let e = CGFloat.ulpOfOne.squareRoot()
            let sender = CGPoint(x: 1, y: 1)
            let value = 1 + e

            return [(sender, value, e, true)]
        }()

        result += {
            let e = CGFloat.ulpOfOne.squareRoot()
            let sender = CGPoint(x: 1, y: 1)
            let value = 1 - e / 2

            return [(sender, value, e, true)]
        }()

        result += {
            let e = CGFloat.ulpOfOne.squareRoot()
            let sender = CGPoint(x: 1, y: 1)
            let value = 1 + 2 * e

            return [(sender, value, e, false)]
        }()

        result += {
            let e = CGFloat.ulpOfOne.squareRoot()
            let sender = CGPoint(x: 1, y: 1)
            let value = 1 - 3 * e / 2

            return [(sender, value, e, false)]
        }()

        return result
    }
}
