/// Supported output format types for site generation
enum OutputFormat: String, CaseIterable {
    case html
    case api
    case sitemap
    case rss
    case notFound = "404"

    /// YAML configuration filename for this format
    var configFilename: String {
        "\(rawValue).yml"
    }

    /// Human-readable description
    var description: String {
        switch self {
        case .html:
            return "HTML pages"
        case .api:
            return "JSON API for search"
        case .sitemap:
            return "XML sitemap"
        case .rss:
            return "RSS 2.0 feed"
        case .notFound:
            return "404 error page"
        }
    }
}
