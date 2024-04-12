import Foundation

public final class FrequencyManager {
    private let inputReader: InputReader

    init(inputReader: InputReader) {
        self.inputReader = inputReader
    }

    public func print(inputPath: String) async throws -> [String: Int] {
        let nodesMap = try await inputReader.read(inputPath: inputPath)
        var frequencies: [String: Int] = nodesMap.values.reduce(into: [:]) { parents, node in
            node.children.forEach { name in
                parents[name, default: 0] += 1
            }
        }
        nodesMap.keys.forEach { name in
            frequencies[name, default: 0] += 1
        }
        return frequencies
    }
}
