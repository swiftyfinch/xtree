import Fish

// MARK: - Interface

public struct TreeFilterOptions {
    public var roots: Set<String>
    public var contains: Set<String>
    public var except: Set<String>
    public var exceptIcons: Set<String>
    public var maxHeight: Int?

    public init(
        roots: Set<String>,
        contains: Set<String>,
        except: Set<String>,
        exceptIcons: Set<String>,
        maxHeight: Int? = nil
    ) {
        self.roots = roots
        self.contains = contains
        self.except = except
        self.exceptIcons = exceptIcons
        self.maxHeight = maxHeight
    }
}

public protocol ITreeManager: AnyObject {
    func print(
        inputPath: String,
        filter: TreeFilterOptions,
        sort: Sort,
        needsCompress: Bool
    ) async throws -> TreeNode
}

protocol IInternalTreeManager: ITreeManager {
    func print(
        nodesMap: [String: Node],
        filter: TreeFilterOptions,
        sort: Sort,
        needsCompress: Bool
    ) throws -> TreeNode
}

// MARK: - Implementation

final class TreeManager {
    private let inputReader: InputReader
    private let regexBuilder: RegexBuilder
    private let treeBuilder: TreeBuilder
    private let treeFilter: TreeFilter

    init(
        inputReader: InputReader,
        regexBuilder: RegexBuilder,
        treeBuilder: TreeBuilder,
        treeFilter: TreeFilter
    ) {
        self.inputReader = inputReader
        self.regexBuilder = regexBuilder
        self.treeBuilder = treeBuilder
        self.treeFilter = treeFilter
    }
}

// MARK: - IInternalTreeManager

extension TreeManager: IInternalTreeManager {
    func print(
        nodesMap: [String: Node],
        filter: TreeFilterOptions,
        sort: Sort,
        needsCompress: Bool
    ) throws -> TreeNode {
        let rootRegexs = try filter.roots.map(regexBuilder.build(wildcardsPattern:))
        let forest = treeBuilder.build(
            from: nodesMap,
            roots: nodesMap.keys.filter { name in
                rootRegexs.isEmpty || rootRegexs.contains(where: name.contains)
            },
            sort: sort,
            needsCompress: needsCompress
        )
        let filteredForest = try forest.compactMap { tree in
            try treeFilter.filter(
                tree,
                contains: filter.contains.map(regexBuilder.build(wildcardsPattern:)),
                except: filter.except.map(regexBuilder.build(wildcardsPattern:)),
                exceptIcons: filter.exceptIcons,
                maxHeight: filter.maxHeight
            )
        }
        let children = filteredForest.recursiveChildren()
        return TreeNode(
            icon: nil,
            name: ".",
            info: nil,
            explicitChildren: filteredForest,
            children: children,
            stats: TreeNode.Stats(
                height: forest.maxHeight(),
                explicitChildrenCount: filteredForest.count,
                childrenCount: children.count
            )
        )
    }
}

// MARK: - ITreeManager

extension TreeManager: ITreeManager {
    func print(
        inputPath: String,
        filter: TreeFilterOptions,
        sort: Sort,
        needsCompress: Bool
    ) async throws -> TreeNode {
        let nodesMap = try await inputReader.read(inputPath: inputPath)
        return try print(nodesMap: nodesMap, filter: filter, sort: sort, needsCompress: needsCompress)
    }
}
