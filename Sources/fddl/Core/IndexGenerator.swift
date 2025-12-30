import Foundation

/// Generates index pages for directories
class IndexGenerator {
    private let templateEngine: TemplateEngine
    private let outputTemplate: OutputTemplate

    init(templateEngine: TemplateEngine, outputTemplate: OutputTemplate) {
        self.templateEngine = templateEngine
        self.outputTemplate = outputTemplate
    }

    /// Generate index pages for all directories containing content
    func generateIndexPages(for site: Site, outputDirectory: URL) throws {
        // Find all unique directories
        let directories = findDirectories(in: site.pages)

        for directory in directories {
            try generateIndexPage(for: directory, site: site, outputDirectory: outputDirectory)
        }
    }

    /// Find all unique directories from page paths
    private func findDirectories(in pages: [Page]) -> Set<String> {
        var directories = Set<String>()

        for page in pages {
            let pathComponents = page.path.split(separator: "/").dropLast()
            if !pathComponents.isEmpty {
                let directory = pathComponents.joined(separator: "/") + "/"
                directories.insert(directory)
            }
        }

        return directories
    }

    /// Generate an index page for a specific directory
    private func generateIndexPage(for directory: String, site: Site, outputDirectory: URL) throws {
        // Create a virtual index page for this directory
        let indexPage = Page(
            path: directory + "index.md",
            frontMatter: FrontMatter(
                title: directoryTitle(from: directory),
                description: "Index of \(directory)",
                date: nil,
                tags: nil,
                layout: nil
            ),
            content: "",
            rawMarkdown: "",
            modifiedDate: Date()
        )

        // Create template context with pages in this directory
        let context = TemplateContext.create(
            site: site,
            page: indexPage,
            currentDirectory: directory
        )

        // Use index view if specified, otherwise use default view
        let viewPath = outputTemplate.indexView ?? outputTemplate.view
        let viewTemplate = try templateEngine.loadView(named: viewPath)

        // Render the template
        let renderedHTML = templateEngine.render(template: viewTemplate, context: context)

        // Write to output directory
        let outputPath = outputDirectory
            .appendingPathComponent(directory)
            .appendingPathComponent("index\(outputTemplate.fileExtension)")

        // Create directory if needed
        let outputDir = outputPath.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

        // Write file
        try renderedHTML.write(to: outputPath, atomically: true, encoding: String.Encoding.utf8)

        print("Generated index: \(directory)index.html")
    }

    /// Extract a nice title from a directory path
    private func directoryTitle(from directory: String) -> String {
        let trimmed = directory.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let components = trimmed.split(separator: "/")

        if let last = components.last {
            // Convert "blog-posts" to "Blog Posts"
            return String(last)
                .replacingOccurrences(of: "-", with: " ")
                .replacingOccurrences(of: "_", with: " ")
                .capitalized
        }

        return "Index"
    }
}
