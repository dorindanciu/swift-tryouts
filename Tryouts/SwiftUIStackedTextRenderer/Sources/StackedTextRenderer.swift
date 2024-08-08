//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// A custom text renderer that stacks multiple variants of the same text,
// creating a replication effect by gradually offsetting and clipping each copy.
//

import SwiftUI

/// A custom text renderer that stacks multiple variants of the same text
/// on top of each other. The renderer is used to create a replication effect
/// by gradually offsetting and clipping each copy of the text, until the text vanishes.
///
/// ## Example
/// ```swift
/// let prefix = Text("SUPER").fontWeight(.black)
/// let suffix = Text("COLOR").fontWeight(.regular)
///
/// Text("\(prefix)\(suffix)")
///    .font(.custom("Avenir", fixedSize: 42))
///    .textRenderer(StackedTextRenderer(spacing: 10))
///    .foregroundStyle(Gradient(colors: [.orange, .red, .purple, .blue]))
/// ```
/// - Note: If the text spans multiple lines, only the first line will be replicated.
public struct StackedTextRenderer: TextRenderer {

    /// The default spacing value used by this type.
    private var defaultSpacing: CGFloat = 8.0

    /// The explicit spacing value configured during init.
    private var explicitSpacing: CGFloat?

    /// The spacing between each stacked variant of the text.
    private var spacing: CGFloat {
        explicitSpacing ?? defaultSpacing
    }

    /// Creates a new `StackedTextRenderer` with the given spacing.
    /// - Parameter spacing: The spacing between each stacked variant of the text.
    public init(spacing: CGFloat? = nil) {
        self.explicitSpacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, text: TextProxy) -> CGSize {
        var requiredSize = sizeThatFitsLine(proposal: proposal, text: text)
        let layout = layoutOptions(lineSize: requiredSize, spacing: spacing)
        requiredSize.height += layout.map(\.0.y).reduce(0, +)

        return requiredSize
    }

    public func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        guard let line = layout.first else {
            return
        }

        // Use the stacked lines as a mask.
        context.clipToLayer { layer in
            stack(line: line, in: &layer)
        }

        // Fill the clipping bounds with the foreground style.
        context.fill(Path(context.clipBoundingRect), with: .style(.foreground))
    }

    /// Calculates the size required to fit one line of text.
    ///
    /// - Parameters:
    ///   - proposal: The proposed view size.
    ///   - text: The text to be rendered.
    ///
    /// - Returns: The size required to fit one line of text.
    private func sizeThatFitsLine(proposal: ProposedViewSize, text: TextProxy) -> CGSize {
        // Determine the required sizes for
        // multiline and single line variants.
        let multiLineSize = text.sizeThatFits(proposal)
        let singleLineSize = text.sizeThatFits(.infinity)

        // Return the size required to fit one line of text.
        return CGSize(
            width: multiLineSize.width,
            height: singleLineSize.height
        )
    }

    /// Calculates the layout options for stacked text rendering.
    ///
    /// - Parameters:
    ///   - lineSize: The reference line size.
    ///   - spacing: The spacing between each line of text.
    ///
    /// - Returns: An array of tuples representing the layout options.
    /// Each tuple contains a CGPoint representing the offset and a CGFloat representing the trim height.
    private func layoutOptions(lineSize: CGSize, spacing: CGFloat) -> [(CGPoint, CGFloat)] {
        let lineHeight = lineSize.height.rounded() * 0.625
        let trimUnit = CGFloat(2.0)
        var trimHeight = CGFloat.zero
        var offset = CGPoint.zero

        var options: [(CGPoint, CGFloat)] = []

        while trimHeight < lineHeight - trimUnit * 2 {
            if trimHeight > .zero {
                offset.y = lineHeight - trimHeight + spacing
            }
            options.append((offset, trimHeight))

            trimHeight += trimUnit
        }

        return options
    }

    /// Stack the given line of text in the graphics context.
    ///
    /// - Parameters:
    ///   - line: The line of text to stack.
    ///   - context: The graphics context to draw the text in.
    ///
    /// This method stacks the given line of text in the provided graphics context.
    /// Each stacked variant of the text is offset and clipped until the content vanishes.
    private func stack(line: Text.Layout.Line, in context: inout GraphicsContext) {
        let lineSize = line.typographicBounds.rect.size
        let options = layoutOptions(lineSize: lineSize, spacing: spacing)

        for (offset, trimHeight) in options {
            // Offset the origin accordingly.
            context.translateBy(x: 0, y: offset.y)

            // Draw the trimmed variant of the line.
            context.drawLayer { layer in
                // Mask the layer with the shape of the line.
                layer.clipToLayer { $0.draw(line) }

                // Determine the area to fill based on the current trimHeight.
                let clippingRect = layer.clipBoundingRect
                let trimmingRect = clippingRect.offsetBy(dx: 0, dy: trimHeight)

                // Fill the resolved area in black.
                layer.fill(Path(trimmingRect), with: .color(.black))
            }
        }
    }
}

// MARK: - Xcode Previews

#Preview("StackedText Renderer") {

    @Previewable @State
    var spacing: CGFloat = 10

    VStack {
        Spacer()

        let prefix = Text("SUPER").fontWeight(.black)
        let suffix = Text("COLOR").fontWeight(.regular)

        Text("\(prefix)\(suffix)")
            .font(.custom("Avenir", fixedSize: 42))
            .textRenderer(StackedTextRenderer(spacing: spacing))
            .foregroundStyle(Gradient(colors: [.orange, .red, .purple, .blue]))

        Spacer()

        GroupBox("Layout") {
            LabeledContent("Spacing") {
                Slider(value: $spacing, in: 0...8, step: 1)
            }
        }
        .padding()
    }
}
