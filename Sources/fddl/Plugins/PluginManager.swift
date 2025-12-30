import Foundation

/// Manages plugin lifecycle and execution
public class PluginManager {
    private var plugins: [Plugin] = []
    private let registry: PluginRegistry
    private let context: PluginContext

    public init(context: PluginContext, registry: PluginRegistry = PluginRegistry()) {
        self.context = context
        self.registry = registry
    }

    /// Load plugins from configuration
    public func loadPlugins(from configs: [PluginConfig]) {
        for config in configs {
            guard config.enabled else {
                print("  ⊘ Plugin '\(config.identifier)' is disabled")
                continue
            }

            guard let plugin = registry.create(from: config) else {
                print("  ⚠️  Unknown plugin: \(config.identifier)")
                continue
            }

            plugins.append(plugin)
            plugin.didLoad(context: context)
            print("  ✓ Loaded plugin: \(plugin.name) v\(plugin.version)")
        }
    }

    /// Execute beforeBuild hooks
    public func beforeBuild() throws {
        for plugin in plugins {
            try plugin.beforeBuild(context: context)
        }
    }

    /// Execute afterBuild hooks
    public func afterBuild() throws {
        for plugin in plugins {
            try plugin.afterBuild(context: context)
        }
    }

    /// Execute beforePageRender hooks
    public func beforePageRender(_ page: Page) throws -> Page {
        var modifiedPage = page
        for plugin in plugins {
            modifiedPage = try plugin.beforePageRender(page: modifiedPage, context: context)
        }
        return modifiedPage
    }

    /// Execute afterPageRender hooks
    public func afterPageRender(page: Page, html: String) throws -> String {
        var modifiedHTML = html
        for plugin in plugins {
            modifiedHTML = try plugin.afterPageRender(page: page, html: modifiedHTML, context: context)
        }
        return modifiedHTML
    }

    /// Execute beforeMarkdownProcessing hooks
    public func beforeMarkdownProcessing(_ markdown: String) throws -> String {
        var modifiedMarkdown = markdown
        for plugin in plugins {
            modifiedMarkdown = try plugin.beforeMarkdownProcessing(markdown: modifiedMarkdown, context: context)
        }
        return modifiedMarkdown
    }

    /// Execute afterMarkdownProcessing hooks
    public func afterMarkdownProcessing(_ html: String) throws -> String {
        var modifiedHTML = html
        for plugin in plugins {
            modifiedHTML = try plugin.afterMarkdownProcessing(html: modifiedHTML, context: context)
        }
        return modifiedHTML
    }

    /// Get loaded plugins
    public var loadedPlugins: [Plugin] {
        plugins
    }
}
