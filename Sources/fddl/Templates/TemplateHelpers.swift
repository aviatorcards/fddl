import Foundation

/// Helper functions for filtering and sorting pages
struct TemplateHelpers {

    /// Sort order for pages
    enum SortOrder {
        case dateDescending
        case dateAscending
        case titleAscending
        case titleDescending
    }

    /// Get pages filtered by a specific tag
    static func pages(withTag tag: String, from pages: [Page]) -> [Page] {
        return pages.filter { page in
            page.frontMatter.tags?.contains(tag) ?? false
        }
    }

    /// Get pages in a specific directory path
    static func pages(inDirectory directory: String, from pages: [Page]) -> [Page] {
        let normalizedDir = directory.hasSuffix("/") ? directory : directory + "/"
        return pages.filter { page in
            page.path.hasPrefix(normalizedDir)
        }
    }

    /// Get the most recent pages sorted by date
    static func recentPages(from pages: [Page], limit: Int = 5) -> [Page] {
        return pages
            .filter { $0.frontMatter.date != nil }
            .sorted { ($0.frontMatter.date ?? Date.distantPast) > ($1.frontMatter.date ?? Date.distantPast) }
            .prefix(limit)
            .map { $0 }
    }

    /// Sort pages by the specified order
    static func sorted(_ pages: [Page], by order: SortOrder) -> [Page] {
        switch order {
        case .dateDescending:
            return pages.sorted { ($0.frontMatter.date ?? Date.distantPast) > ($1.frontMatter.date ?? Date.distantPast) }
        case .dateAscending:
            return pages.sorted { ($0.frontMatter.date ?? Date.distantPast) < ($1.frontMatter.date ?? Date.distantPast) }
        case .titleAscending:
            return pages.sorted { $0.displayTitle < $1.displayTitle }
        case .titleDescending:
            return pages.sorted { $0.displayTitle > $1.displayTitle }
        }
    }

    /// Get all unique tags from a collection of pages
    static func allTags(from pages: [Page]) -> [String] {
        let tagSet = Set(pages.flatMap { $0.frontMatter.tags ?? [] })
        return Array(tagSet).sorted()
    }

    /// Get tag counts for all tags
    static func tagCounts(from pages: [Page]) -> [(tag: String, count: Int)] {
        var counts: [String: Int] = [:]

        for page in pages {
            if let tags = page.frontMatter.tags {
                for tag in tags {
                    counts[tag, default: 0] += 1
                }
            }
        }

        return counts.map { (tag: $0.key, count: $0.value) }
            .sorted { $0.tag < $1.tag }
    }

    /// Get pages grouped by year (based on date)
    static func pagesByYear(from pages: [Page]) -> [Int: [Page]] {
        var grouped: [Int: [Page]] = [:]

        let calendar = Calendar.current
        for page in pages {
            guard let date = page.frontMatter.date else { continue }
            let year = calendar.component(.year, from: date)
            grouped[year, default: []].append(page)
        }

        return grouped
    }
}
