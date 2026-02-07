import Foundation

/// Orchestrates the site generation process
class SiteGenerator {
    let workingDirectory: URL
    private var pluginManager: PluginManager?

    init(workingDirectory: URL) {
        self.workingDirectory = workingDirectory
    }

    /// Generate the static site
    func generate(templateName: String = "default") throws {
        print("Generating site in: \(workingDirectory.path)")
        print("Using template: \(templateName)")
        print("")

        // 1. Validate directory structure
        let contentsDir = workingDirectory.appendingPathComponent("contents")
        let templateDir = workingDirectory.appendingPathComponent("templates/\(templateName)")

        guard FileManager.default.fileExists(atPath: contentsDir.path) else {
            throw GeneratorError.missingContentsDirectory
        }

        guard FileManager.default.fileExists(atPath: templateDir.path) else {
            throw GeneratorError.missingTemplateDirectory
        }

        // 2. Load template configuration
        print("Loading template configuration...")
        let templateEngine = try TemplateEngine(templateDirectory: templateDir)
        let templateConfig = try templateEngine.loadConfiguration()
        print("  ✓ Template '\(templateConfig.name)' loaded")

        // 3. Initialize and load plugins
        let outputDirectory = workingDirectory.appendingPathComponent("output")
        let pluginContext = PluginContext(
            workingDirectory: workingDirectory,
            outputDirectory: outputDirectory,
            templateDirectory: templateDir
        )

        if let pluginConfigs = templateConfig.plugins, !pluginConfigs.isEmpty {
            print("\nLoading plugins...")
            let manager = PluginManager(context: pluginContext)
            manager.loadPlugins(from: pluginConfigs)
            self.pluginManager = manager
            try manager.beforeBuild()
        }

        // 3. Scan and collect markdown files
        print("\nScanning for markdown files...")
        let scanner = DirectoryScanner(rootDirectory: contentsDir)
        let markdownFiles = try scanner.findMarkdownFiles()
        print("  ✓ Found \(markdownFiles.count) markdown files")

        // 4. Process markdown files into Pages
        print("\nProcessing markdown files...")
        let processor = MarkdownProcessor()
        let pages = try markdownFiles.map { file in
            try processor.process(file: file, relativeTo: contentsDir)
        }
        print("  ✓ Processed \(pages.count) pages")

        // 5. Get or increment build number
        let buildID = try BuildInfo.generateBuildID(in: workingDirectory)

        // 6. Create Site model
        let site = Site(
            pages: pages,
            configuration: templateConfig,
            buildID: buildID,
            commitHash: BuildInfo.getGitCommitHash(),
            generatedDate: Date()
        )

        // 7. Generate outputs based on configuration
        for output in templateConfig.outputs {
            switch output {
            case "html":
                print("\nGenerating HTML output...")
                let htmlRenderer = HTMLRenderer(templateEngine: templateEngine, pluginManager: pluginManager)
                try htmlRenderer.render(site: site, to: workingDirectory)

                // Generate directory index pages
                print("\nGenerating directory indexes...")
                let htmlTemplate = try templateEngine.loadOutputTemplate(named: "html")
                let htmlOutputDirectory = workingDirectory.appendingPathComponent(htmlTemplate.outputPath)
                let indexGenerator = IndexGenerator(templateEngine: templateEngine, outputTemplate: htmlTemplate)
                try indexGenerator.generateIndexPages(for: site, outputDirectory: htmlOutputDirectory)

                // Generate taxonomy pages (tags)
                print("\nGenerating tag pages...")
                let taxonomyGenerator = TaxonomyGenerator(templateEngine: templateEngine, outputTemplate: htmlTemplate)
                try taxonomyGenerator.generateTagPages(for: site, outputDirectory: htmlOutputDirectory)

            case "api":
                print("\nGenerating JSON API...")
                let jsonRenderer = JSONRenderer(templateEngine: templateEngine)
                try jsonRenderer.render(site: site, to: workingDirectory)

            case "notFound", "404":
                print("\nGenerating 404 page...")
                let notFoundRenderer = NotFoundRenderer(templateEngine: templateEngine, pluginManager: pluginManager)
                try notFoundRenderer.render(site: site, to: workingDirectory)

            default:
                print("\n⚠️ Unknown output format: \(output)")
            }
        }

        // 8. Copy assets
        print("\nCopying assets...")
        let assetCopier = AssetCopier()
        let assetsSource = templateDir.appendingPathComponent("assets")
        let assetsDestination = workingDirectory.appendingPathComponent("output/assets")
        try assetCopier.copyAssets(from: assetsSource, to: assetsDestination)

        // 11. Run plugin afterBuild hooks
        if let pluginManager = pluginManager {
            print("\nRunning plugin post-build hooks...")
            try pluginManager.afterBuild()
        }

        print("\n✓ Generated \(pages.count) pages (build \(buildID))")
        print("Output directory: \(workingDirectory.appendingPathComponent("output").path)")
    }
}

enum GeneratorError: LocalizedError {
    case missingContentsDirectory
    case missingTemplateDirectory
    case invalidTemplateConfiguration(String)
    case markdownProcessingFailed(String)
    case renderingFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingContentsDirectory:
            return "Contents directory not found. Expected: contents/"
        case .missingTemplateDirectory:
            return "Template directory not found. Expected: templates/[name]/"
        case .invalidTemplateConfiguration(let detail):
            return "Invalid template configuration: \(detail)"
        case .markdownProcessingFailed(let file):
            return "Failed to process markdown file: \(file)"
        case .renderingFailed(let detail):
            return "Rendering failed: \(detail)"
        }
    }
}
