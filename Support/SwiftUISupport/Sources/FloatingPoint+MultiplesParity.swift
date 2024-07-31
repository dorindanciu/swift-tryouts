//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// FloatingPoint extension providing support to check if the sender is
// an odd or even multiple of the given value.
//

extension FloatingPoint {

    /// Checks if the sender is an even multiple of the given value.
    /// - Parameter value: The value to check against.
    /// - Returns: `true` if the sender is an even multiple of the given value, `false` otherwise.
    @inlinable public func isEvenMultiple(of value: Self) -> Bool {
        return self.remainder(dividingBy: 2 * value) == 0
    }

    /// Checks if the sender is an odd multiple of the given value.
    /// - Parameter value: The value to check against.
    /// - Returns: `true` if the sender is an odd multiple of `value`, otherwise `false`.
    @inlinable public func isOddMultiple(of value: Self) -> Bool {
        let remainder = self.remainder(dividingBy: 2 * value)
        return abs(remainder) == value
    }
}
