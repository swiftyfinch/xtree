import Foundation
import XcodeProj

final class XcodeProjectReader {
    private let inputCacher: InputFileCacher
    private let inputInMemoryCacher: InputInMemoryCacher

    init(inputCacher: InputFileCacher,
         inputInMemoryCacher: InputInMemoryCacher) {
        self.inputCacher = inputCacher
        self.inputInMemoryCacher = inputInMemoryCacher
    }

    func parseTargets(
        projectPath: String
    ) async throws -> [String: Node] {
        var projectPaths = [projectPath]
        if let inMemoryCache = try await inputInMemoryCacher.read(basedOnPaths: projectPaths.pbxprojs()) {
            return inMemoryCache
        }
        if let cache = try await inputCacher.read(basedOnPaths: projectPaths.pbxprojs()) { return cache }

        let xcodeproj = try XcodeProj(pathString: projectPath)
        let subprojectPaths = try subprojectPaths(xcodeproj, projectPath: projectPath)
        projectPaths.append(contentsOf: subprojectPaths)
        if let inMemoryCache = try await inputInMemoryCacher.read(basedOnPaths: projectPaths.pbxprojs()) {
            return inMemoryCache
        }
        if let cache = try await inputCacher.read(basedOnPaths: projectPaths.pbxprojs()) {
            return cache
        }

        var nodesMap: [String: Node] = [:]
        try mergeTargets(&nodesMap, from: xcodeproj)
        try await subprojectPaths.concurrentMap(XcodeProj.init(pathString:)).forEach { subproject in
            try mergeTargets(&nodesMap, from: subproject)
        }
        try await inputCacher.keep(nodesMap, basedOnPaths: projectPaths.pbxprojs())
        try await inputInMemoryCacher.keep(nodesMap, basedOnPaths: projectPaths.pbxprojs())
        return nodesMap
    }

    private func mergeTargets(_ nodesMap: inout [String: Node], from xcodeproj: XcodeProj) throws {
        guard let rootProject = try xcodeproj.pbxproj.rootProject() else { return }
        rootProject.targets.forEach {
            nodesMap[$0.name] = Node(
                icon: makeIcon(pbxTarget: $0),
                name: $0.name,
                info: nil,
                children: $0.dependencies.compactMap(\.displayName)
            )
        }
    }

    private func subprojectPaths(_ xcodeproj: XcodeProj, projectPath: String) throws -> [String] {
        let projectFolderPath = URL(fileURLWithPath: projectPath).deletingLastPathComponent().path
        return try xcodeproj.pbxproj.fileReferences
            .filter { $0.path?.hasSuffix(.xcodeprojExtension) == true }
            .compactMap { try $0.fullPath(sourceRoot: projectFolderPath) }
    }

    private func makeIcon(pbxTarget: PBXTarget) -> Node.Icon? {
        if pbxTarget is PBXAggregateTarget {
            return .init(sfSymbol: "target", primaryColor: 0xCA6854, secondaryColor: nil)
        } else if pbxTarget.productType == .framework {
            return .init(sfSymbol: "latch.2.case.fill", primaryColor: 0xBD923E, secondaryColor: nil)
        } else if pbxTarget.productType == .bundle {
            return .init(sfSymbol: "batteryblock.fill", primaryColor: 0x6EB5DC, secondaryColor: nil)
        } else if pbxTarget.productType == .uiTestBundle || pbxTarget.productType == .unitTestBundle {
            return .init(sfSymbol: "checkmark.diamond.fill", primaryColor: 0xFFFFFF, secondaryColor: 0x57AB59)
        } else if pbxTarget.productType == .application {
            return .init(sfSymbol: "app.fill", primaryColor: 0xADBAC7, secondaryColor: nil)
        }
        return nil
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
