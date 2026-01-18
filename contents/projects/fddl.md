---
title: "fddl"
description: "A high-performance static site generator written in Swift."
layout: project
tags:
  - open-source
  - swift
  - static-sites
  - fddl
date: 2025-10-01
---

# Fast Document Deployment Layer (fddl)

**fddl** (pronounced "fiddle") is my personal static site generator, built entirely in Swift. It's the engine powering this very website.

## Why build another SSG?

While there are many excellent static site generators like Jekyll, Hugo, and Astro, I wanted something that combined:

1.  **Swift Power**: Leveraging the speed and type safety of Swift for the build engine.
2.  **Custom Markdown**: A processor (SwiftMark) that I can extend with custom shortcodes and syntax.
3.  **Minimalist Templates**: A simple YAML-based configuration that stays out of the way.
4.  **Learning**: Building it was a way to dive deep into Swift's string processing, file system APIs, and CLI argument parsing.

## Key Features

- **[SwiftMark](/projects/swiftmark.html)**: A custom Markdown engine with real-time, high-fidelity rendering.
- **Shortcode System**: Easily embed YouTube videos, info alerts, and even retro Geocities-style effects.
- **Plugin Architecture**: Support for automated sitemaps, RSS feeds, and search indexing.
- **Flexible Navigation**: Navigation menus defined in simple YAML configs.
- **Themes**: Support for multiple look-and-feel options, from "Brutalist" to "Glassmorphism."

## How it works

The generator scans your `contents/` directory for Markdown files, processes the frontmatter, and applies your chosen template. It then copies all assets (CSS, JS, Images) to the `output/` folder.

```bash
# Generate the site
fddl generate

# Preview with live-reload
fddl serve
```

The resulting `output` folder is purely static—it can be hosted anywhere with zero server-side requirements.
