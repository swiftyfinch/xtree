import Fish

public enum Environment {
    public static let version = "2.0.0"

    static let cacheFolderPath = Folder.home.subpath(".xtree/cache")
    static let maxCacheStorageCount = 20
}
