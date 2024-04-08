import ArgumentParser

extension Sort: ExpressibleByArgument {}
extension XTree {
    struct Print: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "print",
            abstract: "Print a tree with children statistics.",
            discussion: """
            \("Each node can contain:".accent)
            \("╰─ Name".accent) \("height:explicit_children/children".white.secondary) \("info?".tertiary)
            """
        )

        @OptionGroup
        var inputOptions: InputOptions

        @OptionGroup
        var treeOptions: TreeOptions
    }
}

// MARK: - Implementation

extension XTree.Print {
    func run() async throws {
        let inputPath = try inputOptions.validateInputPath()

        let treeManager = Vault.shared.treeManager
        try await treeManager.print(
            inputPath: inputPath,
            filter: .init(
                roots: treeOptions.roots,
                contains: treeOptions.contains,
                except: treeOptions.except,
                maxHeight: treeOptions.maxHeight
            ),
            sort: treeOptions.sort
        )
    }
}
