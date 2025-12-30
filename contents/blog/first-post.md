---
title: "The Renaissance of Static Sites"
date: 2024-03-20
description: "Exploring why the world is moving back to static sites and the benefits of simplicity."
tags: ["web", "performance", "architecture"]
layout: post
---

# The Renaissance of Static Sites

For a decade, we were told that everything had to be dynamic. Single Page Applications (SPAs) were the holy grail. But as the web grew more complex, it also grew heavier, slower, and more fragile.

## Why Static?

The return to static site generators isn't a step backward; it's a realization that for most content-driven sites, the trade-off of a dynamic server isn't worth it.

1.  **Security**: No database, no server-side execution, no SQL injection.
2.  **Scale**: Static files can be served from a CDN edge for pennies.
3.  **Speed**: There is nothing faster than serving a pre-rendered HTML file.

## Enter fddl

This is where `fddl` comes in. By using a compiled language like Swift, we can generate thousands of pages in milliseconds. It allows developers to enjoy the type-safety and performance of Swift while outputting a site that anyone can host.

> "Simplicity is the ultimate sophistication." — Leonardo da Vinci

In our next post, we'll dive into how to customize the fddl build pipeline to suit your specific needs.
