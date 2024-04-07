import ArgumentParser

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
        try await frequencyManager.print(inputPath: inputPath)
    }
}
