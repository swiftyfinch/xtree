import SwiftUI

struct IconState: Equatable {
    let icon: TreeNodeContent.Icon
    var isHidden: Bool
}

struct IconsMenu: View {
    @Binding var state: [IconState]

    var body: some View {
        Menu {
            ForEach(Array(state.enumerated()), id: \.offset) { index, icon in
                Button(action: {
                    state[index].isHidden.toggle()
                }, label: {
                    buildButtonLabel(icon)
                })
            }
        } label: {
            Image(systemName: "square.filled.on.square")
        }
    }

    private func buildButtonLabel(_ state: IconState) -> some View {
        HStack {
            if state.isHidden {
                Text("Show").foregroundStyle(.hidden)
                Image(systemName: state.icon.sfSymbol).foregroundStyle(.hidden, .hidden)
            } else {
                Text("Hide")
                Image(systemName: state.icon.sfSymbol)
                    .foregroundStyle(
                        Color(hex: state.icon.primaryColor),
                        state.icon.secondaryColor.map(Color.init(hex:)) ?? Color(hex: state.icon.primaryColor)
                    )
            }
        }
    }
}

private extension ShapeStyle where Self == Color {
    static var hidden: Color {
        Color(hex: 0x9DA1A7).opacity(0.5)
    }
}
