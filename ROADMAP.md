# FDDL Roadmap

FDDL is a markdown-based static site generator written in Swift, built as a learning project with NotebookLM.

## Related Projects

- **[SwiftMark](../swiftmark)** - Markdown library with similar features (potential integration)
- **[Atmosphere](../atmosphere)** - Journaling app that uses SwiftMark

---

## Current State

FDDL is a functional static site generator with:

- Markdown processing with YAML frontmatter
- Template system with variable substitution
- Shortcodes (YouTube, alerts, retro effects)
- Plugin architecture (sitemaps, RSS, search)
- CLI interface
- Dev server with hot reload

**Current Dependencies**:

- swift-markdown (Apple's parser)
- Yams (YAML parsing)
- Splash (Swift syntax highlighting)
- swift-nio (dev server)

---

## Potential SwiftMark Integration

### Current Situation

FDDL uses swift-markdown directly, while SwiftMark is a wrapper around swift-markdown with additional features.

### Evaluation Needed

- [ ] Compare FDDL's markdown processing with SwiftMark's capabilities
- [ ] Identify any FDDL-specific features not in SwiftMark
- [ ] Evaluate if switching would simplify FDDL's codebase
- [ ] Consider if shared improvements would benefit both projects

### Potential Benefits of Integration

- **Consistency**: Single markdown processor across all projects
- **Shared Improvements**: SwiftMark enhancements automatically benefit FDDL
- **Reduced Duplication**: Less code to maintain
- **Community**: SwiftMark improvements from others benefit FDDL

### Potential Drawbacks

- **Dependency**: Adds another layer of abstraction
- **Flexibility**: May lose some FDDL-specific customizations
- **Complexity**: Migration effort required

**Decision**: Evaluate when SwiftMark reaches feature parity with FDDL's needs

---

## FDDL-Specific Improvements

### 1. Dev Server Enhancements

**Priority**: Medium | **Effort**: Medium

- [ ] Improve hot reload reliability
- [ ] Add live preview in browser
- [ ] Better error reporting during development
- [ ] Watch mode for automatic rebuilds

---

### 2. Plugin System Expansion

**Priority**: Low | **Effort**: Medium

- [ ] API JSON output (api.yml)
- [ ] 404 error page generation
- [ ] Sitemap generation improvements
- [ ] RSS 2.0 feed enhancements
- [ ] Search index optimization

---

### 3. Template System Improvements

**Priority**: Low | **Effort**: Medium

- [ ] More flexible variable substitution
- [ ] Conditional rendering
- [ ] Loops for generating lists
- [ ] Partial templates for reusability

---

### 4. macOS Services Integration

**Priority**: Low | **Effort**: Low

- [ ] Add to macOS Services menu
- [ ] Quick actions for markdown files
- [ ] Right-click context menu integration

---

## Frontmatter Pattern (Already Established)

FDDL uses YAML frontmatter consistently:

```markdown
---
title: "Entry Title"
description: "Brief description"
date: 2026-02-06
tags: [tag1, tag2, tag3]
layout: post
custom_field: "custom value"
---

# Content starts here
```

**This pattern is being adopted by**:

- Atmosphere (for journal entries)
- Any future projects using SwiftMark

**Benefits**:

- Consistent metadata across projects
- Portable content
- Extensible with custom fields

---

## Relationship to Other Projects

### Atmosphere

- Atmosphere uses SwiftMark for markdown processing
- Could potentially export journal entries as FDDL-compatible markdown files
- Shared frontmatter pattern enables interoperability
- Atmosphere entries could become blog posts via FDDL

### SwiftMark

- FDDL could switch to SwiftMark for consistency
- Would benefit from SwiftMark's improvements
- Could contribute FDDL-specific features back to SwiftMark
- Evaluation needed to determine fit

---

## Questions to Consider

1. **SwiftMark Integration**: Would switching to SwiftMark simplify or complicate FDDL?
2. **Feature Parity**: Does SwiftMark support all of FDDL's markdown needs?
3. **Performance**: Would SwiftMark maintain FDDL's build speed?
4. **Customization**: Can SwiftMark be extended for FDDL-specific features?

---

## Quick Wins

Current FDDL improvements (independent of SwiftMark decision):

1. Improve dev server hot reload
2. Enhance error reporting
3. Add more template flexibility

---

For the complete integration roadmap across all projects, see the main [integration analysis](../../.gemini/antigravity/brain/8914a23f-0057-4b15-b75d-ddcbf17aaf03/roadmap.md).
