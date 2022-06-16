import UIKit

public class XGradientLabel: UIView {

    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private(set) lazy var label: UILabel = UILabel()
    public var text: String? {
        set { label.text = newValue }
        get { return label.text }
    }

    public var font: UIFont! {
        set { label.font = newValue }
        get { return label.font }
    }

    public var textColor: UIColor! {
        set { label.textColor = newValue }
        get { return label.textColor }
    }

    public var textAlignment: NSTextAlignment {
        set { label.textAlignment = newValue }
        get { return label.textAlignment }
    }

    public var lineBreakMode: NSLineBreakMode {
        set { label.lineBreakMode = newValue }
        get { return label.lineBreakMode }
    }

    public var numberOfLines: Int {
        set { label.numberOfLines = newValue }
        get { return label.numberOfLines }
    }

    private var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        gradientLayer.colors = [UIColor(r: 252, g: 236, b: 214).cgColor,
                                UIColor(r: 216, g: 164, b: 134).cgColor]
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    public func set(beginColor: UIColor, endColor: UIColor) {
        gradientLayer.colors = [beginColor.cgColor, endColor.cgColor]
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.mask = label.layer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
