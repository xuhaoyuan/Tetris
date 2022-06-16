import UIKit

extension UIStackView {

    convenience public init(subviews: [UIView] = [], axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) {
        self.init(arrangedSubviews: subviews)
        self.alignment = alignment
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
}
