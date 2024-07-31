//
// See the LICENSE file for this sample’s licensing information.
//
// Abstract:
//
// A generic application glyph.
//

import SwiftUI

extension Shape where Self == AppFigure {

    /// A generic application glyph.
    @MainActor public static var appFigure: Self { Self() }
}

/// A generic application glyph.
///
/// The shape is centered in the frame of the view containing it.
public struct AppFigure: Shape {

    public nonisolated func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        let sanitizedSize = proposal.replacingUnspecifiedDimensions(by: .zero)
        let smallestSide = min(sanitizedSize.width, sanitizedSize.height)

        return CGSize(width: smallestSide, height: smallestSide)
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.48732 * width, y: 0.19898 * height))
        path.addLine(to: CGPoint(x: 0.63547 * width, y: 0.45579 * height))
        path.addCurve(
            to: CGPoint(x: 0.63631 * width, y: 0.45628 * height),
            control1: CGPoint(x: 0.63564 * width, y: 0.45609 * height),
            control2: CGPoint(x: 0.63596 * width, y: 0.45628 * height)
        )
        path.addLine(to: CGPoint(x: 0.76996 * width, y: 0.45628 * height))
        path.addLine(to: CGPoint(x: 0.76996 * width, y: 0.45628 * height))
        path.addCurve(
            to: CGPoint(x: 0.7965 * width, y: 0.46297 * height),
            control1: CGPoint(x: 0.77989 * width, y: 0.45628 * height),
            control2: CGPoint(x: 0.7889 * width, y: 0.45867 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.8146 * width, y: 0.48107 * height),
            control1: CGPoint(x: 0.80411 * width, y: 0.46727 * height),
            control2: CGPoint(x: 0.8103 * width, y: 0.47346 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.82128 * width, y: 0.50655 * height),
            control1: CGPoint(x: 0.81874 * width, y: 0.4884 * height),
            control2: CGPoint(x: 0.82112 * width, y: 0.49704 * height)
        )
        path.addLine(to: CGPoint(x: 0.82129 * width, y: 0.50761 * height))
        path.addCurve(
            to: CGPoint(x: 0.8146 * width, y: 0.53415 * height),
            control1: CGPoint(x: 0.82129 * width, y: 0.51753 * height),
            control2: CGPoint(x: 0.8189 * width, y: 0.52654 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.7965 * width, y: 0.55225 * height),
            control1: CGPoint(x: 0.8103 * width, y: 0.54175 * height),
            control2: CGPoint(x: 0.80411 * width, y: 0.54795 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.76996 * width, y: 0.55894 * height),
            control1: CGPoint(x: 0.7889 * width, y: 0.55654 * height),
            control2: CGPoint(x: 0.77989 * width, y: 0.55894 * height)
        )
        path.addLine(to: CGPoint(x: 0.69683 * width, y: 0.55894 * height))
        path.addCurve(
            to: CGPoint(x: 0.69585 * width, y: 0.55991 * height),
            control1: CGPoint(x: 0.69629 * width, y: 0.55894 * height),
            control2: CGPoint(x: 0.69585 * width, y: 0.55937 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.69598 * width, y: 0.5604 * height),
            control1: CGPoint(x: 0.69585 * width, y: 0.56008 * height),
            control2: CGPoint(x: 0.6959 * width, y: 0.56025 * height)
        )
        path.addLine(to: CGPoint(x: 0.74693 * width, y: 0.64863 * height))
        path.addLine(to: CGPoint(x: 0.74693 * width, y: 0.64863 * height))
        path.addCurve(
            to: CGPoint(x: 0.7544 * width, y: 0.67496 * height),
            control1: CGPoint(x: 0.75189 * width, y: 0.65723 * height),
            control2: CGPoint(x: 0.75432 * width, y: 0.66623 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.74777 * width, y: 0.69969 * height),
            control1: CGPoint(x: 0.75448 * width, y: 0.6837 * height),
            control2: CGPoint(x: 0.75221 * width, y: 0.69216 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.72908 * width, y: 0.71819 * height),
            control1: CGPoint(x: 0.7435 * width, y: 0.70693 * height),
            control2: CGPoint(x: 0.73722 * width, y: 0.7133 * height)
        )
        path.addLine(to: CGPoint(x: 0.72814 * width, y: 0.71875 * height))
        path.addCurve(
            to: CGPoint(x: 0.70181 * width, y: 0.72623 * height),
            control1: CGPoint(x: 0.71954 * width, y: 0.72371 * height),
            control2: CGPoint(x: 0.71054 * width, y: 0.72614 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.67708 * width, y: 0.7196 * height),
            control1: CGPoint(x: 0.69307 * width, y: 0.72631 * height),
            control2: CGPoint(x: 0.68461 * width, y: 0.72404 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.65802 * width, y: 0.69996 * height),
            control1: CGPoint(x: 0.66956 * width, y: 0.71516 * height),
            control2: CGPoint(x: 0.66298 * width, y: 0.70856 * height)
        )
        path.addLine(to: CGPoint(x: 0.51733 * width, y: 0.45628 * height))
        path.move(to: CGPoint(x: 0.50187 * width, y: 0.55894 * height))
        path.addLine(to: CGPoint(x: 0.24469 * width, y: 0.55894 * height))
        path.move(to: CGPoint(x: 0.20253 * width, y: 0.63197 * height))
        path.addCurve(
            to: CGPoint(x: 0.16328 * width, y: 0.69996 * height),
            control1: CGPoint(x: 0.19288 * width, y: 0.64868 * height),
            control2: CGPoint(x: 0.1798 * width, y: 0.67134 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.14421 * width, y: 0.7196 * height),
            control1: CGPoint(x: 0.15831 * width, y: 0.70856 * height),
            control2: CGPoint(x: 0.15173 * width, y: 0.71516 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.11949 * width, y: 0.72624 * height),
            control1: CGPoint(x: 0.13669 * width, y: 0.72404 * height),
            control2: CGPoint(x: 0.12822 * width, y: 0.72631 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.09316 * width, y: 0.71875 * height),
            control1: CGPoint(x: 0.11075 * width, y: 0.72614 * height),
            control2: CGPoint(x: 0.10175 * width, y: 0.72371 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.07352 * width, y: 0.69969 * height),
            control1: CGPoint(x: 0.08456 * width, y: 0.71379 * height),
            control2: CGPoint(x: 0.07796 * width, y: 0.70721 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.06689 * width, y: 0.67496 * height),
            control1: CGPoint(x: 0.06908 * width, y: 0.69216 * height),
            control2: CGPoint(x: 0.06681 * width, y: 0.6837 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.07437 * width, y: 0.64863 * height),
            control1: CGPoint(x: 0.06697 * width, y: 0.66623 * height),
            control2: CGPoint(x: 0.06941 * width, y: 0.65723 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.10633 * width, y: 0.59327 * height),
            control1: CGPoint(x: 0.08773 * width, y: 0.62549 * height),
            control2: CGPoint(x: 0.09838 * width, y: 0.60704 * height)
        )
        path.move(to: CGPoint(x: 0.24469 * width, y: 0.55894 * height))
        path.addLine(to: CGPoint(x: 0.05133 * width, y: 0.55894 * height))
        path.addCurve(
            to: CGPoint(x: 0.02479 * width, y: 0.55225 * height),
            control1: CGPoint(x: 0.04141 * width, y: 0.55894 * height),
            control2: CGPoint(x: 0.0324 * width, y: 0.55654 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.00669 * width, y: 0.53415 * height),
            control1: CGPoint(x: 0.01719 * width, y: 0.54795 * height),
            control2: CGPoint(x: 0.01099 * width, y: 0.54175 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0, y: 0.50761 * height),
            control1: CGPoint(x: 0.0024 * width, y: 0.52654 * height),
            control2: CGPoint(x: 0, y: 0.51753 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.00669 * width, y: 0.48107 * height),
            control1: CGPoint(x: 0, y: 0.49768 * height),
            control2: CGPoint(x: 0.0024 * width, y: 0.48867 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.02479 * width, y: 0.46297 * height),
            control1: CGPoint(x: 0.01099 * width, y: 0.47346 * height),
            control2: CGPoint(x: 0.01719 * width, y: 0.46727 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.05133 * width, y: 0.45628 * height),
            control1: CGPoint(x: 0.0324 * width, y: 0.45867 * height),
            control2: CGPoint(x: 0.04141 * width, y: 0.45628 * height)
        )
        path.addLine(to: CGPoint(x: 0.18486 * width, y: 0.45628 * height))
        path.addCurve(
            to: CGPoint(x: 0.18571 * width, y: 0.45579 * height),
            control1: CGPoint(x: 0.18521 * width, y: 0.45628 * height),
            control2: CGPoint(x: 0.18553 * width, y: 0.45609 * height)
        )
        path.addLine(to: CGPoint(x: 0.35109 * width, y: 0.16933 * height))
        path.addCurve(
            to: CGPoint(x: 0.35109 * width, y: 0.16835 * height),
            control1: CGPoint(x: 0.35127 * width, y: 0.16903 * height),
            control2: CGPoint(x: 0.35127 * width, y: 0.16866 * height)
        )
        path.addLine(to: CGPoint(x: 0.2987 * width, y: 0.07761 * height))
        path.addLine(to: CGPoint(x: 0.2987 * width, y: 0.07761 * height))
        path.addCurve(
            to: CGPoint(x: 0.29123 * width, y: 0.05128 * height),
            control1: CGPoint(x: 0.29374 * width, y: 0.06902 * height),
            control2: CGPoint(x: 0.29131 * width, y: 0.06001 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.29785 * width, y: 0.02656 * height),
            control1: CGPoint(x: 0.29115 * width, y: 0.04255 * height),
            control2: CGPoint(x: 0.29342 * width, y: 0.03408 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.31749 * width, y: 0.00749 * height),
            control1: CGPoint(x: 0.30229 * width, y: 0.01903 * height),
            control2: CGPoint(x: 0.3089 * width, y: 0.01245 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.34382 * width, y: 0),
            control1: CGPoint(x: 0.32608 * width, y: 0.00253 * height),
            control2: CGPoint(x: 0.33509 * width, y: 0.0001 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.36854 * width, y: 0.00664 * height),
            control1: CGPoint(x: 0.35255 * width, y: -0.00006 * height),
            control2: CGPoint(x: 0.36102 * width, y: 0.0022 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.38761 * width, y: 0.02628 * height),
            control1: CGPoint(x: 0.37607 * width, y: 0.01108 * height),
            control2: CGPoint(x: 0.38265 * width, y: 0.01769 * height)
        )
        path.addLine(to: CGPoint(x: 0.4098 * width, y: 0.06472 * height))
        path.addCurve(
            to: CGPoint(x: 0.41113 * width, y: 0.06507 * height),
            control1: CGPoint(x: 0.41007 * width, y: 0.06518 * height),
            control2: CGPoint(x: 0.41067 * width, y: 0.06534 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.41149 * width, y: 0.06472 * height),
            control1: CGPoint(x: 0.41128 * width, y: 0.06499 * height),
            control2: CGPoint(x: 0.4114 * width, y: 0.06486 * height)
        )
        path.addLine(to: CGPoint(x: 0.43368 * width, y: 0.02628 * height))
        path.addLine(to: CGPoint(x: 0.43368 * width, y: 0.02628 * height))
        path.addCurve(
            to: CGPoint(x: 0.45275 * width, y: 0.00664 * height),
            control1: CGPoint(x: 0.43864 * width, y: 0.01769 * height),
            control2: CGPoint(x: 0.44523 * width, y: 0.01108 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.47747 * width, y: 0),
            control1: CGPoint(x: 0.46027 * width, y: 0.0022 * height),
            control2: CGPoint(x: 0.46874 * width, y: -0.00006 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.50285 * width, y: 0.00695 * height),
            control1: CGPoint(x: 0.48588 * width, y: 0.0001 * height),
            control2: CGPoint(x: 0.49454 * width, y: 0.00235 * height)
        )
        path.addLine(to: CGPoint(x: 0.5038 * width, y: 0.00749 * height))
        path.addCurve(
            to: CGPoint(x: 0.52344 * width, y: 0.02656 * height),
            control1: CGPoint(x: 0.5124 * width, y: 0.01245 * height),
            control2: CGPoint(x: 0.519 * width, y: 0.01903 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.53008 * width, y: 0.05128 * height),
            control1: CGPoint(x: 0.52788 * width, y: 0.03408 * height),
            control2: CGPoint(x: 0.53015 * width, y: 0.04255 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.52259 * width, y: 0.07761 * height),
            control1: CGPoint(x: 0.52998 * width, y: 0.06001 * height),
            control2: CGPoint(x: 0.52755 * width, y: 0.06902 * height)
        )
        path.addLine(to: CGPoint(x: 0.41065 * width, y: 0.2715 * height))
        path.move(to: CGPoint(x: 0.41065 * width, y: 0.2715 * height))
        path.addLine(to: CGPoint(x: 0.30481 * width, y: 0.45481 * height))
        path.addCurve(
            to: CGPoint(x: 0.30517 * width, y: 0.45614 * height),
            control1: CGPoint(x: 0.30454 * width, y: 0.45528 * height),
            control2: CGPoint(x: 0.3047 * width, y: 0.45587 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.30566 * width, y: 0.45628 * height),
            control1: CGPoint(x: 0.30532 * width, y: 0.45623 * height),
            control2: CGPoint(x: 0.30549 * width, y: 0.45628 * height)
        )
        path.addLine(to: CGPoint(x: 0.47132 * width, y: 0.45628 * height))
        path.addLine(to: CGPoint(x: 0.47132 * width, y: 0.45628 * height))
        path.move(to: CGPoint(x: 0.51733 * width, y: 0.45628 * height))
        path.addLine(to: CGPoint(x: 0.43634 * width, y: 0.316 * height))

        let boundingRect = path.boundingRect
        let lineWidth = boundingRect.height * 0.025
        let dX = rect.center.x - boundingRect.width / 2
        let dY = rect.center.y - boundingRect.height / 2
        let translation = CGAffineTransform(translationX: dX, y: dY)
        let strokeStyle = StrokeStyle(lineWidth: lineWidth, lineCap: .round)

        return
            path
            .transform(translation)
            .stroke(style: strokeStyle)
            .path(in: rect)
    }
}

// MARK: - Xcode Previews

#Preview("AppFigure Shape") {
    AppFigure()
}

#Preview("AppFigure Blueprint") {
    Blueprint(.appFigure)
        .foregroundStyle(.blue.gradient, .white)
        .padding()
}
