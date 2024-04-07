final class ParentsManager {
    private let inputReader: InputReader

    init(inputReader: InputReader) {
        self.inputReader = inputReader
    }

    func print(inputPath: String, name: String) async throws {
        let nodesMap = try await inputReader.read(inputPath: inputPath)
        let parents: [String: [String]] = nodesMap.values.reduce(into: [:]) { parents, node in
            node.children.forEach { name in
                parents[name, default: []].append(node.name)
            }
        }
        guard let parents = parents[name] else { return }
        let list = parents.sorted()
            .map { " * ".secondary + $0.accent }
            .joined(separator: "\n")
        Swift.print(list)
    }
}
