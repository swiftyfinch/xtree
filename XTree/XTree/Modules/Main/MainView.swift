import SwiftUI

struct MainState {
    var filters = FiltersViewState()
    var toolbar = ToolBarState()
    var isInDropArea = false
    var tree: TreeViewState?
}

struct MainView: View {
    @EnvironmentObject var treeBuilder: TreeBuilder

    @State private var state = MainState()
    @FocusState var focusState: FocusField?

    var body: some View {
        VStack(spacing: 0) {
            Color(.background).frame(height: 40).zIndex(2)
            if state.toolbar.isFiltersBlockShown {
                FiltersView(
                    filtersState: $state.filters,
                    focusState: _focusState,
                    onSubmit: update
                )
                .padding(.horizontal, 12)
                .transition(.move(edge: .top).combined(with: .blurReplace))
            }
            ZStack {
                Color.clear
                if let tree = state.tree {
                    TreeView(state: tree).opacity(state.isInDropArea ? 0 : 1)
                }
                DragAndDropView(isInDropArea: $state.isInDropArea, onDrop: { fileURL in
                    treeBuilder.saveFileURL(fileURL)
                    update()
                    return true
                })
                .opacity(!state.toolbar.isProcessing && (state.isInDropArea || state.tree == nil) ? 1 : 0)
            }
        }
        .ignoresSafeArea()
        .toolbar {
            ToolBarView(
                state: $state.toolbar,
                onTrash: { state.tree = nil },
                focusState: _focusState
            )
            .disabled(state.tree == nil)
        }
        .onChange(of: state.toolbar.sorting, update)
        .onChange(of: state.toolbar.isCompressed, update)
        .onChange(of: state.toolbar.icons, update)
    }

    private func update() {
        state.toolbar.isProcessing = true
        treeBuilder.build(
            roots: formatFilters(state.filters.roots),
            contains: formatFilters(state.filters.contains),
            except: formatFilters(state.filters.except),
            sorting: state.toolbar.sorting,
            isCompressed: state.toolbar.isCompressed,
            filterText: state.filters.filter,
            hiddenIcons: state.toolbar.icons.hidden
        ) {
            state.tree = $0
            state.toolbar.icons = convertIcons($0?.icons)
            state.toolbar.isProcessing = false
        }
    }

    private func formatFilters(_ filters: String) -> [String] {
        filters.components(separatedBy: ",").filter { !$0.isEmpty }
    }

    private func convertIcons(_ icons: [TreeNodeContent.Icon]?) -> [IconState] {
        let hiddenIcons = state.toolbar.icons.hidden
        return icons?.map { icon in
            IconState(
                icon: icon,
                isHidden: hiddenIcons.contains(icon.sfSymbol)
            )
        } ?? []
    }
}
