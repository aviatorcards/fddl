import Foundation

/// Represents a single markdown page with its metadata and content
struct Page {
    /// Relative path from the contents directory
    let path: String

    /// Metadata extracted from YAML frontmatter
    let frontMatter: FrontMatter

    /// Rendered HTML content from markdown
    let content: String

    /// Original markdown source
    let rawMarkdown: String

    /// File modification date
    let modifiedDate: Date

    /// Computed URL path for the generated HTML file
    var urlPath: String {
        path.replacingOccurrences(of: ".md", with: ".html")
    }

    /// Display title (from frontmatter or derived from filename)
    var displayTitle: String {
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
