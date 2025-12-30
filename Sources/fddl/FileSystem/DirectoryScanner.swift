import Foundation

/// Scans directories for markdown files
class DirectoryScanner {
    let rootDirectory: URL

    init(rootDirectory: URL) {
        self.rootDirectory = rootDirectory
    }

    /// Find all markdown files in the directory tree
    func findMarkdownFiles() throws -> [URL] {
        var markdownFiles: [URL] = []
        let fileManager = FileManager.default

        guard let enumerator = fileManager.enumerator(
            at: rootDirectory,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            throw ScannerError.cannotEnumerateDirectory(rootDirectory.path)
        }

        for case let fileURL as URL in enumerator {
            // Check if it's a regular file
            let resourceValues = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
            guard resourceValues.isRegularFile == true else { continue }

            // Check if it's a markdown file
            let pathExtension = fileURL.pathExtension.lowercased()
            if pathExtension == "md" || pathExtension == "markdown" {
                markdownFiles.append(fileURL)
            }
        }

        return markdownFiles.sorted { $0.path < $1.path }
    }
}

enum ScannerError: LocalizedError {
    case cannotEnumerateDirectory(String)

    var errorDescription: String? {
        switch self {
        case .cannotEnumerateDirectory(let path):
            return "Cannot enumerate directory: \(path)"
        }
    }
}
