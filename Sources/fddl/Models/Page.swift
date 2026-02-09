import Foundation
import SwiftMark

// Re-export SwiftMark's Page type
public typealias Page = SwiftMark.Page

// Re-export SwiftMark's FrontMatter type
public typealias FrontMatter = SwiftMark.FrontMatter

// Re-export SwiftMark's MarkdownProcessor type
public typealias MarkdownProcessor = SwiftMark.MarkdownProcessor

/// fddl-specific extensions for Page
extension SwiftMark.Page {
    /// Computed URL path for the generated HTML file
    public var urlPath: String {
        path.replacingOccurrences(of: ".md", with: ".html")
    }
}

/// Extension to add Codable conformance to SwiftMark's Page
extension SwiftMark.Page: @retroactive Codable {
    enum CodingKeys: String, CodingKey {
        case path
        case frontMatter
        case content
        case rawMarkdown
        case modifiedDate
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let path = try container.decode(String.self, forKey: .path)
        let frontMatter = try container.decode(SwiftMark.FrontMatter.self, forKey: .frontMatter)
        let content = try container.decode(String.self, forKey: .content)
        let rawMarkdown = try container.decode(String.self, forKey: .rawMarkdown)
        let modifiedDate = try container.decode(Date.self, forKey: .modifiedDate)

        self.init(
            path: path,
            frontMatter: frontMatter,
            content: content,
            rawMarkdown: rawMarkdown,
            modifiedDate: modifiedDate
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(frontMatter, forKey: .frontMatter)
        try container.encode(content, forKey: .content)
        try container.encode(rawMarkdown, forKey: .rawMarkdown)
        try container.encode(modifiedDate, forKey: .modifiedDate)
    }
}
