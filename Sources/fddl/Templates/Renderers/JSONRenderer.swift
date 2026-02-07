import Foundation

/// Renders site data to JSON for API usage
class JSONRenderer {
    let templateEngine: TemplateEngine

    init(templateEngine: TemplateEngine) {
        self.templateEngine = templateEngine
    }

    /// Render site data to a JSON file
    func render(site: Site, to outputDirectory: URL) throws {
        // Try to load api.yml configuration, fallback to defaults
        let apiConfig: OutputTemplate
        do {
            apiConfig = try templateEngine.loadOutputTemplate(named: "api")
        } catch {
            // Default configuration for API
            apiConfig = OutputTemplate(
                format: "api",
                fileExtension: ".json",
                outputPath: "api",
                view: "api.json", // Not really used for JSON
                indexView: nil,
                variables: nil,
                layouts: nil
            )
        }

        // Create output directory
        let apiOutputDir = outputDirectory.appendingPathComponent(apiConfig.outputPath)
        try FileManager.default.createDirectory(
            at: apiOutputDir, withIntermediateDirectories: true)

        let outputPath = apiOutputDir.appendingPathComponent("site").appendingPathExtension("json")

        print("Rendering site to JSON API...")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601

        let jsonData = try encoder.encode(site)
        try jsonData.write(to: outputPath)

        print("  ✓ site → \(outputPath.lastPathComponent)")
        
        // Also generate individual JSON files for each page if requested
        // (This could be a configuration option in the future)
        let pagesDir = apiOutputDir.appendingPathComponent("pages")
        try FileManager.default.createDirectory(at: pagesDir, withIntermediateDirectories: true)
        
        for page in site.pages {
            let pageJSONData = try encoder.encode(page)
            let pagePath = page.path.replacingOccurrences(of: ".md", with: ".json")
            let pageOutputPath = pagesDir.appendingPathComponent(pagePath)
            
            // Create subdirectories if needed
            try FileManager.default.createDirectory(
                at: pageOutputPath.deletingLastPathComponent(), 
                withIntermediateDirectories: true
            )
            
            try pageJSONData.write(to: pageOutputPath)
            print("  ✓ \(page.path) → pages/\(pagePath)")
        }
    }
}
