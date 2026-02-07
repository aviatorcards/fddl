import Foundation

/// Plugin lifecycle protocol
public protocol Plugin {
    /// Unique identifier for the plugin
    var identifier: String { get }

    /// Plugin name
    var name: String { get }

    /// Plugin version
    var version: String { get }

    /// Plugin description
    var description: String { get }

    /// Initialize the plugin with configuration
    init(config: PluginConfig)

    /// Called when the plugin is loaded
    func didLoad(context: PluginContext)

    /// Called before the site build starts
    func beforeBuild(context: PluginContext) throws

    /// Called after the site build completes
    func afterBuild(context: PluginContext) throws

    /// Called before a page is rendered
    func beforePageRender(page: Page, context: PluginContext) throws -> Page

    /// Called after a page is rendered
    func afterPageRender(page: Page, html: String, context: PluginContext) throws -> String

    /// Called before markdown is processed
    func beforeMarkdownProcessing(markdown: String, context: PluginContext) throws -> String

    /// Called after markdown is processed to HTML
    func afterMarkdownProcessing(html: String, context: PluginContext) throws -> String
}

/// Default implementations for optional lifecycle methods
public extension Plugin {
    func didLoad(context: PluginContext) {}
    func beforeBuild(context: PluginContext) throws {}
    func afterBuild(context: PluginContext) throws {}
    func beforePageRender(page: Page, context: PluginContext) throws -> Page { page }
    func afterPageRender(page: Page, html: String, context: PluginContext) throws -> String { html }
    func beforeMarkdownProcessing(markdown: String, context: PluginContext) throws -> String { markdown }
    func afterMarkdownProcessing(html: String, context: PluginContext) throws -> String { html }
}

/// Plugin configuration loaded from YAML
public struct PluginConfig: Codable {
    public let identifier: String
    public let enabled: Bool
    public let options: [String: String]?

    public init(identifier: String, enabled: Bool = true, options: [String: String]? = nil) {
        self.identifier = identifier
        self.enabled = enabled
        self.options = options
    }

    enum CodingKeys: String, CodingKey {
        case identifier
        case enabled
        case options
    }
}

/// Context provided to plugins during execution
public class PluginContext {
    public let workingDirectory: URL
    public let outputDirectory: URL
    public let templateDirectory: URL
    public var sharedData: [String: Any] = [:]
    public weak var shortcodeProcessor: ShortcodeProcessor?

    public init(
        workingDirectory: URL,
        outputDirectory: URL,
        templateDirectory: URL,
        shortcodeProcessor: ShortcodeProcessor? = nil
    ) {
        self.workingDirectory = workingDirectory
        self.outputDirectory = outputDirectory
        self.templateDirectory = templateDirectory
        self.shortcodeProcessor = shortcodeProcessor
    }

    /// Register a custom shortcode
    public func registerShortcode(_ shortcode: Shortcode) {
        shortcodeProcessor?.register(shortcode)
    }
}

/// Plugin registry for built-in and custom plugins
public class PluginRegistry {
    private var factories: [String: (PluginConfig) -> Plugin] = [:]

    public init() {
        registerBuiltInPlugins()
    }

    /// Register built-in plugins
    private func registerBuiltInPlugins() {
        register(identifier: "sitemap", factory: SitemapPlugin.init)
        register(identifier: "rss", factory: RSSPlugin.init)
        register(identifier: "search", factory: SearchIndexPlugin.init)
        register(identifier: "analytics", factory: AnalyticsPlugin.init)
        register(identifier: "reading-time", factory: ReadingTimePlugin.init)
        register(identifier: "robots", factory: RobotsPlugin.init)
    }

    /// Register a plugin factory
    public func register(identifier: String, factory: @escaping (PluginConfig) -> Plugin) {
        factories[identifier] = factory
    }

    /// Create a plugin instance from configuration
    public func create(from config: PluginConfig) -> Plugin? {
        factories[config.identifier]?(config)
    }

    /// Get all registered plugin identifiers
    public var availablePlugins: [String] {
        Array(factories.keys).sorted()
    }
}
