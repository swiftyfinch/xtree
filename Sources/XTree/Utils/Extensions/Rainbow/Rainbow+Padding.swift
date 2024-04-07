extension RainbowNamespace {
    func padding(size: Int) -> String {
        guard rawCount < size else { return string }
        let remaining = size - rawCount
        return "\(string)\(String(repeating: " ", count: remaining))"
    }
}
