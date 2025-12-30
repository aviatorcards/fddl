import ArgumentParser
import Foundation

struct Version: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Display version and build information"
    )

    @Option(name: .shortAndLong, help: "Working directory")
    var directory: String = "."

    func run() throws {
        print("fddl version 0.1.0")

        let workingDir = URL(fileURLWithPath: directory)
        if let buildID = BuildInfo.getCurrentBuildID(in: workingDir) {
            print("Current build: \(buildID)")
        } else {
            print("No builds yet in this directory")
        }
    }
}
