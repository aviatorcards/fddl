import Foundation

/// Renders HTML pages from markdown content using templates
class HTMLRenderer {
    let templateEngine: TemplateEngine
    weak var pluginManager: PluginManager?

    init(templateEngine: TemplateEngine, pluginManager: PluginManager? = nil) {
        self.templateEngine = templateEngine
        self.pluginManager = pluginManager
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
        // Run beforePageRender hooks
        var processedPage = page
        if let pluginManager = pluginManager {
            processedPage = try pluginManager.beforePageRender(page)
        }

        // Determine which view template to use
        let layout = processedPage.frontMatter.layout
        let viewPath = config.viewPath(for: layout)

        // Load view template
        let viewTemplate = try templateEngine.loadView(named: viewPath)

        // Build template context
        var variables = config.variables ?? [:]
        variables["charset"] = variables["charset"] ?? "utf-8"
        variables["language"] = variables["language"] ?? "en"

        // Add theme CSS if theme is configured
        if let theme = site.configuration.theme {
            variables["themeCSS"] = theme.generateCSSVariables()
        }

        // Create initial context for processing page content
        let initialContext = TemplateContext.create(site: site, page: processedPage, variables: variables)

        // Process template variables in the page content
        let processedContent = templateEngine.render(template: processedPage.content, context: initialContext)

        // Create a new page with the processed content
        let pageWithProcessedContent = Page(
            path: processedPage.path,
            frontMatter: processedPage.frontMatter,
            content: processedContent,
            rawMarkdown: processedPage.rawMarkdown,
            modifiedDate: processedPage.modifiedDate
        )

        // Create final context with the processed page
        let context = TemplateContext.create(site: site, page: pageWithProcessedContent, variables: variables)

        // Perform variable substitution on the view template
        var html = templateEngine.render(template: viewTemplate, context: context)

        // Run afterPageRender hooks
        if let pluginManager = pluginManager {
            html = try pluginManager.afterPageRender(page: processedPage, html: html)
        }

        return html
    }

    /// Calculate the output file path for a page
    private func calculateOutputPath(for page: Page, config: OutputTemplate, baseDir: URL) -> URL {
        // Convert markdown path to HTML path
        let htmlPath = page.path.replacingOccurrences(of: ".md", with: config.fileExtension)
        return baseDir.appendingPathComponent(htmlPath)
    }
}
