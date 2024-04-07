import Foundation

enum Terminal {
    static func columns() -> Int? {
        var windowSize = winsize()
        guard ioctl(1, UInt(TIOCGWINSZ), &windowSize) == 0 else { return nil }
        return Int(windowSize.ws_col)
    }
}
