// MARK: - Interface

public protocol IImpactManager: AnyObject {
    func print(
        inputPath: String,
        names: [String],
        filter: TreeFilterOptions,
        sort: Sort
    ) async throws -> TreeNode?
}

// MARK: - Implementation

final class ImpactManager {
    private let inputReader: InputReader
    private let regexBuilder: RegexBuilder
    private let treeManager: IInternalTreeManager

    init(inputReader: InputReader,
         regexBuilder: RegexBuilder,
         treeManager: IInternalTreeManager) {
        self.inputReader = inputReader
        self.regexBuilder = regexBuilder
        self.treeManager = treeManager
    }

    private func findAffectedNodes(
        by names: [String],
        nodesMap: [String: Node]
    ) throws -> Set<String> {
        let parents: [String: [String]] = nodesMap.values.reduce(into: [:]) { parents, node in
            node.children.forEach { name in
                parents[name, default: []].append(node.name)
            }
        }

        let namesRegex = try names.map(regexBuilder.build(wildcardsPattern:))
        let foundNames = nodesMap.keys.filter { name in
            namesRegex.contains(where: name.contains)
        }

        var affected = Set(foundNames)
        var queue = foundNames
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

// MARK: - IImpactManager

extension ImpactManager: IImpactManager {
    func print(
        inputPath: String,
        names: [String],
        filter: TreeFilterOptions,
        sort: Sort
    ) async throws -> TreeNode? {
        let nodesMap = try await inputReader.read(inputPath: inputPath)
        let affected = try findAffectedNodes(by: names, nodesMap: nodesMap)
        if affected.isEmpty { return nil }

        var filter = filter
        filter.contains.append(contentsOf: affected)
        return try treeManager.print(nodesMap: nodesMap, filter: filter, sort: sort)
    }
}
