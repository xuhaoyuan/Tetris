import Foundation

public func currentTopViewController() -> UIViewController? {
    guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
        return nil
    }
    return enumCurrentViewController(rootVC)
}

private func enumCurrentViewController(_ fromVC: UIViewController) -> UIViewController {
    if let fromVC = fromVC.presentedViewController {
        return enumCurrentViewController(fromVC)
    }
    if let fromVC = fromVC as? UINavigationController,
       fromVC.viewControllers.count > 0 {
        return enumCurrentViewController(fromVC.topViewController!)
    }
    if let fromVC = fromVC as? UITabBarController,
       (fromVC.viewControllers ?? []).count > 0 {
        return enumCurrentViewController(fromVC.selectedViewController!)
    }
    return fromVC
}
