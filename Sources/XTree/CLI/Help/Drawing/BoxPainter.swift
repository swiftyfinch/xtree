final class BoxPainter {
    private static let verticalBorder = "│".accent
    private let leftBorder = "\(verticalBorder) "
    private let rightBorder = " \(verticalBorder)"
    private let horizontalBorder = "─".accent
    private let topLeftCorner = "╭".accent
    private let topMiddleCross = "┬".accent
    private let topRightCorner = "╮".accent
    private let bottomLeftCorner = "╰".accent
    private let bottomMiddleCross = "┴".accent
    private let bottomRightCorner = "╯".accent

    func drawTable(_ lines: [(left: String, right: String)], terminalWidth: Int) -> String? {
        guard let leftWidth = lines.map(\.left.rainbow.rawCount).max() else { return nil }

        let terminalRight = terminalWidth - leftBorder.rainbow.rawCount - leftWidth - 1 - rightBorder.rainbow.rawCount
        let wrappedLines = wrapLines(lines: lines, terminalRight: terminalRight)
        guard let maxRightWidth = wrappedLines.flatMap(\.rights).map(\.rainbow.rawCount).max() else { return nil }
        let rightWidth = min(terminalRight, maxRightWidth)

        var output = ""
        let separator = " \(Self.verticalBorder) "
        output.append(makeTopBorder(leftWidth: leftWidth, rightWidth: rightWidth))
        output.append("\n")
        for (left, rights) in wrappedLines {
            output.append("\(leftBorder)\(left.rainbow.padding(size: leftWidth))")
            output.append(separator)
            for (index, line) in rights.enumerated() {
                let right = "\(line.rainbow.padding(size: rightWidth))\(rightBorder)\n"
                if index == 0 {
                    output.append(right)
                } else {
                    let leftPadding = "\(leftBorder)\(String(repeating: " ", count: leftWidth))\(separator)"
                    output.append("\(leftPadding)\(right)")
                }
            }
        }
        output.append(makeBottomBorder(leftWidth: leftWidth, rightWidth: rightWidth))
        return output
    }

    private func wrapLines(
        lines: [(left: String, right: String)],
        terminalRight: Int
    ) -> [(left: String, rights: [String])] {
        var wrappedLines: [(left: String, rights: [String])] = []
        for line in lines {
            let rightLines = line.right.rainbow.wordWrappedLines(width: terminalRight - 2).enumerated()
                .map { index, line in
                    guard !line.isEmpty else { return line }
                    let edittedLine = (index == 0) ? "\("*".accent) \(line)" : "  \(line)"
                    return edittedLine.hasSuffix(" ") ? String(edittedLine.dropLast()) : edittedLine
                }
            wrappedLines.append((line.left, rightLines))
        }
        return wrappedLines
    }

    private func makeTopBorder(leftWidth: Int, rightWidth: Int) -> String {
        let topLeftBorder = String(repeating: horizontalBorder, count: 1 + leftWidth + 1)
        let topRightBorder = String(repeating: horizontalBorder, count: 1 + rightWidth + 1)
        return "\(topLeftCorner)\(topLeftBorder)\(topMiddleCross)\(topRightBorder)\(topRightCorner)"
    }

    private func makeBottomBorder(leftWidth: Int, rightWidth: Int) -> String {
        let bottomLeftBorder = String(repeating: horizontalBorder, count: 1 + leftWidth + 1)
        let bottomRightBorder = String(repeating: horizontalBorder, count: 1 + rightWidth + 1)
        return "\(bottomLeftCorner)\(bottomLeftBorder)\(bottomMiddleCross)\(bottomRightBorder)\(bottomRightCorner)"
    }
}
