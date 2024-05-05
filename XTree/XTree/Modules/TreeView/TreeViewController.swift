import AppKit

private final class TreeViewNode {
    let id: String
    let title: String

    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

final class TreeViewController: NSViewController {
    private let rowIdentifier = NSUserInterfaceItemIdentifier("RowView")
    private let treeRowTitleFormatter: TreeRowTitleFormatter

    // State
    private var id: String?
    private var tree: TreeViewNode?
    private var adjacentList: [String: TreeNodeContent] = [:]
    private var highlightText: String?
    private var cache: [String: TreeViewNode] = [:]

    // MARK: - UI

    private lazy var scrollView: NSScrollView = {
        let view = NSScrollView(frame: .zero)
        view.hasVerticalScroller = true
        view.hasHorizontalRuler = false
        view.drawsBackground = false
        return view
    }()

    private lazy var outlineView: NSOutlineView = {
        let view = NSOutlineView()
        view.dataSource = self
        view.delegate = self

        view.allowsMultipleSelection = true
        view.autoresizesOutlineColumn = false
        view.headerView = nil
        view.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        view.style = .sourceList
        view.backgroundColor = .clear
        view.gridColor = .clear

        let onlyColumn = NSTableColumn()
        onlyColumn.resizingMask = .autoresizingMask
        view.addTableColumn(onlyColumn)
        return view
    }()

    // MARK: - Init

    init(treeRowTitleFormatter: TreeRowTitleFormatter) {
        self.treeRowTitleFormatter = treeRowTitleFormatter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods

    override func loadView() {
        view = scrollView
        scrollView.documentView = outlineView
    }

    // MARK: - Methods

    func update(state: TreeViewState) {
        if state.id != id {
            cache.removeAll()
        }

        id = state.id
        tree = buildNode(name: state.root, parent: nil)
        adjacentList = state.adjacentList
        highlightText = state.highlightText
        outlineView.reloadData()

        // TODO: How to expand rows in faster way?
        expand(items: [tree], expandChildren: false)
        if highlightText != nil, highlightText?.isEmpty == false {
            if let tree = tree, let children = adjacentList[tree.title]?.children {
                let items = children.map {
                    buildNode(name: $0, parent: tree)
                }
                expand(items: items, expandChildren: true)
            }
        }
    }

    private func buildNode(name: String, parent: TreeViewNode?) -> TreeViewNode {
        let id = parent.map { "\($0.id)-\(name)" } ?? name
        if let cached = cache[id] { return cached }
        let tree = TreeViewNode(id: id, title: name)
        cache[id] = tree
        return tree
    }

    private func expand(items: [Any?], expandChildren: Bool) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0
        items.forEach {
            outlineView.expandItem($0, expandChildren: expandChildren)
        }
        NSAnimationContext.endGrouping()
    }

    @objc private func copy(_: AnyObject) {
        let titles = outlineView.selectedRowIndexes.compactMap {
            (outlineView.item(atRow: $0) as? TreeViewNode)?.title
        }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(titles.joined(separator: "\n"), forType: .string)
    }
}

// MARK: - NSOutlineViewDataSource

extension TreeViewController: NSOutlineViewDataSource {
    func outlineView(
        _: NSOutlineView,
        numberOfChildrenOfItem item: Any?
    ) -> Int {
        if item == nil { return 1 }
        guard let node = item as? TreeViewNode,
              let content = adjacentList[node.title] else { return 0 }
        return content.children.count
    }

    func outlineView(
        _: NSOutlineView,
        child index: Int,
        ofItem item: Any?
    ) -> Any {
        if item == nil {
            return tree as Any
        } else if let node = item as? TreeViewNode,
                  let content = adjacentList[node.title] {
            let name = content.children[index]
            let treeNode = buildNode(name: name, parent: node)
            return treeNode
        }
        fatalError()
    }

    func outlineView(
        _: NSOutlineView,
        isItemExpandable item: Any
    ) -> Bool {
        guard let node = item as? TreeViewNode,
              let content = adjacentList[node.title] else { return false }
        return content.children.count > 0
    }
}

// MARK: - NSOutlineViewDelegate

extension TreeViewController: NSOutlineViewDelegate {
    func outlineView(
        _ outlineView: NSOutlineView,
        viewFor _: NSTableColumn?,
        item: Any
    ) -> NSView? {
        guard let node = item as? TreeViewNode,
              let content = adjacentList[node.title] else { return nil }

        let view = outlineView.makeView(withIdentifier: rowIdentifier, owner: self) as? TreeRowView ?? TreeRowView()
        view.update(
            text: treeRowTitleFormatter.formatTitle(content: content, highlightText: highlightText),
            icon: content.icon.flatMap(treeRowTitleFormatter.buildIcon)
        )
        view.identifier = rowIdentifier
        view.isEmphasized = false
        return view
    }

    func outlineView(_: NSOutlineView, heightOfRowByItem _: Any) -> CGFloat {
        20
    }

    func outlineView(_: NSOutlineView, rowViewForItem _: Any) -> NSTableRowView? {
        SelectionTreeRowView()
    }
}
