import ArgumentParserToolInfo
import XTreeKit

private extension Int {
    static let terminalMaxWidth = 80
}

final class HelpPrinter {
    private let terminalWidth = min(.terminalMaxWidth, Terminal.columns() ?? .terminalMaxWidth)

    func print(command: CommandInfoV0) {
        let blocks = [
            block(abstract: command.abstract),
            block(discussion: command.discussion),
            block(subcommands: command.subcommands,
                  defaultSubcommand: command.defaultSubcommand,
                  arguments: command.arguments)
        ]
        Swift.print(blocks.compactMap { $0 }.joined(separator: "\n"))
    }

    private func block(abstract: String?) -> String? {
        abstract.map { "\n 🌳 \($0)".accent }
    }

    private func block(discussion: String?) -> String? {
        discussion?
            .components(separatedBy: "\n")
            .map { "    \($0)" }
            .joined(separator: "\n")
    }

    private func block(
        subcommands: [CommandInfoV0]?,
        defaultSubcommand: String?,
        arguments: [ArgumentInfoV0]?
    ) -> String? {
        var lines: [(left: String, right: String)] = []
        for subcommand in subcommands ?? [] {
            guard let abstract = subcommand.abstract else { continue }
            let subcommandName = "> \(subcommand.commandName)".accent
            let left = subcommand.commandName == defaultSubcommand
                ? subcommandName.bold
                : subcommandName
            lines.append((left: left, right: abstract))
        }

        for kind in [ArgumentInfoV0.KindV0.positional, .option, .flag] {
            let kindArguments = (arguments ?? []).filter { $0.kind == kind }
            if !lines.isEmpty && !kindArguments.isEmpty {
                lines.append(("", ""))
            }
            for argument in kindArguments {
                lines.append((left: argument.displayName.accent, right: argument.help))
            }
        }
        return BoxPainter().drawTable(lines, terminalWidth: terminalWidth)
    }
}

private extension ArgumentInfoV0 {
    var help: String {
        var result = abstract ?? ""
        if let defaultValue {
            if result.contains(defaultValue) {
                result = result.replacingOccurrences(of: defaultValue, with: defaultValue.accent)
            } else {
                result.append(" \("(\(defaultValue))".accent)")
            }
        }
        return result
    }
}

private extension [ArgumentInfoV0.NameInfoV0] {
    var string: String {
        map(\.string).sorted().joined(separator: ", ")
    }
}

private extension ArgumentInfoV0.NameInfoV0.KindV0 {
    var prefix: String {
        switch self {
        case .long: return "--"
        case .short: return "-"
        case .longWithSingleDash: return "-"
        }
    }
}

private extension ArgumentInfoV0.NameInfoV0 {
    var string: String { "\(kind.prefix)\(name)" }
}

private extension ArgumentInfoV0 {
    var displayName: String {
        var result: String
        let repeatingSuffix = isRepeating ? " []" : ""
        switch kind {
        case .positional:
            result = "\(valueName ?? "-")\(repeatingSuffix)"
        case .option, .flag:
            result = "\(names?.string ?? "-")\(repeatingSuffix)"
        }
        result = isOptional ? result : result.bold
        return result
    }
}
