import Foundation

final class InputInMemoryCacher {
    private let sha1Hasher: SHA1Hasher

    private var cache: [String: [String: Node]] = [:]

    init(sha1Hasher: SHA1Hasher) {
        self.sha1Hasher = sha1Hasher
    }

    func keep(_ nodesMap: [String: Node], basedOnPaths paths: [String]) async throws {
        let hash = try await hash(paths: paths)
        cache[hash] = nodesMap
    }

    func read(basedOnPaths paths: [String]) async throws -> [String: Node]? {
        let hash = try await hash(paths: paths)
        return cache[hash]
    }

    private func hash(paths: [String]) async throws -> String {
        let pathHashes = try await paths.sorted().concurrentMap {
            let data = try Data(contentsOf: URL(fileURLWithPath: $0))
            return self.sha1Hasher.hash(data)
        }
        return sha1Hasher.hash(pathHashes)
    }
}
