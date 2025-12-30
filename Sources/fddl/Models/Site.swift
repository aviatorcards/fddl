import Foundation

/// Represents the entire static site with all pages and configuration
struct Site {
    /// All pages in the site
    let pages: [Page]

    /// Template configuration
    let configuration: TemplateConfiguration

    /// Build ID for this generation
    let buildID: String
    
    /// Commit hash for this generation
    let commitHash: String

    /// Date when the site was generated
    let generatedDate: Date

    /// Formatted generation date string
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: generatedDate)
    }
}
