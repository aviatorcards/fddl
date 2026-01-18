---
title: "fddl Features"
description: "A few things fddl can do."
layout: page
tags:
  - demo
  - features
  - geocities
---

# fddl Features

This page demonstrates new features added to fddl.

## Syntax Highlighting

Check out this Swift code with beautiful syntax highlighting:

```swift
struct Person {
    let name: String
    var age: Int

    func greet() {
        print("Hello, my name is \(name)!")
    }
}

let person = Person(name: "Web Developer", age: 25)
person.greet()
```

And here's some JavaScript:

```javascript
function createAwesomeWebsite() {
  const features = ["live reload", "syntax highlighting", "themes"];
  features.forEach((feature) => {
    console.log(`✨ ${feature} is enabled!`);
  });
}

createAwesomeWebsite();
```

## GeoCities-Style Shortcodes

Let's get retro! Here are some classic GeoCities elements:

{{< blink >}}🌟 UNDER CONSTRUCTION 🌟{{< /blink >}}

{{< marquee direction="left" speed="normal" >}}Welcome to my homepage! This text scrolls just like the good old days!{{< /marquee >}}

{{< rainbow >}}Rainbow Text is BACK!{{< /rainbow >}}

{{< counter style="digital" >}}

## Modern Features

### YouTube Embeds

{{< youtube id="dQw4w9WgXcQ" width="560" height="315" >}}

### Alert Boxes

{{< alert type="info" title="Did you know?" >}}
fddl now has a complete plugin system for extending functionality!
{{< /alert >}}

{{< alert type="success" title="Build Status" >}}
Your site was generated successfully! 🎉
{{< /alert >}}

{{< alert type="warning" title="Remember" >}}
Always backup your content before making major changes.
{{< /alert >}}

### Image with Caption

{{< image src="/assets/images/example.jpg" alt="Example image" caption="This is a beautiful example image" width="600" >}}

## Theming System

This site uses the **GeoCities** theme. You can switch between:

- Modern (clean and professional)
- Dark (easy on the eyes)
- Minimal (typography-focused)
- **GeoCities** (maximum nostalgia!)

## Plugin Features

### Sitemap Generation

Automatically generates `sitemap.xml` for SEO.

### RSS Feed

Creates an RSS 2.0 feed at `/feed.xml` for your blog posts.

### Search Index

Builds a searchable JSON index of all your content.

### Reading Time

Estimates how long it takes to read each page.

### Analytics Support

Easy integration with Google Analytics or Plausible.

## Live Development Server

The dev server includes:

- 🔥 Hot reload via WebSocket
- 👀 Watches for file changes
- 🚀 Instant rebuilds
- 🌐 Local preview server

Just run: `fddl serve --open`

## Code Examples

Python with syntax highlighting:

```python
def generate_awesome_site():
    """Generate a static site with fddl"""
    features = {
        'themes': ['modern', 'dark', 'minimal', 'geocities'],
        'plugins': ['sitemap', 'rss', 'search', 'analytics'],
        'shortcodes': ['blink', 'marquee', 'rainbow', 'youtube']
    }

    for category, items in features.items():
        print(f"{category}: {', '.join(items)}")

    return "Site generated! 🎉"

result = generate_awesome_site()
print(result)
```

Bash scripting:

```bash
#!/bin/bash

# Build and deploy your fddl site
echo "🔨 Building site..."
fddl generate

echo "🚀 Starting dev server..."
fddl serve --port 8080

echo "✅ Done!"
```

## Dynamic Site Context

fddl exposes site-wide metadata that you can use anywhere in your content or templates.

{{< alert type="info" title="Build Instance" >}}
This specific build of the demo site has the following properties:

- **Build ID**: `{{site.buildID}}`
- **Commit**: `{{site.commitHash}}`
- **Generated On**: {{site.generatedDate}}
  {{< /alert >}}

## More GeoCities Fun

{{< marquee direction="right" speed="fast" >}}⭐ BEST VIEWED IN NETSCAPE NAVIGATOR ⭐{{< /marquee >}}

{{< blink >}}NEW!{{< /blink >}} Check out my guestbook!

---

**Built with fddl** - A modern static site generator with retro vibes! 🌈✨
