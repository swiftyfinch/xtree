import SwiftUI

enum FocusField: Int, Hashable {
    case roots, contains, except, filter
}

struct FiltersViewState {
    var roots = ""
    var contains = ""
    var except = ""
    var filter = ""
}

struct FiltersView: View {
    @Binding var filtersState: FiltersViewState
    @FocusState var focusState: FocusField?
    var onSubmit: () -> Void

    var body: some View {
        VStack(spacing: 2) {
            FilterTextField(
                text: $filtersState.roots,
                placeholder: "Roots (Separated by comma, supports wildcards)",
                onClear: onSubmit
            )
            .onSubmit(onSubmit)
            .focused($focusState, equals: .roots)

            FilterTextField(
                text: $filtersState.contains,
                placeholder: "Contains (Separated by comma, supports wildcards)",
                onClear: onSubmit
            )
            .onSubmit(onSubmit)
            .focused($focusState, equals: .contains)

            FilterTextField(
                text: $filtersState.except,
                placeholder: "Except (Separated by comma, supports wildcards)",
                onClear: onSubmit
            )
            .onSubmit(onSubmit)
            .focused($focusState, equals: .except)

            FilterTextField(
                text: $filtersState.filter,
                placeholder: "Filter (Any match)",
                onClear: onSubmit
            )
            .onSubmit(onSubmit)
            .focused($focusState, equals: .filter)
        }
    }
}
