import UIKit

open class XEdgeLabel: UILabel {
    open var textInset = UIEdgeInsets.zero

    public init(inset: UIEdgeInsets) {
        self.textInset = inset
        super.init(frame: .zero)
    }

    required public init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
    }

    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds.inset(by: textInset), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= textInset.left
        rect.origin.y -= textInset.top
        rect.size.width += textInset.left + textInset.right
        rect.size.height += textInset.top + textInset.bottom
        return rect
    }

    override open func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInset))
    }
}
