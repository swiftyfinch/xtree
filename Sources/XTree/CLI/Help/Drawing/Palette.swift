import Rainbow

extension String {
    var accent: String { green }
    var secondary: String { white.dim }
    var tertiary: String { yellow }
}

extension Color {
    static let accent: Color = .green
}

extension Style {
    static let secondary: Style = .dim
}
