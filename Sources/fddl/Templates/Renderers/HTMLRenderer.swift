import Foundation

/// Renders HTML pages from markdown content using templates
class HTMLRenderer {
    let templateEngine: TemplateEngine

    init(templateEngine: TemplateEngine) {
        self.templateEngine = templateEngine
    }

    /// Render all pages in a site to HTML files
    func render(site: Site, to outputDirectory: URL) throws {
        // Load html.yml configuration
        let htmlConfig = try templateEngine.loadOutputTemplate(named: "html")

        // Create output directory
        let htmlOutputDir = outputDirectory.appendingPathComponent(htmlConfig.outputPath)
        try FileManager.default.createDirectory(at: htmlOutputDir, withIntermediateDirectories: true)

        print("Rendering \(site.pages.count) pages to HTML...")

        // Render each page
        for page in site.pages {
            let htmlContent = try renderPage(page, site: site, config: htmlConfig)
            let outputPath = calculateOutputPath(for: page, config: htmlConfig, baseDir: htmlOutputDir)

            // Create subdirectories if needed
            let outputDir = outputPath.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

            // Write HTML file
            try htmlContent.write(to: outputPath, atomically: true, encoding: .utf8)

            print("  ✓ \(page.path) → \(outputPath.lastPathComponent)")
        }
    }

    /// Render a single page to HTML
    private func renderPage(_ page: Page, site: Site, config: OutputTemplate) throws -> String {
        // Determine which view template to use
        let layout = page.frontMatter.layout
        let viewPath = config.viewPath(for: layout)

        // Load view template
        let viewTemplate = try templateEngine.loadView(named: viewPath)

        // Build template context
        var variables = config.variables ?? [:]
        variables["charset"] = variables["charset"] ?? "utf-8"
        variables["language"] = variables["language"] ?? "en"

        let context = TemplateContext.create(site: site, page: page, variables: variables)

        // Perform variable substitution
        return templateEngine.render(template: viewTemplate, context: context)
    }

    /// Calculate the output file path for a page
    private func calculateOutputPath(for page: Page, config: OutputTemplate, baseDir: URL) -> URL {
        // Convert markdown path to HTML path
        let htmlPath = page.path.replacingOccurrences(of: ".md", with: config.fileExtension)
        return baseDir.appendingPathComponent(htmlPath)
    }
}
