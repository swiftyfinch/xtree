import SwiftUI

extension Color {
    init(hex: UInt) {
        self.init(nsColor: NSColor(hex: hex))
    }
}
