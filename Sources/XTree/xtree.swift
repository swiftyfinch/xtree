import ArgumentParser

@main
struct XTree: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "xtree",
        abstract: "Printing and analyzing trees in a handy way.",
        version: Environment.version,
        subcommands: [Print.self, Frequency.self, Parents.self, Update.self],
        defaultSubcommand: Print.self
    )

    static func main() async {
        do {
            if try printHelp() { return }
            var command: AsyncParsableCommand! = try parseCommand() as? AsyncParsableCommand
            try await ErrorWrapper().wrap {
                try await command.run()
            }
        } catch {
            exit(withError: error)
        }
    }

    // MARK: - Private

    private static func printHelp() throws -> Bool {
        if CommonFlags.help.isDisjoint(with: CommandLine.arguments) { return false }
        let commandInfo = try HelpDumper().dump(command: XTree.self)
        HelpPrinter().print(command: commandInfo)
        return true
    }
}
