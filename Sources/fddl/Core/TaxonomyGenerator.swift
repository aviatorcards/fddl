import Foundation

/// Generates taxonomy pages (tags, categories, etc.)
class TaxonomyGenerator {
    private let templateEngine: TemplateEngine
    private let outputTemplate: OutputTemplate

    init(templateEngine: TemplateEngine, outputTemplate: OutputTemplate) {
        self.templateEngine = templateEngine
        self.outputTemplate = outputTemplate
    }

    /// Generate tag pages for all tags
    func generateTagPages(for site: Site, outputDirectory: URL) throws {
        let allTags = TemplateHelpers.allTags(from: site.pages)

        // Create tags directory
        let tagsDirectory = outputDirectory.appendingPathComponent("tags")
        try FileManager.default.createDirectory(at: tagsDirectory, withIntermediateDirectories: true)

        // Generate a page for each tag
        for tag in allTags {
            try generateTagPage(for: tag, site: site, outputDirectory: tagsDirectory)
        }

        // Generate tags index page
        try generateTagsIndexPage(tags: allTags, site: site, outputDirectory: tagsDirectory)
    }

    /// Generate a page for a specific tag
    private func generateTagPage(for tag: String, site: Site, outputDirectory: URL) throws {
        // Filter pages by tag
        let taggedPages = TemplateHelpers.pages(withTag: tag, from: site.pages)

        // Create a virtual tag page
        let tagPage = Page(
            path: "tags/\(tag).md",
            frontMatter: FrontMatter(
                title: "Tag: \(tag)",
                description: "All posts tagged with '\(tag)'",
                date: nil,
                tags: [tag],
                layout: nil
            ),
            content: "",
            rawMarkdown: "",
            modifiedDate: Date()
        )

        // Create template context
        let context = TemplateContext.create(
            site: site,
            page: tagPage,
            variables: [
                "tag": tag,
                "pageCount": "\(taggedPages.count)"
            ]
        )

        // Use index view if specified, otherwise use default view
        let viewPath = outputTemplate.indexView ?? outputTemplate.view
        let viewTemplate = try templateEngine.loadView(named: viewPath)

        // Render the template
        let renderedHTML = templateEngine.render(template: viewTemplate, context: context)

        // Write to output file
        let outputPath = outputDirectory.appendingPathComponent("\(tag)\(outputTemplate.fileExtension)")
        try renderedHTML.write(to: outputPath, atomically: true, encoding: String.Encoding.utf8)

        print("Generated tag page: tags/\(tag).html (\(taggedPages.count) posts)")
    }

    /// Generate an index page listing all tags
    private func generateTagsIndexPage(tags: [String], site: Site, outputDirectory: URL) throws {
        let tagCounts = TemplateHelpers.tagCounts(from: site.pages)

        // Create a virtual tags index page
        let tagsIndexPage = Page(
            path: "tags/index.md",
            frontMatter: FrontMatter(
                title: "All Tags",
                description: "Browse content by tag",
                date: nil,
                tags: nil,
                layout: nil
            ),
            content: "",
            rawMarkdown: "",
            modifiedDate: Date()
        )

        // Create template context with tag count info
        var variables: [String: String] = [:]
        for (tag, count) in tagCounts {
            variables["tag_\(tag)_count"] = "\(count)"
        }
        variables["totalTags"] = "\(tags.count)"

        let context = TemplateContext.create(
            site: site,
            page: tagsIndexPage,
            variables: variables
        )

        // Use index view if specified, otherwise use default view
        let viewPath = outputTemplate.indexView ?? outputTemplate.view
        let viewTemplate = try templateEngine.loadView(named: viewPath)

        // Render the template
        let renderedHTML = templateEngine.render(template: viewTemplate, context: context)

        // Write to output file
        let outputPath = outputDirectory.appendingPathComponent("index\(outputTemplate.fileExtension)")
        try renderedHTML.write(to: outputPath, atomically: true, encoding: String.Encoding.utf8)

        print("Generated tags index: tags/index.html (\(tags.count) tags)")
    }
}
