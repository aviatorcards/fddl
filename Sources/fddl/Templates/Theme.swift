import Foundation

/// Theme configuration for site styling
struct Theme: Codable {
    let name: String
    let colors: ColorScheme
    let typography: Typography
    let spacing: Spacing?
    let customCSS: [String: String]?

    enum CodingKeys: String, CodingKey {
        case name
        case colors
        case typography
        case spacing
        case customCSS = "custom_css"
    }

    /// Generate CSS variables from theme
    func generateCSSVariables() -> String {
        var css = ":root {\n"

        // Colors
        css += "  --color-primary: \(colors.primary);\n"
        css += "  --color-secondary: \(colors.secondary ?? colors.primary);\n"
        css += "  --color-accent: \(colors.accent ?? colors.primary);\n"
        css += "  --color-background: \(colors.background);\n"
        css += "  --color-text: \(colors.text);\n"

        if let link = colors.link {
            css += "  --color-link: \(link);\n"
        }
        if let linkHover = colors.linkHover {
            css += "  --color-link-hover: \(linkHover);\n"
        }
        if let border = colors.border {
            css += "  --color-border: \(border);\n"
        }
        if let code = colors.codeBackground {
            css += "  --color-code-bg: \(code);\n"
        }

        // Typography
        css += "  --font-family: \(typography.fontFamily);\n"
        css += "  --font-size-base: \(typography.baseFontSize ?? "16px");\n"
        css += "  --line-height: \(typography.lineHeight ?? "1.6");\n"

        if let headingFont = typography.headingFont {
            css += "  --font-family-heading: \(headingFont);\n"
        }
        if let codeFont = typography.codeFont {
            css += "  --font-family-code: \(codeFont);\n"
        }

        // Spacing
        if let spacing = spacing {
            css += "  --spacing-xs: \(spacing.xs ?? "0.25rem");\n"
            css += "  --spacing-sm: \(spacing.sm ?? "0.5rem");\n"
            css += "  --spacing-md: \(spacing.md ?? "1rem");\n"
            css += "  --spacing-lg: \(spacing.lg ?? "1.5rem");\n"
            css += "  --spacing-xl: \(spacing.xl ?? "2rem");\n"
        }

        // Custom CSS variables
        if let customCSS = customCSS {
            for (key, value) in customCSS {
                css += "  --\(key): \(value);\n"
            }
        }

        css += "}\n"
        return css
    }
}

/// Color scheme configuration
struct ColorScheme: Codable {
    let primary: String
    let secondary: String?
    let accent: String?
    let background: String
    let text: String
    let link: String?
    let linkHover: String?
    let border: String?
    let codeBackground: String?

    enum CodingKeys: String, CodingKey {
        case primary
        case secondary
        case accent
        case background
        case text
        case link
        case linkHover = "link_hover"
        case border
        case codeBackground = "code_background"
    }
}

/// Typography configuration
struct Typography: Codable {
    let fontFamily: String
    let headingFont: String?
    let codeFont: String?
    let baseFontSize: String?
    let lineHeight: String?

    enum CodingKeys: String, CodingKey {
        case fontFamily = "font_family"
        case headingFont = "heading_font"
        case codeFont = "code_font"
        case baseFontSize = "base_font_size"
        case lineHeight = "line_height"
    }
}

/// Spacing configuration
struct Spacing: Codable {
    let xs: String?
    let sm: String?
    let md: String?
    let lg: String?
    let xl: String?
}

// MARK: - Preset Themes

extension Theme {
    /// Modern clean theme
    static var modern: Theme {
        Theme(
            name: "modern",
            colors: ColorScheme(
                primary: "#007bff",
                secondary: "#6c757d",
                accent: "#28a745",
                background: "#ffffff",
                text: "#212529",
                link: "#007bff",
                linkHover: "#0056b3",
                border: "#dee2e6",
                codeBackground: "#f8f9fa"
            ),
            typography: Typography(
                fontFamily: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif",
                headingFont: nil,
                codeFont: "'SF Mono', 'Monaco', 'Inconsolata', 'Roboto Mono', monospace",
                baseFontSize: "16px",
                lineHeight: "1.6"
            ),
            spacing: nil,
            customCSS: nil
        )
    }

    /// Retro GeoCities-style theme
    static var geocities: Theme {
        Theme(
            name: "geocities",
            colors: ColorScheme(
                primary: "#ff00ff",
                secondary: "#00ffff",
                accent: "#ffff00",
                background: "#000080",
                text: "#ffffff",
                link: "#00ff00",
                linkHover: "#ffff00",
                border: "#ff00ff",
                codeBackground: "#000000"
            ),
            typography: Typography(
                fontFamily: "'Comic Sans MS', 'Chalkboard SE', 'Comic Neue', cursive",
                headingFont: "'Impact', 'Arial Black', sans-serif",
                codeFont: "'Courier New', monospace",
                baseFontSize: "14px",
                lineHeight: "1.4"
            ),
            spacing: Spacing(xs: "4px", sm: "8px", md: "16px", lg: "24px", xl: "32px"),
            customCSS: [
                "border-style": "ridge",
                "border-width": "3px",
                "text-shadow": "2px 2px #000000"
            ]
        )
    }

    /// Dark mode theme
    static var dark: Theme {
        Theme(
            name: "dark",
            colors: ColorScheme(
                primary: "#bb86fc",
                secondary: "#03dac6",
                accent: "#cf6679",
                background: "#121212",
                text: "#e1e1e1",
                link: "#bb86fc",
                linkHover: "#985eff",
                border: "#2c2c2c",
                codeBackground: "#1e1e1e"
            ),
            typography: Typography(
                fontFamily: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif",
                headingFont: nil,
                codeFont: "'Fira Code', 'Cascadia Code', monospace",
                baseFontSize: "16px",
                lineHeight: "1.6"
            ),
            spacing: nil,
            customCSS: nil
        )
    }

    /// Minimalist theme
    static var minimal: Theme {
        Theme(
            name: "minimal",
            colors: ColorScheme(
                primary: "#000000",
                secondary: "#666666",
                accent: "#333333",
                background: "#ffffff",
                text: "#000000",
                link: "#000000",
                linkHover: "#666666",
                border: "#e0e0e0",
                codeBackground: "#f5f5f5"
            ),
            typography: Typography(
                fontFamily: "'Georgia', 'Times New Roman', serif",
                headingFont: "'Helvetica Neue', 'Arial', sans-serif",
                codeFont: "'IBM Plex Mono', monospace",
                baseFontSize: "18px",
                lineHeight: "1.8"
            ),
            spacing: Spacing(xs: "0.5rem", sm: "1rem", md: "2rem", lg: "3rem", xl: "4rem"),
            customCSS: nil
        )
    }
}
