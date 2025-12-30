import Foundation
import Splash

/// Handles syntax highlighting for code blocks
class SyntaxHighlighter {
    private let swiftHighlighter: Splash.SyntaxHighlighter<HTMLOutputFormat>

    init() {
        self.swiftHighlighter = Splash.SyntaxHighlighter(format: HTMLOutputFormat())
    }

    /// Highlight code based on language
    func highlight(code: String, language: String) -> String {
        // Map common language names to supported highlighters
        let normalizedLanguage = language.lowercased()

        switch normalizedLanguage {
        case "swift":
            return swiftHighlighter.highlight(code)
        case "javascript", "js", "typescript", "ts":
            // For now, use generic highlighting or return with classes
            return highlightGeneric(code: code, language: language)
        case "python", "py":
            return highlightGeneric(code: code, language: language)
        case "html", "xml":
            return highlightGeneric(code: code, language: language)
        case "css", "scss", "sass":
            return highlightGeneric(code: code, language: language)
        case "json":
            return highlightGeneric(code: code, language: language)
        case "bash", "sh", "shell":
            return highlightGeneric(code: code, language: language)
        default:
            return highlightGeneric(code: code, language: language)
        }
    }

    /// Generic highlighting with CSS classes for client-side highlighting fallback
    private func highlightGeneric(code: String, language: String) -> String {
        return """
        <pre><code class="language-\(language.htmlEscaped)">\(code.htmlEscaped)</code></pre>
        """
    }
}

/// Custom output format for Splash that generates HTML with inline styles
private struct HTMLOutputFormat: Splash.OutputFormat {
    func makeBuilder() -> Builder {
        return Builder()
    }
}

private extension HTMLOutputFormat {
    struct Builder: OutputBuilder {
        private var html = ""

        mutating func addToken(_ token: String, ofType type: TokenType) {
            let color = colorFor(tokenType: type)
            if let color = color {
                html += "<span style=\"color: \(color);\">\(token.htmlEscaped)</span>"
            } else {
                html += token.htmlEscaped
            }
        }

        mutating func addPlainText(_ text: String) {
            html += text.htmlEscaped
        }

        mutating func addWhitespace(_ whitespace: String) {
            html += whitespace
        }

        func build() -> String {
            return "<pre><code class=\"language-swift\">\(html)</code></pre>"
        }

        private func colorFor(tokenType: TokenType) -> String? {
            switch tokenType {
            case .keyword:
                return "#c586c0"  // Purple
            case .string:
                return "#b5cea8"  // Green
            case .type:
                return "#4ec9b0"  // Cyan
            case .call:
                return "#dcdcaa"  // Yellow
            case .number:
                return "#b5cea8"  // Green
            case .comment:
                return "#6a9955"  // Olive
            case .property:
                return "#9cdcfe"  // Light blue
            case .dotAccess:
                return "#c586c0"  // Purple
            case .preprocessing:
                return "#c586c0"  // Purple
            default:
                return nil
            }
        }
    }
}

private extension String {
    var htmlEscaped: String {
        self.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
