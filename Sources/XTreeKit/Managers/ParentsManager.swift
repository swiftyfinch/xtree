// MARK: - Interface

public protocol IParentsManager: AnyObject {
    func print(inputPath: String, name: String) async throws -> [String]?
}

// MARK: - Implementation

final class ParentsManager {
    private let inputReader: InputReader

    init(inputReader: InputReader) {
        self.inputReader = inputReader
    }
}

// MARK: - IParentsManager

extension ParentsManager: IParentsManager {
    func print(inputPath: String, name: String) async throws -> [String]? {
        let nodesMap = try await inputReader.read(inputPath: inputPath)
        let parents: [String: [String]] = nodesMap.values.reduce(into: [:]) { parents, node in
            node.children.forEach { name in
                parents[name, default: []].append(node.name)
            }
        }
        return parents[name]
    }
}
