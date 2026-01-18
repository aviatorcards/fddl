---
title: "Fast Document Deployment Layer"
layout: page
description: "A personal space for thoughts, projects, and structured chaos. Powered by fddl."
---

## Welcome to fddl.dev

This is a personal homepage and demonstration of [fddl](https://github.com/aviatorcards/fddl), a static site generator crafted in Swift. Built with performance and simplicity in mind, fddl leverages Swift's compiled nature to deliver blazing-fast site generation. It features a custom markdown processor (SwiftMark), flexible shortcode system, plugin architecture, and modern templating—all while maintaining the simplicity of writing in plain Markdown. Perfect for blogs, documentation, portfolios, and any static site that demands speed and type safety.

---

## ⚡️ Quick Navigation

- **[Explore the Blog](/blog/)**: Deep dives into software engineering, design, and culture.
- **[View My Projects](/projects/)**: Open-source tools and experiments from [github.com/aviatorcards](https://github.com/aviatorcards).
- **[Documentation](/docs/)**: Comprehensive guides on how this site is built and maintained.
- **[The Lab](/recipes/)**: Technical experiments, code snippets, and proof-of-concept demos.

---

## 🏗️ How it's Built

fddl is designed for performance and aesthetics. Every page is pre-rendered into static HTML, ensuring near-instant load times and zero server-side vulnerabilities.

### Key Technology Stack

- **Core Engine**: Swift 5.10 (compiled for maximum performance)
- **Markdown Processor**: SwiftMark (custom recursive descent parser)
- **Templating**: fddl HTML Engine with YAML-based layouts
- **Shortcodes**: Dynamic content embedding system (YouTube, alerts, retro effects)
- **Plugin Architecture**: Extensible system for sitemap, RSS, search indexing
- **Syntax Highlighting**: Splash for beautiful code blocks
- **Dev Server**: SwiftNIO-powered hot reload server
- **Styling**: Modern CSS with multiple default themes
- **Build System**: GitHub Actions with incremental build tracking

### 🚀 Latest Build Info

- **Build ID**: `{{site.buildID}}`
- **Commit**: [`{{site.commitHash}}`](https://github.com/aviatorcards/fddl/commit/{{site.commitHash}})
- **Generated**: {{site.generatedDate}}

---

## 🖋️ Latest Thought

> "The best way to predict the future is to build it. But the best way to maintain it is to keep it simple." - Lincoln/Drucker
