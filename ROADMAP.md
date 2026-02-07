# fddl Roadmap

This document outlines the planned features and development path for **fddl**, the markdown-based static site generator.

## Status: 🟢 Active Development

fddl is currently a functional tool used for learning Swift and building personal projects. While it is feature-rich, it is still evolving towards a "production-ready" 1.0 release.

---

## ✅ Completed Features

### Core Engine
- **Markdown Processing**: High-performance markdown to HTML conversion via SwiftMarkdown.
- **YAML Frontmatter**: Support for metadata in markdown files.
- **Variable Substitution**: Simple `{{page.title}}` style variables in templates.
- **Asset Management**: Automatic synchronization of CSS, JS, and images.
- **Build Tracking**: Automatic build number increments and generation timestamps.

### Built-in Plugins
- **Sitemap Generator**: Automatic `sitemap.xml` generation for SEO.
- **RSS 2.0 Feed**: Generate feeds for your blog or project updates.
- **Search Index**: JSON index for client-side search functionality.
- **Analytics Injector**: Easy integration of Google Analytics or Plausible.
- **Reading Time**: Automatic calculation and injection of "min read" indicators.
- **API JSON Output**: Generate `site.json` and individual page JSON files for headless usage.
- **Custom 404 Pages**: Support for generating dedicated error pages.
- **robots.txt Generator**: Automatic `robots.txt` generation via plugin.

### Developer Experience
- **Dev Server**: Built-in HTTP server with NIO.
- **Live Reload**: Instant browser refresh on content or template changes via WebSockets.
- **CLI Tool**: Intuitive command-line interface powered by Swift Argument Parser.
- **Watch Mode**: Automatic rebuilding when files change.

### Deployment
- **Neocities Integration**: First-class support for deploying to Neocities with API key authentication.

---

## 🛠 Short-Term Goals (v0.6 - v0.8)

### Template System Enhancements
- [ ] **Template Partials**: Support for reusable components (header, footer, etc.) across views.
- [ ] **Conditional Logic**: Basic `if/else` support in templates.
- [ ] **Loops**: Ability to loop over lists of pages in any view (currently restricted to index pages).
- [ ] **More Built-in Themes**: Expand the library of high-quality, responsive templates.

### Image Optimization
- [ ] **Automatic Image Processing**: Resize, compress, and convert images to WebP during build.
- [ ] **Responsive Images**: Generate `<picture>` tags automatically.

---

## 🚀 Long-Term Vision (v1.0 and Beyond)

### Extensibility
- [ ] **External Plugin System**: Allow users to write and use plugins without modifying fddl core.
- [ ] **Shell Script Hooks**: Trigger custom scripts before or after build stages.

### Platform Support
- [ ] **macOS Services Integration**: Right-click a folder to "Generate Site".
- [ ] **Desktop GUI**: A companion app for people who prefer a visual interface over the CLI.
- [ ] **More Deployment Adapters**: Support for GitHub Pages (Actions), Netlify, and Vercel.

### Advanced Features
- [ ] **Incremental Builds**: Only rebuild pages that have actually changed.
- [ ] **Full-Text Search**: More robust search options, potentially server-side for larger sites.
- [ ] **Internationalization (i18n)**: Better support for multi-lingual websites.

---

## 💡 Contributing

Have an idea for a feature or found a bug? Please open an issue or submit a pull request!