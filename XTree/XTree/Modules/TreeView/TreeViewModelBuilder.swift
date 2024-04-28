import Foundation
import XTreeKit

final class TreeViewModelBuilder {
    func buildAdjacentList(root: TreeNode, filterText: String) -> [String: TreeNodeContent] {
        var adjacentList: [String: TreeNodeContent] = [:]
        var visited: Set<String> = []
        collect(adjacentList: &adjacentList, beginWith: root, filter: filterText, visited: &visited)
        if adjacentList.isEmpty {
            adjacentList[root.name] = TreeNodeContent(
                icon: nil,
                title: formatTitle(root.name),
                stats: format(root.stats),
                details: root.info,
                children: []
            )
        }
        return adjacentList
    }

    @discardableResult
    private func collect(
        adjacentList: inout [String: TreeNodeContent],
        beginWith treeNode: TreeNode,
        filter filterText: String,
        visited: inout Set<String>
    ) -> Bool {
        guard adjacentList[treeNode.name] == nil else { return true }
        guard !visited.contains(treeNode.name) else { return false }

        var suitableChildren: [TreeNode] = []
        for child in treeNode.explicitChildren {
            if collect(adjacentList: &adjacentList, beginWith: child, filter: filterText, visited: &visited) {
                suitableChildren.append(child)
            }
        }

        let isSuitable = !suitableChildren.isEmpty || filterText.isEmpty || treeNode.name.contains(filterText)
        if isSuitable {
            adjacentList[treeNode.name] = TreeNodeContent(
                icon: treeNode.icon.map {
                    .init(sfSymbol: $0.sfSymbol,
                          primaryColor: $0.primaryColor,
                          secondaryColor: $0.secondaryColor)
                },
                title: formatTitle(treeNode.name),
                stats: format(treeNode.stats),
                details: treeNode.info,
                children: suitableChildren.map(\.name)
            )
        } else {
            visited.insert(treeNode.name)
        }
        return isSuitable
    }

    private func formatTitle(_ name: String) -> String {
        name == "." ? "🌳" : name
    }

    private func format(_ stats: TreeNode.Stats) -> String {
        var groups: [String] = []

        var countComponents: [String] = []
        if stats.explicitChildrenCount != 0 {
            countComponents.append(String(stats.explicitChildrenCount))
        }
        if stats.explicitChildrenCount != stats.childrenCount {
            countComponents.append(String(stats.childrenCount))
        }
        if !countComponents.isEmpty {
            groups.append("\(stats.height):\(countComponents.joined(separator: "/"))")
        }

        return groups.joined(separator: " ")
    }
}
