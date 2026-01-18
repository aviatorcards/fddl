import ArgumentParser
import Foundation

struct Serve: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "serve",
        abstract: "Start development server with live reload"
    )

    @Option(name: .shortAndLong, help: "Port to run server on")
    var port: Int = 8080

    @Option(name: .shortAndLong, help: "Host to bind to")
    var host: String = "127.0.0.1"

    @Option(name: .shortAndLong, help: "Template name to use")
    var template: String = "default"

    @Flag(name: .long, help: "Open browser automatically")
    var open: Bool = false

    mutating func run() throws {
        let workingDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let outputDirectory = workingDirectory.appendingPathComponent("output")
        let templateName = self.template

        print("🔨 fddl development server")
        print("")

        // Warn if binding to non-local address
        if host != "127.0.0.1" && host != "localhost" {
            print("⚠️  WARNING: Binding to \(host) exposes dev server to network")
            print("   This is intended for development only, not production!")
            print("")
        }

        // Initial build
        try buildSite(workingDirectory: workingDirectory, templateName: templateName)
        print("")

        // Set up file watchers
        let contentsWatcher = FileWatcher(
            directory: workingDirectory.appendingPathComponent("contents"))
        let templatesWatcher = FileWatcher(
            directory: workingDirectory.appendingPathComponent("templates"))

        var isRebuilding = false

        let rebuild = { [workingDirectory, templateName] in
            guard !isRebuilding else { return }
            isRebuilding = true

            print("\n📝 Changes detected, rebuilding...")

            do {
                let generator = SiteGenerator(workingDirectory: workingDirectory)
                try generator.generate(templateName: templateName)
                print("✅ Build complete!")

                // Notify browser to reload
                if let server = Self.devServer {
                    server.notifyReload()
                }
            } catch {
                print("❌ Build failed: \(error.localizedDescription)")
            }

            isRebuilding = false
        }

        contentsWatcher.onChange = rebuild
        templatesWatcher.onChange = rebuild

        try contentsWatcher.start()
        try templatesWatcher.start()

        // Start dev server
        print("")
        let server = DevServer(host: host, port: port, documentRoot: outputDirectory)
        self.devServer = server

        // Open browser if requested
        if open {
            openBrowser(url: "http://\(host):\(port)")
        }

        // Start server (blocks)
        try server.start()
    }

    private func buildSite(workingDirectory: URL, templateName: String) throws {
        let generator = SiteGenerator(workingDirectory: workingDirectory)
        try generator.generate(templateName: templateName)
    }

    private func openBrowser(url: String) {
        #if os(macOS)
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
            task.arguments = [url]
            try? task.run()
        #endif
    }

    // Keep reference to server
    private static var devServer: DevServer?
    private var devServer: DevServer? {
        get { Self.devServer }
        set { Self.devServer = newValue }
    }
}
