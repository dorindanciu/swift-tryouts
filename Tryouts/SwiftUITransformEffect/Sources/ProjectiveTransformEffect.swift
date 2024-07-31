//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// A 3D projective transformation effect.
//

internal import PreviewSupport
import SwiftUI
import simd

/// A 3D projective transformation effect.
public struct ProjectiveTransformEffect {

    /// The transform component of the projective transformation effect.
    public var transform: Transform

    /// The anchor component of the projective transformation effect.
    public var anchor: UnitPoint3D

    /// The perspective component of the projective transformation effect.
    public var perspective: Double

    /// Creates a projective transformation effect from the specified components.
    /// - Parameters:
    ///   - transform: A transform structure that defines the scale, rotation, and translation of an effect. Defaults to `.identity`.
    ///   - anchor: A point structure that specifies the anchor point. Defaults to`[0.5, 0.5, 0.0]`
    ///   - perspective: A double value that specifies the perspective over z axis. Defaults to `1`.
    public init(
        transform: Transform = .identity,
        anchor: UnitPoint3D = .front,
        perspective: Double = 1
    ) {
        self.transform = transform
        self.anchor = anchor
        self.perspective = perspective
    }
}

/// Sendable conformance.
extension ProjectiveTransformEffect: Sendable {}

/// Hashable conformance.
extension ProjectiveTransformEffect: Hashable {}

/// Equatable conformance.
extension ProjectiveTransformEffect: Equatable {}

/// Convenience functions.
extension ProjectiveTransformEffect {

    /// The transform represented as a 4x4 double-precision matrix for the given view size.
    /// - Parameter size: Structure representing the view size.
    public func matrixValue(size: CGSize) -> simd_double4x4 {
        let anchorOffset = anchorOffsetMatrix(size: size)
        let perspective = perspectiveMatrix(size: size)
        let translation = translationMatrix(size: size)
        let rotation = rotationMatrix(size: size)
        let scale = scaleMatrix(size: size)

        // Start with identity matrix.
        var matrix = simd_double4x4(1)

        // Apply perspective transform.
        matrix *= perspective

        // Apply translation transform.
        matrix *= translation

        // Rotate and scale around anchor point.
        matrix = anchorOffset * matrix

        // Apply rotation transform.
        matrix *= rotation

        // Apply scale transform.
        matrix *= scale

        // Reset anchor point.
        matrix *= anchorOffset.inverse

        return matrix
    }

    private func perspectiveMatrix(size: CGSize) -> simd_double4x4 {
        let z = -perspective / max(max(size.width, size.height), 1)
        return matrix4x4(perspective: vector3(.zero, z))
    }

    private func anchorOffsetMatrix(size: CGSize) -> simd_double4x4 {
        let projectedPoint = anchor.vector * vector3(size.width, size.height, 1)
        return matrix4x4(translation: projectedPoint)
    }

    private func translationMatrix(size: CGSize) -> simd_double4x4 {
        matrix4x4(translation: transform.translation)
    }

    private func rotationMatrix(size: CGSize) -> simd_double4x4 {
        matrix4x4(rotation: transform.rotation)
    }

    private func scaleMatrix(size: CGSize) -> simd_double4x4 {
        matrix4x4(scale: transform.scale)
    }
}

/// Type properties.
extension ProjectiveTransformEffect {

    /// Renders a view’s content as if it’s rotated in three dimensions around the specified axis.
    /// - Parameters:
    ///   - angle: The angle by which to rotate the view’s content.
    ///   - axis: The axis of rotation, specified as a tuple with named elements for each of the three spatial dimensions.
    ///   - anchor: A two dimensional unit point within the view about which to perform the rotation. The default value is UnitPoint/center.
    ///   - anchorZ: The location on the z-axis around which to rotate the content. The default is 0.
    ///   - perspective: The relative vanishing point for the rotation. The default is 1.
    public static func perspectiveRotation(
        _ angle: Angle,
        axis: (x: CGFloat, y: CGFloat, z: CGFloat),
        anchor: UnitPoint = .center,
        anchorZ: CGFloat = 0,
        perspective: CGFloat = 1
    ) -> Self {
        Self(
            transform: .init(angle: angle, axis: vector3(axis.x, axis.y, axis.z)),
            anchor: .init(xy: anchor, z: anchorZ),
            perspective: perspective
        )
    }
}

/// Animatable conformance.
extension ProjectiveTransformEffect: Animatable {
    public typealias AnimatableData = AnimatablePair<
        Transform.AnimatableData, AnimatablePair<UnitPoint3D.AnimatableData, Double>
    >

    public var animatableData: AnimatableData {
        get {
            .init(transform.animatableData, .init(anchor.animatableData, perspective))
        }
        set {
            transform.animatableData = newValue.first
            anchor.animatableData = newValue.second.first
            perspective.animatableData = newValue.second.second
        }
    }
}

/// GeometryEffect conformance.
extension ProjectiveTransformEffect: GeometryEffect {
    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(matrixValue(size: size))
    }
}

// MARK: - Xcode Previews

#Preview("ProjectiveEffect Editor") {

    @Previewable @State
    var angle: Angle = .zero

    @Previewable @State
    var axis: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 1, 0)

    @Previewable @State
    var anchor: (x: CGFloat, y: CGFloat, z: CGFloat) = (0.5, 0.5, 0.0)

    @Previewable @State
    var perspective: Double = 0.25

    VStack {

        Spacer()

        HStack {
            Blueprint(.appFigure)
                .foregroundStyle(.blue.gradient, .white)
                .scaledToFit()
                .rotation3DEffect(
                    angle,
                    axis: axis,
                    anchor: UnitPoint(x: anchor.x, y: anchor.y),
                    anchorZ: anchor.z,
                    perspective: perspective
                )

            Blueprint(.appFigure)
                .foregroundStyle(.yellow.gradient, .gray)
                .scaledToFit()
                .modifier(
                    ProjectiveTransformEffect.perspectiveRotation(
                        angle,
                        axis: axis,
                        anchor: UnitPoint(x: anchor.x, y: anchor.y),
                        anchorZ: anchor.z,
                        perspective: perspective
                    )
                )
        }
        .padding()

        Spacer()

        VStack {
            GroupBox("Rotation3D") {
                LabeledContent("Angle") {
                    Slider(value: $angle.degrees, in: -180...180)
                }

                LabeledContent("Anchor.x") {
                    Slider(value: $anchor.x, in: 0...1)
                }

                LabeledContent("Anchor.y") {
                    Slider(value: $anchor.y, in: 0...1)
                }

                LabeledContent("Anchor.z") {
                    Slider(value: $anchor.z, in: 0...1)
                }

                LabeledContent("Perspective") {
                    Slider(value: $perspective, in: 0...1)
                }
            }

            GroupBox {
                HStack {
                    Button("Randomize") {
                        withAnimation(.spring) {
                            angle.degrees = .random(in: -180...180)
                            anchor.x = .random(in: 0...1)
                            anchor.y = .random(in: 0...1)
                            anchor.z = .random(in: 0...1)
                            perspective = .random(in: 0...1)
                        }
                    }

                    Spacer()

                    Button("Reset") {
                        withAnimation(.spring) {
                            angle = .zero
                            axis = (0, 1, 0)
                            anchor = (0.5, 0.5, 0.0)
                            perspective = 0.25
                        }
                    }
                }
            }
        }
        .labeledContentStyle(.inspector)
        .padding()
    }
}
