final class ImpactManager {
    private let inputReader: InputReader
    private let treeManager: TreeManager

    init(inputReader: InputReader,
         treeManager: TreeManager) {
        self.inputReader = inputReader
        self.treeManager = treeManager
    }

    func print(
        inputPath: String,
        names: [String],
        filter: TreeFilterOptions,
        sort: Sort
    ) async throws {
        let nodesMap = try await inputReader.read(inputPath: inputPath)
        let affected = findAffectedNodes(by: names, nodesMap: nodesMap)
        if affected.isEmpty { return }

        var filter = filter
        filter.contains.append(contentsOf: affected)
        try treeManager.print(nodesMap: nodesMap, filter: filter, sort: sort)
    }

    private func findAffectedNodes(
        by names: [String],
        nodesMap: [String: Node]
    ) -> Set<String> {
        let parents: [String: [String]] = nodesMap.values.reduce(into: [:]) { parents, node in
            node.children.forEach { name in
                parents[name, default: []].append(node.name)
            }
        }

        var affected = Set(names)
        var queue = names
        while !queue.isEmpty {
            let first = queue.removeFirst()
            for node in parents[first] ?? [] {
                if affected.insert(node).inserted {
                    queue.append(node)
                }
            }
        }
        return affected
    }
}
