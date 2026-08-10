# Treesitter text objects — operate on code by structure

Text objects let an operator (`d`, `c`, `y`, `v`) act on a *semantic* chunk of
code instead of characters or lines. Built-in Vim knows words and quotes (`ciw`,
`di"`); treesitter parses the file into a syntax tree, so it also knows what a
function, class, argument, loop, or conditional is — and finds their boundaries
for you no matter where the cursor sits inside them.

As usual, `i` = **inner** (contents only) and `a` = **around** (contents plus the
surrounding syntax). So `dif` wipes a function body; `daf` deletes the whole
function.

Config lives in `lua/plugins/treesitter.lua` (branch `main`).

## Select / operate

Use in visual (`x`) or operator-pending (`o`) mode, e.g. `vif`, `daf`, `cia`.

| Keys | Text object |
| --- | --- |
| `if` / `af` | function inner / around |
| `ic` / `ac` | class inner / around |
| `ia` / `aa` | argument (parameter) inner / around |
| `io` / `ao` | loop inner / around |
| `ii` / `ai` | conditional (`if` block) inner / around |

`lookahead` is on: if the cursor is before the object on the line, it jumps
forward to it rather than failing.

## Move

Jump between definitions. Works in normal, visual, and operator-pending mode.
Lowercase = start of the object, uppercase = end. Jumps land in the jumplist, so
`Ctrl-o` returns.

| Keys | Motion |
| --- | --- |
| `]f` / `[f` | next / previous function **start** |
| `]F` / `[F` | next / previous function **end** |
| `]c` / `[c` | next / previous class start |
| `]C` / `[C` | next / previous class end |
| `]a` / `[a` | next / previous argument start |
| `]A` / `[A` | next / previous argument end |

## Notes

- Objects resolve against the parser for the current filetype; if no parser is
  installed for that buffer, highlighting and these mappings simply do nothing.
- The key letters are a personal convention (`f`/`c`/`a`/`o`/`i`), not a plugin
  default — the `main` branch ships no keymaps. Edit the tables in
  `treesitter.lua` to taste.
