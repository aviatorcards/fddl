---
title: "Configuration Reference"
description: "Master the settings that drive your site generation."
tags: ["doc", "configuration", "tutorial"]
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

## Template Configuration

Each template has a `template.yml` file that defines global variables.

```yaml
name: "My Site"
navigation:
  - label: "Home"
    url: "/"
  - label: "About"
    url: "/about.html"
```

## Global Variables

You can access site-wide variables using the `{{site}}` namespace in your templates:

- `{{site.name}}`: The name defined in your configuration.
- `{{site.buildID}}`: The current build's unique identifier.
- `{{site.commitHash}}`: The short git hash of the current commit.
- `{{site.generatedDate}}`: The timestamp of when the build completed.
