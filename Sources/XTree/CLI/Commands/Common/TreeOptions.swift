import ArgumentParser

struct TreeOptions: ParsableCommand {
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
