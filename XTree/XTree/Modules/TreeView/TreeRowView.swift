import AppKit

final class TreeRowView: NSTableRowView {
    private let iconView: NSImageView = {
        let view = NSImageView()
        return view
    }()

    private let textField: NSTextField = {
        let view = NSTextField()
        view.isBezeled = false
        view.drawsBackground = false
        view.isEditable = false
        view.isSelectable = false
        view.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        return view
    }()

    private var textFieldLeadingToContainerViewConstraint: NSLayoutConstraint?
    private var textFieldLeadingToIconViewConstraint: NSLayoutConstraint?

    // MARK: - Init

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        leadingAnchor.constraint(equalTo: iconView.leadingAnchor).isActive = true
        iconView.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 1).isActive = true
        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true

        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 2).isActive = true
        textFieldLeadingToIconViewConstraint = textField.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 2)
        textFieldLeadingToContainerViewConstraint = textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1)
        trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 2).isActive = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update

    func update(text: NSAttributedString, icon: NSImage?) {
        textField.attributedStringValue = text
        iconView.image = icon

        if icon != nil {
            iconView.isHidden = false
            textFieldLeadingToContainerViewConstraint?.isActive = false
            textFieldLeadingToIconViewConstraint?.isActive = true
        } else {
            iconView.isHidden = true
            textFieldLeadingToIconViewConstraint?.isActive = false
            textFieldLeadingToContainerViewConstraint?.isActive = true
        }
    }
}
