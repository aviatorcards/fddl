import ArgumentParser

struct FDDL: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "fddl",
        abstract: "A markdown-based static site generator",
        version: "0.5.0",
        subcommands: [Generate.self, Serve.self, Deploy.self, Version.self],
        defaultSubcommand: Generate.self
    )
}

FDDL.main()
