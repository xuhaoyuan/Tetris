import Foundation

extension String {
    public func short(_ number: Int) -> String {
        if count > number {
            return prefix(number) + "..."
        } else {
            return self
        }
    }

    var isChinese: Bool {
        for value in self {
            guard ("\u{4E00}" <= value && value <= "\u{9FA5}") else { return false }
        }
        return true
    }
}

extension String {
    func QRCode() -> UIImage? {
        let data = self.data(using: String.Encoding.ascii)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 9, y: 9)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
        return UIImage(ciImage: output)
    }
}
