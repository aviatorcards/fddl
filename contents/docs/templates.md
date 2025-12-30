---
title: "Templating Engine"
description: "How to build and customize your own views."
tags: ["doc", "templates", "advanced"]
layout: doc
---

# Templating Engine

The `fddl` engine uses a custom-built, logic-light templating syntax inspired by Handlebars.

## Basic Substitution

Wrap variable names in double curly braces:

```html
<h1>{{page.title}}</h1>
<p>{{page.description}}</p>
```

## Logic Blocks

### Each Loop
Iterate over lists like pages or tags:

```html
{{#each site.recentPosts}}
  <li><a href="{{this.url}}">{{this.title}}</a></li>
{{/each}}
```

### If Conditional
Show or hide content based on the presence of a value:

```html
{{#if page.date}}
  <time>{{page.date}}</time>
{{/if}}
```

## Filters

Transform values before outputting them:

- `| uppercase`: Convert to all caps.
- `| formatDate`: Format a date string using the system locale.

Example:
```html
<span>{{page.title | uppercase}}</span>
```
