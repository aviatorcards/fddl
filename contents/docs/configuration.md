---
title: "Configuration Reference"
description: "Master the settings that drive your site generation."
tags:
  - doc
  - configuration
  - tutorial
layout: doc
---

# Configuration

`fddl` is designed to be "zero-config" by default, but it offers deep customization via YAML files.

## YAML Frontmatter

Every markdown file in `contents/` can include a YAML header blocked by `---`.

```yaml
---
title: "My Page"
date: 2024-03-25
layout: post
tags: ["tag1", "tag2"]
---
```

## Template Configuration (`template.yml`)

The `template.yml` file in your template directory defines the site's structure and behavior.

### Navigation

The `navigation` key defines the menu items for your site.

```yaml
navigation:
  - label: "Home"
    url: "/"
  - label: "About"
    url: "/about.html"
```

### Theme

`fddl` supports a CSS-variable-based theme system.

```yaml
theme:
  name: "custom"
  colors:
    primary: "#ff00ff"
    background: "#000080"
    text: "#ffffff"
  typography:
    font_family: "Comic Sans MS, cursive"
    base_font_size: "16px"
```

### Plugins

Plugins extend the build process.

```yaml
plugins:
  - identifier: "sitemap"
    enabled: true
    options:
      base_url: "https://example.com"
  - identifier: "rss"
    enabled: true
    options:
      site_title: "My Feed"
      limit: "10"
  - identifier: "search"
    enabled: true
```

## Global Variables

You can access site-wide variables using the `{{site}}` namespace in your templates:

- `{{site.name}}`: The name defined in your configuration.
- `{{site.buildID}}`: The current build's unique identifier.
- `{{site.commitHash}}`: The short git hash of the current commit.
- `{{site.generatedDate}}`: The timestamp of when the build completed.
- `{{site.navigation}}`: Array of navigation items.
- `{{site.recentPosts}}`: The 5 latest pages with a date.
- `{{site.allTags}}`: List of every tag used in the site.
