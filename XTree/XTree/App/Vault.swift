import XTreeKit

final class Vault {
    private(set) lazy var userDefaultsStorage = UserDefaultsStorage()
    private(set) lazy var treeViewModelBuilder = TreeViewModelBuilder()
    private(set) lazy var treeBuilder = TreeBuilder(
        treeManager: XTreeKit.Vault.shared.treeManager,
        treeViewModelBuilder: treeViewModelBuilder,
        userDefaultsStorage: userDefaultsStorage
    )
    private(set) lazy var treeRowTitleFormatter = TreeRowTitleFormatter()
}
