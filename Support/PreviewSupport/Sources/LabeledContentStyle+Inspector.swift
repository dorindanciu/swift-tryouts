//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// A custom `LabeledContentStyle` suitable for inspector-like interfaces.
//

import SwiftUI

extension LabeledContentStyle where Self == InspectorLabeledContentStyle {

    /// Creates a default inspector style.
    @MainActor public static var inspector: Self { Self() }

    /// Creates an inspector style with the given label length.
    @MainActor public static func inspector(labelLength: Self.LabelLength) -> Self {
        Self(labelLength: labelLength)
    }
}

/// A style for `LabeledContent` that is suitable for inspector-like interfaces.
public struct InspectorLabeledContentStyle: LabeledContentStyle {

    /// Type defining the length of the label.
    public enum LabelLength {
        /// Fixed length.
        case fixed(CGFloat)

        /// Container relative length, expressed as percentage (ratio).
        case relative(CGFloat)
    }

    /// The length of the label.
    let labelLength: LabelLength

    /// Creates an inspector style with the given label length.
    ///
    /// - Parameter labelLength: The length of the label.
    ///
    /// - Note: The default value is `.relative(0.3)`.
    public init(labelLength: LabelLength = .relative(0.3)) {
        self.labelLength = labelLength
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.subheadline)
                .containerRelativeFrame(.horizontal, alignment: .leading) { length, axis in
                    switch labelLength {
                    case .fixed(let length):
                        return length
                    case .relative(let ratio):
                        return length * ratio
                    }
                }

            configuration.content
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

// MARK: - Xcode Previews

#Preview("Inspector Group", traits: .defaultLayout) {

    @Previewable @State
    var translation: (x: Double, y: Double, z: Double) = (.zero, .zero, .zero)

    @Previewable @State
    var rotation: (x: Angle, y: Angle, z: Angle) = (.zero, .zero, .zero)

    @Previewable @State
    var anchor: (x: Double, y: Double, z: Double) = (0.5, 0.5, 0.5)

    @Previewable @State
    var scale: (width: Double, height: Double, depth: Double) = (1.0, 1.0, 1.0)

    @Previewable @State
    var perspective: Double = 0.25

    VStack {
        #if os(watchOS)
        Text("Preview unavailable for watchOS.")
        #else
        GroupBox("Transform") {
            VStack {
                LabeledContent("Perspective") {
                    Slider(value: $perspective, in: 0...1)
                }
                LabeledContent("Δz") {
                    Slider(value: $translation.z, in: 0...1)
                }
                LabeledContent("Pitch") {
                    Slider(value: $rotation.x.degrees, in: -180...180)
                }
                LabeledContent("Yaw") {
                    Slider(value: $rotation.y.degrees, in: -180...180)
                }
                LabeledContent("Roll") {
                    Slider(value: $rotation.z.degrees, in: -180...180)
                }
            }
        }

        GroupBox {
            Button {
                perspective = 0.25
                translation = (.zero, .zero, .zero)
                rotation = (.zero, .zero, .zero)
                anchor = (0.5, 0.5, 0.5)
                scale = (1.0, 1.0, 1.0)
            } label: {
                Text("Reset")
                    .frame(maxWidth: .infinity)
                    .font(.body.weight(.semibold))
            }
        }
        #endif
    }
    .labeledContentStyle(.inspector)
    .padding()
}
