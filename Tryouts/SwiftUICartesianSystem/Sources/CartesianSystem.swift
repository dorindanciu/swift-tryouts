//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// This sample code serves as a playground to debug transforms in a 2D Cartesian System.
//

internal import PreviewSupport
import SwiftUI
internal import SwiftUISupport

public struct CartesianSystem {

    public let unitSize: CGSize

    public let boundingRect: CGRect

    public var center: CGPoint {
        CGPoint(x: boundingRect.width / 2, y: boundingRect.height / 2)
    }

    /// Cursor that iterates over the entire system width, marking the x axis gridline intersections.
    public var horizontalCursor: Cursor {
        Cursor(trough: boundingRect.width, by: unitSize.width)
    }

    /// Cursor that iterates over the entire system height, marking the y axis gridline intersections.
    public var verticalCursor: Cursor {
        Cursor(trough: boundingRect.height, by: unitSize.height)
    }

    /// Type designed to compute a sequence of marks, striding the given length in such a way that
    /// one mark will overlap with the middle of the length precisely.
    public struct Cursor: Sequence {
        internal let length: CGFloat
        internal let stride: CGFloat

        public init(trough length: CGFloat, by stride: CGFloat) {
            self.length = length
            self.stride = stride
        }

        public func makeIterator() -> some IteratorProtocol<CGFloat> {
            CursorIterator(self)
        }

        internal struct CursorIterator: IteratorProtocol {
            private let cursor: Cursor
            private var offset: CGFloat

            internal init(_ cursor: Cursor) {
                self.cursor = cursor

                self.offset = (cursor.length / 2).truncatingRemainder(dividingBy: cursor.stride)
            }

            internal mutating func next() -> CGFloat? {
                guard offset <= cursor.length else { return nil }
                defer { offset += cursor.stride }
                return offset
            }
        }
    }
}

extension CartesianSystem {

    fileprivate var debugRotationEntries: [(path: Path, rotationPoint: CGPoint, shading: GraphicsContext.Shading)] {
        var results = [(Path, CGPoint, GraphicsContext.Shading)]()

        // Blue rounded rectangle
        do {
            let rect = CGRect(
                x: boundingRect.center.x + unitSize.width,
                y: boundingRect.center.y + unitSize.height * 2,
                width: unitSize.height * 2,
                height: unitSize.height * 2
            )

            let shape = RoundedRectangle(cornerRadius: 4)
            let shading = GraphicsContext.Shading.color(.blue)
            let rotationPoint = boundingRect.center

            results += [(shape.path(in: rect), rotationPoint, shading)]
        }

        // Red capsule
        do {
            let rect = CGRect(
                x: boundingRect.center.x + unitSize.width * 3,
                y: boundingRect.center.y - unitSize.height * 9,
                width: unitSize.width,
                height: unitSize.height * 3
            )
            let shape = Capsule()
            let shading = GraphicsContext.Shading.color(.red)
            let rotationPoint = rect.center.applying(.init(translationX: 0, y: unitSize.height))

            results += [(shape.path(in: rect), rotationPoint, shading)]
        }

        // Green circle
        do {
            let rect = CGRect(
                x: boundingRect.center.x - unitSize.width * 6,
                y: boundingRect.center.y - unitSize.height * 10,
                width: unitSize.width * 2,
                height: unitSize.height * 2
            )
            let shape = Circle()
            let shading = GraphicsContext.Shading.color(.green)
            let rotationPoint = rect.center.applying(.init(translationX: unitSize.width, y: unitSize.height))

            results += [(shape.path(in: rect), rotationPoint, shading)]
        }

        return results
    }
}

extension GraphicsContext {

    public func draw(_ system: CartesianSystem, with shading: Shading = .color(.gray)) {
        // Draw the grid lines in their own layer.
        drawLayer { layer in

            // Adjust opacity for the gird lines.
            layer.opacity = 0.24

            // Draw vertical lines at the given offsets.
            for distance in system.horizontalCursor {
                layer.draw(lineIn: system.boundingRect, atDistance: distance, from: .leading, with: shading)
            }

            // Draw horizontal lines at the given offsets.
            for distance in system.verticalCursor {
                layer.draw(lineIn: system.boundingRect, atDistance: distance, from: .top, with: shading)
            }
        }

        // Draw the x, y axes in their own layer.
        drawLayer { layer in
            layer.draw(lineIn: system.boundingRect, atDistance: system.center.x, from: .leading, with: shading)
            layer.draw(lineIn: system.boundingRect, atDistance: system.center.y, from: .top, with: shading)
        }
    }

    private func draw(lineIn bounds: CGRect, atDistance distance: CGFloat, from edge: Edge, with shading: Shading) {
        var copy = self
        copy.translateBy(x: bounds.origin.x, y: bounds.origin.y)

        let startPoint = CGPoint(
            x: edge == .leading ? distance : 0,
            y: edge == .top ? distance : 0
        )
        let endPoint = CGPoint(
            x: edge == .leading ? distance : bounds.width,
            y: edge == .top ? distance : bounds.height
        )

        copy.stroke(Path(lineSegment: (startPoint, endPoint)), with: shading)
    }

    public func debugRotation(_ angle: CGFloat, around point: CGPoint, for path: Path, with shading: Shading) {
        drawLayer { layer in
            // Draw the anchor point.
            layer.stroke(Path(circleAt: point, radius: 2), with: shading)

            // Draw the initial state using a dashed stroke style.
            layer.stroke(path, with: shading, style: StrokeStyle(lineWidth: 1, dash: [4, 2]))

            // Compute anchor point offset params.
            let dx = point.x - path.boundingRect.origin.x
            let dy = point.y - path.boundingRect.origin.y

            // Compute the radius for the circle describing path's origin point rotation,
            // using Pythagorean hypotenuse formula.
            let radius = sqrt(pow(dx, 2) + pow(dy, 2))

            // Draw the circle describing path's origin point rotation transform.
            layer.opacity = 0.24
            layer.stroke(Path(circleAt: point, radius: radius), with: shading)

            // Compute the transform matrix.
            let offset = CGAffineTransform(translationX: -point.x, y: -point.y)
            let rotation = CGAffineTransform(rotationAngle: angle)
            let matrix = CGAffineTransform.identity
                .concatenating(offset)
                .concatenating(rotation)
                .concatenating(offset.inverted())

            // Apply the transform matrix.
            layer.concatenate(matrix)

            // Draw the current state using a solid stroke style.
            layer.opacity = 1
            layer.stroke(path, with: shading)
        }
    }
}

// MARK: - Xcode Previews

#Preview("GraphicsContext Transforms") {

    @Previewable @State
    var angle: Angle = .degrees(0)

    VStack {
        Canvas { context, size in
            // Define the cartesian coordinate system.
            let unitSize = CGSize(width: 20, height: 20)
            let boundingRect = CGRect(origin: .zero, size: size)
            let system = CartesianSystem(unitSize: unitSize, boundingRect: boundingRect)

            // Draw the system's grid and axes.
            context.draw(system, with: .color(.gray))

            // Draw rotation transform debug clues for several entries.
            for entry in system.debugRotationEntries {
                context.debugRotation(
                    angle.radians,
                    around: entry.rotationPoint,
                    for: entry.path,
                    with: entry.shading
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 0.75))
        .padding()

        GroupBox("Inspector") {
            LabeledContent("Rotation") {
                Slider(value: $angle.degrees, in: 0...360, step: 1)
            }
        }
        .labeledContentStyle(.inspector)
        .padding()
    }
}
