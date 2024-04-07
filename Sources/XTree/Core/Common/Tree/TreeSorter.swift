final class TreeSorter {
    func sorted(_ trees: [TreeNode], type: Sort) -> [TreeNode] {
        switch type {
        case .name:
            return trees.sorted { $0.name < $1.name }
        case .children:
            return trees.sorted { ($0.stats.childrenCount, $1.name) > ($1.stats.childrenCount, $0.name) }
        case .height:
            return trees.sorted { ($0.stats.height, $1.name) > ($1.stats.height, $0.name) }
        }
    }
}
