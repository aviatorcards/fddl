import ArgumentParser
import Foundation

struct Generate: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Static Site Generator using markdown files"
    )

    @Option(name: .shortAndLong, help: "Template to use:")
    var template: String = "default"

    @Option(name: .shortAndLong, help: "Working directory")
    var directory: String = "."

    @Flag(name: .shortAndLong, help: "Verbose output")
    var verbose: Bool = false

    mutating func run() throws {
        let workingDir = URL(fileURLWithPath: directory)
        let generator = SiteGenerator(workingDirectory: workingDir)

        do {
            try generator.generate(templateName: template)
        } catch {
            print("\nError: \(error.localizedDescription)")
            throw ExitCode.failure
        }
    }
}
