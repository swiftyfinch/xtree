import SwiftUI

@main
struct XTreeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let vault = Vault()

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(.background).ignoresSafeArea()
                MainView()
                    .environmentObject(vault.treeBuilder)
                    .environmentObject(vault.userDefaultsStorage)
                    .environmentObject(vault.treeRowTitleFormatter)
            }
            .preferredColorScheme(.dark)
            .frame(
                minWidth: .baseWidth,
                idealWidth: .baseWidth,
                minHeight: .baseHeight,
                idealHeight: .baseHeight
            )
        }
        .windowToolbarStyle(.unified(showsTitle: false))
        .windowStyle(.hiddenTitleBar)
    }
}

private extension CGFloat {
    static let baseHeight: CGFloat = 320
    static let baseWidth: CGFloat = 320
}
