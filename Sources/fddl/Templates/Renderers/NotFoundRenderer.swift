import Foundation

/// Renders a custom 404 Not Found page
class NotFoundRenderer {
    let templateEngine: TemplateEngine
    weak var pluginManager: PluginManager?

    init(templateEngine: TemplateEngine, pluginManager: PluginManager? = nil) {
        self.templateEngine = templateEngine
        self.pluginManager = pluginManager
    }

    /// Render the 404 page
    func render(site: Site, to outputDirectory: URL) throws {
        // Try to load 404.yml configuration, fallback to defaults
        let config: OutputTemplate
        do {
            config = try templateEngine.loadOutputTemplate(named: "404")
        } catch {
            // Default configuration for 404
            config = OutputTemplate(
                format: "notFound",
                fileExtension: ".html",
                outputPath: "output",
                view: "views/404.html",
                indexView: nil,
                variables: nil,
                layouts: nil
            )
        }

        // Create output directory
        let outputDir = outputDirectory.appendingPathComponent(config.outputPath)
        try FileManager.default.createDirectory(
            at: outputDir, withIntermediateDirectories: true)

        let outputPath = outputDir.appendingPathComponent("404").appendingPathExtension("html")

        print("Rendering 404 page...")

        // Create a dummy page for the 404 content
        let dummyPage = Page(
            path: "404.md",
            frontMatter: FrontMatter(title: "Page Not Found", layout: "404"),
            content: "",
            rawMarkdown: "",
            modifiedDate: Date()
        )

        // Load view template
        let viewTemplate = try templateEngine.loadView(named: config.view)

        // Build template context
        let context = TemplateContext.create(site: site, page: dummyPage)

        // Render template
        var html = templateEngine.render(template: viewTemplate, context: context)

        // Run afterPageRender hooks if needed
        if let pluginManager = pluginManager {
            html = try pluginManager.afterPageRender(page: dummyPage, html: html)
        }

        // Write HTML file
        try html.write(to: outputPath, atomically: true, encoding: .utf8)

        print("  ✓ 404 → \(outputPath.lastPathComponent)")
    }
}
