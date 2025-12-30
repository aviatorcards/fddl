import Foundation
import Markdown
import Yams

/// Processes markdown files into Page objects
class MarkdownProcessor {
    private let shortcodeProcessor = ShortcodeProcessor()

    /// Process a markdown file into a Page
    func process(file: URL, relativeTo baseURL: URL) throws -> Page {
        // Read file content
        let content = try String(contentsOf: file, encoding: .utf8)

        // Extract frontmatter if present
        let (frontMatter, markdown) = try extractFrontMatter(from: content)

        // Parse markdown to HTML first
        let htmlContent = renderHTML(from: markdown)

        // Process shortcodes in the HTML (after markdown rendering)
        let processedHTML = shortcodeProcessor.process(htmlContent)

        // Calculate relative path
        let relativePath = file.path.replacingOccurrences(
            of: baseURL.path + "/",
            with: ""
        )

        // Get file metadata
        let attributes = try FileManager.default.attributesOfItem(atPath: file.path)
        let modifiedDate = attributes[.modificationDate] as? Date ?? Date()

        return Page(
            path: relativePath,
            frontMatter: frontMatter ?? .default,
            content: processedHTML,
            rawMarkdown: markdown,
            modifiedDate: modifiedDate
        )
    }

    /// Extract YAML frontmatter from markdown content
    private func extractFrontMatter(from content: String) throws -> (FrontMatter?, String) {
        // Check for YAML frontmatter delimited by ---
        let lines = content.components(separatedBy: .newlines)

        guard lines.first == "---" else {
            return (nil, content)
        }

        // Find closing ---
        guard let endIndex = lines.dropFirst().firstIndex(of: "---") else {
            return (nil, content)
        }

        // Extract YAML content
        let yamlLines = lines[1..<endIndex]
        let yamlString = yamlLines.joined(separator: "\n")

        // Parse YAML
        let decoder = YAMLDecoder()
        let frontMatter = try? decoder.decode(FrontMatter.self, from: yamlString)

        // Get remaining markdown content
        let markdownLines = lines[(endIndex + 1)...]
        let markdown = markdownLines.joined(separator: "\n")

        return (frontMatter, markdown)
    }

    /// Render markdown to HTML using swift-markdown
    private func renderHTML(from markdown: String) -> String {
        let document = Document(parsing: markdown)
        var renderer = MarkdownHTMLRenderer()
        return renderer.render(document)
    }
}

/// HTML renderer for markdown documents
private struct MarkdownHTMLRenderer: MarkupWalker {
    private var html = ""
    private let highlighter = SyntaxHighlighter()

    mutating func render(_ document: Document) -> String {
        html = ""
        visit(document)
        return html
    }

    mutating func visitHeading(_ heading: Heading) -> () {
        let tag = "h\(heading.level)"
        html += "<\(tag)>"
        descendInto(heading)
        html += "</\(tag)>\n"
    }

    mutating func visitParagraph(_ paragraph: Paragraph) -> () {
        html += "<p>"
        descendInto(paragraph)
        html += "</p>\n"
    }

    mutating func visitText(_ text: Text) -> () {
        html += text.string.htmlEscaped
    }

    mutating func visitStrong(_ strong: Strong) -> () {
        html += "<strong>"
        descendInto(strong)
        html += "</strong>"
    }

    mutating func visitEmphasis(_ emphasis: Emphasis) -> () {
        html += "<em>"
        descendInto(emphasis)
        html += "</em>"
    }

    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> () {
        let language = codeBlock.language ?? ""
        let code = codeBlock.code

        if !language.isEmpty {
            // Use syntax highlighter for known languages
            html += highlighter.highlight(code: code, language: language)
            html += "\n"
        } else {
            // No language specified, render as plain code
            html += "<pre><code>"
            html += code.htmlEscaped
            html += "</code></pre>\n"
        }
    }

    mutating func visitInlineCode(_ inlineCode: InlineCode) -> () {
        html += "<code>\(inlineCode.code.htmlEscaped)</code>"
    }

    mutating func visitLink(_ link: Link) -> () {
        let destination = link.destination ?? ""
        html += "<a href=\"\(destination.htmlEscaped)\">"
        descendInto(link)
        html += "</a>"
    }

    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> () {
        html += "<ul>\n"
        descendInto(unorderedList)
        html += "</ul>\n"
    }

    mutating func visitOrderedList(_ orderedList: OrderedList) -> () {
        html += "<ol>\n"
        descendInto(orderedList)
        html += "</ol>\n"
    }

    mutating func visitListItem(_ listItem: ListItem) -> () {
        html += "<li>"
        descendInto(listItem)
        html += "</li>\n"
    }

    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> () {
        html += "<blockquote>\n"
        descendInto(blockQuote)
        html += "</blockquote>\n"
    }

    mutating func visitLineBreak(_ lineBreak: LineBreak) -> () {
        html += "<br>\n"
    }

    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> () {
        html += " "
    }
}

/// HTML escaping extension
private extension String {
    var htmlEscaped: String {
        self.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
