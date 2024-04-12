import ArgumentParser
import XTreeKit

extension XTree {
    struct Impact: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "impact",
            abstract: "Find affected parent nodes and print them out as a tree.",
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
            \("(required)".accent) \
            The names of the nodes with wildcards \("(*, ?)".secondary) that will be the leaves of the tree.
            """
        )
        var names: [String]

        @OptionGroup
        var treeOptions: TreeOptions
    }
}

// MARK: - Implementation

extension XTree.Impact {
    func run() async throws {
        let inputPath = try inputOptions.validateInputPath()

        let impactManager = Vault.shared.impactManager
        let tree = try await impactManager.print(
            inputPath: inputPath,
            names: names,
            filter: .init(
                roots: treeOptions.roots,
                contains: treeOptions.contains,
                except: treeOptions.except,
                maxHeight: treeOptions.maxHeight
            ),
            sort: treeOptions.sort
        )
        if let tree {
            print(TreePrinter().print(tree))
        }
    }
}
