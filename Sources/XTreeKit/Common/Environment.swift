import Fish

public enum Environment {
    public static let version = "2.2.1"

    static let cacheFolderPath = Folder.home.subpath(".xtree/cache")
    static let maxCacheStorageCount = 20
}
