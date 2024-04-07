import Rainbow

final class TreePrinter {
    private let labelStyle: ColorType = .named(.accent)
    private let arrowsStyle: ColorType = .named(.accent)
    private let inMiddle = "├─"
    private let leaf = "╰─"
    private let pipe = "│"

    func print(
        _ tree: TreeNode,
        height: Int = 0,
        last: Bool = false,
        prefix: String = ""
    ) -> String {
        var output: [String] = []
        for (index, child) in tree.explicitChildren.enumerated() {
            var prefix = prefix
            if height > 0 { prefix += last ? "   " : "\(pipe)  " }
            let childOutput = print(
                child,
                height: height + 1,
                last: index + 1 == tree.explicitChildren.count,
                prefix: prefix
            )
            output.append(childOutput)
        }
        let label = tree.name.applyingCodes(labelStyle)
        let stats = tree.formatStats()
        let arrow = (height == 0) ? "" : (last ? "\(leaf) " : "\(inMiddle) ")
        output.insert((prefix + arrow).applyingCodes(arrowsStyle) + "\(label)\(stats)", at: 0)
        return output.joined(separator: "\n")
    }
}

private extension TreeNode {
    func formatStats() -> String {
        var groups: [String] = []

        var countComponents: [String] = []
        if stats.explicitChildrenCount != 0 {
            countComponents.append(String(stats.explicitChildrenCount))
        }
        if stats.explicitChildrenCount != stats.childrenCount {
            countComponents.append(String(stats.childrenCount))
        }
        if !countComponents.isEmpty {
            groups.append("\(stats.height):\(countComponents.joined(separator: "/"))".secondary)
        }

        if let info {
            groups.append(info.tertiary)
        }

        let output = groups.joined(separator: " ")
        return output.isEmpty ? "" : " \(output)"
    }
}
