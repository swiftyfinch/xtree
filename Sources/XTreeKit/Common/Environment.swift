import Fish

public enum Environment {
    public static let version = "1.1.1"

    static let cacheFolderPath = Folder.home.subpath(".xtree/cache")
    static let maxCacheStorageCount = 20
}
