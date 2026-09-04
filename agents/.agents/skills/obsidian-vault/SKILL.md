---
name: obsidian-vault
description: Search, read, and write notes in the user's personal Obsidian vault — free-form notes plus a generated wiki/ knowledge base. Use when the user says "my notes", "my vault", "Obsidian", or "daily note"; asks to look up, capture, jot, or file something in their own notes rather than on the web; or asks to summarize, link, or reorganize existing notes.
---

# Obsidian Vault

## Vault location

Read from a `.obsidian-vault` config. Nearest wins: the working directory, then
the repo root, then `~/.claude/.obsidian-vault`. Resolve once per session and
reuse the literal path — file tools don't expand shell vars, and vault paths
often contain spaces.

```bash
for f in "./.obsidian-vault" \
         "$(git rev-parse --show-toplevel 2>/dev/null)/.obsidian-vault" \
         "$HOME/.claude/.obsidian-vault"; do
  [ -f "$f" ] && CFG="$f" && break
done
VAULT="$(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$CFG" | head -1)"
VAULT="${VAULT/#\~/$HOME}"; VAULT="${VAULT//\$HOME/$HOME}"
echo "$CFG -> $VAULT"
```

If no config exists, or the folder it names doesn't, say which is missing and
ask — then offer to write the answer to `./.obsidian-vault` (this repo) or
`~/.claude/.obsidian-vault` (everywhere). Don't guess a path.

## Two zones

The vault splits in two, and the split decides whether you may write:

- **`$VAULT/wiki/` is READ-ONLY.** A generated knowledge base — search it, read
  it, cite it, follow its links. Never create, edit, move, or delete anything
  inside it, `index.md` and `log.md` included. If a request would change the
  wiki, say so and propose the equivalent free note instead.
- **Everything else is writable** — These are the user's own
  free-form notes. Create and edit here.

## Naming conventions

Free notes have no imposed scheme — match the folder you're writing into.

- Filename = the note's title; it's what wikilinks resolve against
- Add frontmatter.
- Daily notes live in `Daily notes/` as `YYYY-MM-DD.md`
- Attachments go in `attachments/` beside the note (`attachmentFolderPath`)
- Format tables using standard Markdown table syntax (`| Col | ... |`), never ASCII or Unicode box-drawing character art.

## Linking

- Free notes use bare Obsidian wikilinks: `[[Note Title]]`, `[[Note Title|shown]]`
- Wiki pages use full paths: `[[concepts/page-name|Display]]`,
  `[[entities/page-name|Display]]` — match that form when linking *to* the wiki
- Some wiki links omit the folder prefix (`[[agentic-loop]]`), so a backlink
  hunt should try the bare form too, not just the prefixed one
- Renaming a note breaks incoming links. Obsidian repairs these itself when the
  rename happens in-app (`alwaysUpdateLinks: true`), but a filesystem rename
  bypasses that — grep for the old title and fix the links yourself

## Workflows

### Search for notes

```bash
# Search by filename
find "$VAULT" -name "*.md" | grep -i "keyword"

# Search by content
grep -rl "keyword" "$VAULT" --include="*.md"

# Free notes only (skip the wiki)
grep -rl "keyword" "$VAULT" --include="*.md" | grep -v "/wiki/"
```

Or use Grep/Glob tools directly on the vault path. Search both zones when
answering a question — the wiki holds the structured knowledge, the free notes
hold the user's own thinking.

### Answer from the wiki

1. `cat "$VAULT/wiki/index.md"` — the generated directory of every page
2. Read the pages it points at; follow `## Related Concepts` / `## Related
   Entities` to pull in the neighbourhood
3. Cite page names so the answer maps back into the vault

### Find backlinks

Wiki links carry a folder prefix, so match on the path:

```bash
grep -rlE "\[\[(concepts/)?page-name" "$VAULT"   # wiki page, prefixed or bare
grep -rl "\[\[Note Title" "$VAULT"               # free note
```

### Create a new note

Free zone only.

1. Pick the folder by topic. If none existing is matching, offer to create a new folder.
2. Name it as its title, matching the folder's existing style
4. Link it in with `[[wikilinks]]`.
5. Report the title and folder

### Add to today's daily note

`Daily notes/<YYYY-MM-DD>.md`. Append under a fitting heading, preserving the
day's existing entries; create the file if it doesn't exist yet.
