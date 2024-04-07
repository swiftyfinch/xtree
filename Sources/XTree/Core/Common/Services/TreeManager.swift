import Fish

final class TreeManager {
    struct Filter {
        let roots: [String]
        let contains: [String]
        let except: [String]
        let maxHeight: Int?
    }

    private let inputReader: InputReader
    private let regexBuilder: RegexBuilder
    private let treeBuilder: TreeBuilder
    private let treeFilter: TreeFilter
    private let treePrinter: TreePrinter

    init(
        inputReader: InputReader,
        regexBuilder: RegexBuilder,
        treeBuilder: TreeBuilder,
        treeFilter: TreeFilter,
        treePrinter: TreePrinter
    ) {
        self.inputReader = inputReader
        self.regexBuilder = regexBuilder
        self.treeBuilder = treeBuilder
        self.treeFilter = treeFilter
        self.treePrinter = treePrinter
    }

    func print(
        inputPath: String,
        filter: Filter,
        sort: Sort
    ) async throws {
        let nodesMap = try await inputReader.read(inputPath: inputPath)
        let rootRegexs = try filter.roots.map(regexBuilder.build(wildcardsPattern:))
        let trees = treeBuilder.build(
            from: nodesMap,
            roots: nodesMap.keys.filter { name in
                rootRegexs.isEmpty || rootRegexs.contains(where: name.contains)
            },
            sort: sort
        )
        let filteredTrees = try trees.compactMap { tree in
            try treeFilter.filter(
                tree,
                contains: filter.contains.map(regexBuilder.build(wildcardsPattern:)),
                except: filter.except.map(regexBuilder.build(wildcardsPattern:)),
                maxHeight: filter.maxHeight
            )
        }
        let forest = TreeNode(
            name: ".",
            info: nil,
            explicitChildren: filteredTrees,
            children: filteredTrees.recursiveChildren(),
            stats: TreeNode.Stats(
                height: trees.maxHeight(),
                explicitChildrenCount: trees.count,
                childrenCount: trees.recursiveChildren().count
            )
        )
        Swift.print(treePrinter.print(forest))
    }
}
