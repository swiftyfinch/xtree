import ArgumentParser
import Foundation
import XTreeKit

extension XTree {
    struct Frequency: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "frequency",
            abstract: "Calculate a frequency of each node."
        )

        @OptionGroup
        var inputOptions: InputOptions
    }
}

// MARK: - Implementation

extension XTree.Frequency {
    func run() async throws {
        let inputPath = try inputOptions.validateInputPath()

        let frequencyManager = Vault.shared.frequencyManager
        let frequencies = try await frequencyManager.print(inputPath: inputPath)
        guard let maxFrequency = frequencies.map(\.value).max() else { return }
        let width = Int(log10f(Float(maxFrequency)).rounded(.up))
        let list = frequencies
            .sorted { ($0.value, $1.key) > ($1.value, $0.key) }
            .map { String(format: " %\(width)d ", $0.value).secondary + "\($0.key)".accent }
            .joined(separator: "\n")
        print(list)
    }
}
