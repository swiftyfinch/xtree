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
    var onUpdate: () -> Void

    @FocusState var focusState: FocusField?
    @State private var restore: FocusField?

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                if focusState != nil { restore = focusState }
                let animationDuration: TimeInterval = 0.3
                let animation: Animation = .easeInOut(duration: animationDuration)
                let animationBlock: () -> Void = {
                    state.isFiltersBlockShown.toggle()
                }
                let completionBlock: () -> Void = {
                    if focusState == nil { focusState = restore ?? .roots }
                }

                if #available(macOS 14.0, *) {
                    withAnimation(animation, animationBlock, completion: completionBlock)
                } else {
                    withAnimation(animation) {
                        animationBlock()
                        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: completionBlock)
                    }
                }
            }, label: {
                Image(systemName: "magnifyingglass.circle.fill")
                    .imageScale(.large)
                    .offset(y: 1)
            })
            .keyboardShortcut(.init(.init("F"), modifiers: .command))
            .help(state.isFiltersBlockShown ? "Hide filters" : "Show filters")

            IconsMenu(state: $state.icons)
                .help("Show or hide nodes by icon type")

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
                onUpdate()
            }, label: {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .imageScale(.large)
                    .offset(y: 1)
            })
            .help("Read again the current tree input file")
        }

        Picker("", selection: $state.sorting) {
            ForEach(state.sortingValues, id: \.self) { value in
                HStack {
                    Image(systemName: "arrow.up.arrow.down.square.fill")
                    Text(value)
                }
            }
        }
        .help("Sorting by")

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
