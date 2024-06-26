public final class Vault {
    public static let shared = Vault()
    private init() {}

    // MARK: - Managers

    public private(set) lazy var frequencyManager: IFrequencyManager = FrequencyManager(inputReader: inputReader)
    public private(set) lazy var parentsManager: IParentsManager = ParentsManager(inputReader: inputReader)
    public private(set) lazy var treeManager: ITreeManager = internalTreeManager
    public private(set) lazy var impactManager: IImpactManager = ImpactManager(
        inputReader: inputReader,
        regexBuilder: regexBuilder,
        treeManager: internalTreeManager
    )

    // MARK: - Common

    public private(set) lazy var system: ISystem = System()
    public private(set) lazy var terminal: ITerminal = Terminal()

    private(set) lazy var yamlFileManager = YAMLFileManager()
    private(set) lazy var sha1Hasher = SHA1Hasher()
    private(set) lazy var inputCacher = InputFileCacher(
        sha1Hasher: sha1Hasher,
        yamlFileManager: yamlFileManager,
        cacheFolderPath: Environment.cacheFolderPath,
        maxStorageCount: Environment.maxCacheStorageCount
    )
    private(set) lazy var inputInMemoryCacher = InputInMemoryCacher(sha1Hasher: sha1Hasher)
    private(set) lazy var xcodeProjectReader = XcodeProjectReader(
        inputCacher: inputCacher,
        inputInMemoryCacher: inputInMemoryCacher
    )
    private(set) lazy var podfileLockReader = PodfileLockReader()
    private(set) lazy var inputReader = InputReader(
        xcodeProjectReader: xcodeProjectReader,
        yamlFileManager: yamlFileManager,
        podfileLockReader: podfileLockReader,
        inputInMemoryCacher: inputInMemoryCacher
    )
    private(set) lazy var regexBuilder = RegexBuilder()
    private(set) lazy var treeSorter = TreeSorter()
    private(set) lazy var treeBuilder = TreeBuilder(treeSorter: treeSorter)
    private(set) lazy var treeFilter = TreeFilter()
    private(set) lazy var internalTreeManager: IInternalTreeManager = TreeManager(
        inputReader: inputReader,
        regexBuilder: regexBuilder,
        treeBuilder: treeBuilder,
        treeFilter: treeFilter
    )
}
