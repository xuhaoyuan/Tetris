import UIKit

public struct KeyboardInfoValue {
    public let frameBegin: CGRect
    public let frameEnd: CGRect
    public let animationDuration: TimeInterval
    public let animationCurve: UInt
    public let isLocal: Bool
}

public extension KeyboardInfoValue {
    static let defaultValue = KeyboardInfoValue(frameBegin: .zero, frameEnd: .zero, animationDuration: 0.3, animationCurve: 13, isLocal: true)
}

public enum KeyboardAction {
    public typealias RawValue = NSNotification.Name
    case willShow
    case didShow
    case willHide
    case didHide
    case willChangeFrame
    case didChangeFrame

    var rawValue: NSNotification.Name {
        switch self {
        case .willShow:
            return UIResponder.keyboardWillShowNotification
        case .didShow:
            return UIResponder.keyboardDidShowNotification
        case .willHide:
            return UIResponder.keyboardWillHideNotification
        case .didHide:
            return UIResponder.keyboardDidHideNotification
        case .willChangeFrame:
            return UIResponder.keyboardWillChangeFrameNotification
        case .didChangeFrame:
            return UIResponder.keyboardDidChangeFrameNotification
        }
    }
}

extension NotificationCenter {

    public static func keyboardObserver(forName name: KeyboardAction, queue: OperationQueue = .main, using block: @escaping (KeyboardInfoValue) -> Void) -> NSObjectProtocol {
        return self.default.addObserver(forName: name.rawValue, object: nil, queue: queue) { noti in
            guard let info = noti.userInfo else { return }
            let beginUser = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
            let endUser = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            let curve = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
            let isLocal = (info[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue
            let defaultRect = CGRect(x: 0, y: UIScreen.main.bounds.height,
                                     width: UIScreen.main.bounds.width, height: 0)
            let keyboardInfo = KeyboardInfoValue(
                frameBegin: beginUser ?? defaultRect,
                frameEnd: endUser ?? defaultRect,
                animationDuration: duration ?? 0,
                animationCurve: curve ?? 0,
                isLocal: isLocal ?? false)
            block(keyboardInfo)
        }
    }
}
