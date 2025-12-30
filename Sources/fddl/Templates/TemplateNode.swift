import Foundation

/// Represents a node in the template abstract syntax tree
enum TemplateNode {
    /// Plain text to be output as-is
    case text(String)

    /// Variable to be substituted (e.g., {{page.title}})
    case variable(keyPath: String)

    /// Each loop to iterate over a collection (e.g., {{#each site.pages}}...{{/each}})
    case each(collection: String, body: [TemplateNode])

    /// If conditional to show content conditionally (e.g., {{#if page.date}}...{{/if}})
    case ifCondition(condition: String, body: [TemplateNode])

    /// Filter to transform a value (e.g., {{page.date | formatDate}})
    case filter(variable: String, filterName: String)
}

/// Represents a value that can be used in template evaluation
enum TemplateValue {
    case string(String)
    case int(Int)
    case bool(Bool)
    case array([TemplateValue])
    case dictionary([String: TemplateValue])
    case date(Date)
    case null

    /// Convert to string representation
    var stringValue: String {
        switch self {
        case .string(let str):
            return str
        case .int(let num):
            return String(num)
        case .bool(let b):
            return b ? "true" : "false"
        case .array:
            return ""
        case .dictionary:
            return ""
        case .date(let date):
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        case .null:
            return ""
        }
    }

    /// Check if value is truthy (for conditionals)
    var isTruthy: Bool {
        switch self {
        case .string(let str):
            return !str.isEmpty
        case .int(let num):
            return num != 0
        case .bool(let b):
            return b
        case .array(let arr):
            return !arr.isEmpty
        case .dictionary(let dict):
            return !dict.isEmpty
        case .date:
            return true
        case .null:
            return false
        }
    }

    /// Get array values (for iteration)
    var arrayValue: [TemplateValue]? {
        if case .array(let arr) = self {
            return arr
        }
        return nil
    }

    /// Get dictionary value (for property access)
    var dictionaryValue: [String: TemplateValue]? {
        if case .dictionary(let dict) = self {
            return dict
        }
        return nil
    }
}
