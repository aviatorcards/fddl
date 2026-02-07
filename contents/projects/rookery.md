---
title: "Rookery"
description: "A Swift-based web application for managing code snippets with beautiful image generation powered by freeze"
tags:
  - swift
  - vapor
  - open-source
  - web-application
layout: project
date: 2025-12-14
---

**A colony of code fragments**

Rookery is a modern Swift-based web application for managing code snippets. Think of it as your personal, local GitHub Gist focused on Swift's dynamic programming capabilities with built-in beautiful image generation.

## Key Features

- **Snippet Management**: Organize code fragments with metadata, tags, and search.
- **Syntax Highlighting**: Beautiful code display using the [Splash](https://github.com/JohnSundell/Splash) library.
- **Image Generation**: Create stunning code images for social sharing using [freeze](https://github.com/charmbracelet/freeze).
- **Search & Filter**: Instantly find snippets by title, language, tags, or content.
- **RESTful API**: Full programmatic access for integration with other tools.
- **Native Swift Integration**: Pre-loaded with 29 production-ready Swift snippets covering modern patterns.

## Built-in Snippet Library

Rookery ships with a curated collection of Swift code covering:

- **Async/Await**: Actors, TaskGroups, and Concurrency patterns.
- **Data Structures**: Stacks, Queues, Graphs, and LRU Caches.
- **Networking**: Type-safe API clients and WebSocket implementations.
- **Error Handling**: Custom error types and retry logic with backoff.

## Tech Stack

- **Backend**: Swift 6.0 + Vapor 4
- **Database**: SQLite (via Fluent ORM)
- **Templating**: Leaf
- **Syntax Highlighting**: Splash
- **Image Generation**: freeze CLI integration

---

**Built with Swift 6 + Vapor 4** | Powered by [freeze](https://github.com/charmbracelet/freeze)

[View Source on GitHub](https://github.com/aviatorcards/rookery)
[View Live Site](https://rookery.fddl.dev)
