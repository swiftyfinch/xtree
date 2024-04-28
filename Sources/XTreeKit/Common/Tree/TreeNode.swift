public final class TreeNode {
    public struct Stats {
        public let height: Int
        public let explicitChildrenCount: Int
        public let childrenCount: Int
    }

    public struct Icon {
        public let sfSymbol: String
        public let primaryColor: UInt
        public let secondaryColor: UInt?
    }

    public let icon: Icon?
    public let name: String
    public let info: String?
    public let explicitChildren: [TreeNode]
    public let children: Set<TreeNode>
    public let stats: Stats

    init(
        icon: Icon?,
        name: String,
        info: String?,
        explicitChildren: [TreeNode] = [],
        children: Set<TreeNode> = [],
        stats: Stats
    ) {
        self.icon = icon
        self.name = name
        self.info = info
        self.explicitChildren = explicitChildren
        self.children = children
        self.stats = stats
    }
}

extension TreeNode: Equatable {
    public static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        lhs.name == rhs.name
    }
}

extension TreeNode: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
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
