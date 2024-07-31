//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// Extension providing `Animatable` support for several SIMD types.
//

import SwiftUI
import simd

/// Animatable conformance.
extension SIMD2<Double>: @retroactive Animatable {

    public typealias AnimatableData = AnimatablePair<Double, Double>

    public var animatableData: AnimatableData {
        get { AnimatablePair(x, y) }
        set {
            x = newValue.first
            y = newValue.second
        }
    }
}

/// Animatable conformance.
extension SIMD3<Double>: @retroactive Animatable {

    public typealias AnimatableData = AnimatablePair<Double, AnimatablePair<Double, Double>>

    public var animatableData: AnimatableData {
        get { AnimatablePair(x, AnimatablePair(y, z)) }
        set {
            x = newValue.first
            y = newValue.second.first
            z = newValue.second.second
        }
    }
}

/// Animatable conformance.
extension SIMD4<Double>: @retroactive Animatable {

    public typealias AnimatableData = AnimatablePair<Double, AnimatablePair<Double, AnimatablePair<Double, Double>>>

    public var animatableData: AnimatableData {
        get { AnimatablePair(x, AnimatablePair(y, AnimatablePair(z, w))) }
        set {
            x = newValue.first
            y = newValue.second.first
            z = newValue.second.second.first
            w = newValue.second.second.second
        }
    }
}

/// Animatable conformance.
extension simd_quatd: @retroactive Animatable {

    public typealias AnimatableData = SIMD4<Double>.AnimatableData

    public var animatableData: AnimatableData {
        get { vector.animatableData }
        set { vector.animatableData = newValue }
    }
}
