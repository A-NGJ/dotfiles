---
name: vim-treesitter
description: Complete reference for Neovim's vim.treesitter API — all functions, arguments, and submodules. Use this skill whenever the user asks about treesitter functions, treesitter queries, syntax highlighting, TSNode manipulation, or tree-sitter configuration in Neovim, even if they don't say "vim.treesitter" explicitly.
---

## vim.treesitter

```lua
vim.treesitter.get_parser(bufnr?, lang?, opts?) -> vim.treesitter.LanguageTree?, string?
vim.treesitter.get_string_parser(str, lang, opts?) -> vim.treesitter.LanguageTree
vim.treesitter.get_node(opts?) -> TSNode?
  -- opts: { bufnr?, pos?, lang?, ignore_injections?, include_anonymous? }
vim.treesitter.get_node_text(node, source, opts?) -> string
vim.treesitter.get_node_range(node_or_range) -> integer, integer, integer, integer
vim.treesitter.get_range(node, source?, metadata?) -> Range6
vim.treesitter.get_captures_at_pos(bufnr, row, col) -> {capture, lang, metadata, id}[]
vim.treesitter.get_captures_at_cursor(winnr?) -> string[]
vim.treesitter.start(bufnr?, lang?)
vim.treesitter.stop(bufnr?)
vim.treesitter.inspect_tree(opts?)
vim.treesitter.foldexpr(lnum?) -> string
vim.treesitter.is_ancestor(dest, source) -> boolean
vim.treesitter.is_in_node_range(node, line, col) -> boolean
vim.treesitter.node_contains(node, range) -> boolean
```

## vim.treesitter.language

```lua
vim.treesitter.language.add(lang, opts?) -> boolean?, string?
  -- opts: { path?, symbol_name? }
vim.treesitter.language.register(lang, filetype)
vim.treesitter.language.get_lang(filetype) -> string?
vim.treesitter.language.get_filetypes(lang) -> string[]
vim.treesitter.language.inspect(lang) -> TSLangInfo
```

## vim.treesitter.query

```lua
vim.treesitter.query.get(lang, query_name) -> vim.treesitter.Query?
vim.treesitter.query.set(lang, query_name, text)
vim.treesitter.query.parse(lang, query) -> vim.treesitter.Query
vim.treesitter.query.get_files(lang, query_name, is_included?) -> string[]
vim.treesitter.query.add_predicate(name, handler, opts?)
  -- opts: { all?, force? }
vim.treesitter.query.add_directive(name, handler, opts?)
  -- opts: { all?, force? }
vim.treesitter.query.list_predicates() -> string[]
vim.treesitter.query.list_directives() -> string[]
vim.treesitter.query.lint(buf, opts?)
vim.treesitter.query.omnifunc(findstart, base)
vim.treesitter.query.edit(lang?)
```

## vim.treesitter.Query

```lua
Query:iter_captures(node, source, start_row?, end_row?, opts?) -> fun(): integer, TSNode, TSMetadata, TSQueryMatch, TSTree
Query:iter_matches(node, source, start?, stop?, opts?) -> fun(): integer, table<integer, TSNode[]>, TSMetadata, TSTree
```

## TSQuery

```lua
TSQuery:disable_capture(capture_name)
TSQuery:disable_pattern(pattern_index)
```

## vim.treesitter.LanguageTree

```lua
LanguageTree:parse(range?, on_parse?) -> table<integer, TSTree>?
LanguageTree:trees() -> table<integer, TSTree>
LanguageTree:lang() -> string
LanguageTree:source() -> integer|string
LanguageTree:is_valid(exclude_children?, range?) -> boolean
LanguageTree:invalidate(reload?)
LanguageTree:children() -> table<string, vim.treesitter.LanguageTree>
LanguageTree:parent() -> vim.treesitter.LanguageTree?
LanguageTree:for_each_tree(fn)
LanguageTree:contains(range) -> boolean
LanguageTree:tree_for_range(range, opts?) -> TSTree?
  -- opts: { ignore_injections? }
LanguageTree:node_for_range(range, opts?) -> TSNode?
LanguageTree:named_node_for_range(range, opts?) -> TSNode?
LanguageTree:language_for_range(range) -> vim.treesitter.LanguageTree
LanguageTree:included_regions() -> table<integer, Range6[]>
LanguageTree:register_cbs(cbs, recursive?)
  -- cbs: on_changedtree, on_bytes, on_detach, on_child_added, on_child_removed
LanguageTree:destroy()
```

## vim.treesitter.highlighter

```lua
TSHighlighter.new(tree, opts?) -> vim.treesitter.highlighter
TSHighlighter:destroy()
TSHighlighter:get_query(lang) -> vim.treesitter.highlighter.Query
```

## TSNode

```lua
-- Identity
TSNode:type() -> string
TSNode:symbol() -> integer
TSNode:id() -> string

-- Position
TSNode:start() -> integer, integer, integer
TSNode:end_() -> integer, integer, integer
TSNode:range(include_bytes?) -> integer, integer, integer, integer [, integer, integer]
TSNode:byte_length() -> integer

-- Hierarchy
TSNode:parent() -> TSNode?
TSNode:child(index) -> TSNode?
TSNode:child_count() -> integer
TSNode:named_child(index) -> TSNode?
TSNode:named_child_count() -> integer
TSNode:named_children() -> TSNode[]
TSNode:child_with_descendant(descendant) -> TSNode?

-- Siblings
TSNode:next_sibling() -> TSNode?
TSNode:prev_sibling() -> TSNode?
TSNode:next_named_sibling() -> TSNode?
TSNode:prev_named_sibling() -> TSNode?

-- Field access
TSNode:field(name) -> TSNode[]

-- Iteration
TSNode:iter_children() -> fun(): TSNode, string

-- Descendant lookup
TSNode:descendant_for_range(start_row, start_col, end_row, end_col) -> TSNode?
TSNode:named_descendant_for_range(start_row, start_col, end_row, end_col) -> TSNode?

-- Predicates
TSNode:named() -> boolean
TSNode:missing() -> boolean
TSNode:extra() -> boolean
TSNode:has_error() -> boolean
TSNode:has_changes() -> boolean

-- Serialization
TSNode:sexpr() -> string
TSNode:equal(node) -> boolean
TSNode:tree() -> TSTree
TSNode:root() -> TSNode
```

## TSTree

```lua
TSTree:root() -> TSNode
TSTree:copy() -> TSTree
TSTree:edit(start_byte, old_end_byte, new_end_byte, start_row, start_col, old_end_row, old_end_col, new_end_row, new_end_col) -> TSTree
TSTree:included_ranges(include_bytes?) -> table
```
