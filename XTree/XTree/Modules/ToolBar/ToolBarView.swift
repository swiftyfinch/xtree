import SwiftUI

struct ToolBarState {
    var isFiltersBlockShown = false
    let sortingValues = ["Name", "Children", "Height"]
    var sorting = "Name"
    var isCompressed = true
    var isProcessing = false
    var icons: [IconState] = []
}

struct ToolBarView: View {
    @Binding var state: ToolBarState
    var onTrash: () -> Void

    @FocusState var focusState: FocusField?
    @State private var restore: FocusField?

    var body: some View {
        Button(action: {
            if focusState != nil { restore = focusState }
            withAnimation(.easeInOut(duration: 0.3), {
                state.isFiltersBlockShown.toggle()
            }, completion: {
                if focusState == nil { focusState = restore ?? .roots }
            })
        }, label: {
            Image(systemName: "magnifyingglass.circle.fill")
                .imageScale(.large)
                .offset(y: 1)
        })
        .keyboardShortcut(.init(.init("F"), modifiers: .command))
        .help(state.isFiltersBlockShown ? "Hide filters" : "Show filters")

        IconsMenu(state: $state.icons)

        Picker("", selection: $state.sorting) {
            ForEach(state.sortingValues, id: \.self) { value in
                HStack {
                    Image(systemName: "arrow.up.arrow.down.square.fill")
                    Text(value)
                }
            }
        }
        .help("Sorting by")

        Button(action: {
            state.isCompressed.toggle()
        }, label: {
            Image(
                systemName: state.isCompressed
                    ? "arrow.up.backward.and.arrow.down.forward.circle.fill"
                    : "arrow.down.right.and.arrow.up.left.circle.fill"
            )
            .rotationEffect(.degrees(45))
            .imageScale(.large)
            .offset(y: 1)
        })
        .help(state.isCompressed ? "Show redundant explicit dependencies" : "Hide redundant explicit dependencies")

        Button(action: {
            state.isFiltersBlockShown = false
            onTrash()
        }, label: {
            Image(systemName: "trash.circle.fill")
                .imageScale(.large)
                .offset(y: 1)
        })
        .help("Close the current tree input file")

        Spacer()

        if state.isProcessing {
            ProgressView().controlSize(.mini).opacity(0.5).padding(.trailing, 4)
        }
    }
}

extension [IconState] {
    var hidden: Set<String> {
        Set(filter(\.isHidden).map(\.icon.sfSymbol))
    }
}
