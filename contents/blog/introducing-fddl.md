---
title: "Introducing fddl: A Swift-Powered Static Site Generator"
date: 2025-12-22
description: "Meet fddl, a markdown-based static site generator built with Swift as a learning journey with NotebookLM."
tags:
  - fddl
  - swift
  - static-sites
  - learning
layout: post
---

# Introducing fddl

Welcome to **fddl**, a markdown-based static site generator written entirely in Swift. This project represents both a functional tool and a learning journey—built in conjunction with NotebookLM to explore Swift development.

## What is fddl?

fddl is a static site generator that transforms markdown files into beautiful, fast-loading HTML websites. It's designed for anyone who wants to publish content without the overhead of a database, server-side rendering, or complex deployment pipelines.

### Perfect For

- **Personal blogs** - Share your thoughts and ideas
- **Project documentation** - Keep your docs alongside your code
- **Portfolio sites** - Showcase your work professionally
- **Family sites** - Share photos and stories with loved ones
- **Knowledge bases** - Build your personal wiki or codebase with rookery (Rookery is a Swift-based web application for managing code snippets)
- **Countless other uses** - fddl is a static site generator, so it can be used for any static site generation task

## Why Another Static Site Generator?

Great question! fddl was born from a desire to learn Swift while building something practical. By working with NotebookLM as a learning companion, this project explores Swift's capabilities beyond iOS development—specifically in the realm of developer tooling.

The result is a fast, type-safe static site generator that leverages Swift's modern features:

- **Performance**: Swift's compiled nature means blazing-fast site generation
- **Type Safety**: Catch errors at compile time, not runtime
- **Modern Syntax**: Clean, readable code that's a joy to work with
- **Rich Ecosystem**: Built on solid Swift packages like ArgumentParser and swift-markdown

## Getting Started

Getting up and running with fddl is straightforward:

```bash
# Build from source
swift build -c release
cp .build/release/fddl /usr/local/bin/

# Generate your site
fddl generate

# Check version
fddl version
```

Your content lives in the `contents/` directory as markdown files with YAML frontmatter:

```markdown
---
title: "My First Post"
description: "Getting started with fddl"
layout: post
tags: ["example"]
---

# Hello World

Your content goes here!
```

## What Makes fddl Special?

While fddl is still evolving (it's not production-ready yet!), it already includes some compelling features:

- **Markdown Processing** with YAML frontmatter support
- **Shortcodes** for dynamic content (YouTube embeds, alerts, even retro GeoCities effects!)
- **Template System** with flexible layouts
- **Plugin Architecture** for extending functionality
- **Build Tracking** to version your site generations
- **Dev Server** with hot reload (coming soon!)

## The Learning Journey

This project is openly a learning experience. It's not perfect, and it's not trying to compete with established tools like Hugo or Jekyll. Instead, it's a playground for exploring Swift's capabilities in a different context.

If you're interested in Swift beyond iOS, or if you're curious about building developer tools, fddl's source code might be worth exploring. It demonstrates practical applications of:

- Command-line argument parsing
- File system operations
- Template rendering
- Markdown processing
- Plugin architectures

## What's Next?

In upcoming posts, we'll dive deeper into:

- The technical architecture and Swift dependencies
- Feature showcases with live examples
- Customization and theming
- Building your own plugins

> "The best way to learn is by doing." — Someone wise, probably

Ready to explore more? Check out the [features demo](/features-demo.html) to see what fddl can do!

---

**Built with fddl** - Learning Swift, one static site at a time.
