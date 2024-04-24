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
        sort: Sort = .name,
        needsCompress: Bool
    ) -> [TreeNode] {
        var cache: [String: TreeNode] = [:]
        let forest = roots.compactMap { name in
            build(
                name: name,
                info: nodesMap[name]?.info,
                nodesMap: nodesMap,
                sort: sort,
                needsCompress: needsCompress,
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
        needsCompress: Bool,
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
                    needsCompress: needsCompress,
                    cache: &cache
                )
            }
        }
        let modifiedChildren = needsCompress ? compress(childrenNodes) : childrenNodes
        let recursiveChildren = modifiedChildren.recursiveChildren()
        let treeNode = TreeNode(
            name: name,
            info: info,
            explicitChildren: treeSorter.sorted(modifiedChildren, type: sort),
            children: recursiveChildren,
            stats: TreeNode.Stats(
                height: modifiedChildren.maxHeight(),
                explicitChildrenCount: modifiedChildren.count,
                childrenCount: recursiveChildren.count
            )
        )
        cache[name] = treeNode
        return treeNode
    }

    private func compress(_ nodes: [TreeNode]) -> [TreeNode] {
        nodes.filter {
            for child in nodes where child != $0 {
                if child.children.contains($0) {
                    return false
                }
            }
            return true
        }
    }
}
