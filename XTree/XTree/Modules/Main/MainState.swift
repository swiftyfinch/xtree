import Combine

final class MainState: ObservableObject {
    @Published var filters = FiltersViewState()
    @Published var toolbar = ToolBarState()
    @Published var isInDropArea = false
    @Published var tree: TreeViewState?

    private var ignoresChanges = false
    private var bag = Set<AnyCancellable>()

    func onToolbarChange(_ onChange: @escaping (@escaping () -> Void) -> Void) {
        guard bag.isEmpty else { return }
        $toolbar.sink(receiveValue: { [weak self] _ in
            guard let self = self, !ignoresChanges else { return }
            self.ignoresChanges = true
            onChange {
                self.ignoresChanges = false
            }
        }).store(in: &bag)
    }
}
