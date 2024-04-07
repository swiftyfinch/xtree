final class TreeNode {
    struct Stats {
        let height: Int
        let explicitChildrenCount: Int
        let childrenCount: Int
    }

    let name: String
    let info: String?
    let explicitChildren: [TreeNode]
    let children: Set<TreeNode>
    let stats: Stats

    init(
        name: String,
        info: String?,
        explicitChildren: [TreeNode] = [],
        children: Set<TreeNode> = [],
        stats: Stats
    ) {
        self.name = name
        self.info = info
        self.explicitChildren = explicitChildren
        self.children = children
        self.stats = stats
    }
}

extension TreeNode: Hashable {
    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension TreeNode: Comparable {
    static func < (lhs: TreeNode, rhs: TreeNode) -> Bool {
        lhs.name < rhs.name
    }
}

extension [TreeNode] {
    func recursiveChildren() -> Set<TreeNode> {
        Set(flatMap(\.children)).union(self)
    }

    func maxHeight() -> Int {
        map(\.stats.height).max().map { $0 + 1 } ?? 0
    }
}
