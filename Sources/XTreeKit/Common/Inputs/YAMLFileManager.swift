import Fish
import Yams

final class YAMLFileManager {
    fileprivate struct CacheNode: Decodable {
        struct Icon: Decodable {
            let sfSymbol: String
            let primaryColor: UInt
            let secondaryColor: UInt?
        }

        let icon: Icon?
        let id: String
        let info: String?
        let nodes: [String]
    }

    func parse(path: String) throws -> [String: Node] {
        let content = try File.at(path).readData()
        let nodes = try YAMLDecoder().decode([CacheNode].self, from: content)
        return nodes.reduce(into: [:]) { map, node in
            map[node.id] = Node(
                icon: node.icon.map {
                    .init(sfSymbol: $0.sfSymbol,
                          primaryColor: $0.primaryColor,
                          secondaryColor: $0.secondaryColor)
                },
                name: node.id,
                info: node.info,
                children: node.nodes
            )
        }
    }

    func write(_ nodesMap: [String: Node], to folder: IFolder, fileName: String) throws {
        guard !File.isExist(at: folder.subpath(fileName)) else { return }

        let nodes = nodesMap.values.map {
            CacheNode(
                icon: $0.icon.map {
                    .init(sfSymbol: $0.sfSymbol,
                          primaryColor: $0.primaryColor,
                          secondaryColor: $0.secondaryColor)
                },
                id: $0.name,
                info: $0.info,
                nodes: $0.children
            )
        }
        let content = try Yams.dump(object: nodes, width: -1, sortKeys: true)
        try folder.createFile(named: fileName, contents: content)
    }
}

// MARK: - Yams.NodeRepresentable

extension YAMLFileManager.CacheNode: Yams.NodeRepresentable {
    func represented() throws -> Yams.Node {
        var pairs: [(Yams.Node, Yams.Node)] = []
        pairs.append((.scalar(.init("id")), .scalar(.init(id))))
        if let icon {
            var iconPairs: [(Yams.Node, Yams.Node)] = [
                (.scalar(.init("sfSymbol")), .scalar(.init(icon.sfSymbol))),
                (.scalar(.init("primaryColor")), .scalar(.init(String(icon.primaryColor))))
            ]
            if let secondaryColor = icon.secondaryColor {
                iconPairs.append((
                    .scalar(.init("secondaryColor")),
                    .scalar(.init(String(secondaryColor)))
                ))
            }
            pairs.append((
                .scalar(.init("icon")),
                .mapping(.init(iconPairs))
            ))
        }
        if let info {
            pairs.append((.scalar(.init("info")), .scalar(.init(info))))
        }
        pairs.append(
            (.scalar(.init("nodes")),
             .sequence(.init(nodes.map { Yams.Node.scalar(.init($0)) })))
        )
        return .mapping(.init(pairs))
    }
}
