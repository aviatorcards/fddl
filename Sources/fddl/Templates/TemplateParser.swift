import Foundation

/// Parses template strings into an abstract syntax tree
class TemplateParser {
    /// Parse a template string into a list of nodes
    func parse(_ template: String) throws -> [TemplateNode] {
        var nodes: [TemplateNode] = []
        var current = template.startIndex

        while current < template.endIndex {
            // Look for {{ opening delimiter
            if let rangeOfOpen = template.range(of: "{{", range: current..<template.endIndex) {
                // Add any text before the delimiter
                if current < rangeOfOpen.lowerBound {
                    let textContent = String(template[current..<rangeOfOpen.lowerBound])
                    if !textContent.isEmpty {
                        nodes.append(.text(textContent))
                    }
                }

                // Find matching }} closing delimiter
                guard let rangeOfClose = template.range(of: "}}", range: rangeOfOpen.upperBound..<template.endIndex) else {
                    throw TemplateParseError.unmatchedDelimiter("Missing closing }}")
                }

                // Extract content between {{ and }}
                let content = String(template[rangeOfOpen.upperBound..<rangeOfClose.lowerBound]).trimmingCharacters(in: .whitespaces)

                // Parse the content
                if content.hasPrefix("#each ") {
                    // Parse each loop
                    let collection = content.dropFirst(6).trimmingCharacters(in: .whitespaces)
                    let (body, endIndex) = try parseBlock(template: template, startIndex: rangeOfClose.upperBound, endTag: "{{/each}}")
                    nodes.append(.each(collection: collection, body: body))
                    current = endIndex
                } else if content.hasPrefix("#if ") {
                    // Parse if conditional
                    let condition = content.dropFirst(4).trimmingCharacters(in: .whitespaces)
                    let (body, endIndex) = try parseBlock(template: template, startIndex: rangeOfClose.upperBound, endTag: "{{/if}}")
                    nodes.append(.ifCondition(condition: condition, body: body))
                    current = endIndex
                } else if content.contains("|") {
                    // Parse filter
                    let parts = content.split(separator: "|", maxSplits: 1)
                    if parts.count == 2 {
                        let variable = parts[0].trimmingCharacters(in: .whitespaces)
                        let filterName = parts[1].trimmingCharacters(in: .whitespaces)
                        nodes.append(.filter(variable: variable, filterName: filterName))
                    } else {
                        // Fallback to variable
                        nodes.append(.variable(keyPath: content))
                    }
                    current = rangeOfClose.upperBound
                } else if content.hasPrefix("/") {
                    // Closing tag - should have been handled by parseBlock
                    throw TemplateParseError.unexpectedClosingTag(content)
                } else {
                    // Regular variable
                    nodes.append(.variable(keyPath: content))
                    current = rangeOfClose.upperBound
                }
            } else {
                // No more delimiters, add remaining text
                let textContent = String(template[current...])
                if !textContent.isEmpty {
                    nodes.append(.text(textContent))
                }
                break
            }
        }

        return nodes
    }

    /// Parse a block (content between opening and closing tags)
    private func parseBlock(template: String, startIndex: String.Index, endTag: String) throws -> ([TemplateNode], String.Index) {
        guard let endRange = template.range(of: endTag, range: startIndex..<template.endIndex) else {
            throw TemplateParseError.unmatchedBlock("Missing \(endTag)")
        }

        let blockContent = String(template[startIndex..<endRange.lowerBound])
        let nodes = try parse(blockContent)
        return (nodes, endRange.upperBound)
    }
}

/// Errors that can occur during template parsing
enum TemplateParseError: LocalizedError {
    case unmatchedDelimiter(String)
    case unmatchedBlock(String)
    case unexpectedClosingTag(String)

    var errorDescription: String? {
        switch self {
        case .unmatchedDelimiter(let message):
            return "Template parse error: \(message)"
        case .unmatchedBlock(let message):
            return "Template parse error: \(message)"
        case .unexpectedClosingTag(let tag):
            return "Template parse error: Unexpected closing tag \(tag)"
        }
    }
}
