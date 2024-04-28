import Foundation

final class UserDefaultsStorage {
    private let fileURLKey = "last_input_path"
    var fileURL: URL? {
        get { UserDefaults.standard.url(forKey: fileURLKey) }
        set { UserDefaults.standard.set(newValue, forKey: fileURLKey) }
    }
}

extension UserDefaultsStorage: ObservableObject {}
