---
title: "Templating Engine"
description: "How to build and customize your own views."
tags:
  - doc
  - templates
  - advanced
layout: doc
---

# Templating Engine

The `fddl` engine uses a custom-built, logic-light templating syntax inspired by Handlebars.

## Variable Substitution

Variables are wrapped in double curly braces: `{{variable}}`.

### Page Variables (`page.`)

- `{{page.title}}`: Page title from frontmatter or filename.
- `{{page.content}}`: The rendered HTML of the page.
- `{{page.description}}`: Meta description from frontmatter.
- `{{page.date}}`: Formatted date (if provided in frontmatter).
- `{{page.url}}`: The relative URL path.
- `{{page.tags}}`: An array of tags assigned to the page.

### Site Global Variables (`site.`)

- `{{site.name}}`: The site name from `template.yml`.
- `{{site.buildID}}`: Unique ID for the current build.
- `{{site.commitHash}}`: Current Git commit hash.
- `{{site.generatedDate}}`: Human-readable build timestamp.
- `{{site.pages}}`: List of all processed pages.
- `{{site.navigation}}`: Array of `{label, url}` objects.
- `{{site.recentPosts}}`: The 5 most recent posts by date.
- `{{site.allTags}}`: Every unique tag used across the site.

## Filters

Transform values by piping them to a filter: `{{page.title | uppercase}}`.

- `| uppercase`: CONVERT TO ALL CAPS.
- `| lowercase`: convert to all lowercase.
- `| capitalize`: Capitalize The First Letter Of Each Word.
- `| formatDate`: Format date strings based on system locale.

## Logic Blocks

### Each Loop

Iterate over collections:

```html
<ul>
  {{#each site.recentPosts}}
  <li><a href="{{this.url}}">{{this.title}}</a></li>
  {{/each}}
</ul>
```

### If Conditional

Conditional rendering:

```html
{{#if page.author}}
<span>By {{page.author}}</span>
{{/if}}
```

## Shortcodes

`fddl` supports Hugo-style shortcodes for advanced content like YouTube embeds, alerts, and retro effects. See the [Shortcodes Reference](/docs/shortcodes.html) for more.

## Available Templates

fddl includes 13 pre-built templates with distinct themes and use cases. Choose a template when generating your site:

```bash
fddl generate --template=minimal
```

### Professional Templates

#### Default (GeoCities)

The original fddl template with a retro 90s GeoCities aesthetic. Features bright colors, playful design elements, and nostalgic vibes.

**Use cases:** Fun personal sites, creative portfolios, nostalgic projects

#### Minimal

Ultra-clean minimalist design with generous whitespace and typography focus. Black and white with system fonts for maximum clarity.

**Color palette:** Black (#000000), Gray (#666666), White (#ffffff)
**Use cases:** Personal portfolios, professional blogs, simple documentation

#### Blog

Blog-focused layout with reading-optimized typography (Georgia serif) and prominent sidebar. Classic blog aesthetic with emphasis on content.

**Color palette:** Navy (#2c3e50), Blue (#3498db), Light gray background
**Use cases:** Content-heavy blogs, article sites, writing portfolios

#### Docs

Technical documentation theme with strong left-sidebar navigation and code focus. Clean, professional appearance optimized for technical content.

**Color palette:** Blue (#0066cc), Light gray background (#f8f9fa)
**Use cases:** Technical documentation, API references, guides, tutorials

#### Magazine

News/magazine style with bold headings (Oswald font), serif body text, and support for multi-column layouts.

**Color palette:** Red (#c0392b), Merriweather serif font
**Use cases:** News sites, content aggregation, online magazines

### Design Variety Templates

#### Brutalist

Bold brutalist web design with raw HTML aesthetics, stark contrasts, monospace fonts, and thick black borders. Intentionally unpolished and confrontational.

**Color palette:** Black/White with Red (#ff0000) and Yellow (#ffff00) accents
**Use cases:** Artistic portfolios, experimental sites, statement pieces

#### Neon

Cyberpunk neon aesthetic with glowing text effects on dark background. Terminal-style fonts with bright neon accents.

**Color palette:** Neon green (#00ff00), Magenta (#ff00ff), Cyan (#00ffff) on black
**Use cases:** Tech blogs, gaming sites, cyberpunk-themed projects

#### Vintage

Vintage newspaper/print style with serif fonts and aged paper colors. Classic typography with warm, nostalgic tones.

**Color palette:** Brown (#3d2817), Tan (#c19a6b), Cream background (#f4e8d0)
**Use cases:** Literary sites, vintage aesthetics, historical content

#### Nature

Nature-inspired with earth tones, organic design elements, and rounded corners. Calm, peaceful aesthetic.

**Color palette:** Forest green (#2d5016), Olive (#6b8e23), Beige background (#f5f5dc)
**Use cases:** Environmental blogs, outdoor content, wellness sites

### Era-Inspired Templates

#### Retro 80s

1980s computer aesthetic with CRT terminal colors, bitmap fonts, and neon grid background. Pure nostalgia.

**Color palette:** Hot pink (#ff1493), Cyan (#00ffff), Yellow (#ffff00) on purple-black
**Use cases:** Retro computing, nostalgia projects, vaporwave aesthetics

#### Y2K

Y2K/early 2000s style with gradients, bubble effects, Comic Sans, and metallic touches. Peak early internet vibes.

**Color palette:** Hot pink (#ff69b4), Purple (#9370db), Sky blue (#00bfff), pastel backgrounds
**Use cases:** Nostalgic sites, creative portfolios, fun personal pages

#### Web 2.0

Web 2.0 style with glossy buttons, subtle reflections, and rounded corners. Professional 2000s-era design.

**Color palette:** Blue (#4a90e2), Gray (#7f8c8d), Green accent (#27ae60)
**Use cases:** Business sites, SaaS landing pages, professional blogs

#### Glass

Modern glassmorphism with frosted glass effects, backdrop filters, soft shadows, and blur. Contemporary and elegant.

**Color palette:** Purple gradient (#667eea to #764ba2 to #f093fb), transparent overlays
**Use cases:** Modern portfolios, contemporary design showcases, creative agencies

## Template Customization

Each template includes:

- **template.yml** - Theme configuration (colors, fonts, spacing)
- **html.yml** - Output format configuration
- **views/** - HTML template files for different layouts
- **assets/css/theme.css** - Stylesheet with theme variables
- **assets/javascript/theme.js** - Interactive features

To customize a template:

1. Copy a template directory: `cp -r templates/minimal templates/my-theme`
2. Edit `template.yml` to change colors, fonts, and settings
3. Modify `assets/css/theme.css` for styling changes
4. Update view files in `views/` for structure changes
5. Use your custom template: `fddl generate --template=my-theme`
