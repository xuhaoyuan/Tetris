import Foundation

public typealias VoidHandler = () -> Void
public typealias SingleHandler<T> = (T) -> Void
public typealias DoubleHandler<F, S> = (F, S) -> Void
