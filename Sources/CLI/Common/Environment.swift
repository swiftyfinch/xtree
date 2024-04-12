import Fish
import XTreeKit

extension Environment {
    static var repositoryPath: String { "swiftyfinch/xtree" }
    static var binName: String { "xtree" }
    static var binFolderPath: String { Folder.home.subpath(".local/bin") }
    static var downloadsPath: String { Folder.home.subpath(".xtree/downloads") }
}
