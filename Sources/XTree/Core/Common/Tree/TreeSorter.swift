final class TreeSorter {
    func sorted(_ trees: [TreeNode], type: Sort) -> [TreeNode] {
        switch type {
        case .name:
            return trees.sorted()
        case .children:
            return trees.sorted { $0.stats.childrenCount > $1.stats.childrenCount }
        case .height:
            return trees.sorted { $0.stats.height > $1.stats.height }
        }
    }
}
