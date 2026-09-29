# Obsidian Markdown

Agent reference for writing and reviewing Obsidian note files. Local attachment and naming conventions come from the main skill. Official guides are linked below; query blocks and Kanban boards depend on community plugins.

## Views and rendered output

- Reading view shows the note without Markdown syntax. Use it to check final document formatting.
- Live Preview is an editing mode. It formats much of the note but reveals underlying syntax when the cursor enters formatted content.
- Source mode displays the Markdown as written.

When investigating a rendering complaint, establish the active view and inspect the affected content in Reading view. A syntax check alone does not verify its appearance. The inline-footnote limitation below applies to `^[text]`, not to every kind of footnote.

## Paragraphs and line breaks

Use a blank line between paragraphs. For an explicit line break within a paragraph, write two spaces before the newline. When the vault's strict-line-breaks setting is enabled, a single newline without trailing spaces becomes a space in rendered output.

Repeated blank lines do not create extra paragraph spacing in Reading view. Use paragraph structure rather than extra blank lines to separate ideas.

## Links

| Syntax | Target |
| --- | --- |
| `[[Note Title]]` | a note, by filename without `.md` |
| `[[Note Title\|shown text]]` | same, with display text (escape `\|` only inside tables) |
| `[[Note Title#Heading]]` | a heading inside a note |
| `[[Note Title#^block-id]]` | a block; define its identifier as described below |
| `[[#Heading]]` | a heading in the current note |
| `[[#^block-id]]` | a block in the current note |
| `[[Folder/Note Title]]` | a note whose title isn't unique in the vault |

Link by title alone unless two notes share it. Linking to a note that doesn't exist yet is valid — it marks a note worth writing.

Obsidian also supports Markdown links such as `[Note title](Note%20Title.md)` and external links such as `[Source](https://example.com)`. URL-encode spaces in Markdown destinations as `%20`. Folder paths in internal links start at the vault root and use `/`.

Include the extension when linking to an attachment, for example `[[Report.pdf]]`. Use descriptive display text for ordinary navigation links and footnotes for numbered source citations.

### Block identifiers

For a paragraph, append a space and the identifier:

```md
A paragraph that another note can reference. ^source-summary
```

For a whole list, quotation, callout or table, put its identifier on a separate line with blank lines before and after it. Block identifiers contain only Latin letters, numbers and dashes. Links to specific parts of quotations, callouts and tables are unsupported.

Block links navigate to existing content. Footnotes create numbered references. Choose the form that matches the document's purpose; block links are specific to Obsidian and do not work as such outside it.

## Footnotes and source citations

Use a reference in the text and a matching definition:

```md
This finding has a source[^1].

[^1]: Author, report title, publication date, p. 8. [Source](https://example.com).
```

Named identifiers also render as numbers:

```md
This finding has a source[^report].

[^report]: Author, report title, p. 18, table 11.
```

- Keep identifiers identical between references and definitions, and define each identifier once.
- Place definitions at the end of the note for editing clarity. Preserve source links, dates and page or table locators when converting citations. Use distinct definitions when different passages need different locators.
- Indent continuation lines in a multiline definition by two spaces, as shown in the official guide.
- Check citation markers, table citations and the footnote list in Reading view. The official guide does not specify all table or Live Preview rendering behavior.

Inline footnotes use a different form, with the caret outside the brackets:

```md
A finding with an inline footnote. ^[Source details.]
```

The official guide states that inline footnotes work only in Reading view, not Live Preview. Prefer reference-and-definition footnotes for sourced documents that need to be edited and reviewed. The Footnotes view core plugin can list all footnotes in the active note.

## Tables

Use pipe tables with a header and separator row. Cells need no manual space padding for alignment. Align numeric columns to the right with `---:`:

```md
| Comparison | Monthly pay | Source |
| --- | ---: | --- |
| Specialist | 54,359 | [[Salary report\|Report]] |
```

Escape a literal pipe inside a cell, including a wikilink display-text separator or image size, as `\|`. Check wide tables in Reading view and shorten lengthy cell prose when it makes the table hard to scan.

## Embeds

Prefix a link with `!` to render the target inline:

- `![[Note Title]]`, `![[Note Title#Heading]]` — transclude a note or section
- `![[image.png]]`, `![[image.png|300]]` — image, optionally sized to a width in px
- `![[file.pdf]]` — PDFs, audio, and other attachments

Put the embedded file in `attachments/` beside the note, then embed it by filename.

For a specific PDF page, use `![[Report.pdf#page=3]]`. The official guide also supports a viewer height, for example `![[Report.pdf#height=400]]`. Verify that the selected PDF page matches the printed page cited in the document.

## Frontmatter (properties)

YAML between `---` fences on the first line of the file:

```yaml
---
tags:
  - project
  - type/term
aliases:
  - Alternate Title
created: 2026-09-29
source: "https://example.com"
---
```

- `tags` and `aliases` are lists; write tag values without `#`
- `aliases` make `[[Alternate Title]]` resolve to this note
- Dates as `YYYY-MM-DD`; quote strings containing `:` or `#`
- Custom keys are fine — Dataview queries read them (e.g. `definition:` in glossary notes)
- `kanban-plugin: board` marks a Kanban file; leave it in place

## Tags

Inline `#tag` anywhere in the body, or in frontmatter `tags`. Nest with `/`: `#type/term`. Letters, digits, `_`, `-`, `/`; at least one non-digit; no spaces.

## Callouts

```markdown
> [!note] Optional title
> Body text.
```

Types: `note`, `tip`, `info`, `warning`, `danger`, `question`, `example`, `quote`, `todo`, `success`, `failure`, `bug`, `abstract`. Append `-` to collapse by default (`> [!tip]-`), `+` to expand.

## Query blocks

Fenced blocks tagged `tasks` or `dataview` require their respective community plugins to render query results. Check that the relevant plugin is installed and enabled before adding a query. Markdown task lists such as `- [ ] Read the report` are built-in syntax.

````markdown
```tasks
not done
tags include #netlight
```

```dataview
TABLE WITHOUT ID file.link AS Term, definition AS Definition
FROM #type/term
SORT file.name ASC
```
````

To make an item appear in a query view, edit the source notes (add the tag, property, or task), then leave the query to render it.

## Other file types

- `.base` — Bases view definitions (YAML)
- `.canvas` — JSON Canvas: `nodes` and `edges` arrays

Both are editable; keep them valid YAML / JSON.

## Comments

`%% hidden text %%` — visible in the editor, hidden when rendered.

## HTML and Markdown

Obsidian does not render Markdown syntax inside HTML elements. Use native Markdown tables, links and emphasis when they need Markdown processing, rather than placing them inside `<div>`, `<span>` or `<table>` wrappers.

## Official guides

- [Basic formatting syntax](https://help.obsidian.md/syntax), paragraphs, line breaks, external links, task lists and footnotes.
- [Views and editing mode](https://help.obsidian.md/edit-and-read), rendering differences between Reading view, Live Preview and Source mode.
- [Internal links](https://help.obsidian.md/links), heading links, block identifiers, display text and attachment links.
- [Advanced formatting syntax](https://help.obsidian.md/advanced-syntax), table formatting and escaping pipes inside cells.
- [Embed files](https://help.obsidian.md/embeds), attachment embeds and PDF page selection.
- [Obsidian Flavored Markdown](https://help.obsidian.md/obsidian-flavored-markdown), supported extensions and the Markdown-inside-HTML limitation.

If a help page fetch returns only a title or loading shell, retrieve the corresponding Markdown file from the official [obsidianmd/obsidian-help repository](https://github.com/obsidianmd/obsidian-help/tree/master/en). Verify the relevant passage before treating the page as evidence.
