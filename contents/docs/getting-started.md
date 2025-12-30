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

## Next Steps

Check out the [Configuration Guide](/docs/configuration.html) to learn how to customize your site settings.
