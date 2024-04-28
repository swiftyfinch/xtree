import Foundation
import XTreeKit

final class TreeBuilder: ObservableObject {
    private let treeManager: ITreeManager
    private let treeViewModelBuilder: TreeViewModelBuilder
    private let userDefaultsStorage: UserDefaultsStorage

    // State
    private var fileURL: URL?

    init(treeManager: ITreeManager,
         treeViewModelBuilder: TreeViewModelBuilder,
         userDefaultsStorage: UserDefaultsStorage) {
        self.treeManager = treeManager
        self.treeViewModelBuilder = treeViewModelBuilder
        self.userDefaultsStorage = userDefaultsStorage
    }

    func saveFileURL(_ fileURL: URL) {
        self.fileURL = fileURL
    }

    func build(
        roots: [String],
        contains: [String],
        except: [String],
        sorting: String,
        isCompressed: Bool,
        filterText: String,
        completion: @escaping (TreeViewState?) -> Void
    ) {
        guard let fileURL else { return completion(nil) }
        Task.detached {
            do {
                let tree = try await self.treeManager.print(
                    inputPath: fileURL.path,
                    filter: .init(
                        roots: roots,
                        contains: contains,
                        except: except,
                        maxHeight: nil
                    ),
                    sort: Sort(rawValue: sorting.lowercased()) ?? .name,
                    needsCompress: isCompressed
                )
                self.userDefaultsStorage.fileURL = fileURL
                let adjacentList = self.treeViewModelBuilder.buildAdjacentList(
                    root: tree,
                    filterText: filterText
                )
                Task { @MainActor in
                    completion(TreeViewState(
                        id: fileURL.path,
                        root: tree.name,
                        adjacentList: adjacentList,
                        highlightText: filterText
                    ))
                }
            } catch {
                Task { @MainActor in
                    completion(nil)
                }
            }
        }
    }
}
