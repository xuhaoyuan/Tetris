import Foundation

extension CALayer {
    public func image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
