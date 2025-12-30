import Foundation

/// Context data passed to templates for variable substitution
struct TemplateContext {
    let site: SiteContext
    let page: PageContext
    let variables: [String: String]

    /// Create context from Site and Page models
    static func create(site: Site, page: Page, variables: [String: String] = [:], currentDirectory: String? = nil) -> TemplateContext {
        let allPageContexts = site.pages.map { PageContext.from(page: $0) }

        // Get navigation from template configuration
        let navigation = site.configuration.navigation

        // Get recent posts (sorted by date, limit 5)
        let recentPosts = allPageContexts
            .filter { !($0.date?.isEmpty ?? true) }
            .sorted { ($0.date ?? "") > ($1.date ?? "") }
            .prefix(5)
            .map { $0 }

        // Get all unique tags
        let allTags = Array(Set(allPageContexts.flatMap { $0.tags })).sorted()

        // Get posts in current directory (if applicable)
        let postsInDirectory: [PageContext]
        if let currentDir = currentDirectory {
            postsInDirectory = allPageContexts.filter { $0.path.hasPrefix(currentDir) }
        } else {
            postsInDirectory = []
        }

        let siteContext = SiteContext(
            name: site.configuration.name,
            buildID: site.buildID,
            commitHash: site.commitHash,
            generatedDate: site.formattedDate,
            pages: allPageContexts,
            navigation: navigation,
            recentPosts: Array(recentPosts),
            allTags: allTags,
            postsInDirectory: postsInDirectory
        )

        let pageContext = PageContext.from(page: page)

        return TemplateContext(
            site: siteContext,
            page: pageContext,
            variables: variables
        )
    }

    struct SiteContext {
        let name: String
        let buildID: String
        let commitHash: String
        let generatedDate: String
        let pages: [PageContext]
        let navigation: [NavigationItem]
        let recentPosts: [PageContext]
        let allTags: [String]
        let postsInDirectory: [PageContext]
    }

    struct PageContext {
        let title: String
        let content: String
        let path: String
        let url: String
        let date: String?
        let description: String?
        let tags: [String]

        static func from(page: Page) -> PageContext {
            let dateString: String?
            if let date = page.frontMatter.date {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                dateString = formatter.string(from: date)
            } else {
                dateString = nil
            }

            return PageContext(
                title: page.displayTitle,
                content: page.content,
                path: page.path,
                url: "/" + page.urlPath,
                date: dateString,
                description: page.frontMatter.description,
                tags: page.frontMatter.tags ?? []
            )
        }
    }
}
