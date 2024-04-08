import ArgumentParser
import Foundation

extension XTree {
    struct Parents: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "parents",
            abstract: "Find all parents of nodes."
        )

        @OptionGroup
        var inputOptions: InputOptions

        @Option(name: .shortAndLong, help: "The name of the node to display its parents.")
        var name: String?
    }
}

// MARK: - Implementation

extension XTree.Parents {
    enum Error: LocalizedError {
        case missingName

        var errorDescription: String? {
            switch self {
            case .missingName:
                return "Please provide the node name to the \("-n, --name".secondary) argument."
            }
        }
    }

    func validateName() throws -> String {
        guard let name else { throw Error.missingName }
        return name
    }
}

extension XTree.Parents {
    func run() async throws {
        let inputPath = try inputOptions.validateInputPath()
        let name = try validateName()

        let parentsManager = Vault.shared.parentsManager
        try await parentsManager.print(
            inputPath: inputPath,
            name: name
        )
    }
}
