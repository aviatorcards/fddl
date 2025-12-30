---
title: "Getting Started with fddl"
description: "From zero to deployed in under five minutes."
tags: ["doc", "tutorial", "introduction"]
layout: doc
---

# Getting Started

Welcome to the documentation for **fddl**. This guide will help you set up your first static site.

## Installation

Currently, `fddl` is distributed as a Swift package. You can build it from source:

```bash
git clone https://github.com/aviatorcards/fddl.git
cd fddl
swift build -c release
```

The executable will be located in `.build/release/fddl`.

## Project Structure

A typical `fddl` project looks like this:

- `contents/`: Your markdown files.
- `templates/`: Your HTML views and configurations.
- `output/`: The generated static files (don't edit these!).

## Your First Build

To generate your site using the default template, simply run:

```bash
./fddl
```

Or specify a template:

```bash
./fddl --template default
```

## Build System & Versioning

Every site generation is automatically trackable. `fddl` generates a unique **Build ID** and captures the current **Git Commit Hash** to ensure you always know exactly which version of your code produced which version of your site.

These variables are exposed via:

- `{{site.buildID}}`
- `{{site.commitHash}}`
- `{{site.generatedDate}}`

## Next Steps

- [Configuration Guide](/docs/configuration.html)
- [Shortcodes Reference](/docs/shortcodes.html)
- [Templating Engine](/docs/templates.html)
