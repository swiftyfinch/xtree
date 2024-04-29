import Fish
import Foundation

final class InputFileCacher {
    private let sha1Hasher: SHA1Hasher
    private let yamlFileManager: YAMLFileManager
    private let cacheFolderPath: String
    private let maxStorageCount: Int

    private let ymlExtension = "yml"

    init(sha1Hasher: SHA1Hasher,
         yamlFileManager: YAMLFileManager,
         cacheFolderPath: String,
         maxStorageCount: Int) {
        self.sha1Hasher = sha1Hasher
        self.yamlFileManager = yamlFileManager
        self.cacheFolderPath = cacheFolderPath
        self.maxStorageCount = maxStorageCount
    }

    func keep(_ nodesMap: [String: Node], basedOnPaths paths: [String]) async throws {
        try cleanUp()

        let hash = try await hash(paths: paths)
        let cacheFolder = try Folder.create(at: cacheFolderPath)
        let cacheFileName = "\(hash).\(ymlExtension)"
        try yamlFileManager.write(nodesMap, to: cacheFolder, fileName: cacheFileName)
    }

    func read(basedOnPaths paths: [String]) async throws -> [String: Node]? {
        guard Folder.isExist(at: cacheFolderPath) else { return nil }

        let hash = try await hash(paths: paths)
        let cacheFilePath = "\(cacheFolderPath)/\(hash).\(ymlExtension)"
        guard File.isExist(at: cacheFilePath) else { return nil }
        return try yamlFileManager.parse(path: cacheFilePath)
    }

    private func cleanUp() throws {
        let cacheFolder = try Folder.create(at: cacheFolderPath)
        let files = try cacheFolder.files()
        guard files.count >= maxStorageCount else { return }

        let oldestFile = try files.min { try $0.creationDate() < $1.creationDate() }
        try oldestFile?.delete()
    }

    private func hash(paths: [String]) async throws -> String {
        let pathHashes = try await paths.sorted().concurrentMap {
            let data = try Data(contentsOf: URL(fileURLWithPath: $0))
            return self.sha1Hasher.hash(data)
        }
        return sha1Hasher.hash(pathHashes)
    }
}
