---
name: obsidian-vault
description: >-
  Read, search, create, and edit notes in the user's personal Obsidian vault,
  located at "$HOME/Documents/Remote vault primary". Use this skill WHENEVER the
  user refers to "my notes", "my vault", "my Obsidian", a "daily note", or asks
  to find / look up / write down / jot / capture / file something into their
  notes — even if they don't say the word "Obsidian". Also use it when the user
  asks to summarize, link, or reorganize existing notes, or to add to today's
  daily note. If a request plausibly concerns the user's own knowledge base
  rather than the wider web, reach for this skill before falling back to generic
  file tools, so that Obsidian conventions (wikilinks, tags, frontmatter, daily
  notes) are respected.
---

# Obsidian vault

This skill lets you work inside the user's Obsidian vault as a careful, native
collaborator — someone who knows where their notes live and respects the
conventions Obsidian relies on, rather than treating the vault as an anonymous
pile of Markdown files.

An Obsidian vault is just a folder of plain Markdown (`.md`) files plus a hidden
`.obsidian/` config folder. Almost everything special about it — wikilinks,
tags, frontmatter, daily notes, embeds — is a *convention* layered on top of
plain text. Honoring those conventions is what keeps the user's graph of linked
notes intact. Breaking them (e.g. writing a link Obsidian can't resolve, or
clobbering frontmatter) silently degrades their vault, which is the main thing
to avoid.

## The vault location

The vault is at:

```
$HOME/Documents/Remote vault primary
```

Note the spaces in the folder name. They are a common source of broken commands,
so two habits matter:

1. **Resolve `$HOME` to a literal path once, at the start of a session**, because
   not every tool expands shell variables. Run:
   ```bash
   echo "$HOME/Documents/Remote vault primary"
   ```
   and use the resulting absolute path for file-tool operations.
2. **Always quote the path** in shell commands: `"$HOME/Documents/Remote vault primary"`,
   never bare. Define a variable to keep commands readable:
   ```bash
   VAULT="$HOME/Documents/Remote vault primary"
   ls "$VAULT"
   ```

If that folder doesn't exist (e.g. the vault is synced under a different name or
not present on this machine), say so plainly and ask the user for the correct
path rather than guessing or creating a new folder.

## Orient yourself first (cheap, do it once)

Before creating or substantially editing notes, take a moment to learn how *this*
vault is configured. The user's preferences live in `.obsidian/`, so you don't
have to guess. Read these if present:

- `.obsidian/daily-notes.json` — daily note settings: `folder` (where dailies
  go), `format` (a Moment.js date format such as `YYYY-MM-DD`), and `template`
  (path to a template note). If the file is absent, Obsidian's defaults are
  format `YYYY-MM-DD` and folder = vault root.
- `.obsidian/app.json` — among other things, `attachmentFolderPath` tells you
  where pasted images/files should go (a folder name, `/` for vault root, or
  `./` for "same folder as the note").
- `.obsidian/templates.json` — the templates folder, if the user uses templates.

You usually don't need to read the whole vault. Glob and grep are enough to find
what you need on demand:

```bash
# list note titles
find "$VAULT" -name '*.md' -not -path '*/.obsidian/*'

# full-text search across notes
grep -rl --include='*.md' "search term" "$VAULT"
```

Skip the `.obsidian/`, `.trash/`, and any `.git/` directories when searching for
content — they aren't notes.

## Obsidian conventions you must preserve

These are the load-bearing conventions. Getting them right is the whole point of
the skill.

### Wikilinks
Obsidian links notes by **title (filename without `.md`), not by path**:

- `[[Note Name]]` → links to the file `Note Name.md`, wherever it lives in the
  vault. You do not include the folder or the extension.
- `[[Note Name|shown text]]` → same link, custom display text.
- `[[Note Name#Heading]]` → link to a heading inside that note.
- `[[Note Name#^blockid]]` → link to a specific block.
- `![[Note Name]]` → *embeds* (transcludes) the whole note inline.
- `![[image.png]]` → embeds an attachment.

When you reference another note, link it by its title and trust Obsidian to
resolve the path. Before inventing a `[[link]]`, check the target note actually
exists (glob for `Target.md`); a link to a non-existent note is valid Obsidian
("unresolved link") but is often a typo, so flag it unless the user clearly wants
to create that note next.

### Tags
- Inline: `#topic`, nested as `#area/subarea`. They can appear anywhere in the
  body.
- Frontmatter: a `tags:` property (a YAML list, or space/comma-separated).
- Tags are written **without** the `#` in frontmatter but **with** it inline —
  match whichever style the surrounding notes already use.

### Frontmatter (Properties)
A YAML block fenced by `---` at the very top of the file, before any other
content:

```markdown
---
tags: [reading, ideas]
created: 2025-06-29
aliases: [Alt Title]
---

# Note body starts here
```

When editing an existing note, **treat its frontmatter as sacred**: read it,
preserve every key you're not explicitly changing, and keep it valid YAML. A
common, damaging mistake is to rewrite a note and drop or mangle its frontmatter.
If a note has no frontmatter and the user hasn't asked for any, don't add it.

## Reading and searching

This is the most common request ("what did I write about X?", "find my note on
Y", "summarize my notes about Z"). Approach:

1. Search by filename first (`find … -iname '*term*.md'`) for direct title hits.
2. Then full-text grep across note bodies for the concept.
3. Read the matching notes, follow relevant `[[wikilinks]]` to gather connected
   context, and synthesize an answer that cites note titles so the user can find
   them.

When summarizing, quote sparingly and link notes by title so your answer doubles
as a map back into their vault.

## Creating notes

1. **Filename = the note's title** (e.g. `Project Kickoff.md`). The title is what
   wikilinks will reference, so make it clean and human-readable.
2. **Choose a sensible folder.** Look at how the vault is already organized and
   place the note where similar notes live. If it's genuinely unclear, put it in
   the vault root and mention where you put it. Don't invent elaborate new folder
   structures unasked.
3. **Frontmatter is optional** — add it only if the vault's other notes use it or
   the user asks. If you do, mirror the keys/style the vault already uses (often a
   `created` date and `tags`).
4. **Link it in.** A new note that nothing links to is an orphan. Where it makes
   sense, add `[[wikilinks]]` to related existing notes (and consider linking the
   new note *from* an obvious hub note), so it joins the graph.
5. After creating, tell the user the title and folder so they can find it.

## Editing notes

- Read the whole note first, including frontmatter, then make the smallest change
  that satisfies the request.
- Preserve frontmatter, existing links, tags, and the author's voice/formatting.
- If the user's edit renames a note, remember that **incoming `[[links]]` point at
  the old title** and will break. Offer to update references (grep the vault for
  `[[Old Title]]` and `[[Old Title|`).
- Prefer surgical edits over wholesale rewrites of notes the user has authored.

## Daily notes

The user uses daily notes occasionally. To work with one (e.g. "add this to
today's note", "what's in my daily note"):

1. Read `.obsidian/daily-notes.json` for `folder` and `format`. Translate the
   Moment.js `format` to the actual date — e.g. `YYYY-MM-DD` → `2025-06-29`. If
   the config is missing, default to `YYYY-MM-DD` in the vault root.
2. The daily note's path is `<folder>/<formatted-date>.md`.
3. If it already exists, append to it (don't overwrite the day's existing
   entries). If it doesn't, create it — applying the daily-note `template` if one
   is configured — then add the content.
4. When *appending*, add your content under an appropriate heading or at the end,
   preserving what's already there.

## Good citizenship

The vault is the user's personal knowledge base, often built over years. So:

- **Never bulk-reorganize, rename, or delete** notes unless explicitly asked, and
  even then, confirm scope first and report exactly what changed.
- Stay within the vault; don't read unrelated parts of the filesystem.
- When unsure whether something is destructive (moving files, mass find-and-
  replace across notes, editing many files), describe the plan and get a yes
  before doing it.
- Leave `.obsidian/`, `.trash/`, and `.git/` alone unless the user specifically
  asks about configuration.
