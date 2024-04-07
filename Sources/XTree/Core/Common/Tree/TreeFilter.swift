final class TreeFilter {
    func filter(
        _ tree: TreeNode,
        contains: [Regex<Substring>],
        except: [Regex<Substring>],
        height: Int = 0,
        maxHeight: Int? = nil
    ) -> TreeNode? {
        if contains.isEmpty, except.isEmpty, maxHeight == nil { return tree }
        if let maxHeight = maxHeight, height >= maxHeight { return nil }
        guard contains.isEmpty || contains.contains(where: tree.name.contains) else { return nil }
        guard except.isEmpty || !except.contains(where: tree.name.contains) else { return nil }

        let filteredExplicitChildren = tree.explicitChildren.compactMap {
            filter(
                $0,
                contains: contains,
                except: except,
                height: height + 1,
                maxHeight: maxHeight
            )
        }
        return TreeNode(
            name: tree.name,
            info: tree.info,
            explicitChildren: filteredExplicitChildren,
            children: filteredExplicitChildren.recursiveChildren(),
            stats: tree.stats
        )
    }
}
