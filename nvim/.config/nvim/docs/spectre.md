# Spectre — project-wide find & replace

Text-based search/replace across files, with a preview buffer you edit before
committing. **Not** a rename tool — for renaming a code symbol use `<leader>rn`
(LSP rename), which is scope-aware. Reach for Spectre when there's no LSP, or
when the thing you're changing isn't a symbol (string, URL, env var, comment,
markdown, config).

## Opening it

| Key | Mode | What |
| --- | --- | --- |
| `<leader>ss` | n | Open/close Spectre, empty search |
| `<leader>sw` | n | Open with the word under the cursor |
| `<leader>sw` | v | Open with the visual selection |
| `<leader>sf` | n | Search **current file only**, word under cursor |

## The panel

Three editable lines at the top:

```
Search:   old_name
Replace:  new_name
Path:     src/          <- optional; blank = whole project
```

Edit them like any buffer (`cc` on the line is handy). Results refresh as you
leave insert mode. `Path` accepts globs and multiple space-separated entries,
e.g. `*.py`, `src/ tests/`, `!node_modules`.

## Keys inside the panel

| Key | Action |
| --- | --- |
| `<leader>R` | **Replace all** matches |
| `<leader>rc` | Replace just the match under the cursor |
| `dd` | Toggle a match off — excluded from replace all |
| `<CR>` | Jump to the file at that match |
| `<Tab>` / `<S-Tab>` | Next / previous match |
| `<leader>q` | Send all matches to the quickfix list |
| `<leader>o` | Options menu |
| `<leader>v` | Toggle view mode (show only replacement text) |
| `<leader>l` | Resume last search |
| `ti` | Toggle ignore-case |
| `th` | Toggle searching hidden files |

## Typical run

1. Cursor on the thing you want gone → `<leader>sw`
2. `j` to the Replace line, `cc`, type the new text, `<Esc>`
3. Skim the results; `dd` on any match you want to keep
4. `<leader>R`
5. `<leader>ss` to close

Replacements write straight to the files on disk (unsaved buffers get updated
too). There's no undo across files — if it goes wrong, `git checkout` is your
safety net, so run it on a clean tree.

## Regex

The Search line is a regex (ripgrep syntax). Capture groups work:

```
Search:   get_(\w+)_value
Replace:  fetch_$1
```

Word boundaries are worth the habit: `\bcount\b` won't match `counter`.
