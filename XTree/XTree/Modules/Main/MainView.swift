import SwiftUI
import Combine

class MainState: ObservableObject {
    @Published var filters = FiltersViewState()
    @Published var toolbar = ToolBarState()
    @Published var isInDropArea = false
    @Published var tree: TreeViewState?
    
    private var ignoresChanges = false
    private var bag = Set<AnyCancellable>()
    
    func onToolbarChange(_ onChange: @escaping (@escaping () -> Void) -> Void) {
        guard bag.isEmpty else { return }
        $toolbar.sink(receiveValue: { [weak self] value in
            guard let self = self, !ignoresChanges else { return }
            self.ignoresChanges = true
            onChange {
                self.ignoresChanges = false
            }
        }).store(in: &bag)
    }
}

struct MainView: View {
    @EnvironmentObject var treeBuilder: TreeBuilder
    @ObservedObject private var state: MainState = MainState()
    @FocusState var focusState: FocusField?

    var body: some View {
        VStack(spacing: 0) {
            Color(.background).frame(height: 40).zIndex(2)
            if state.toolbar.isFiltersBlockShown {
                let filtersView = FiltersView(
                    filtersState: $state.filters,
                    focusState: _focusState,
                    onSubmit: update
                ).padding(.horizontal, 12)
                
                if #available(macOS 14.0, *) {
                    filtersView.transition(.move(edge: .top).combined(with: .blurReplace))
                } else {
                    // no transition
                }
                
                // returns view
                filtersView
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
                onUpdate: update,
                focusState: _focusState
            )
            .disabled(state.tree == nil)
        }
    }
    
    private func update() {
        self.update(completion: nil)
    }

    private func update(completion: (() -> Void)?) {
        guard treeBuilder.hasFileURL() else { return }
        state.onToolbarChange(update(completion:))
        
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
            completion?()
        }
    }

    private func formatFilters(_ filters: String) -> Set<String> {
        Set(filters.components(separatedBy: ",").filter { !$0.isEmpty })
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
