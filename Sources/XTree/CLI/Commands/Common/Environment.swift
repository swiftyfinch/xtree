import Fish

enum Environment {
    static let version = "1.0.0"
    static let repositoryPath = "swiftyfinch/xtree"

    static let cacheFolderPath = Folder.home.subpath(".xtree/cache")
    static let maxCacheStorageCount = 20

    static let binName = "xtree"
    static let binFolderPath = Folder.home.subpath(".local/bin")
    static let downloadsPath = Folder.home.subpath(".xtree/downloads")
}
