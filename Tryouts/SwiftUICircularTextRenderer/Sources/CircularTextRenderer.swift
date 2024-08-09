//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// A custom text renderer responsible for rendering text in a circular layout.
//

internal import PreviewSupport
public import SwiftUI

/// A specialized renderer that layouts text in a circular manner.
public struct CircularTextRenderer: TextRenderer {

    /// The angle at which the text starts in the circular layout.
    /// - Note: The default value is `.zero`.
    ///
    /// The angle represents the rotation of the text around the center
    /// of the circle. The angle is applied in a clockwise direction.
    public var startAngle: Angle

    /// Creates a new `CircularTextRenderer` with the given start angle.
    /// - Parameter startAngle: The angle at which the text starts in the circular layout.
    public init(startAngle: Angle = .zero) {
        self.startAngle = startAngle
    }

    public func sizeThatFits(proposal: ProposedViewSize, text: TextProxy) -> CGSize {
        text.sizeThatFitsCircularLayout(proposal: proposal)
    }

    public func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        let circularLayout = CircularLayout(layout, startAngle: startAngle.radians)
        context.draw(circularLayout)
    }
}

extension TextProxy {

    /// Returns the size that fits the circular layout.
    /// - Parameter proposal: The proposed size for the view.
    internal func sizeThatFitsCircularLayout(proposal: ProposedViewSize) -> CGSize {
        let typographicBounds = CircularLayout.TypographicBounds(
            lineSize: sizeThatFits(.infinity)
        )

        return typographicBounds.rect.size
    }
}

extension GraphicsContext {

    /// Draws the circular layout in the current context.
    /// - Parameters:
    ///  - layout: The circular layout to draw.
    /// - options: The drawing options to apply.
    ///
    /// The drawing options allow you to enable debug guides for the layout.
    internal func draw(_ layout: CircularLayout, options: CircularLayout.DrawingOptions = .init()) {

        // Debug layout guides if required.
        if options.contains(.debugBoundingGuides) {
            debugBoundingGuides(layout)
        }

        // Draw each slice in the circular layout.
        drawLayer { layer in
            // Iterate over each slice in the layout.
            for slice in layout {

                // Apply the transform to the layer.
                layer.concatenate(slice.transform)

                // Debug the slice bounds if required.
                if options.contains(.debugSliceBounds) {
                    layer.debugBoundingRect(slice.runSlice)
                }

                // Draw the slice in the layer.
                layer.draw(slice.runSlice)

                // Invert the transform and reset the layer.
                layer.concatenate(slice.transform.inverted())
            }
        }
    }

    private func debugBoundingRect(_ slice: Text.Layout.RunSlice) {
        // Determine the guide bounding the slice.
        let guide = Path(slice.typographicBounds.rect)

        // Stroke guide using the quinary foreground style.
        self.stroke(guide, with: .style(.quinary))
    }

    private func debugBoundingGuides(_ layout: CircularLayout) {
        // Create an array to store all guides.
        var guides: [Path] = []

        // Append bounding guide.
        guides.append(Path(layout.typographicBounds.rect))

        // Append outer circle guide.
        guides.append(Path(ellipseIn: layout.typographicBounds.rect))

        // Append inner circle guide.
        guides.append(Path(ellipseIn: layout.typographicBounds.innerRect))

        // Append vertical axis guide.
        guides.append(
            Path { path in
                let startPoint = CGPoint(
                    x: layout.typographicBounds.rect.midX,
                    y: layout.typographicBounds.rect.minY
                )
                let endPoint = CGPoint(
                    x: layout.typographicBounds.rect.midX,
                    y: layout.typographicBounds.rect.maxY
                )
                path.move(to: startPoint)
                path.addLine(to: endPoint)
            }
        )

        // Append horizontal axis guide.
        guides.append(
            Path { path in
                let startPoint = CGPoint(
                    x: layout.typographicBounds.rect.minX,
                    y: layout.typographicBounds.rect.midY
                )
                let endPoint = CGPoint(
                    x: layout.typographicBounds.rect.maxX,
                    y: layout.typographicBounds.rect.midY
                )
                path.move(to: startPoint)
                path.addLine(to: endPoint)
            }
        )

        // Stroke all guides using the quinary foreground style.
        for guide in guides {
            self.stroke(guide, with: .style(.quinary))
        }
    }
}

/// A custom text layout that converts a flow layout into a circular layout.
///
/// It provides a convenient way to iterate over the slices in a circular layout.
/// Each element is represented by a `CircularLayout.Slice` instance containing the
/// original `Text.Layout.RunSlice` and the corresponding `CGAffineTransform`
/// that positions the slice on the circle's circumference.
internal struct CircularLayout: Sequence {

    /// Drawing options for the circular layout.
    ///
    /// The drawing options allow you to enable debug guides for the layout.
    internal struct DrawingOptions: OptionSet {

        internal let rawValue: UInt32

        internal init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// Debug the bounding guides of the circular layout.
        internal static var debugBoundingGuides: CircularLayout.DrawingOptions {
            Self(rawValue: 1 << 0)
        }

        /// Debug the slice bounds of the circular layout.
        internal static var debugSliceBounds: CircularLayout.DrawingOptions {
            Self(rawValue: 1 << 1)
        }
    }

    /// A slice in the circular layout.
    internal struct Slice {

        /// The run slice in the circular layout.
        internal let runSlice: Text.Layout.RunSlice

        /// The transform that positions the slice on the circle's circumference.
        internal let transform: CGAffineTransform

        /// Creates a new slice in the circular layout.
        /// - Parameters:
        ///  - runSlice: The run slice in the circular layout.
        ///  - transform: The transform that positions the slice on the circle's circumference.
        internal init(_ runSlice: Text.Layout.RunSlice, transform: CGAffineTransform) {
            self.runSlice = runSlice
            self.transform = transform
        }
    }

    /// Typographic bounds for the circular layout.
    internal struct TypographicBounds {

        /// The size of the text when laid out in a single line.
        internal let lineSize: CGSize

        /// The descender of the text.
        ///
        /// The descender represents the radius of the circle tangent to the bottom of the slices.
        internal var descender: CGFloat {
            lineSize.width / (2 * .pi)
        }

        /// The ascender of the text.
        ///
        /// The ascender represents the radius of the circle tangent to the top of the slices.
        internal var ascender: CGFloat {
            descender + lineSize.height
        }

        /// The rectangle that bounds the circular layout.
        internal var rect: CGRect {
            CGRect(x: 0, y: 0, width: 2 * ascender, height: 2 * ascender)
        }

        /// The rectangle that bounds the circular layout excluding the line width.
        internal var innerRect: CGRect {
            rect.insetBy(dx: lineSize.height, dy: lineSize.height)
        }
    }

    /// The text layout to convert into a circular layout.
    internal let textLayout: Text.Layout

    /// The angle at which the text starts in the circular layout.
    internal let startAngle: CGFloat

    /// The typographic bounds for the circular layout.
    internal let typographicBounds: TypographicBounds

    /// Creates a new circular layout with the given text layout and start angle.
    /// - Parameters:
    /// - layout: The text layout to convert into a circular layout.
    /// - startAngle: The angle at which the text starts in the circular layout.
    internal init(_ layout: Text.Layout, startAngle: CGFloat = 0) {
        self.textLayout = layout
        self.startAngle = startAngle
        self.typographicBounds = TypographicBounds(lineSize: layout.lineSize)
    }

    /// Returns an iterator over the elements of this sequence.
    internal func makeIterator() -> some IteratorProtocol<Slice> {
        CircularLayoutIterator(self)
    }

    /// An iterator that provides access to the slices in the circular layout.
    internal struct CircularLayoutIterator: IteratorProtocol {
        internal let layout: CircularLayout
        internal var sliceIterator: [Text.Layout.RunSlice].Iterator
        internal var offset: CGFloat = .zero

        internal init(_ layout: CircularLayout) {
            self.layout = layout
            self.sliceIterator = layout.textLayout.flattenedRunSlices.makeIterator()
        }

        internal mutating func next() -> CircularLayout.Slice? {
            // Grab the next slice from the iterator or return nil
            // if there are no more slices to iterate over.
            guard let slice = sliceIterator.next() else {
                return nil
            }

            // Define the radius, line width, and start angle for the circular layout.
            let radius = layout.typographicBounds.ascender
            let lineWidth = layout.typographicBounds.lineSize.width
            let startAngle = layout.startAngle

            // Define the slice's coordinates and dimensions.
            let sliceWidth = slice.typographicBounds.width
            let sliceHeight = slice.typographicBounds.rect.height
            let sliceMidX = slice.typographicBounds.rect.midX
            let sliceMidY = slice.typographicBounds.rect.midY

            // Adjust the initial offset to center the slice around the origin.
            if offset == .zero {
                offset -= sliceWidth / 2
            }

            // Calculate the progress for the slice as if it was laid out in a single line.
            let progress = ((offset + sliceWidth / 2) / lineWidth)

            // Calculate the angle for the slice based on the progress.
            let angle = startAngle + 2 * .pi * progress

            // Define the transforms to position the slice on the circle's circumference.
            let transforms: [CGAffineTransform] = [

                // Translate to center the slice around the origin.
                CGAffineTransform(translationX: -sliceMidX, y: -sliceMidY),

                // Translate upward to align the slice with the top of the circle.
                CGAffineTransform(translationX: 0, y: -(radius - sliceHeight / 2)),

                // Rotate around the origin by the given angle.
                CGAffineTransform(rotationAngle: angle),

                // Translate to move the slice to its position on the circle's circumference.
                CGAffineTransform(translationX: radius, y: radius),
            ]

            // Combine transforms using concatenation.
            // The transform is a concatenation of the following transforms:
            //
            // 1. Translate to center the slice around the origin.
            // 2. Translate upward to align the slice with the top of the circle.
            // 3. Rotate around the origin by the given angle.
            // 4. Translate to move the slice to its position on the circle's circumference.
            let combinedTransform = transforms.reduce(CGAffineTransform.identity) { partialResult, element in
                partialResult.concatenating(element)
            }

            // Create the next slice in the circular layout.
            let nextElement = CircularLayout.Slice(slice, transform: combinedTransform)

            // Update the offset for the next iteration.
            offset += sliceWidth

            return nextElement
        }
    }
}

extension Text.Layout {

    /// The size of the text when laid out in a single line.
    ///
    /// The line size is calculated as the sum of the widths of all run slices
    /// and the maximum height of all run slices in the layout.
    internal var lineSize: CGSize {
        CGSize(
            width: flattenedRuns.map(\.typographicBounds.width).reduce(.zero, +).rounded(),
            height: flattenedRuns.map(\.typographicBounds.rect.height).max() ?? .zero
        )
    }

    /// A helper function for easier access to all runs in a layout.
    internal var flattenedRuns: Array<Text.Layout.Run> {
        flatMap(\.self)
    }

    /// A helper function for easier access to all run slices in a layout.
    internal var flattenedRunSlices: Array<Text.Layout.RunSlice> {
        flattenedRuns.flatMap(\.self)
    }
}

// MARK: - Xcode Previews

#Preview("CircularTextRenderer Editor") {

    @Previewable @State
    var startAngle: Angle = .zero

    VStack {
        Spacer()

        Text("Here's to the crazy ones • The misfits, the rebels, the troublemakers • ")
            .fontWeight(.medium)
            .font(.system(size: 24))
            .textRenderer(CircularTextRenderer(startAngle: startAngle))

        Spacer()

        GroupBox("Configuration") {
            LabeledContent("Start Angle") {
                Slider(value: $startAngle.degrees, in: -180...180)
            }
        }
        .labeledContentStyle(.inspector)
        .padding()
    }
}

#Preview("CircularTextRenderer Animation") {

    @Previewable @State
    var angle: Angle = .zero

    Text("Here's to the crazy ones • The misfits, the rebels, the troublemakers • ")
        .fontWeight(.semibold)
        .fontDesign(.serif)
        .font(.body.italic())
        .textRenderer(CircularTextRenderer())
        .rotationEffect(angle)
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                angle.degrees = -360
            }
        }
}
