final class TreeSorter {
    func sorted(_ forest: [TreeNode], type: Sort) -> [TreeNode] {
        switch type {
        case .name:
            return forest.sorted { $0.name < $1.name }
        case .children:
            return forest.sorted { ($0.stats.childrenCount, $1.name) > ($1.stats.childrenCount, $0.name) }
        case .height:
            return forest.sorted { ($0.stats.height, $1.name) > ($1.stats.height, $0.name) }
        }
    }
}
