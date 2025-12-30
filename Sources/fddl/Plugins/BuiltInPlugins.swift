import Foundation

// MARK: - Sitemap Plugin

/// Generates sitemap.xml for SEO
public class SitemapPlugin: Plugin {
    public let identifier = "sitemap"
    public let name = "Sitemap Generator"
    public let version = "1.0.0"
    public let description = "Generates sitemap.xml for search engines"

    private let config: PluginConfig
    private var pages: [Page] = []

    public required init(config: PluginConfig) {
        self.config = config
    }

    public func beforePageRender(page: Page, context: PluginContext) throws -> Page {
        pages.append(page)
        return page
    }

    public func afterBuild(context: PluginContext) throws {
        let baseURL = config.options?["base_url"] ?? "https://example.com"
        let outputPath = context.outputDirectory.appendingPathComponent("sitemap.xml")

        var xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

        """

        for page in pages {
            let url = "\(baseURL)/\(page.urlPath)"
            let lastMod = ISO8601DateFormatter().string(from: page.modifiedDate)

            xml += """
            <url>
                <loc>\(url)</loc>
                <lastmod>\(lastMod)</lastmod>
            </url>

            """
        }

        xml += "</urlset>"

        try xml.write(to: outputPath, atomically: true, encoding: .utf8)
        print("  ✓ Generated sitemap.xml with \(pages.count) URLs")
    }
}

// MARK: - RSS Plugin

/// Generates RSS feed for blog posts
public class RSSPlugin: Plugin {
    public let identifier = "rss"
    public let name = "RSS Feed Generator"
    public let version = "1.0.0"
    public let description = "Generates RSS 2.0 feed for your content"

    private let config: PluginConfig
    private var posts: [Page] = []

    public required init(config: PluginConfig) {
        self.config = config
    }

    public func beforePageRender(page: Page, context: PluginContext) throws -> Page {
        // Only include posts (pages with dates)
        if page.frontMatter.date != nil {
            posts.append(page)
        }
        return page
    }

    public func afterBuild(context: PluginContext) throws {
        let siteTitle = config.options?["site_title"] ?? "My Site"
        let siteURL = config.options?["site_url"] ?? "https://example.com"
        let description = config.options?["description"] ?? "Site feed"
        let limit = Int(config.options?["limit"] ?? "20") ?? 20

        let outputPath = context.outputDirectory.appendingPathComponent("feed.xml")

        // Sort posts by date (newest first)
        let sortedPosts = posts.sorted { p1, p2 in
            (p1.frontMatter.date ?? Date.distantPast) > (p2.frontMatter.date ?? Date.distantPast)
        }.prefix(limit)

        var xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
        <channel>
            <title>\(siteTitle.xmlEscaped)</title>
            <link>\(siteURL)</link>
            <description>\(description.xmlEscaped)</description>
            <atom:link href="\(siteURL)/feed.xml" rel="self" type="application/rss+xml"/>

        """

        for post in sortedPosts {
            let title = post.displayTitle.xmlEscaped
            let url = "\(siteURL)/\(post.urlPath)"
            let description = (post.frontMatter.description ?? "").xmlEscaped
            let pubDate: String
            if let date = post.frontMatter.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
                pubDate = formatter.string(from: date)
            } else {
                pubDate = ""
            }

            xml += """
            <item>
                <title>\(title)</title>
                <link>\(url)</link>
                <description>\(description)</description>
                <pubDate>\(pubDate)</pubDate>
                <guid>\(url)</guid>
            </item>

            """
        }

        xml += """
        </channel>
        </rss>
        """

        try xml.write(to: outputPath, atomically: true, encoding: .utf8)
        print("  ✓ Generated RSS feed with \(sortedPosts.count) items")
    }
}

// MARK: - Search Index Plugin

/// Generates search index for client-side search
public class SearchIndexPlugin: Plugin {
    public let identifier = "search"
    public let name = "Search Index Generator"
    public let version = "1.0.0"
    public let description = "Generates JSON search index"

    private let config: PluginConfig
    private var pages: [Page] = []

    public required init(config: PluginConfig) {
        self.config = config
    }

    public func beforePageRender(page: Page, context: PluginContext) throws -> Page {
        pages.append(page)
        return page
    }

    public func afterBuild(context: PluginContext) throws {
        let outputPath = context.outputDirectory.appendingPathComponent("search-index.json")

        let searchEntries = pages.map { page in
            [
                "title": page.displayTitle,
                "url": page.urlPath,
                "description": page.frontMatter.description ?? "",
                "content": page.rawMarkdown.prefix(500).description, // First 500 chars
                "tags": (page.frontMatter.tags ?? []).joined(separator: ", ")
            ]
        }

        let jsonData = try JSONSerialization.data(withJSONObject: searchEntries, options: .prettyPrinted)
        try jsonData.write(to: outputPath)
        print("  ✓ Generated search index with \(pages.count) entries")
    }
}

// MARK: - Analytics Plugin

/// Injects analytics code into HTML pages
public class AnalyticsPlugin: Plugin {
    public let identifier = "analytics"
    public let name = "Analytics Injector"
    public let version = "1.0.0"
    public let description = "Injects analytics tracking code"

    private let config: PluginConfig

    public required init(config: PluginConfig) {
        self.config = config
    }

    public func afterPageRender(page: Page, html: String, context: PluginContext) throws -> String {
        guard let trackingId = config.options?["tracking_id"] else {
            return html
        }

        let provider = config.options?["provider"] ?? "google"

        let trackingCode: String
        switch provider {
        case "google":
            trackingCode = """
            <!-- Google Analytics -->
            <script async src="https://www.googletagmanager.com/gtag/js?id=\(trackingId)"></script>
            <script>
              window.dataLayer = window.dataLayer || [];
              function gtag(){dataLayer.push(arguments);}
              gtag('js', new Date());
              gtag('config', '\(trackingId)');
            </script>
            """
        case "plausible":
            let domain = config.options?["domain"] ?? ""
            trackingCode = """
            <script defer data-domain="\(domain)" src="https://plausible.io/js/script.js"></script>
            """
        default:
            return html
        }

        // Inject before </head>
        if let headEnd = html.range(of: "</head>", options: .caseInsensitive) {
            var modified = html
            modified.insert(contentsOf: trackingCode + "\n", at: headEnd.lowerBound)
            return modified
        }

        return html
    }
}

// MARK: - Reading Time Plugin

/// Adds reading time estimates to pages
public class ReadingTimePlugin: Plugin {
    public let identifier = "reading-time"
    public let name = "Reading Time Calculator"
    public let version = "1.0.0"
    public let description = "Calculates and adds reading time to pages"

    private let config: PluginConfig

    public required init(config: PluginConfig) {
        self.config = config
    }

    public func beforePageRender(page: Page, context: PluginContext) throws -> Page {
        let wordsPerMinute = Int(config.options?["words_per_minute"] ?? "200") ?? 200
        let wordCount = page.rawMarkdown.components(separatedBy: .whitespacesAndNewlines).count
        let readingTime = max(1, wordCount / wordsPerMinute)

        // Store reading time in shared context so templates can access it
        context.sharedData["reading_time_\(page.path)"] = readingTime

        return page
    }

    public func afterPageRender(page: Page, html: String, context: PluginContext) throws -> String {
        guard let readingTime = context.sharedData["reading_time_\(page.path)"] as? Int else {
            return html
        }

        // Inject reading time indicator
        let indicator = "<span class=\"reading-time\">\(readingTime) min read</span>"

        // Try to inject after first heading
        if let h1End = html.range(of: "</h1>", options: .caseInsensitive) {
            var modified = html
            modified.insert(contentsOf: indicator, at: h1End.upperBound)
            return modified
        }

        return html
    }
}

// MARK: - Helper Extensions

private extension String {
    var xmlEscaped: String {
        self.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&apos;")
    }
}
