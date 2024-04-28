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

        let specRepos = yaml[.specRepos] as? [String: [String]] ?? [:]
        let checkoutOptions = yaml[.checkoutOptions] as? [String: [String: Any]] ?? [:]
        let remotePodNames = Set(specRepos.flatMap(\.value) + checkoutOptions.keys)

        var pods: [String: Node] = [:]
        for value in podsNode {
            switch value {
            case let string as String:
                let node = makeNode(string, children: [], remotePodNames: remotePodNames)
                pods[node.name] = node
            case let dictionary as [String: [String]]:
                for (string, array) in dictionary {
                    let node = makeNode(string, children: array, remotePodNames: remotePodNames)
                    pods[node.name] = node
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

    private func makeNode(_ line: String, children: [String], remotePodNames: Set<String>) -> Node {
        let (name, version) = parsePod(line)
        let isPodRemote = isPodRemote(name: name, remotePodNames: remotePodNames)
        return Node(
            icon: makeIcon(isRemotePod: isPodRemote),
            name: name,
            info: version,
            children: children.map { parsePod($0).name }
        )
    }

    private func isPodRemote(name: String, remotePodNames: Set<String>) -> Bool {
        let baseName = name.components(separatedBy: "/")[0]
        return remotePodNames.contains(baseName)
    }

    private func makeIcon(isRemotePod: Bool) -> Node.Icon {
        .init(
            sfSymbol: isRemotePod ? "shippingbox.fill" : "folder.fill",
            primaryColor: isRemotePod ? 0xBD923E : 0x666666,
            secondaryColor: nil
        )
    }
}

private extension String {
    static let podsNode = "PODS"
    static let specRepos = "SPEC REPOS"
    static let checkoutOptions = "CHECKOUT OPTIONS"
}
