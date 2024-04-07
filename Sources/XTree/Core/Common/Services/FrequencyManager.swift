import Foundation

final class FrequencyManager {
    private let inputReader: InputReader

    init(inputReader: InputReader) {
        self.inputReader = inputReader
    }

    func print(inputPath: String) async throws {
        let nodesMap = try await inputReader.read(inputPath: inputPath)
        let frequencies: [String: Int] = nodesMap.values.reduce(into: [:]) { parents, node in
            node.children.forEach { name in
                parents[name, default: 0] += 1
            }
        }
        guard let maxFrequency = frequencies.map(\.value).max() else { return }
        let width = Int(log10f(Float(maxFrequency)).rounded(.up))
        let list = frequencies
            .sorted { $0.value > $1.value }
            .map { String(format: " %\(width)d ", $0.value).secondary + "\($0.key)".accent }
            .joined(separator: "\n")
        Swift.print(list)
    }
}
