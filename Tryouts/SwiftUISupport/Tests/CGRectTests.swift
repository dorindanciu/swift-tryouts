//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
// Unit tests covering CGRect extensions.
//

import CoreGraphics
import Testing
import TestingSupport

@testable import SwiftUISupport

@Suite("CGRect Extensions")
struct CGRectTests {

    @Test("Center point", arguments: centerArguments)
    func centerPoint(source: CGRect, expectedResult: CGPoint) async throws {
        let result = source.center
        #expect(result == expectedResult)
    }

    @Test("Centered modifier", arguments: centeredModifierArguments)
    func centeredModifier(source: CGRect, point: CGPoint, expectedResult: CGRect) async throws {
        let result = source.centered(at: point)
        #expect(result == expectedResult)
    }

    @Test("Scaled modifier", arguments: scaledModifierArguments)
    func scaledModifier(source: CGRect, scale: CGFloat, expectedResult: CGRect) async throws {
        let result = source.scaled(by: scale)
        #expect(result == expectedResult)
    }

    @Test("Aspect ratio modifier", arguments: aspectRatioModifierArguments)
    func aspectRatioModifier(source: CGRect, ratio: CGFloat?, bounds: CGRect, expectedResult: CGRect) async throws {
        let result = source.aspectRatio(ratio, insideRect: bounds)
        #expect(result == expectedResult)
    }

    @Test("Segment dividing at angle", arguments: dividingSegmentAtAngleArguments)
    func dividingSegment(source: CGRect, angle: CGFloat, expectedResult: (CGPoint, CGPoint)) async throws {
        let result = source.segment(dividingAt: angle)
        #expect(result.startPoint.isApproximatelyEqual(to: expectedResult.0, tolerance: 0.0001))
        #expect(result.endPoint.isApproximatelyEqual(to: expectedResult.1, tolerance: 0.0001))
    }

    @Test("Segment dividing at distance", arguments: dividingSegmentAtDistanceArguments)
    func dividingSegment(
        source: CGRect,
        distance: CGFloat,
        edge: CGRectEdge,
        expectedResult: (CGPoint, CGPoint)
    ) async throws {
        let result = source.segment(dividingAt: distance, from: edge)
        #expect(result.startPoint == expectedResult.0)
        #expect(result.endPoint == expectedResult.1)
    }
}

extension CGRectTests {

    /// List of tuples defining (source, result) argument pairs, required to test CGRect's center point getter.
    fileprivate static var centerArguments: [(CGRect, CGPoint)] {
        var result: [(CGRect, CGPoint)] = [
            (.zero, .zero),
            (.infinite, .zero),
        ]

        result += {
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = CGPoint(x: 0, y: 0)
            return [(source, result)]
        }()

        result += {
            let source = CGRect(x: 10, y: 20, width: 30, height: 30)
            let result = CGPoint(x: 25, y: 35)
            return [(source, result)]
        }()

        return result
    }

    /// List of tuples defining (source - point - result) argument pairs, required to test CGRect's centered modifier.
    fileprivate static var centeredModifierArguments: [(CGRect, CGPoint, CGRect)] {
        var result: [(CGRect, CGPoint, CGRect)] = [
            (.zero, .zero, .zero),
            (.infinite, .zero, .infinite),
        ]

        result += {
            let source: CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)
            let result: CGRect = CGRect(x: 5, y: 5, width: 10, height: 10)
            let point: CGPoint = CGPoint(x: 10, y: 10)

            return [(source, point, result)]
        }()

        result += {
            let source: CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)
            let result: CGRect = CGRect(x: -15, y: -15, width: 10, height: 10)
            let point: CGPoint = CGPoint(x: -10, y: -10)

            return [(source, point, result)]
        }()

        return result
    }

    /// List of tuples defining (source - scale - result) argument pairs, required to test CGRect's scaled modifier.
    fileprivate static var scaledModifierArguments: [(CGRect, CGFloat, CGRect)] {
        var result: [(CGRect, CGFloat, CGRect)] = [
            (.zero, -1, .zero),
            (.zero, 0, .zero),
            (.zero, 1, .zero),

            (.infinite, -1, .infinite),
            (.infinite, 0, .infinite),
            (.infinite, 1, .infinite),
        ]

        result += {
            let source: CGRect = CGRect(x: -10, y: -10, width: 20, height: 20)
            let scale: CGFloat = CGFloat.zero
            let result: CGRect = CGRect.zero

            return [(source, scale, result)]
        }()

        result += {
            let source: CGRect = CGRect(x: -10, y: -10, width: 20, height: 20)
            let scale: CGFloat = CGFloat(1)
            let result: CGRect = CGRect(x: -10, y: -10, width: 20, height: 20)

            return [(source, scale, result)]
        }()

        result += {
            let source: CGRect = CGRect(x: -10, y: -10, width: 20, height: 20)
            let scale: CGFloat = CGFloat(2)
            let result: CGRect = CGRect(x: -20, y: -20, width: 40, height: 40)

            return [(source, scale, result)]
        }()

        result += {
            let source: CGRect = CGRect(x: -10, y: -10, width: 20, height: 20)
            let scale: CGFloat = CGFloat(0.5)
            let result: CGRect = CGRect(x: -5, y: -5, width: 10, height: 10)

            return [(source, scale, result)]
        }()

        result += {
            let source: CGRect = CGRect(x: -10, y: -10, width: 20, height: 20)
            let scale: CGFloat = CGFloat(-1)
            let result: CGRect = CGRect(x: -10, y: -10, width: 20, height: 20)

            return [(source, scale, result)]
        }()

        return result
    }

    /// List of tuples defining (source - ratio - bounds - result) argument pairs, required to test CGRect's aspect ratio modifier.
    fileprivate static var aspectRatioModifierArguments: [(CGRect, CGFloat?, CGRect, CGRect)] {
        var result: [(CGRect, CGFloat?, CGRect, CGRect)] = [
            (.zero, .zero, .zero, .zero),
            (.infinite, .zero, .zero, .zero),
            (.infinite, .none, .infinite, .infinite),
        ]

        result += {
            let aspectRatio: CGFloat = 16.0 / 9.0
            let source = CGRect(x: 0, y: 0, width: 160, height: 90)
            let bounds = CGRect(x: 0, y: 0, width: 1920, height: 1080)
            let result = CGRect(x: 0, y: 0, width: 1920, height: 1080)

            return [(source, aspectRatio, bounds, result)]
        }()

        result += {
            let aspectRatio: CGFloat? = nil
            let source = CGRect(x: 0, y: 0, width: 160, height: 90)
            let bounds = CGRect(x: 0, y: 0, width: 1920, height: 1080)
            let result = CGRect(x: 0, y: 0, width: 1920, height: 1080)

            return [(source, aspectRatio, bounds, result)]
        }()

        result += {
            let aspectRatio: CGFloat = 1.0
            let source = CGRect(x: 0, y: 0, width: 160, height: 90)
            let bounds = CGRect(x: 0, y: 0, width: 1920, height: 1080)
            let result = CGRect(x: 420, y: 0, width: 1080, height: 1080)

            return [(source, aspectRatio, bounds, result)]
        }()

        result += {
            let aspectRatio: CGFloat = 1.0
            let source = CGRect(x: 0, y: 0, width: 640, height: 960)
            let bounds = CGRect(x: 0, y: 0, width: 640, height: 960)
            let result = CGRect(x: 0, y: 160, width: 640, height: 640)

            return [(source, aspectRatio, bounds, result)]
        }()

        result += {
            let aspectRatio: CGFloat = 4.0 / 5.0
            let source = CGRect(x: 0, y: 0, width: 6000, height: 4000)
            let bounds = CGRect(x: 0, y: 0, width: 640, height: 960)
            let result = CGRect(x: 0, y: 80, width: 640, height: 800)

            return [(source, aspectRatio, bounds, result)]
        }()

        return result
    }

    /// List of tuples defining (source - angle - result) argument pairs, required to test CGRects's dividing segment modifier.
    fileprivate static var dividingSegmentAtAngleArguments: [(CGRect, CGFloat, (CGPoint, CGPoint))] {
        var result: [(CGRect, CGFloat, (CGPoint, CGPoint))] = [
            (.zero, .pi / 2, (.zero, .zero)),
            (.zero, .pi / 3, (.zero, .zero)),
            (.zero, .pi / 4, (.zero, .zero)),

            (.zero, .pi, (.zero, .zero)),
            (.zero, .nan, (.zero, .zero)),
            (.zero, .zero, (.zero, .zero)),
            (.zero, .infinity, (.zero, .zero)),

            (.infinite, .pi, (.zero, .zero)),
            (.infinite, .nan, (.zero, .zero)),
            (.infinite, .zero, (.zero, .zero)),
            (.infinite, .infinity, (.zero, .zero)),

            (CGRect(x: 0, y: 0, width: 1, height: 1), .nan, (.zero, .zero)),
            (CGRect(x: 0, y: 0, width: 1, height: 1), .infinity, (.zero, .zero)),
        ]

        result += {
            let angle: CGFloat = .zero
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: -10, y: 0), CGPoint(x: 10, y: 0))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = .pi
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: -10, y: 0), CGPoint(x: 10, y: 0))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = 2 * .pi
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: -10, y: 0), CGPoint(x: 10, y: 0))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = .pi / 2
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: 0, y: -10), CGPoint(x: 0, y: 10))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = 3 * .pi / 2
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: 0, y: -10), CGPoint(x: 0, y: 10))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = .pi / 3
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: -5.7735, y: -10), CGPoint(x: 5.7735, y: 10))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = .pi / 4
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: -10, y: -10), CGPoint(x: 10, y: 10))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = .pi / 6
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: -10, y: -5.7735), CGPoint(x: 10, y: 5.7735))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = -1 * .pi / 3
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: 5.7735, y: -10), CGPoint(x: -5.7735, y: 10))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = -1 * .pi / 4
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: -10, y: 10), CGPoint(x: 10, y: -10))

            return [(source, angle, result)]
        }()

        result += {
            let angle: CGFloat = -1 * .pi / 6
            let source = CGRect(x: -10, y: -10, width: 20, height: 20)
            let result = (CGPoint(x: -10, y: 5.7735), CGPoint(x: 10, y: -5.7735))

            return [(source, angle, result)]
        }()

        return result
    }

    /// List of tuples defining (source - distance - edge - result) argument pairs, required to test CGRect's dividing segment modifier.
    fileprivate static var dividingSegmentAtDistanceArguments: [(CGRect, CGFloat, CGRectEdge, (CGPoint, CGPoint))] {
        var result: [(CGRect, CGFloat, CGRectEdge, (CGPoint, CGPoint))] = []

        result += {
            let source = CGRect(x: 0, y: 0, width: 10, height: 10)
            let distance: CGFloat = 1
            let edge: CGRectEdge = .maxXEdge
            let result = (CGPoint(x: 9, y: 0), CGPoint(x: 9, y: 10))

            return [(source, distance, edge, result)]
        }()

        result += {
            let source = CGRect(x: 0, y: 0, width: 10, height: 10)
            let distance: CGFloat = 1
            let edge: CGRectEdge = .maxYEdge
            let result = (CGPoint(x: 0, y: 9), CGPoint(x: 10, y: 9))

            return [(source, distance, edge, result)]
        }()

        result += {
            let source = CGRect(x: 0, y: 0, width: 10, height: 10)
            let distance: CGFloat = 1
            let edge: CGRectEdge = .minXEdge
            let result = (CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 10))

            return [(source, distance, edge, result)]
        }()

        result += {
            let source = CGRect(x: 0, y: 0, width: 10, height: 10)
            let distance: CGFloat = 1
            let edge: CGRectEdge = .minYEdge
            let result = (CGPoint(x: 0, y: 1), CGPoint(x: 10, y: 1))

            return [(source, distance, edge, result)]
        }()

        return result
    }
}
