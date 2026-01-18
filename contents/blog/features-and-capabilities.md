---
title: "fddl Features: Shortcodes, Plugins, and More"
date: 2025-12-26
description: "A comprehensive look at fddl's features including shortcodes, plugins, the dev server, and the template system."
tags:
  - features
  - shortcodes
  - plugins
  - templates
layout: post
---

# fddl Features and Capabilities

fddl packs a surprising amount of functionality into a Swift-based static site generator; these features include shortcodes, plugins, the dev server, and the template system. A custom markdown processor (SwiftMark) is also included.

## Shortcodes: Dynamic Content in Static Sites

Shortcodes let you embed rich content without writing HTML. fddl supports both modern and retro shortcodes. Think geocities, gopher, & gemini (not the AI)

### Modern Shortcodes

Modern shortcodes are written in markdown and should be processed by SwiftMark. Sometimes they are simply going to be parsed as markdown, other times they are going to be processed as HTML, depending on the situation.

#### YouTube Embeds

Embed videos with a simple shortcode:

```markdown
{{\< youtube id="dQw4w9QgXcW" width="560" height="315" \>}}
```

#### Alert Boxes

Create styled alert boxes for different message types:

```markdown
{{\< alert type="info" title="Did you know?" \>}}
fddl has a complete plugin system!
{{\< /alert \>}}

{{\< alert type="success" title="Build Status" \>}}
Your site was generated successfully! 🎉
{{\< /alert \>}}

{{\< alert type="warning" title="Remember" \>}}
Always backup your content before major changes.
{{\< /alert \>}}
```

#### Images with Captions

```markdown
{{\< image src="/assets/images/photo.jpg" alt="Description" caption="A beautiful sunset" width="600" \>}}
```

### Retro GeoCities Shortcodes

For those who miss the 90s web, fddl includes nostalgic effects:

```markdown
{{\< blink \>}}🌟 UNDER CONSTRUCTION 🌟{{\< /blink \>}}

{{\< marquee direction="left" speed="normal" \>}}
Welcome to my homepage!
{{\< /marquee \>}}

{{\< rainbow \>}}Rainbow Text is BACK!{{\< /rainbow \>}}

{{\< counter style="digital" \>}}
```

These aren't just for fun—they demonstrate fddl's flexible shortcode system that you can extend with your own custom shortcodes.

## Plugin System

fddl's plugin architecture allows you to extend functionality without modifying core code.

### Built-in Plugins

#### Sitemap Generation

Automatically creates `sitemap.xml` for SEO:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://yoursite.com/</loc>
    <lastmod>2024-12-30</lastmod>
  </url>
</urlset>
```

#### RSS Feed

Generates an RSS 2.0 feed at `/feed.xml` for blog posts:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>Your Blog</title>
    <item>
      <title>Latest Post</title>
      <link>https://yoursite.com/blog/latest-post.html</link>
    </item>
  </channel>
</rss>
```

#### Search Index

Builds a searchable JSON index of all content:

```json
{
  "pages": [
    {
      "title": "Page Title",
      "url": "/page.html",
      "content": "Searchable content...",
      "tags": ["example"]
    }
  ]
}
```

#### Reading Time Estimator

Automatically calculates reading time for each page based on word count.

### Creating Custom Plugins

The plugin system is designed to be extensible. Future versions will include a documented API for creating your own plugins.

## Template System

fddl uses a flexible YAML-based template system with multiple layouts.

### Template Configuration

```yaml
# template.yml
name: "default"
version: "1.0"
defaultLayout: "page"
outputs:
  - html
```

### Multiple Layouts

Different content types can use different layouts:

```yaml
# html.yml
layouts:
  page: "views/page.html"
  post: "views/post.html"
  index-list: "views/index-list.html"
```

### Template Variables

Access page and site metadata in your templates:

```html
<h1>{{page.title}}</h1>
<div class="content">{{page.content}}</div>
<p>Generated on {{site.generatedDate}}</p>
<p>Build #{{site.buildID}}</p>
```

Available variables include:

- `{{page.title}}` - Page title from frontmatter
- `{{page.content}}` - Rendered HTML content
- `{{page.description}}` - Page description
- `{{page.date}}` - Publication date
- `{{site.name}}` - Site name
- `{{site.buildID}}` - Incremental build number
- `{{site.generatedDate}}` - Generation timestamp

## Development Server

fddl includes a development server with hot reload capabilities (powered by SwiftNIO):

```bash
fddl serve --port 8080 --open
```

Features:

- 🔥 **Hot Reload**: Changes appear instantly via WebSocket
- 👀 **File Watching**: Automatically detects content changes
- 🚀 **Instant Rebuilds**: Fast regeneration on save
- 🌐 **Local Preview**: Test before deploying

## Syntax Highlighting

Code blocks are automatically highlighted using Splash:

```swift
struct Person {
    let name: String
    var age: Int

    func greet() {
        print("Hello, my name is \(name)!")
    }
}
```

Supports multiple languages including Swift, JavaScript, Python, Bash, and more.

## Asset Management

fddl automatically handles static assets:

```
templates/default/assets/
├── css/
│   └── theme.css
├── javascript/
│   └── theme.js
└── images/
    └── logo.png
```

All assets are copied to the output directory, maintaining the folder structure.

## Build Tracking

Every site generation increments a build number, stored in `.fddl-build`:

```
Build #42
```

This helps track versions and can be displayed in your site footer.

## Flexible Navigation

Navigation is simple HTML in your templates—no complex configuration:

```html
<nav>
  <a href="/">Home</a>
  <a href="/blog/">Blog</a>
  <a href="/about.html">About</a>
  <a href="/projects/">Projects</a>
</nav>
```

Different layouts can have different navigation menus.

## What's Coming Next?

Future features on the roadmap:

- API JSON output for headless CMS usage
- Custom 404 error pages
- macOS Services menu integration
- Watch mode improvements
- Theme marketplace
- Plugin documentation and API

## Try It Yourself

The best way to understand fddl's capabilities is to use it. Check out the [features demo](/features-demo.html) page to see these features in action, or dive into the source code to see how they're implemented.

> "Features are only as good as their implementation." — fddl's guiding principle

---

**Built with fddl** - Where modern meets retro, and Swift meets markdown.
