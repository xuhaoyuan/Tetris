import UIKit

public class XGradientView: UIView {

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        guard let layer = layer as? CAGradientLayer else { return }
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let layer = layer as? CAGradientLayer else { return }
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.masksToBounds = true
    }

    public func configure(startPoint: CGPoint = .init(x: 0, y: 0), endPoint: CGPoint = .init(x: 1.0, y: 0)) {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.startPoint = startPoint
        layer.endPoint = endPoint
    }

    public func configure(startPoint: CGPoint = .init(x: 0, y: 0), endPoint: CGPoint = .init(x: 1.0, y: 0), colors: [UIColor], cornerRadius: CGFloat) {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.colors = colors.map({ $0.cgColor })
        layer.cornerRadius = cornerRadius
    }
}
