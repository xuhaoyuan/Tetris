import UIKit

@propertyWrapper
public struct AssociatedObject<T> {
    public var key: UnsafeRawPointer
    public var defaultValue: T
    public var wrappedValue: T {
        set {
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, key) as? T ?? defaultValue
        }
    }
    public init(key: UnsafeRawPointer, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
