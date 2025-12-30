import Foundation
import ArgumentParser

struct Deploy: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "deploy",
        abstract: "Deploy your site to Neocities"
    )

    @Option(name: .shortAndLong, help: "Neocities username")
    var username: String?

    @Option(name: .shortAndLong, help: "Neocities API key or password")
    var apiKey: String?

    @Option(name: .shortAndLong, help: "Path to output directory")
    var outputDir: String = "output"

    @Flag(name: .long, help: "Dry run - show what would be uploaded without actually uploading")
    var dryRun: Bool = false

    mutating func run() throws {
        print("🚀 fddl Neocities Deployer")
        print("")

        // Get credentials from environment if not provided
        let finalUsername = username ?? ProcessInfo.processInfo.environment["NEOCITIES_USER"]
        let finalApiKey = apiKey ?? ProcessInfo.processInfo.environment["NEOCITIES_API_KEY"]

        guard let user = finalUsername, !user.isEmpty else {
            throw DeployError.missingUsername
        }

        guard let key = finalApiKey, !key.isEmpty else {
            throw DeployError.missingAPIKey
        }

        let workingDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let outputDirectory = workingDirectory.appendingPathComponent(outputDir)

        guard FileManager.default.fileExists(atPath: outputDirectory.path) else {
            throw DeployError.outputDirectoryNotFound(outputDir)
        }

        print("📁 Output directory: \(outputDirectory.path)")
        print("👤 Neocities user: \(user)")
        print("")

        if dryRun {
            print("🔍 DRY RUN - No files will be uploaded")
            print("")
        }

        // Deploy to Neocities
        let deployer = NeocitiesDeployer(username: user, apiKey: key)
        try deployer.deploy(from: outputDirectory, dryRun: dryRun)

        if !dryRun {
            print("")
            print("✅ Deployment complete!")
            print("🌐 Visit your site at: https://\(user).neocities.org")
        }
    }
}

/// Handles deployment to Neocities
class NeocitiesDeployer {
    private let username: String
    private let apiKey: String
    private let baseURL = "https://neocities.org/api"

    init(username: String, apiKey: String) {
        self.username = username
        self.apiKey = apiKey
    }

    func deploy(from directory: URL, dryRun: Bool) throws {
        // Get all files to upload
        let files = try collectFiles(from: directory)

        print("📦 Found \(files.count) files to upload")

        if dryRun {
            print("")
            print("Files that would be uploaded:")
            for (remotePath, _) in files {
                print("  • \(remotePath)")
            }
            return
        }

        print("")
        print("⬆️  Uploading files...")

        // Upload files in batches (Neocities API can handle multiple files per request)
        let batchSize = 50
        var uploaded = 0

        for batch in files.chunked(into: batchSize) {
            try uploadBatch(batch)
            uploaded += batch.count
            print("  ✓ Uploaded \(uploaded)/\(files.count) files")
        }
    }

    private func collectFiles(from directory: URL) throws -> [(remotePath: String, localURL: URL)] {
        var files: [(String, URL)] = []
        let fileManager = FileManager.default

        let enumerator = fileManager.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        )

        guard let enumerator = enumerator else {
            throw DeployError.cannotEnumerateFiles
        }

        for case let fileURL as URL in enumerator {
            let attributes = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
            guard attributes.isRegularFile == true else { continue }

            let relativePath = fileURL.path.replacingOccurrences(
                of: directory.path + "/",
                with: ""
            )

            files.append((relativePath, fileURL))
        }

        return files
    }

    private func uploadBatch(_ files: [(remotePath: String, localURL: URL)]) throws {
        let url = URL(string: "\(baseURL)/upload")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Create basic auth
        let credentials = "\(username):\(apiKey)"
        let credentialsData = credentials.data(using: .utf8)!
        let base64Credentials = credentialsData.base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")

        // Create multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        for (remotePath, localURL) in files {
            let fileData = try Data(contentsOf: localURL)
            let mimeType = mimeType(for: remotePath)

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(remotePath)\"; filename=\"\(remotePath)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // Perform upload
        let semaphore = DispatchSemaphore(value: 0)
        var uploadError: Error?

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }

            if let error = error {
                uploadError = error
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                uploadError = DeployError.invalidResponse
                return
            }

            if httpResponse.statusCode != 200 {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    uploadError = DeployError.uploadFailed(statusCode: httpResponse.statusCode, message: responseString)
                } else {
                    uploadError = DeployError.uploadFailed(statusCode: httpResponse.statusCode, message: "Unknown error")
                }
            }
        }

        task.resume()
        semaphore.wait()

        if let error = uploadError {
            throw error
        }
    }

    private func mimeType(for path: String) -> String {
        let ext = (path as NSString).pathExtension.lowercased()

        switch ext {
        case "html", "htm": return "text/html"
        case "css": return "text/css"
        case "js": return "application/javascript"
        case "json": return "application/json"
        case "xml": return "application/xml"
        case "txt": return "text/plain"
        case "png": return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "gif": return "image/gif"
        case "svg": return "image/svg+xml"
        case "ico": return "image/x-icon"
        case "woff": return "font/woff"
        case "woff2": return "font/woff2"
        case "ttf": return "font/ttf"
        case "pdf": return "application/pdf"
        default: return "application/octet-stream"
        }
    }
}

enum DeployError: LocalizedError {
    case missingUsername
    case missingAPIKey
    case outputDirectoryNotFound(String)
    case cannotEnumerateFiles
    case invalidResponse
    case uploadFailed(statusCode: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .missingUsername:
            return """
            Neocities username not provided.
            Provide it via --username flag or NEOCITIES_USER environment variable.
            """
        case .missingAPIKey:
            return """
            Neocities API key not provided.
            Provide it via --api-key flag or NEOCITIES_API_KEY environment variable.
            Get your API key at: https://neocities.org/settings
            """
        case .outputDirectoryNotFound(let dir):
            return "Output directory not found: \(dir). Run 'fddl generate' first."
        case .cannotEnumerateFiles:
            return "Cannot enumerate files in output directory"
        case .invalidResponse:
            return "Invalid response from Neocities API"
        case .uploadFailed(let statusCode, let message):
            return "Upload failed with status \(statusCode): \(message)"
        }
    }
}

// Helper extension for array chunking
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
