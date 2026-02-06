---
title: "bethanyrhodes.com"
description: "The personal website of Bethany Rhodes."
layout: project
tags:
  - open-source
  - eleventy
  - nunjucks
  - webdev
  - music
date: 2026-01-19
---

[bethanyrhodes.com](https://bethanyrhodes.com) is a modern, modular static website built for Bethany Rhodes. It serves as a central hub for her music, performances, and events.

### Tech Stack

- **[Eleventy (11ty)](https://www.11ty.dev/)**: Flexible static site generator used for performance and modularity.
- **[Nunjucks](https://nunjucks.dev/)**: Templating engine for building complex, reusable layouts.
- **Vanilla CSS**: Custom styling with CSS variables for a maintainable design system.
- **EmailJS (Work in progress)**: Integrated for handling contact form submissions without a backend.

### Key Features

- **Dynamic Events System**: Automatically sorts and categorizes performances into "Upcoming" and "Past" events using Eleventy collections.
- **Modular Content**: Easy management of videos, music releases, and news through Markdown-based data files.
- **Responsive Layout**: Mobile-first design ensuring a seamless experience across all device sizes.
- **SEO Optimized**: Semantic HTML and proper metadata management for search engine visibility.

### Content Structure

The project follows a modular architecture where content is decoupled from logic:

- `src/_layouts`: Base templates for consistent branding.
- `src/events`: individual markdown files for gig data.
- `src/videos-data`: Video references and metadata.
- `src/js/contact.js`: client-side logic for the EmailJS integration.
