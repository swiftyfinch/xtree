import SwiftUI

struct TreeViewState {
    let id: String
    let root: String
    let adjacentList: [String: TreeNodeContent]
    let highlightText: String?
}

struct TreeNodeContent {
    struct Icon {
        let sfSymbol: String
        let primaryColor: UInt
        let secondaryColor: UInt?
    }

    let icon: Icon?
    let title: String
    let stats: String?
    let details: String?
    let children: [String]
}

struct TreeView: NSViewControllerRepresentable {
    @EnvironmentObject var treeRowTitleFormatter: TreeRowTitleFormatter
    var state: TreeViewState?

    func makeNSViewController(context _: Context) -> TreeViewController {
        TreeViewController(treeRowTitleFormatter: TreeRowTitleFormatter())
    }

    func updateNSViewController(_ nsViewController: TreeViewController, context _: Context) {
        if let state {
            nsViewController.update(state: state)
        }
    }
}
