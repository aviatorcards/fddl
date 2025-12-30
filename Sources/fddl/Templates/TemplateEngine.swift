import Foundation
import Yams

/// Loads and processes templates
class TemplateEngine {
    let templateDirectory: URL
    private let parser = TemplateParser()
    private let filters: [String: (TemplateValue) -> String]

    init(templateDirectory: URL) throws {
        self.templateDirectory = templateDirectory

        guard FileManager.default.fileExists(atPath: templateDirectory.path) else {
            throw TemplateError.templateDirectoryNotFound(templateDirectory.path)
        }

        // Initialize filter functions
        self.filters = TemplateEngine.createFilters()
    }

    /// Create filter functions for template transformations
    private static func createFilters() -> [String: (TemplateValue) -> String] {
        return [
            "formatDate": { value in
                if case .date(let date) = value {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    return formatter.string(from: date)
                } else if case .string(let str) = value, !str.isEmpty {
                    return str
                }
                return ""
            },
            "uppercase": { value in
                value.stringValue.uppercased()
            },
            "lowercase": { value in
                value.stringValue.lowercased()
            },
            "capitalize": { value in
                value.stringValue.capitalized
            }
        ]
    }

    /// Load the main template configuration from template.yml
    func loadConfiguration() throws -> TemplateConfiguration {
        let configPath = templateDirectory.appendingPathComponent("template.yml")

        guard FileManager.default.fileExists(atPath: configPath.path) else {
            throw TemplateError.configurationNotFound(configPath.path)
        }

        let yamlContent = try String(contentsOf: configPath, encoding: .utf8)
        let decoder = YAMLDecoder()
        return try decoder.decode(TemplateConfiguration.self, from: yamlContent)
    }

    /// Load an output template configuration (html.yml, api.yml, etc.)
    func loadOutputTemplate(named name: String) throws -> OutputTemplate {
        let configPath = templateDirectory.appendingPathComponent("\(name).yml")

        guard FileManager.default.fileExists(atPath: configPath.path) else {
            throw TemplateError.outputTemplateNotFound(name, configPath.path)
        }

        let yamlContent = try String(contentsOf: configPath, encoding: .utf8)
        let decoder = YAMLDecoder()
        return try decoder.decode(OutputTemplate.self, from: yamlContent)
    }

    /// Load a view template file
    func loadView(named name: String) throws -> String {
        let viewPath = templateDirectory.appendingPathComponent(name)

        guard FileManager.default.fileExists(atPath: viewPath.path) else {
            throw TemplateError.viewNotFound(name, viewPath.path)
        }

        return try String(contentsOf: viewPath, encoding: .utf8)
    }

    /// Render a template with the given context
    func render(template: String, context: TemplateContext) -> String {
        do {
            let nodes = try parser.parse(template)
            return evaluate(nodes, context: context, currentItem: nil)
        } catch {
            print("Template parse error: \(error)")
            return template
        }
    }

    /// Evaluate template nodes recursively
    private func evaluate(_ nodes: [TemplateNode], context: TemplateContext, currentItem: TemplateValue?) -> String {
        var result = ""

        for node in nodes {
            switch node {
            case .text(let text):
                result += text

            case .variable(let keyPath):
                if let value = resolveKeyPath(keyPath, context: context, currentItem: currentItem) {
                    result += value.stringValue
                }

            case .filter(let variable, let filterName):
                if let value = resolveKeyPath(variable, context: context, currentItem: currentItem),
                   let filter = filters[filterName] {
                    result += filter(value)
                } else if let value = resolveKeyPath(variable, context: context, currentItem: currentItem) {
                    result += value.stringValue
                }

            case .each(let collection, let body):
                if let array = resolveKeyPath(collection, context: context, currentItem: currentItem)?.arrayValue {
                    for item in array {
                        result += evaluate(body, context: context, currentItem: item)
                    }
                }

            case .ifCondition(let condition, let body):
                if let value = resolveKeyPath(condition, context: context, currentItem: currentItem), value.isTruthy {
                    result += evaluate(body, context: context, currentItem: currentItem)
                }
            }
        }

        return result
    }

    /// Resolve a key path to a template value
    private func resolveKeyPath(_ keyPath: String, context: TemplateContext, currentItem: TemplateValue?) -> TemplateValue? {
        let components = keyPath.split(separator: ".").map(String.init)

        guard !components.isEmpty else {
            return nil
        }

        // Check if starting with "this" (current iteration item)
        if components[0] == "this" {
            guard let item = currentItem else {
                return nil
            }

            if components.count == 1 {
                return item
            }

            return resolveProperty(components: Array(components.dropFirst()), value: item)
        }

        // Start with root context
        switch components[0] {
        case "page":
            return resolvePageProperty(components: Array(components.dropFirst()), context: context)
        case "site":
            return resolveSiteProperty(components: Array(components.dropFirst()), context: context)
        default:
            // Check custom variables
            if let value = context.variables[keyPath] {
                return .string(value)
            }
            return nil
        }
    }

    /// Resolve page properties
    private func resolvePageProperty(components: [String], context: TemplateContext) -> TemplateValue? {
        guard !components.isEmpty else {
            return nil
        }

        switch components[0] {
        case "title":
            return .string(context.page.title)
        case "content":
            return .string(context.page.content)
        case "path":
            return .string(context.page.path)
        case "url":
            return .string(context.page.url)
        case "description":
            return .string(context.page.description ?? "")
        case "date":
            return .string(context.page.date ?? "")
        case "tags":
            return .array(context.page.tags.map { .string($0) })
        default:
            return nil
        }
    }

    /// Resolve site properties
    private func resolveSiteProperty(components: [String], context: TemplateContext) -> TemplateValue? {
        guard !components.isEmpty else {
            return nil
        }

        switch components[0] {
        case "name":
            return .string(context.site.name)
        case "buildID", "buildId":
            return .string(context.site.buildID)
        case "commitHash":
            return .string(context.site.commitHash)
        case "generatedDate":
            return .string(context.site.generatedDate)
        case "pages":
            return .array(context.site.pages.map { pageContext in
                .dictionary([
                    "title": .string(pageContext.title),
                    "url": .string(pageContext.url),
                    "path": .string(pageContext.path),
                    "description": .string(pageContext.description ?? ""),
                    "date": .string(pageContext.date ?? ""),
                    "tags": .array(pageContext.tags.map { .string($0) })
                ])
            })
        case "navigation":
            return .array(context.site.navigation.map { navItem in
                .dictionary([
                    "label": .string(navItem.label),
                    "url": .string(navItem.url)
                ])
            })
        case "recentPosts":
            return .array(context.site.recentPosts.map { pageContext in
                .dictionary([
                    "title": .string(pageContext.title),
                    "url": .string(pageContext.url),
                    "date": .string(pageContext.date ?? "")
                ])
            })
        case "allTags":
            return .array(context.site.allTags.map { .string($0) })
        case "postsInDirectory":
            return .array(context.site.postsInDirectory.map { pageContext in
                .dictionary([
                    "title": .string(pageContext.title),
                    "url": .string(pageContext.url),
                    "description": .string(pageContext.description ?? ""),
                    "date": .string(pageContext.date ?? ""),
                    "tags": .array(pageContext.tags.map { .string($0) })
                ])
            })
        default:
            return nil
        }
    }

    /// Resolve properties from a template value
    private func resolveProperty(components: [String], value: TemplateValue) -> TemplateValue? {
        guard !components.isEmpty else {
            return value
        }

        guard let dict = value.dictionaryValue else {
            return nil
        }

        guard let nextValue = dict[components[0]] else {
            return nil
        }

        if components.count == 1 {
            return nextValue
        }

        return resolveProperty(components: Array(components.dropFirst()), value: nextValue)
    }
}

enum TemplateError: LocalizedError {
    case templateDirectoryNotFound(String)
    case configurationNotFound(String)
    case outputTemplateNotFound(String, String)
    case viewNotFound(String, String)

    var errorDescription: String? {
        switch self {
        case .templateDirectoryNotFound(let path):
            return "Template directory not found: \(path)"
        case .configurationNotFound(let path):
            return "Template configuration not found: \(path)"
        case .outputTemplateNotFound(let name, let path):
            return "Output template '\(name)' not found: \(path)"
        case .viewNotFound(let name, let path):
            return "View template '\(name)' not found: \(path)"
        }
    }
}
