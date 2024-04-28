import AppKit

final class TreeRowTitleFormatter: ObservableObject {
    func formatTitle(content: TreeNodeContent, highlightText: String?) -> NSAttributedString {
        let result = NSMutableAttributedString()

        result.append(buildTitle(content.title, highlightText: highlightText))

        if let stats = content.stats, !stats.isEmpty {
            result.append(spacing(width: 4))
            result.append(NSAttributedString(string: stats, attributes: [.foregroundColor: NSColor.stats]))
        }

        if let details = content.details {
            result.append(spacing(width: 4))
            result.append(NSAttributedString(string: details, attributes: [.foregroundColor: NSColor.details]))
        }

        return result
    }

    func buildIcon(_ icon: TreeNodeContent.Icon) -> NSImage? {
        guard let image = NSImage(systemSymbolName: icon.sfSymbol, accessibilityDescription: nil) else { return nil }

        let paletteColors = [icon.primaryColor, icon.secondaryColor].compactMap { $0 }.compactMap { NSColor(hex: $0) }
        var imageConfiguration = NSImage.SymbolConfiguration(paletteColors: paletteColors)
        imageConfiguration = imageConfiguration.applying(.init(pointSize: 0, weight: .bold))
        return image.withSymbolConfiguration(imageConfiguration)
    }

    private func buildTitle(_ title: String, highlightText: String?) -> NSAttributedString {
        let titleString = NSMutableAttributedString(string: title, attributes: [.foregroundColor: NSColor.title])
        if let highlightText, let range = title.range(of: highlightText) {
            let nsrange = NSRange(range, in: title)
            titleString.addAttribute(.foregroundColor, value: NSColor.highlight, range: nsrange)
            let highlightFont = NSFont.monospacedSystemFont(ofSize: 14, weight: .medium)
            titleString.addAttribute(.font, value: highlightFont, range: nsrange)
        }
        return titleString
    }

    private func spacing(width: CGFloat) -> NSAttributedString {
        let spacing = NSTextAttachment()
        spacing.image = NSImage()
        spacing.bounds = CGRect(origin: .zero, size: CGSize(width: width, height: 0))
        return NSAttributedString(attachment: spacing)
    }
}
