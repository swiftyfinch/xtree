import Fish
import Foundation
import ZIPFoundation

final class GitHubUpdater {
    private let repositoryPath: String
    private let downloadsPath: String
    private let binName: String
    private let binFolderPath: String
    private let urlSessionManager = URLSessionManager()
    private let fileManager = FileManager.default

    private let versionRegex = #/.*download/(.*)/.*/#
    private var baseURL: URL! { URL(string: "https://github.com/\(repositoryPath)/releases/") }

    init(
        repositoryPath: String,
        downloadsPath: String,
        binName: String,
        binFolderPath: String
    ) {
        self.repositoryPath = repositoryPath
        self.downloadsPath = downloadsPath
        self.binName = binName
        self.binFolderPath = binFolderPath
    }

    // https://docs.github.com/en/repositories/releasing-projects-on-github/linking-to-releases
    func loadLatestVersion() async throws -> String? {
        let architecture: System.Architecture = .arm64
        let url = baseURL.appending(path: "latest/download/\(architecture.rawValue).zip")
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        let redirectionLocation = try await urlSessionManager.data(from: url).redirectionLocation

        return redirectionLocation.flatMap(parseVersion(location:))
    }

    // https://github.com/swiftyfinch/xtree/releases/download/1.0.0/arm64.zip
    // https://github.com/swiftyfinch/xtree/releases/download/1.0.0/x86_64.zip
    func install(version: String) async throws {
        let architecture = System.architecture()
        let url = baseURL.appending(path: "download/\(version)/\(architecture.rawValue).zip")
        let (fileURL, _) = try await urlSessionManager.download(from: url)

        let downloads = try Folder.create(at: downloadsPath)
        try downloads.emptyFolder()
        let downloadsURL = URL(fileURLWithPath: downloads.path)
        try fileManager.unzipItem(at: fileURL, to: downloadsURL)

        let binFile = try downloads.file(named: binName)
        try binFile.move(to: binFolderPath, replace: true)
        try downloads.delete()
    }

    private func parseVersion(location: String) -> String? {
        // https://github.com/swiftyfinch/xtree/releases/download/1.0.0/arm64.zip
        if let output = location.firstMatch(of: versionRegex)?.output {
            return String(output.1)
        }
        return nil
    }
}

// MARK: - URLSessionManager

private final class URLSessionManager: NSObject {
    private var redirectionLocation: String?

    func data(from url: URL) async throws -> (data: Data, response: URLResponse, redirectionLocation: String?) {
        let result = try await URLSession.shared.data(from: url, delegate: self)
        return (result.0, result.1, redirectionLocation)
    }

    func download(from url: URL) async throws -> (URL, URLResponse) {
        try await URLSession.shared.download(from: url)
    }
}

extension URLSessionManager: URLSessionTaskDelegate {
    func urlSession(
        _: URLSession,
        task _: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest _: URLRequest
    ) async -> URLRequest? {
        redirectionLocation = response.allHeaderFields["Location"] as? String
        return nil
    }
}
