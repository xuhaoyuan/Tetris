extension Array {
    public subscript (safe index: Int?) -> Element? {
        guard let index = index else { return nil }
        return indices ~= index ? self[index] : nil
    }

    public func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, count)])
        }
    }
}
