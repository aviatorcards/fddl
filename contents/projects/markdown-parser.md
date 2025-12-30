---
title: "SwiftMark: High Performance Parser"
description: "A recursive descent markdown parser built for speed and extensibility."
tags: ["swift", "parsing", "open-source"]
layout: project
---

# SwiftMark

SwiftMark is the core parsing library behind `fddl`. It's designed to handle complex markdown structures with minimal memory allocation.

## Performance Benchmarks

In our latest tests, SwiftMark outperformed several existing C-based parsers when running on Apple Silicon.

- **SwiftMark**: 15,000 pages/sec
- **C-Mark (Ruby)**: 8,000 pages/sec
- **Red Carpet**: 10,500 pages/sec

## Key Features

- **AST Generation**: Full control over the document tree.
- **Strict Mode**: Optional compliance with CommonMark.
- **Extensions**: Support for tables, task lists, and footnotes.

[View on GitHub](https://github.com/tristan/swiftmark)
