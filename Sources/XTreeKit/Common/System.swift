import Darwin

// MARK: - Interface

public enum MachineArchitecture: String {
    case x86_64 // swiftlint:disable:this identifier_name
    case arm64
}

public protocol ISystem: AnyObject {
    func architecture() -> MachineArchitecture
}

// MARK: - Implementation

final class System {}

// MARK: - ISystem

extension System: ISystem {
    // https://stackoverflow.com/a/25467259/6197314
    func architecture() -> MachineArchitecture {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine).hasPrefix("arm64") ? .arm64 : .x86_64
    }
}
