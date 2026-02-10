---
name: locate-thoughts
description: Search the thoughts/ directory to discover relevant documents (tickets, research, plans, PRs, notes). Returns organized file listings grouped by type with corrected paths. Use when you need to find historical context or documentation.
---

## What I Do

Search the thoughts/ directory structure to find relevant documents and categorize them by type. This is a discovery tool — find where documents live, don't analyze their contents.

## Directory Structure

```
thoughts/
├── shared/          # Team-shared documents
│   ├── research/    # Research documents
│   ├── plans/       # Implementation plans
│   ├── tickets/     # Ticket documentation
│   ├── designs/     # Design documents
│   ├── structures/  # Structure documents
│   └── prs/         # PR descriptions
├── allison/         # Personal thoughts (user-specific)
│   ├── tickets/
│   └── notes/
├── global/          # Cross-repository thoughts
└── searchable/      # Read-only mirror (fix paths when reporting)
```

## Search Strategy

1. **Think about search terms first** — consider synonyms, technical terms, component names, and related concepts
2. **Use grep** for content searching across thoughts/
3. **Use glob** for filename patterns (e.g., `thoughts/**/*rate-limit*`)
4. **Check all subdirectories** — shared, personal, global
5. **Search in searchable/** but report corrected paths (remove "searchable/" from results)

## Search Patterns

- Ticket files: often named `eng_XXXX.md` or `ENG-XXXX-description.md`
- Research files: often dated `YYYY-MM-DD-topic.md`
- Plan files: often named `YYYY-MM-DD-feature-name.md`
- Design files: similar dating convention
- PR descriptions: often `{number}_description.md`

## Output Format

```
## Thought Documents about [Topic]

### Tickets
- `thoughts/shared/tickets/eng_1234.md` - Brief description from title

### Research Documents
- `thoughts/shared/research/2024-01-15_topic.md` - Brief description

### Implementation Plans
- `thoughts/shared/plans/topic.md` - Brief description

### Designs
- `thoughts/shared/designs/topic.md` - Brief description

### Related Notes
- `thoughts/allison/notes/meeting_notes.md` - Brief description

Total: N relevant documents found
```

## Rules

- Don't read full file contents — just scan for relevance
- Preserve directory structure — show where documents live
- Fix searchable/ paths — always report actual editable paths
- Be thorough — check all relevant subdirectories
- Group logically — make categories meaningful
- Note date patterns in filenames
- Use multiple search terms (technical terms, component names, related concepts)
