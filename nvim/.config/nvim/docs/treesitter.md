# Treesitter text objects — operate on code by structure

Text objects let an operator (`d`, `c`, `y`, `v`) act on a *semantic* chunk of
code instead of characters or lines. Built-in Vim knows words and quotes (`ciw`,
`di"`); treesitter parses the file into a syntax tree, so it also knows what a
function, class, argument, loop, or conditional is — and finds their boundaries
for you no matter where the cursor sits inside them.

As usual, `i` = **inner** (contents only) and `a` = **around** (contents plus the
surrounding syntax). So `diF` wipes a function body; `daF` deletes the whole
function.

Selecting objects is done through **mini.ai** (`lua/plugins/mini.lua`), not
nvim-treesitter-textobjects — mini.ai owns the `i`/`a` prefixes, so layering a
second engine on the same keys would clash. Movement between objects lives in
`lua/plugins/treesitter.lua` (branch `main`).

## Select / operate (via mini.ai)

Use in visual (`x`) or operator-pending (`o`) mode, e.g. `viF`, `daF`, `cio`.
Treesitter objects sit on **capital** keys so they don't shadow mini.ai's
built-in lowercase objects (`f` = function *call*, `a` = argument, plus quotes,
brackets, tags — all still available).

| Keys | Text object |
| --- | --- |
| `iF` / `aF` | function definition inner / around |
| `iC` / `aC` | class inner / around |
| `io` / `ao` | conditional (`if`) **or** loop inner / around |
| `ij` / `aj` | JSON key-value pair inner / around |

mini.ai's own defaults still work alongside these: `i"`/`a"`, `i(`/`a(`,
`if` (function call), `ia` (argument), `it` (tag), etc.

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
- Select keys are mini.ai `custom_textobjects` (edit `mini.lua`); movement keys
  are a personal convention in `treesitter.lua`. Neither is a plugin default —
  the treesitter `main` branch ships no keymaps.
