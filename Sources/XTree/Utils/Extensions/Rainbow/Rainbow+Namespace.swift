protocol RainbowNamespace {
    var string: String { get }
}

private struct RainbowWrapper: RainbowNamespace {
    let string: String
}

extension String {
    var rainbow: RainbowNamespace {
        RainbowWrapper(string: self)
    }
}
