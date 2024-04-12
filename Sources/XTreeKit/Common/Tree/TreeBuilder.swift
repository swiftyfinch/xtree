public enum Sort: String {
    case name
    case children
    case height
}

final class TreeBuilder {
    private let treeSorter: TreeSorter

    init(treeSorter: TreeSorter) {
        self.treeSorter = treeSorter
    }

    func build(
        from nodesMap: [String: Node],
        roots: [String],
        sort: Sort = .name
    ) -> [TreeNode] {
        var cache: [String: TreeNode] = [:]
        let forest = roots.compactMap { name in
            build(
                name: name,
                info: nodesMap[name]?.info,
                nodesMap: nodesMap,
                sort: sort,
                cache: &cache
            )
        }
        return treeSorter.sorted(forest, type: sort)
    }

    private func build(
        name: String,
        info: String?,
        nodesMap: [String: Node],
        sort: Sort,
        cache: inout [String: TreeNode]
    ) -> TreeNode? {
        if let existTreeNode = cache[name] { return existTreeNode }
        guard let node = nodesMap[name] else { return nil }

        let childrenNodes: [TreeNode] = node.children.compactMap { name in
            nodesMap[name].flatMap { child in
                build(
                    name: child.name,
                    info: child.info,
                    nodesMap: nodesMap,
                    sort: sort,
                    cache: &cache
                )
            }
        }
        let recursiveChildren = childrenNodes.recursiveChildren()
        let treeNode = TreeNode(
            name: name,
            info: info,
            explicitChildren: treeSorter.sorted(childrenNodes, type: sort),
            children: recursiveChildren,
            stats: TreeNode.Stats(
                height: childrenNodes.maxHeight(),
                explicitChildrenCount: childrenNodes.count,
                childrenCount: recursiveChildren.count
            )
        )
        cache[name] = treeNode
        return treeNode
    }
}
