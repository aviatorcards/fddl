import Foundation

/// Represents a single markdown page with its metadata and content
public struct Page: Codable {
    /// Relative path from the contents directory
    public let path: String

    /// Metadata extracted from YAML frontmatter
    public let frontMatter: FrontMatter

    /// Rendered HTML content from markdown
    public let content: String

    /// Original markdown source
    public let rawMarkdown: String

    /// File modification date
    public let modifiedDate: Date

    enum CodingKeys: String, CodingKey {
        case path
        case frontMatter
        case content
        case rawMarkdown
        case modifiedDate
    }

    /// Computed URL path for the generated HTML file
    public var urlPath: String {
        path.replacingOccurrences(of: ".md", with: ".html")
    }

    /// Display title (from frontmatter or derived from filename)
    public var displayTitle: String {
        if let title = frontMatter.title {
            return title
        }
        // Derive from filename
        let filename = (path as NSString).lastPathComponent
        return filename.replacingOccurrences(of: ".md", with: "")
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
}
