import Fish
import Foundation

struct Node {
    struct Icon {
        let sfSymbol: String
        let primaryColor: UInt
        let secondaryColor: UInt?
    }

    let icon: Icon?
    let name: String
    let info: String?
    let children: [String]
}

enum InputReaderExtensions {
    static let xcodeproj = "xcodeproj"
    static let yml = "yml"
    static let yaml = "yaml"
    static let lock = "lock"
}

enum InputReaderError: LocalizedError {
    case unknownInputExtension
    case inputIsNotExist

    var errorDescription: String? {
        switch self {
        case .unknownInputExtension:
            return "You passed an unknown input extension."
        case .inputIsNotExist:
            return "The input you provided does not exist."
        }
    }
}

final class InputReader {
    typealias Error = InputReaderError

    private let xcodeProjectReader: XcodeProjectReader
    private let yamlFileManager: YAMLFileManager
    private let podfileLockReader: PodfileLockReader
    private let inputInMemoryCacher: InputInMemoryCacher

    init(xcodeProjectReader: XcodeProjectReader,
         yamlFileManager: YAMLFileManager,
         podfileLockReader: PodfileLockReader,
         inputInMemoryCacher: InputInMemoryCacher) {
        self.xcodeProjectReader = xcodeProjectReader
        self.yamlFileManager = yamlFileManager
        self.podfileLockReader = podfileLockReader
        self.inputInMemoryCacher = inputInMemoryCacher
    }

    func read(inputPath: String) async throws -> [String: Node] {
        let resolvedPath = try resolvePath(inputPath)
        switch URL(fileURLWithPath: resolvedPath).pathExtension {
        case InputReaderExtensions.xcodeproj:
            return try await xcodeProjectReader.parseTargets(projectPath: resolvedPath)
        case InputReaderExtensions.yml, InputReaderExtensions.yaml:
            return try await cached(
                paths: [resolvedPath],
                readNodesMap: try yamlFileManager.parse(path: resolvedPath)
            )
        case InputReaderExtensions.lock:
            return try await cached(
                paths: [resolvedPath],
                readNodesMap: try podfileLockReader.parse(path: resolvedPath)
            )
        default:
            throw Error.unknownInputExtension
        }
    }

    private func resolvePath(_ path: String) throws -> String {
        if File.isExist(at: path) || Folder.isExist(at: path) { return path }

        let relativePath = Folder.current.subpath(path)
        if File.isExist(at: relativePath) || Folder.isExist(at: relativePath) { return relativePath }

        throw Error.inputIsNotExist
    }

    private func cached(
        paths: [String],
        readNodesMap: @autoclosure () throws -> [String: Node]
    ) async throws -> [String: Node] {
        if let cache = try await inputInMemoryCacher.read(basedOnPaths: paths) { return cache }
        let nodesMap = try readNodesMap()
        try await inputInMemoryCacher.keep(nodesMap, basedOnPaths: paths)
        return nodesMap
    }
}
