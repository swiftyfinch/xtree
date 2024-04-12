import Darwin

public enum System {
    public enum Architecture: String {
        case x86_64 // swiftlint:disable:this identifier_name
        case arm64
    }

    // https://stackoverflow.com/a/25467259/6197314
    public static func architecture() -> Architecture {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine).hasPrefix("arm64") ? .arm64 : .x86_64
    }
}
