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

        @Option(
            name: .shortAndLong,
            parsing: .upToNextOption,
            help: """
            Keep only subtrees where the root node contains the passed string with wildcards \("(*, ?)".secondary).
            """
        )
        var roots: [String] = []

        @Option(
            name: .shortAndLong,
            parsing: .upToNextOption,
            help: """
            Keep only the nodes that contain the passed strings with wildcards \("(*, ?)".secondary).
            """
        )
        var contains: [String] = []

        @Option(
            name: .shortAndLong,
            parsing: .upToNextOption,
            help: """
            Exclude nodes that contain any of the passed strings with wildcards \("(*, ?)".secondary).
            """
        )
        var except: [String] = []

        @Option(name: [.customShort("d", allowingJoined: true), .customLong("depth")],
                help: "Limit the maximum depth of the tree.")
        var maxHeight: Int?

        @Option(
            name: .shortAndLong,
            help: """
            Select the sorting method: by name, by number of \("children".secondary) or by \("height".secondary).
            """
        )
        var sort: Sort = .name
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
                roots: roots,
                contains: contains,
                except: except,
                maxHeight: maxHeight
            ),
            sort: sort
        )
    }
}
