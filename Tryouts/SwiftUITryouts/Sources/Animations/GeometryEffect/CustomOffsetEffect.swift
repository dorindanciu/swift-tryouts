//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// This sample code is a reimplementation of the _OffsetEffect provided by SwiftUI.
//

import SwiftUI
internal import SwiftUITryoutsSupport

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct CustomOffsetEffect: @preconcurrency GeometryEffect, Equatable {

    public var animatableData: CGSize.AnimatableData

    @inlinable public init(offset: CGSize) {
        self.animatableData = .init(offset.width, offset.height)
    }

    public var offset: CGSize {
        get { CGSize(width: animatableData.first, height: animatableData.second) }
        set { animatableData = .init(newValue.width, newValue.height) }
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        let matrix = CGAffineTransform(translationX: offset.width, y: offset.height)
        return ProjectionTransform(matrix)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Offset this view by the horizontal and vertical amount specified in the offset parameter.
    ///
    /// - Parameter offset: The distance to offset this view.
    /// - Returns: A view that offsets this view by offset.
    ///
    /// Use `offset(_:)` to shift the displayed contents by the amount specified in the offset parameter.
    ///
    /// The original dimensions of the view aren’t changed by offsetting the contents;
    /// in the example below the gray border drawn by this view surrounds the original position of the text:
    ///
    /// ```swift
    /// Text("Offset by passing CGSize()")
    ///     .border(Color.green)
    ///     .customOffset(CGSize(width: 20, height: 25))
    ///     .border(Color.gray)
    /// ```
    @inlinable public func customOffset(_ offset: CGSize) -> some View {
        return modifier(CustomOffsetEffect(offset: offset))
    }

    /// Offset this view by the specified horizontal and vertical distances.
    /// - Parameters:
    ///   - x: The horizontal distance to offset this view.
    ///   - y: The vertical distance to offset this view.
    /// - Returns: A view that offsets this view by x and y.
    ///
    /// Use `offset(x:y:)` to shift the displayed contents by the amount specified in the x and y parameters.
    ///
    /// The original dimensions of the view aren’t changed by offsetting the contents;
    /// in the example below the gray border drawn by this view surrounds the original position of the text:
    ///
    /// ```swift
    /// Text("Offset by passing horizontal & vertical distance")
    ///    .border(Color.green)
    ///    .customOffset(x: 20, y: 50)
    ///    .border(Color.gray)
    /// ```
    @inlinable public func customOffset(x: CGFloat = 0, y: CGFloat = 0) -> some View {
        return customOffset(CGSize(width: x, height: y))
    }
}

// MARK: - Xcode Previews

#Preview("CustomOffsetEffect Editor") {

    @Previewable @State
    var offset: CGSize = .zero

    VStack {
        Spacer()

        HStack {
            Blueprint()
                .foregroundStyle(.blue.gradient, .white)
                .scaledToFit()
                .offset(offset)

            Blueprint()
                .foregroundStyle(.yellow.gradient, .gray)
                .scaledToFit()
                .customOffset(offset)
        }
        .padding()

        Spacer()

        VStack {
            #if os(watchOS)
            HStack {
                Button("Randomize", systemImage: "shuffle") {
                    withAnimation(.snappy) {
                        offset.width = CGFloat.random(in: -50...50)
                        offset.height = CGFloat.random(in: -50...50)
                    }
                }

                Spacer()

                Button("Reset", systemImage: "align.vertical.center.fill") {
                    withAnimation(.snappy) {
                        offset.width = CGFloat.zero
                        offset.height = CGFloat.zero
                    }
                }
            }
            .labelStyle(.iconOnly)

            #else
            GroupBox("Offset") {
                LabeledContent("Width") {
                    Slider(value: $offset.width, in: -50...50)
                }

                LabeledContent("Height") {
                    Slider(value: $offset.height, in: -50...50)
                }
            }

            GroupBox {
                HStack {
                    Button("Randomize") {
                        withAnimation(.snappy) {
                            offset.width = CGFloat.random(in: -50...50)
                            offset.height = CGFloat.random(in: -50...50)
                        }
                    }

                    Spacer()

                    Button("Reset") {
                        withAnimation(.snappy) {
                            offset.width = CGFloat.zero
                            offset.height = CGFloat.zero
                        }
                    }
                }

            }
            #endif
        }
        .labeledContentStyle(.inspector)
    }
}
