import Fish
import Foundation
import Yams

enum PodfileLockReaderError: LocalizedError {
    case incorrectPodfileFormat
    case incorrectPodsNodeFormat

    var errorDescription: String? {
        switch self {
        case .incorrectPodfileFormat:
            return "Incorrect Podfile.lock file format."
        case .incorrectPodsNodeFormat:
            return "Incorrect PODS node format."
        }
    }
}

final class PodfileLockReader {
    typealias Error = PodfileLockReaderError

    func parse(path: String) throws -> [String: Node] {
        let content = try File.read(at: path)
        guard let yaml = try Yams.load(yaml: content) as? [String: Any] else {
            throw Error.incorrectPodfileFormat
        }
        return try parsePodsNode(yaml)
    }

    private func parsePodsNode(_ yaml: [String: Any]) throws -> [String: Node] {
        guard let podsNode = yaml[.podsNode] as? [Any] else {
            throw Error.incorrectPodfileFormat
        }

        var pods: [String: Node] = [:]
        for value in podsNode {
            switch value {
            case let string as String:
                let (name, version) = parsePod(string)
                pods[name] = Node(name: name, info: version, children: [])
            case let dictionary as [String: [String]]:
                for (string, array) in dictionary {
                    let (name, version) = parsePod(string)
                    pods[name] = Node(
                        name: name,
                        info: version,
                        children: array.map { parsePod($0).name }
                    )
                }
            default:
                throw Error.incorrectPodsNodeFormat
            }
        }
        return pods
    }

    private func parsePod(_ line: String) -> (name: String, version: String?) {
        let components = line.components(separatedBy: " (")
        let name = components[0]
        let version = components.count == 2 ? String(components[1].dropLast()) : nil
        return (name, version)
    }
}

private extension String {
    static let podsNode = "PODS"
}
