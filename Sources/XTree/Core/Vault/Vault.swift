final class Vault {
    static let shared = Vault()
    private init() {}

    // MARK: - Managers

    private(set) lazy var frequencyManager = FrequencyManager(inputReader: inputReader)
    private(set) lazy var parentsManager = ParentsManager(inputReader: inputReader)
    private(set) lazy var treeManager = TreeManager(
        inputReader: inputReader,
        regexBuilder: regexBuilder,
        treeBuilder: treeBuilder,
        treeFilter: treeFilter,
        treePrinter: treePrinter
    )
    private(set) lazy var impactManager = ImpactManager(
        inputReader: Vault.shared.inputReader,
        treeManager: Vault.shared.treeManager
    )
    private(set) lazy var gitHubUpdater = GitHubUpdater(
        repositoryPath: Environment.repositoryPath,
        downloadsPath: Environment.downloadsPath,
        binName: Environment.binName,
        binFolderPath: Environment.binFolderPath
    )

    // MARK: - Common

    private(set) lazy var yamlFileManager = YAMLFileManager()
    private(set) lazy var inputCacher = InputCacher(
        sha1Hasher: SHA1Hasher(),
        yamlFileManager: yamlFileManager,
        cacheFolderPath: Environment.cacheFolderPath,
        maxStorageCount: Environment.maxCacheStorageCount
    )
    private(set) lazy var xcodeProjectReader = XcodeProjectReader(inputCacher: inputCacher)
    private(set) lazy var inputReader = InputReader(
        xcodeProjectReader: xcodeProjectReader,
        yamlFileManager: yamlFileManager
    )
    private(set) lazy var regexBuilder = RegexBuilder()
    private(set) lazy var treeSorter = TreeSorter()
    private(set) lazy var treeBuilder = TreeBuilder(treeSorter: treeSorter)
    private(set) lazy var treeFilter = TreeFilter()
    private(set) lazy var treePrinter = TreePrinter()
}
