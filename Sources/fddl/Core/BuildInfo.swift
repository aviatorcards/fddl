import Foundation

/// Manages build number tracking for site generation
struct BuildInfo {
    static let buildInfoFileName = ".fddl-build"

    /// Increments and returns the next build number
    static func generateBuildID(in directory: URL) throws -> String {
        // appendingPathComponent() is deprecated
        // I think this is the correct way to do this below?
        let buildInfoPath = directory.appending(path: buildInfoFileName)

        // Create UUID
        let newBuildID = UUID().uuidString
        
        // Save to file with new .appending() fix
        try newBuildID.write(to: buildInfoPath, atomically: true, encoding: .utf8)
        
        return newBuildID
    }

    /// Renamed and return type changed to String
    static func getCurrentBuildID(in directory: URL) -> String? {
        // corrected .appendingPathComponent
        let buildInfoPath = directory.appending(path: buildInfoFileName)
        guard let content = try? String(contentsOf: buildInfoPath, encoding: .utf8) else {
            return nil
        }
        // Clean up whitespace & newlines
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Creating a git helper
    static func getGitCommitHash() -> String {
        let process = Process()
        process.executableURL = URL(filePath: "/usr/bin/git")
        process.arguments = ["rev-parse", "--short", "HEAD"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        // Swift will crash if nil if told - if statement to calm it down.
        do {
            try process.run()
            
            if let data = try? pipe.fileHandleForReading.readToEnd() {
                // Convert data to string and trim newlines
                return String(data: data, encoding: .utf8)?
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            
            return ""
        } catch {
            return ""
        }
    }
}
