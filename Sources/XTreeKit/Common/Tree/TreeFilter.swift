final class TreeFilter {
    func filter(
        _ tree: TreeNode,
        contains: [Regex<Substring>],
        except: [Regex<Substring>],
        exceptIcons: Set<String>,
        height: Int = 0,
        maxHeight: Int? = nil
    ) -> TreeNode? {
        if contains.isEmpty, except.isEmpty, exceptIcons.isEmpty, maxHeight == nil { return tree }
        if let maxHeight = maxHeight, height >= maxHeight { return nil }
        guard contains.isEmpty || contains.contains(where: tree.name.contains) else { return nil }
        guard except.isEmpty || !except.contains(where: tree.name.contains) else { return nil }
        guard !isIconExcept(tree.icon, exceptIcons: exceptIcons) else { return nil }

        let filteredExplicitChildren = tree.explicitChildren.compactMap {
            filter(
                $0,
                contains: contains,
                except: except,
                exceptIcons: exceptIcons,
                height: height + 1,
                maxHeight: maxHeight
            )
        }
        let children = filteredExplicitChildren.recursiveChildren()
        return TreeNode(
            icon: tree.icon,
            name: tree.name,
            info: tree.info,
            explicitChildren: filteredExplicitChildren,
            children: children,
            stats: TreeNode.Stats(
                height: tree.stats.height,
                explicitChildrenCount: filteredExplicitChildren.count,
                childrenCount: children.count
            )
        )
    }

    private func isIconExcept(_ icon: TreeNode.Icon?, exceptIcons: Set<String>) -> Bool {
        guard !exceptIcons.isEmpty, let icon else { return false }
        return exceptIcons.contains(icon.sfSymbol)
    }
}
