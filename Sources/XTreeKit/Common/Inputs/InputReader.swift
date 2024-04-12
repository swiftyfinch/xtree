import Fish
import Foundation

struct Node {
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

    init(xcodeProjectReader: XcodeProjectReader,
         yamlFileManager: YAMLFileManager) {
        self.xcodeProjectReader = xcodeProjectReader
        self.yamlFileManager = yamlFileManager
    }

    func read(inputPath: String) async throws -> [String: Node] {
        let resolvedPath = try resolvePath(inputPath)
        switch URL(fileURLWithPath: resolvedPath).pathExtension {
        case InputReaderExtensions.xcodeproj:
            return try await xcodeProjectReader.parseTargets(projectPath: resolvedPath)
        case InputReaderExtensions.yml, InputReaderExtensions.yaml:
            return try yamlFileManager.parse(path: resolvedPath)
        case InputReaderExtensions.lock:
            return try PodfileLockReader().parse(path: resolvedPath)
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
}
