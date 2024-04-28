import Foundation

final class RegexBuilder {
    func build(wildcardsPattern: String) throws -> Regex<Substring> {
        var pattern = NSRegularExpression.escapedPattern(for: wildcardsPattern)
        pattern = pattern.replacingOccurrences(of: "\\*", with: ".*")
        pattern = pattern.replacingOccurrences(of: "\\?", with: ".")
        return try Regex("^\(pattern)$")
    }
}
