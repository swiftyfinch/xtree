import ArgumentParser
import Fish
import Foundation
import XTreeKit

extension XTree {
    struct Update: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "update",
            abstract: "Download and install the latest version."
        )
    }
}

// MARK: - Implementation

extension XTree.Update {
    enum Error: LocalizedError {
        case cantFindLatestVersion

        var errorDescription: String? {
            switch self {
            case .cantFindLatestVersion:
                return "Can't reach the latest version."
            }
        }
    }
}

extension XTree.Update {
    func run() async throws {
        let gitHubUpdater = GitHubUpdater(
            repositoryPath: Environment.repositoryPath,
            downloadsPath: Environment.downloadsPath,
            binName: Environment.binName,
            binFolderPath: Environment.binFolderPath
        )
        guard let latestVersion = try await gitHubUpdater.loadLatestVersion() else {
            throw Error.cantFindLatestVersion
        }
        guard latestVersion != Environment.version else {
            return print("✓ Your current version is the latest one available.".accent)
        }
        try await gitHubUpdater.install(version: latestVersion)
        print("✓ The v\(latestVersion) has been installed.".accent)
    }
}
