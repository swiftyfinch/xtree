import AppKit

final class SelectionTreeRowView: NSTableRowView {
    private lazy var selectionView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.1).cgColor
        view.layer?.cornerRadius = 6
        return view
    }()

    override func addSubview(_ view: NSView, positioned place: NSWindow.OrderingMode, relativeTo otherView: NSView?) {
        if view is NSVisualEffectView { return }
        super.addSubview(view, positioned: place, relativeTo: otherView)
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectionView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(selectionView, positioned: .below, relativeTo: nil)
                selectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
                selectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                trailingAnchor.constraint(equalTo: selectionView.trailingAnchor, constant: 10).isActive = true
                selectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            } else if !subviews.isEmpty {
                selectionView.removeFromSuperview()
            }
        }
    }
}
