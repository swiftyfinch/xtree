import ArgumentParser
import Foundation

struct InputOptions: ParsableCommand {
    @Option(
        name: [.short, .customLong("input")],
        help: """
        \("(required)".accent) The path to the suitable file (\
        \("*.xcodeproj".secondary), \
        \("Podfile.lock".secondary), \
        \("*.yml/*.yaml".secondary)\
        ), which will be the tree input source.
        """
    )
    var inputPath: String?
}

extension InputOptions {
    func validateInputPath() throws -> String {
        guard let inputPath, !inputPath.isEmpty else {
            throw InputOptions.Error.emptyInputPath
        }
        return inputPath
    }
}

extension InputOptions {
    enum Error: LocalizedError {
        case emptyInputPath

        var errorDescription: String? {
            switch self {
            case .emptyInputPath:
                return "Please provide the path to the \("--input".secondary) argument."
            }
        }
    }
}
