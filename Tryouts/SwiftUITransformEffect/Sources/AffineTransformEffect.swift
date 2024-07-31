//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// A 3D affine transformation effect.
//

internal import PreviewSupport
import SwiftUI
import simd

/// A 3D affine transformation effect.
public struct AffineTransformEffect {

    /// The transform component of the affine transformation effect.
    public var transform: Transform

    /// The anchor component of the projective transformation effect.
    public var anchor: UnitPoint3D

    /// Creates an affine transform effect.
    public init() {
        self.init(transform: .identity, anchor: .front)
    }

    /// Creates an affine transform effect from the specified scale, rotate, and translate transforms.
    /// - Parameters:
    ///   - scale: The scale factor given as a 3D vector. Defaults to one: `[1, 1, 1]`.
    ///   - rotation: The rotation given as a unit quaternion. Defaults to identity: `[0, 0, 0, 1]`.
    ///   - translation: The translation, or position along the x, y, and z axes. Defaults to zero: `[0, 0, 0]`.
    public init(
        scale: simd_double3 = vector3(1, 1, 1),
        rotation: simd_quatd = simd_quaternion(0, 0, 0, 1),
        translation: simd_double3 = vector3(0, 0, 0)
    ) {
        self.transform = Transform(scale: scale, rotation: rotation, translation: translation)
        self.anchor = .front
    }

    /// Creates an affine transform effect from the given components.
    /// - Parameters:
    ///   - transform: A transform structure that defines the scale, rotation, and translation of an effect. Defaults to `.identity`.
    ///   - anchor: A point structure that specifies the anchor point. Defaults to`[0.5, 0.5, 0.0]`
    public init(transform: Transform = .identity, anchor: UnitPoint3D = .front) {
        self.transform = transform
        self.anchor = anchor
    }
}

/// Sendable conformance.
extension AffineTransformEffect: Sendable {}

/// Hashable conformance.
extension AffineTransformEffect: Hashable {}

/// Equatable conformance.
extension AffineTransformEffect: Equatable {}

/// Convenience functions.
extension AffineTransformEffect {

    /// The transform represented as a 4x4 double-precision matrix for the given view size.
    /// - Parameter size: Structure representing the view size.
    public func matrixValue(size: CGSize) -> simd_double4x4 {
        let anchorOffset = anchorOffsetMatrix(size: size)
        let translation = translationMatrix(size: size)
        let rotation = rotationMatrix(size: size)
        let scale = scaleMatrix(size: size)

        // Start with identity matrix.
        var matrix = simd_double4x4(1)

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

/// Animatable conformance.
extension AffineTransformEffect: Animatable {
    public typealias AnimatableData = AnimatablePair<Transform.AnimatableData, UnitPoint3D.AnimatableData>

    public var animatableData: AnimatableData {
        get {
            AnimatablePair(
                transform.animatableData,
                anchor.animatableData
            )
        }
        set {
            transform.animatableData = newValue.first
            anchor.animatableData = newValue.second
        }
    }
}

/// GeometryEffect conformance.
extension AffineTransformEffect: GeometryEffect {
    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(matrixValue(size: size))
    }
}

// MARK: - Xcode Previews

#Preview("AffineTransform Editor") {

    @Previewable @State
    var angle: Angle = .zero

    @Previewable @State
    var anchor: UnitPoint = .center

    VStack {
        Spacer()

        HStack {
            Blueprint()
                .foregroundStyle(.blue.gradient, .white)
                .scaledToFit()
                .rotationEffect(angle, anchor: anchor)

            Blueprint()
                .foregroundStyle(.yellow.gradient, .gray)
                .scaledToFit()
                .modifier(
                    AffineTransformEffect(
                        transform: .init(angle: angle, axis: vector3(0, 0, 1)),
                        anchor: .init(xy: anchor, z: 1)
                    )
                )
        }
        .padding()

        Spacer()

        VStack {

            GroupBox("Rotation") {
                LabeledContent("Angle") {
                    Slider(value: $angle.degrees, in: -180...180)
                }
            }

            GroupBox("Anchor") {
                LabeledContent("Offset(x)") {
                    Slider(value: $anchor.x, in: 0...1)
                }

                LabeledContent("Offset(y)") {
                    Slider(value: $anchor.y, in: 0...1)
                }
            }

            GroupBox {
                HStack {
                    Button("Randomize") {
                        withAnimation(.snappy) {
                            angle.degrees = Double.random(in: -180...180)
                            anchor.x = CGFloat.random(in: 0...1)
                            anchor.y = CGFloat.random(in: 0...1)
                        }
                    }

                    Spacer()

                    Button("Reset") {
                        withAnimation(.snappy) {
                            angle = .zero
                            anchor = .center
                        }
                    }
                }
            }
        }
        .labeledContentStyle(.inspector)
        .padding()
    }
}
