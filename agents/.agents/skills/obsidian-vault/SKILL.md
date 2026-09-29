---
name: obsidian-vault
description: Search, read, and write notes in the operator's Obsidian vault. Use when the operator says "my notes", "my vault", "Obsidian", or "daily note"; asks to look up, capture, jot, or file something in their own notes rather than on the web; or asks to summarize, link, or reorganize existing notes.
---

# Obsidian vault

## Vault location

The vault path is the single line in `.obsidian-vault` at the repo root
(`git rev-parse --show-toplevel`; outside a repo, the working directory) —
an absolute path, nothing else. Read it once per session and reuse the
literal path; quote it, vault paths often contain spaces.

If the file is missing or the folder it names doesn't exist, ask the operator
for the path, then offer to write it to `.obsidian-vault`.

Every note in the vault is editable.

Before adding or reviewing links beyond a plain `[[wikilink]]`, footnotes, tables, frontmatter, tags, embeds, callouts, tasks, query blocks, or Kanban boards, read [`OBSIDIAN-MARKDOWN.md`](OBSIDIAN-MARKDOWN.md). Also read it when diagnosing formatting or differences between Reading view and Live Preview.

## Conventions

- Filename = the note's title; wikilinks resolve against it, so pick it as the title you'd link by
- Match the folder you're writing into: its naming style, language, and whether its notes carry frontmatter
- Daily notes: `Daily notes/YYYY-MM-DD.md`
- Attachments: `attachments/` beside the note that embeds them
- Tables: Markdown table syntax (`| Col | ... |`)

## Workflows

### Search

Use Grep/Glob on the vault path. Search filenames and content both — a note's title and its body often use different words.

### Find backlinks

```bash
rg -l "\[\[Note Title(#|\||\]\])" "<vault>"
```

Also try the lowercase-hyphenated form (`[[note-title]]`) — some links use it.

### Rename or move a note

A filesystem rename bypasses Obsidian's link updater. Find every backlink to the old title (above), rename, then rewrite each link to the new title. Done when a search for the old title returns no links.

### Create a note

1. Pick the folder by topic. If no existing folder fits, offer to create one.
2. Name it as its title, in the folder's existing style.
3. Link it to related notes with `[[wikilinks]]`.
4. Report the title and folder.

### Add to today's daily note

Open `Daily notes/<YYYY-MM-DD>.md`, creating it if missing. Append under a fitting heading, keeping the day's existing entries intact.

### Review or fix formatting

1. Check the relevant syntax against the Markdown reference. For behavior it does not cover, consult the official guide linked from that reference before changing the note.
2. Check that every footnote reference has a matching definition, source locators remain intact, and links point to the intended files, headings or blocks.
3. Verify the rendered result in Reading view, directly when available or through the operator's confirmation. If only the Markdown was inspected, report that the syntax was checked and rendering remains unverified.
