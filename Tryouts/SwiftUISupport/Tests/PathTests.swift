//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
// Unit tests covering Path extensions.
//

import SwiftUI
import Testing

@testable import SwiftUISupport

@Suite("Path Extensions")
struct PathTests {

    @Test("Circle initializer", arguments: circlePathArguments)
    func circle(center: CGPoint, radius: CGFloat, expectedResult: Path) async throws {
        let result = Path(circleAt: center, radius: radius)
        #expect(result == expectedResult)
    }

    @Test("Line segment initializer", arguments: lineSegmentPathArguments)
    func lineSegment(startPoint: CGPoint, endPoint: CGPoint, expectedResult: Path) async throws {
        let result = Path(lineSegmentBetween: startPoint, and: endPoint)
        #expect(result == expectedResult)
    }
}

extension PathTests {

    /// List of tuples (center - radius - result) argument pairs, required to test Path's circle constructor.
    fileprivate static var circlePathArguments: [(CGPoint, CGFloat, Path)] {
        let result: [(CGPoint, CGFloat, Path)] = [
            (CGPoint(x: 0, y: 0), 10, Path(ellipseIn: CGRect(x: -10, y: -10, width: 20, height: 20))),
            (CGPoint(x: 10, y: 10), 5, Path(ellipseIn: CGRect(x: 5, y: 5, width: 10, height: 10))),
            (CGPoint(x: -10, y: -10), 15, Path(ellipseIn: CGRect(x: -25, y: -25, width: 30, height: 30))),
            (CGPoint(x: 0, y: 0), 0, Path(ellipseIn: CGRect(x: 0, y: 0, width: 0, height: 0))),
        ]

        return result
    }

    /// List of tuples (startPoint - endPoint - result) argument pairs, required to test Path's line segment constructor.
    fileprivate static var lineSegmentPathArguments: [(CGPoint, CGPoint, Path)] {
        let result: [(CGPoint, CGPoint, Path)] = [
            (
                CGPoint(x: 0, y: 0), CGPoint(x: 10, y: 10),
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 10, y: 10))
                }
            ),
            (
                CGPoint(x: 10, y: 10), CGPoint(x: 0, y: 0),
                Path { path in
                    path.move(to: CGPoint(x: 10, y: 10))
                    path.addLine(to: CGPoint(x: 0, y: 0))
                }
            ),
            (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), Path { _ in }),
            (CGPoint(x: 10, y: 10), CGPoint(x: 10, y: 10), Path { _ in }),
        ]

        return result
    }
}
