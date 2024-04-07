import ArgumentParser
import Foundation
import Rainbow

// Workaround for colorizing default error prefix from ArgumentParser
extension AsyncParsableCommand {
    // swiftlint:disable:next identifier_name
    static var _errorLabel: String { errorPrefix() }
}

// MARK: - Error wrapper

final class ErrorWrapper {
    func wrap(_ block: () async throws -> Void) async rethrows {
        do {
            try await block()
        } catch {
            throw PresentableError.common(error.beautifulDescription.red)
        }
    }
}

// MARK: - Error for presenting in logs

private func errorPrefix() -> String {
    "⛔️ \(Rainbow.enabled ? "\u{1B}[31m" : "")Error"
}

private enum PresentableError: LocalizedError {
    case common(String)

    var errorDescription: String? {
        switch self {
        case let .common(description):
            return "\(errorSuffix())\(description)"
        }
    }

    private func errorSuffix() -> String {
        // Need to clear color because in _errorLabel we can't do that
        Rainbow.enabled ? "\u{1B}[0m" : ""
    }
}

private extension Error {
    /// Returns error description in beautiful way.
    var beautifulDescription: String {
        let localizedDescription = (self as? LocalizedError)?.errorDescription
        return localizedDescription ?? String(describing: self)
    }
}
