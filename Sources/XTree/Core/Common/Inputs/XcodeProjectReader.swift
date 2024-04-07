import Foundation
import XcodeProj

final class XcodeProjectReader {
    private let inputCacher: InputCacher

    init(inputCacher: InputCacher) {
        self.inputCacher = inputCacher
    }

    func parseTargets(
        projectPath: String
    ) async throws -> [String: Node] {
        var projectPaths = [projectPath]
        if let cache = try await inputCacher.read(basedOnPaths: projectPaths.pbxprojs()) {
            return cache
        }

        let xcodeproj = try XcodeProj(pathString: projectPath)
        let subprojectPaths = try subprojectPaths(xcodeproj, projectPath: projectPath)
        projectPaths.append(contentsOf: subprojectPaths)
        if let cache = try await inputCacher.read(basedOnPaths: projectPaths.pbxprojs()) {
            return cache
        }

        var nodesMap: [String: Node] = [:]
        try mergeTargets(&nodesMap, from: xcodeproj)
        try await subprojectPaths.concurrentMap(XcodeProj.init(pathString:)).forEach { subproject in
            try mergeTargets(&nodesMap, from: subproject)
        }
        try await inputCacher.keep(nodesMap, basedOnPaths: projectPaths.pbxprojs())
        return nodesMap
    }

    private func mergeTargets(_ nodesMap: inout [String: Node], from xcodeproj: XcodeProj) throws {
        guard let rootProject = try xcodeproj.pbxproj.rootProject() else { return }
        rootProject.targets.forEach {
            nodesMap[$0.name] = Node(
                name: $0.name,
                info: nil,
                children: $0.dependencies.compactMap(\.displayName)
            )
        }
    }

    private func subprojectPaths(_ xcodeproj: XcodeProj, projectPath: String) throws -> [String] {
        let projectFolderPath = URL(fileURLWithPath: projectPath).deletingLastPathComponent().lastPathComponent
        return try xcodeproj.pbxproj.fileReferences
            .filter { $0.path?.hasSuffix(.xcodeprojExtension) == true }
            .compactMap { try $0.fullPath(sourceRoot: projectFolderPath) }
    }
}

private extension String {
    static let xcodeprojExtension = "xcodeproj"
}

private extension [String] {
    func pbxprojs() -> [String] {
        map { "\($0)/project.pbxproj" }
    }
}

private extension PBXTargetDependency {
    var displayName: String? { name ?? target?.name }
}
