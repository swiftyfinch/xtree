import Foundation

// MARK: - Interface

public protocol ITerminal: AnyObject {
    func columns() -> Int?
}

// MARK: - Implementation

final class Terminal {}

// MARK: - ITerminal

extension Terminal: ITerminal {
    func columns() -> Int? {
        var windowSize = winsize()
        guard ioctl(1, UInt(TIOCGWINSZ), &windowSize) == 0 else { return nil }
        return Int(windowSize.ws_col)
    }
}
