import Foundation
import UIKit

extension UIView {
    @objc convenience init(color: UIColor, cornerRadius: CGFloat = 0) {
        self.init(frame: .zero)
        self.backgroundColor = color
        if cornerRadius > 0 {
            self.corner = cornerRadius
        }
    }
}

extension UIView {
    open func show(_ vc: UIViewController, sender: Any?) {
        vc.hidesBottomBarWhenPushed = true
        viewController?.show(vc, sender: sender)
    }
    
    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewController?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    public var viewController: UIViewController? {
        var next: UIResponder?
        next = self.next
        repeat {
            if let vc = next as? UIViewController {
                return vc
            } else {
                next = next?.next
            }
        } while next != nil
        return nil
    }
}

// MARK: 点击事件
extension UIView {
    @objc public func addTapGesture(handler: @escaping () -> Void) {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer {
            handler()
        }
        addGestureRecognizer(tap)
    }
}

extension UIView {
    public var corner: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    public var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    public func border(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    public func rectCorner(rect: UIRectCorner, corners: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: rect, cornerRadii: CGSize(width: corners, height: corners))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.frame = bounds
        layer.mask = maskLayer
    }
    
    public func screenShot() -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.prefersExtendedRange = true
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds, format: format)
        return renderer.image { context in
            context.cgContext.concatenate(CGAffineTransform.identity.scaledBy(x: 1, y: 1))
            layer.render(in: context.cgContext)
        }
    }
}
