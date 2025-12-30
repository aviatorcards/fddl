# fddl

A markdown-based static site generator written in Swift. Perfect for blogs, personal sites, portfolios, documentation, project pages, family sites, and more.

This project is a project I'm using in conjunction with NotebookLM to help me learn Swift. It is not in a state where I would consider it to be production ready, but it does currently work.

## Features

- **Markdown Processing**: Converts markdown files to HTML with YAML frontmatter support
- **Template System**: YAML-configured templates with variable substitution
- **Multiple Layouts**: Support for different page layouts (page, post, etc.)
- **Flexible Navigation**: Easy customization of navigation menus in templates
- **Asset Management**: Automatically copies CSS, JavaScript, and images to output
- **Build Tracking**: Increments build numbers and includes them in generated pages
- **CLI Interface**: Simple command-line tool for site generation

## Use Cases

- Personal blogs and websites
- Project documentation
- Portfolio sites
- Family photo galleries
- Recipe collections
- Knowledge bases
- Any content-focused website!

## Installation

### Build from Source

```bash
swift build -c release
cp .build/release/fddl /usr/local/bin/
```

## Quick Start

```bash
# Generate site from current directory
fddl generate

# Check version and build number
fddl version
```

## Project Structure

```
your-site/
├── contents/                 # Your markdown content
│   ├── index.md
│   └── blog/
│       └── first-post.md
└── templates/
    └── default/             # Template name
        ├── template.yml     # Template configuration
        ├── html.yml         # HTML output configuration
        ├── views/           # View templates
        │   ├── page.html
        │   └── post.html
        └── assets/          # Static assets
            ├── css/
            │   └── theme.css
            ├── javascript/
            │   └── theme.js
            └── images/
```

## Configuration

### template.yml

```yaml
name: "default"
version: "1.0"
defaultLayout: "page"
outputs:
  - html
```

### html.yml

```yaml
format: html
extension: .html
outputPath: "output"
view: "views/page.html"

layouts:
  page: "views/page.html"
  post: "views/post.html"
```

## Markdown Files

```markdown
---
title: "My Page Title"
description: "A brief description"
layout: page
tags:
  - example
---

# Content Goes Here

Your markdown content here.
```

## Template Variables

- `{{page.title}}` - Page title
- `{{page.content}}` - Rendered HTML
- `{{page.description}}` - Page description
- `{{site.name}}` - Site name
- `{{site.buildID}}` - Build number
- `{{site.generatedDate}}` - Generation date

## Customizing Navigation

Navigation is simple to customize in your view templates. Just edit the navigation section in your template files:

```html
<nav>
    <a href="/">Home</a>
    <a href="/blog/">Blog</a>
    <a href="/about.html">About</a>
    <a href="/projects/">Projects</a>
    <a href="/contact.html">Contact</a>
</nav>
```

You can create different navigation menus for different layouts (page vs. post) by editing the respective view files in `templates/default/views/`.

### Example: Blog with Categories

```html
<nav>
    <a href="/">Home</a>
    <a href="/blog/">All Posts</a>
    <a href="/recipes/">Recipes</a>
    <a href="/travel/">Travel</a>
    <a href="/about.html">About</a>
</nav>
```

Then organize your content:
```
contents/
├── index.md
├── about.md
├── blog/
│   └── post-1.md
├── recipes/
│   └── chocolate-cake.md
└── travel/
    └── paris-trip.md
```

## Future Features

- API JSON output (api.yml)
- 404 error page (404.yml)
- Sitemap generation (sitemap.yml)
- RSS 2.0 feed (rss.yml)
- macOS Services menu integration
- Watch mode and development server

## Requirements

- macOS 13.0+
- Swift 5.10+

## License

MIT License
