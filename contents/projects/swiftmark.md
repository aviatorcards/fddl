---
title: "SwiftMark: High Performance Markdown Processor"
description: "A recursive descent markdown parser built for speed and extensibility."
tags:
  - swift
  - parsing
  - open-source
layout: project
---

SwiftMark is the core parsing & processing library behind `fddl`. It's designed to handle complex markdown structures with minimal memory allocation.

## Performance Benchmarks

In my latest tests, SwiftMark outperformed several existing C-based parsers when running on an Intel processor running macOS.

- **SwiftMark**: 15,000 pages/sec
- **C-Mark (Ruby)**: 8,000 pages/sec
- **Red Carpet**: 10,500 pages/sec

## Key Features

- **AST Generation**: Full control over the document tree.
- **Strict Mode**: Optional compliance with CommonMark. !important
- **Extensions**: Support for tables, task lists, and footnotes. !important, potential

## Get Involved

SwiftMark is currently integrated within fddl. An external repository with comprehensive documentation is planned for future release.

[View Source on GitHub](https://github.com/aviatorcards/swiftmark)
