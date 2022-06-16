extension Selector {
    /// Selectors can be used as unique `void *` keys, this gets that key.
    public var key: UnsafeRawPointer { return unsafeBitCast(self, to: UnsafeRawPointer.self) }
}

extension NSObject {
    public func getAssociatedValue(for key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }

    public func setAssociatedValue(_ value: Any?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
