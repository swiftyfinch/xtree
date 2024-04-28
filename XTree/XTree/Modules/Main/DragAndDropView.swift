import SwiftUI

struct DragAndDropView: View {
    @EnvironmentObject var userDefaultsStorage: UserDefaultsStorage

    @Binding var isInDropArea: Bool
    let onDrop: (URL) -> Bool

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            if isInDropArea {
                Color.clear.overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.tertiary, style: StrokeStyle(dash: [4]))
                        .fill(Color.white.opacity(0.03))
                        .padding(10)
                        .opacity(isInDropArea ? 1 : 0)
                )
            }

            VStack(alignment: .center, spacing: 6) {
                VStack(spacing: 6) {
                    Image(systemName: "tray.and.arrow.down")
                        .font(.system(size: 20))
                    Text(String.dragHelp)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                }
                .padding(30)
                .background(.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white.opacity(0.3), lineWidth: 0.5).cornerRadius(8)
                )
                .cornerRadius(8)

                if let lastInputPath = userDefaultsStorage.fileURL {
                    Button(action: {
                        _ = onDrop(lastInputPath)
                    }, label: {
                        Text("Open " + lastInputPath.suffixPath()).font(.system(size: 12))
                    })
                }
                Button(action: {
                    let panel = NSOpenPanel()
                    panel.canChooseDirectories = true
                    if panel.runModal() == .OK, let fileURL = panel.url {
                        _ = onDrop(fileURL)
                    }
                }, label: {
                    Text("Open File").font(.system(size: 12))
                })
            }
            .foregroundColor(.secondary)
            .opacity(isInDropArea ? 0.3 : 1)
        }
        .dropDestination(
            for: URL.self,
            action: { items, _ in items.first.map(onDrop) == true },
            isTargeted: { isInDropArea = $0 }
        )
    }
}

private extension String {
    static let dragHelp = "Drag *.xcodeproj, Podfile.lock or\n*.yml/*.yaml file"
}

private extension URL {
    func suffixPath(upTo components: Int = 4) -> String {
        pathComponents.suffix(components).joined(separator: "/")
    }
}
