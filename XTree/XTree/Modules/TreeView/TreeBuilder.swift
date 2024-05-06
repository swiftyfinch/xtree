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
        hiddenIcons: Set<String>,
        completion: @escaping (TreeViewState?) -> Void
    ) {
        guard let fileURL else { return completion(nil) }
        Task.detached {
            do {
                var filter = TreeFilterOptions(roots: roots, contains: contains, except: except, exceptIcons: [])
                let sort = Sort(rawValue: sorting.lowercased()) ?? .name
                let adjacentList = try await self.buildAdjacentList(
                    path: fileURL.path,
                    filter: filter,
                    sort: sort,
                    needsCompress: isCompressed,
                    filterText: filterText
                )
                self.userDefaultsStorage.fileURL = fileURL

                let icons = self.icons(adjacentList: adjacentList)
                let filteredAdjacentList: [String: TreeNodeContent]
                if hiddenIcons.isEmpty {
                    filteredAdjacentList = adjacentList
                } else {
                    filter.exceptIcons.formUnion(hiddenIcons)
                    filteredAdjacentList = try await self.buildAdjacentList(
                        path: fileURL.path,
                        filter: filter,
                        sort: sort,
                        needsCompress: isCompressed,
                        filterText: filterText
                    )
                }

                Task { @MainActor in
                    completion(TreeViewState(
                        id: fileURL.path,
                        root: ".",
                        adjacentList: filteredAdjacentList,
                        highlightText: filterText,
                        icons: icons
                    ))
                }
            } catch {
                Task { @MainActor in
                    completion(nil)
                }
            }
        }
    }

    private func buildAdjacentList(
        path: String,
        filter: TreeFilterOptions,
        sort: Sort,
        needsCompress: Bool,
        filterText: String
    ) async throws -> [String: TreeNodeContent] {
        let tree = try await treeManager.print(
            inputPath: path,
            filter: filter,
            sort: sort,
            needsCompress: needsCompress
        )
        return treeViewModelBuilder.buildAdjacentList(
            root: tree,
            filterText: filterText
        )
    }

    private func icons(adjacentList: [String: TreeNodeContent]) -> [TreeNodeContent.Icon] {
        adjacentList.values
            .reduce(into: [:]) { map, content in
                guard let icon = content.icon else { return }
                map[icon.sfSymbol] = icon
            }
            .values
            .sorted { $0.sfSymbol < $1.sfSymbol }
    }
}
