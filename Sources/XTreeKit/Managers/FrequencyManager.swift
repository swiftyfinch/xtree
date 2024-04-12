import Foundation

// MARK: - Interface

public protocol IFrequencyManager: AnyObject {
    func print(inputPath: String) async throws -> [String: Int]
}

// MARK: - Implementation

final class FrequencyManager {
    private let inputReader: InputReader

    init(inputReader: InputReader) {
        self.inputReader = inputReader
    }
}

// MARK: - IFrequencyManager

extension FrequencyManager: IFrequencyManager {
    func print(inputPath: String) async throws -> [String: Int] {
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
