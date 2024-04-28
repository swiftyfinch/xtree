import SwiftUI

struct FilterTextField: View {
    @FocusState var isFocused: Bool

    @Binding var text: String
    let placeholder: String
    let onClear: () -> Void

    var body: some View {
        HStack(spacing: 5) {
            TextField(placeholder, text: $text)
                .font(.system(size: 11))
                .disableAutocorrection(true)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)

            if !text.isEmpty {
                Button {
                    text = ""
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .foregroundColor(.secondary)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 5)
        .frame(height: 22)
        .background(Color(nsColor: isFocused ? .textBackgroundColor : .background))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.tertiary).cornerRadius(8)
        )
    }
}
