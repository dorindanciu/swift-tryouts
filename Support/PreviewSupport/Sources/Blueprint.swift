//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
// A view that displays a blueprint of a shape.
//

import SwiftUI
internal import SwiftUISupport

/// A view that displays a blueprint of a shape.
public struct Blueprint: View {

    /// The renderer used to draw the Blueprint's layout.
    @Environment(\.blueprintRenderer)
    private var renderer: any BlueprintRenderer

    /// The shape to unwrap and layout.
    private var shape: (any Shape)?

    /// Creates a new Blueprint.
    ///
    /// - Parameter shape: The shape to unwrap and plan.
    /// - Returns: A new Blueprint.
    /// - Note: If no shape is provided, the Blueprint will have no plan, just guides.
    public init(_ shape: (any Shape)? = nil) {
        self.shape = shape
    }

    public var body: some View {
        Canvas { context, size in
            context.drawLayer { layer in
                // Compute the bounding rectangle.
                let boundingRect = CGRect(origin: .zero, size: size)

                // Determine the layout in the proposed bounds.
                let layout = layoutValue(in: boundingRect)

                // Use the renderer to draw the layout.
                renderer.draw(layout: layout, in: &layer)
            }
        }
    }

    /// Returns the layout components in the proposed bounds.
    private func layoutValue(in rect: CGRect) -> Layout {
        // Compute the bounding boxes used to layout the content.
        let outerBoundingRect = rect.aspectRatio(1, insideRect: rect)
        let gridBoundingRect = outerBoundingRect.scaled(by: 0.7)

        // Determine the layout components in the proposed bounds.
        let sheet = Layout.Sheet(rect)
        let plan = Layout.Plan.unwrap(shape, inside: gridBoundingRect)
        let grid = Layout.Grid.template(fitting: gridBoundingRect, inside: rect)

        return Layout(sheet: sheet, grid: grid, plan: plan)
    }
}

extension Blueprint {

    /// Type defining the layout elements used to compose the Blueprint.
    public struct Layout: Equatable, Sendable {

        /// Type defining the background sheet (Blueprint's canvas).
        public struct Sheet: Equatable, Sendable {

            /// Returns a rectangle encapsulating the bounds.
            public var boundingRect: CGRect

            /// Creates a new sheet.
            /// - Parameter rect: The rectangle representing the bounds of the sheet.
            internal init(_ rect: CGRect) {
                self.boundingRect = rect
            }
        }

        /// Type defining the layout grid used to align the Blueprint's plan.
        public struct Grid: RandomAccessCollection, Equatable, Sendable {

            public typealias Element = Blueprint.Layout.Guide

            private var elements: [Element] = []

            public var startIndex: Int { elements.startIndex }

            public var endIndex: Int { elements.endIndex }

            public subscript(index: Int) -> Element { elements[index] }

            /// Creates a new grid.
            /// - Parameter sequence: The sequence of guides forming the grid.
            internal init<S>(_ sequence: S) where Element == S.Element, S: Sequence {
                self.elements = Array(sequence)
            }

            /// Generates a template of guides that fit the plan's bounding rect within a larger bounding rectangle.
            ///
            /// - Parameters:
            ///   - planBoundingRect: The rectangle representing the plan's bounds.
            ///   - boundingRect: The larger bounding rectangle.
            /// - Returns: A template of guides that fit within the given rectangles.
            internal static func template(fitting gridBoundingRect: CGRect, inside boundingRect: CGRect) -> Self {
                // Create an array to store the accumulated guides.
                var guides: [Blueprint.Layout.Guide] = [Guide]()

                // Define the outline style of the guides.
                let solid = StrokeStyle(lineWidth: 1.0)
                let dashed = StrokeStyle(lineWidth: 1.0, dash: [4, 2])

                // Setup center guides.
                guides.append(.slanted(.radians(.pi), in: boundingRect, style: solid))
                guides.append(.slanted(.radians(.pi / 2), in: boundingRect, style: solid))
                guides.append(.slanted(.radians(.pi / 4), in: boundingRect, style: solid))
                guides.append(.slanted(.radians(-.pi / 4), in: boundingRect, style: solid))

                // Define fitting marks.
                let outerMark = 0.000
                let innerMark = 0.285
                let marks = [outerMark, innerMark]
                let mirroredMarks = marks.map { 1 - $0 }

                for mark in (marks + mirroredMarks) {
                    // Compute the grid offset relative to the bounding rect's origin.
                    let offsetX = gridBoundingRect.minX + gridBoundingRect.height * mark
                    let offsetY = gridBoundingRect.minY + gridBoundingRect.width * mark

                    // Setup fitting guides.
                    guides.append(.vertical(offsetX, in: boundingRect, style: dashed))
                    guides.append(.horizontal(offsetY, in: boundingRect, style: dashed))
                }

                // Define fitting circles.
                let center = gridBoundingRect.center
                let outerRadius = gridBoundingRect.height / 2
                let innerInscribedRadius = outerRadius * (1 - 2 * innerMark)
                let innerCircumscribedRadius = innerInscribedRadius * sqrt(2)
                let radii = [outerRadius, innerInscribedRadius, innerCircumscribedRadius]

                for radius in radii where radius > 0 {
                    // Setup fitting circles.
                    guides.append(.circle(center, radius: radius, style: solid))
                }

                return Self(guides)
            }
        }

        /// Type that represents a guide in a blueprint.
        public struct Guide: Equatable, Sendable {

            /// A `Path` that defines the shape of the guide.
            internal let path: Path

            /// A `StrokeStyle` that indicates how to outline the guide.
            internal let style: StrokeStyle

            /// Returns the smallest rectangle completely enclosing the guide.
            public var boundingRect: CGRect {
                path.boundingRect
            }

            /// Creates a slanted guide with the specified angle, within the given rectangle, and with the specified stroke style.
            ///
            /// - Parameters:
            ///   - angle: The angle of the slant.
            ///   - rect: The rectangle in which the guide is created.
            ///   - style: The stroke style to use for outlining the guide.
            /// - Returns: A slanted guide.
            internal static func slanted(
                _ angle: Angle,
                in rect: CGRect,
                style: StrokeStyle
            ) -> Self {
                let segment = rect.segment(dividingAt: angle.radians)
                return Self(path: Path(lineSegment: segment), style: style)
            }

            /// Creates a horizontal guide at the specified distance from the top edge of the given rectangle, with the specified stroke style.
            ///
            /// - Parameters:
            ///   - distance: The distance from the top edge of the rectangle.
            ///   - rect: The rectangle in which the guide is created.
            ///   - style: The stroke style to use for outlining the guide.
            /// - Returns: A horizontal guide.
            internal static func horizontal(
                _ distance: CGFloat,
                in rect: CGRect,
                style: StrokeStyle
            ) -> Self {
                let segment = rect.segment(dividingAt: distance, from: .minYEdge)
                return Self(path: Path(lineSegment: segment), style: style)
            }

            /// Creates a vertical guide at the specified distance from the left edge of the given rectangle, with the specified stroke style.
            ///
            /// - Parameters:
            ///   - distance: The distance from the left edge of the rectangle.
            ///   - rect: The rectangle in which the guide is created.
            ///   - style: The stroke style to use for outlining the guide.
            /// - Returns: A vertical guide.
            internal static func vertical(
                _ distance: CGFloat,
                in rect: CGRect,
                style: StrokeStyle
            ) -> Self {
                let segment = rect.segment(dividingAt: distance, from: .minXEdge)
                return Self(path: Path(lineSegment: segment), style: style)
            }

            /// Creates a circular guide with the specified center point, radius, and stroke style.
            ///
            /// - Parameters:
            ///   - center: The center point of the circle.
            ///   - radius: The radius of the circle.
            ///   - style: The stroke style to use for outlining the guide.
            /// - Returns: A circular guide.
            internal static func circle(
                _ center: CGPoint,
                radius: CGFloat,
                style: StrokeStyle
            ) -> Self {
                Self(path: Path(circleAt: center, radius: radius), style: style)
            }
        }

        /// A structure that represents a plan in a blueprint.
        public struct Plan: Equatable, Sendable {
            /// A `Path` that defines the shape of the plan.
            internal let path: Path

            /// The smallest rectangle that completely encloses the plan.
            public var boundingRect: CGRect {
                path.boundingRect
            }

            /// Creates an empty plan.
            ///
            /// This static method returns an instance of `Plan` with an empty `Path`.
            ///
            /// - Returns: An empty `Plan` instance.
            internal static var empty: Self {
                Self(path: Path())
            }

            /// Unwraps a shape and creates a plan inside a specified bounding rectangle.
            ///
            /// This static method takes an optional shape and a bounding rectangle, and returns a `Plan` instance.
            /// If the shape is `nil`, it returns an empty plan. Otherwise, it creates a plan using the shape's path inside the bounding rectangle.
            ///
            /// - Parameters:
            ///    - shape: An optional shape.
            ///    - boundingRect: The bounding rectangle for the plan.
            ///
            /// - Returns: A `Plan` instance.
            internal static func unwrap(_ shape: (any Shape)?, inside boundingRect: CGRect) -> Self {
                guard let shape = shape else {
                    return .empty
                }

                return Self(path: shape.path(in: boundingRect))
            }
        }

        /// Canvas component.
        let sheet: Self.Sheet

        /// Grid component.
        let grid: Self.Grid

        /// Plan component.
        let plan: Self.Plan
    }
}

/// Extension providing convenience functions to draw the Blueprint's layout components.
extension GraphicsContext {
    /// Draws a sheet.
    ///
    /// - Parameters:
    ///   - sheet: The sheet to be drawn.
    ///
    /// - Note: The sheet is filled with the primary foreground style.
    ///
    /// This is a convenience function that fills the bounding rectangle of the sheet with the primary foreground style.
    func draw(_ sheet: Blueprint.Layout.Sheet) {
        fill(Path(sheet.boundingRect), with: .style(.primary))
    }

    /// Draws a grid.
    ///
    /// - Parameters:
    ///   - grid: The grid to be drawn.
    ///
    /// - Note: The grid is outlined with a shading derived from the secondary foreground style.
    ///
    /// This is a convenience function that outlines the guides in the grid with a shading derived from the secondary foreground style.
    ///
    /// - SeeAlso: `draw(_ guide:)`
    func draw(_ grid: Blueprint.Layout.Grid) {
        for guide in grid {
            draw(guide)
        }
    }

    /// Draws a guide.
    ///
    /// - Parameters:
    ///   - guide: The guide to be drawn.
    ///
    /// - Note: The guide is outlined with a shading derived from the secondary foreground style.
    ///
    /// This is a convenience function that outlines the guide with a shading derived from the secondary foreground style.
    func draw(_ guide: Blueprint.Layout.Guide) {
        let shading: GraphicsContext.Shading = .style(.secondary.opacity(0.6))
        stroke(guide.path, with: shading, style: guide.style)
    }

    /// Draws a plan.
    ///
    /// - Parameters:
    ///   - plan: The plan to be drawn.
    ///
    /// - Note: The plan is filled with the secondary foreground style.
    ///
    /// This is a convenience function that fills the path of the plan with the secondary foreground style.
    func draw(_ plan: Blueprint.Layout.Plan) {
        fill(plan.path, with: .style(.secondary))
    }
}

/// A value that can replace the default blueprint rendering behavior.
public protocol BlueprintRenderer: Sendable {

    /// Draws the specified layout in the given graphics context.
    ///
    /// - Parameters:
    ///   - layout: The layout to be drawn.
    ///   - context: The graphics context to draw in.
    func draw(layout: Blueprint.Layout, in context: inout GraphicsContext)
}

/// Default implementation of the `BlueprintRenderer` protocol.
///
/// This renderer draws the sheet, grid, and plan of a blueprint.
/// It clips the sheet to a rounded rectangle and is using a gradient mask
/// to create a fading opacity effect on the grid lines.
public struct DefaultBlueprintRenderer: BlueprintRenderer, Sendable {

    public func draw(layout: Blueprint.Layout, in context: inout GraphicsContext) {

        // Draw the sheet into a dedicated layer.
        context.drawLayer { layer in
            // Mask all the subsequent drawing operations in this layer.
            layer.clip(to: maskOutline(in: layout.sheet.boundingRect))

            // Draw the Blueprint's sheet.
            layer.draw(layout.sheet)
        }

        // Draw the grid into a dedicated layer.
        context.drawLayer { layer in
            // Mask all the subsequent drawing operations in this layer.
            layer.clipToLayer { clippingLayer in
                let outline = maskOutline(in: layout.sheet.boundingRect)
                let shading = maskShading(in: layout.sheet.boundingRect)
                clippingLayer.fill(outline, with: shading)
            }

            // Draw the Blueprint's grid.
            layer.draw(layout.grid)
        }

        // Draw the plan into a dedicated layer.
        context.drawLayer { layer in
            layer.draw(layout.plan)
        }
    }

    /// Computed value describing a corner radius value in relation to the bounding frame.
    private func cornerRadius(in rect: CGRect) -> CGFloat {
        min(rect.width, rect.height) * 10.0 / 57
    }

    /// Path defining the shape of the region to mask.
    private func maskOutline(in rect: CGRect) -> Path {
        Path(roundedRect: rect, cornerRadius: cornerRadius(in: rect))
    }

    /// Context shading representing the fill of the clipping mask.
    private func maskShading(in rect: CGRect) -> GraphicsContext.Shading {
        GraphicsContext.Shading.radialGradient(
            Gradient(colors: [.black, .clear]),
            center: CGPoint(x: rect.midX, y: rect.midY),
            startRadius: 0.0,
            endRadius: max(rect.width, rect.height) / 1.75
        )
    }
}

extension BlueprintRenderer where Self == DefaultBlueprintRenderer {
    /// Default blueprint renderer.
    public static var `default`: Self { .init() }
}

extension EnvironmentValues {
    /// The blueprint renderer associated with this environment.
    @Entry public var blueprintRenderer: any BlueprintRenderer = .default
}

/// A view modifier that sets the `blueprintRenderer` environment value for a view.
public struct BlueprintRendererModifier: ViewModifier {

    /// The blueprint renderer to be set as the environment value.
    let renderer: any BlueprintRenderer

    /// Creates a new blueprint renderer modifier.
    /// - Parameter renderer: The blueprint renderer to be set as the environment value.
    public init(renderer: any BlueprintRenderer) {
        self.renderer = renderer
    }

    /// Sets the `blueprintRenderer` environment value for the view.
    /// - Parameter content: The content view to modify.
    /// - Returns: A modified view with the `blueprintRenderer` environment value set.
    public func body(content: Content) -> some View {
        content.environment(\.blueprintRenderer, renderer)
    }
}

extension View {

    /// Sets the `blueprintRenderer` environment value to the given value.
    ///
    /// - Parameters:
    ///   - renderer: The new blueprint renderer value.
    func blueprintRenderer<T>(_ renderer: T) -> some View where T: BlueprintRenderer {
        modifier(BlueprintRendererModifier(renderer: renderer))
    }
}

// MARK: - Xcode Previews

#Preview("Blueprint") {
    Blueprint()
        .foregroundStyle(.blue.gradient, .white.opacity(0.8))
        .padding()
}

#Preview("Blueprint Collection") {

    let templates: [(any ShapeStyle, any ShapeStyle)] = {
        var result: [(any ShapeStyle, any ShapeStyle)] = []

        // App icon template style.
        result += {
            let color = Color.white.opacity(0.8)
            let gradient = Color.blue.gradient

            return [(gradient, color)]
        }()

        // Human Interface Guideline template style
        result += {
            let color = Color.gray.opacity(0.6)
            let gradient = LinearGradient(
                gradient: Gradient(
                    colors: [
                        .yellow.mix(with: .white, by: 0.10),
                        .yellow.mix(with: .black, by: 0.07),
                    ]
                ),
                startPoint: .leading,
                endPoint: .trailing
            )

            return [(gradient, color)]
        }()

        // Mesh gradient & solid color
        result += {
            let color = Color.white
            let gradient = MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], [0.4, 0.0], [1.0, 0.0],
                    [0.0, 0.4], [0.7, 0.2], [1.0, 0.4],
                    [0.0, 1.0], [0.4, 1.0], [1.0, 1.0],
                ],
                colors: [
                    .red, .orange, .green,
                    .purple, .blue, .indigo,
                    .green, .teal, .pink,
                ]
            )

            return [(gradient, color)]
        }()

        return result
    }()

    ScrollView(.horizontal) {
        LazyHStack {
            ForEach(Array(zip(templates.indices, templates)), id: \.0) { _, template in
                let primary = AnyShapeStyle(template.0)
                let secondary = AnyShapeStyle(template.1)

                Blueprint()
                    .foregroundStyle(primary, secondary)
                    .aspectRatio(2.0 / 3.0, contentMode: .fit)
                    .containerRelativeFrame([.horizontal, .vertical])
            }
        }
        .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
    .safeAreaPadding(.horizontal, 40.0)
}
