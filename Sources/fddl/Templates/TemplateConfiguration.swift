import Foundation

/// Navigation item configuration
struct NavigationItem: Codable {
    let label: String
    let url: String
}

/// Configuration loaded from template.yml
struct TemplateConfiguration: Codable {
    let name: String
    let version: String?
    let author: String?
    let description: String?
    let defaultLayout: String?
    let outputs: [String]
    let navigation: [NavigationItem]
    let theme: Theme?
    let plugins: [PluginConfig]?

    enum CodingKeys: String, CodingKey {
        case name
        case version
        case author
        case description
        case defaultLayout
        case outputs
        case navigation
        case theme
        case plugins
    }

    static var `default`: TemplateConfiguration {
        TemplateConfiguration(
            name: "default",
            version: "1.0",
            author: nil,
            description: nil,
            defaultLayout: "page",
            outputs: ["html"],
            navigation: [],
            theme: nil,
            plugins: nil
        )
    }

    /// Get the active theme (from config or use modern as default)
    var activeTheme: Theme {
        theme ?? .modern
    }
}

/// Output template configuration (loaded from html.yml, api.yml, etc.)
struct OutputTemplate: Codable {
    let format: String
    let fileExtension: String
    let outputPath: String
    let view: String
    let indexView: String?
    let variables: [String: String]?
    let layouts: [String: String]?

    enum CodingKeys: String, CodingKey {
        case format
        case fileExtension = "extension"
        case outputPath
        case view
        case indexView
        case variables
        case layouts
    }

    /// Get the view path for a specific layout name
    func viewPath(for layout: String?) -> String {
        if let layout = layout,
           let layouts = layouts,
           let customView = layouts[layout] {
            return customView
        }
        return view
    }
}
