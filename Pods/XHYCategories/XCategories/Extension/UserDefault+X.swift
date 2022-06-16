import UIKit

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set {
            UserDefaults.standard.set(newValue, forKey: key) }
    }

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
