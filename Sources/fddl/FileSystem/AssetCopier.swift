import Foundation

/// Copies template assets to the output directory
class AssetCopier {
    /// Copy assets from template directory to output directory
    func copyAssets(from sourceDir: URL, to destinationDir: URL) throws {
        let fileManager = FileManager.default

        // Check if source assets directory exists
        guard fileManager.fileExists(atPath: sourceDir.path) else {
            print("  ⚠ No assets directory found at \(sourceDir.path)")
            return
        }

        // Remove existing destination directory if it exists
        if fileManager.fileExists(atPath: destinationDir.path) {
            try fileManager.removeItem(at: destinationDir)
        }

        // Copy entire assets directory
        try fileManager.copyItem(at: sourceDir, to: destinationDir)

        // Count copied files
        let count = try countFiles(in: destinationDir)
        print("  ✓ Copied \(count) asset files")
    }

    /// Count files in a directory recursively
    private func countFiles(in directory: URL) throws -> Int {
        let fileManager = FileManager.default
        var count = 0

        guard let enumerator = fileManager.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey]
        ) else {
            return 0
        }

        for case let fileURL as URL in enumerator {
            let resourceValues = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
            if resourceValues.isRegularFile == true {
                count += 1
            }
        }

        return count
    }
}
