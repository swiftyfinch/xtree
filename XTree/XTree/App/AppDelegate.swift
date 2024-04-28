import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        setupMenu()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }

    private func setupMenu() {
        if let mainMenu = NSApp.mainMenu {
            let app = mainMenu.item(withTitle: "XTree")
            let about = app?.submenu?.item(withTitle: "About XTree").map {
                NSMenuItem(title: $0.title, action: $0.action, keyEquivalent: $0.keyEquivalent)
            }
            let quit = app?.submenu?.item(withTitle: "Quit XTree").map {
                NSMenuItem(title: $0.title, action: $0.action, keyEquivalent: $0.keyEquivalent)
            }
            let submenu = NSMenu()
            submenu.items = [about, NSMenuItem.separator(), quit].compactMap { $0 }
            app?.submenu = submenu

            ["File", "View", "Help"].forEach { name in
                mainMenu.item(withTitle: name).map { mainMenu.removeItem($0) }
            }
        }
    }
}
