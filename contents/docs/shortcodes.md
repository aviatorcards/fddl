---
title: "Shortcodes Reference"
description: "Enhance your markdown with dynamic shortcodes."
tags:
  - doc
  - shortcodes
  - advanced
layout: doc
---

# Shortcodes

`fddl` supports shortcodes to add dynamic or complex HTML content to your markdown files without writing HTML.

## Basic Syntax

Shortcodes are wrapped in `{{< ... >}}` tags.

- **Paired**: `{{< name >}}content{{< /name >}}`
- **Self-closing**: `{{< name params />}}` or `{{< name params >}}`

## Available Shortcodes

### YouTube

Embed a YouTube video.

```markdown
{{< youtube id="dQw4w9WgXcQ" />}}
```

- `id`: The YouTube video ID.
- `width`: (Optional) Width in pixels.
- `height`: (Optional) Height in pixels.

### Image

Display an image with an optional caption.

```markdown
{{< image src="/assets/images/photo.jpg" caption="A beautiful sunset" />}}
```

- `src`: Image URL.
- `caption`: (Optional) Text to display underneath.
- `alt`: (Optional) Alt text.
- `width`: (Optional) Width in pixels.
- `align`: (Optional) Text alignment (`left`, `center`, `right`).

### Alert

Create a styled callout box.

```markdown
{{< alert type="warning" title="Heads up!" >}}
This is an important message.
{{< /alert >}}
```

- `type`: `info` (default), `warning`, `error`, `success`.
- `title`: (Optional) Bold title.

### Counter (Retro)

A classic GeoCities-style visitor counter!

```markdown
{{< counter style="digital" />}}
```

- `style`: `digital` (default) or `hidden`.

### Blink (Retro)

Make text blink like it's 1996.

```markdown
{{< blink >}}ATTENTION!{{< /blink >}}
```

### Marquee (Retro)

Scroll text across the screen.

```markdown
{{< marquee direction="left" speed="normal" >}}
Welcome to my website!
{{< /marquee >}}
```

- `direction`: `left`, `right`, `up`, `down`.
- `speed`: `slow`, `normal`, `fast`.

### Rainbow (Retro)

Make your text colorful.

```markdown
{{< rainbow >}}This is FABULOUS!{{< /rainbow >}}
```
