# Verifying the netrw / E216 fix

Background: `snacks.explorer` takes over directory handling by deleting netrw's
`FileExplorer` autocmd group at startup. If netrw's plugin had loaded but the
group was already gone, opening a directory raised `E216: No such group or
event: FileExplorer *`. The error was silenced (`silent!` / `pcall`) so nothing
broke, but it still set `v:errmsg`. Fix: disable netrw *before* any plugin loads
in `init.lua` (`vim.g.loaded_netrw = 1`, `vim.g.loaded_netrwPlugin = 1`), so the
group is never installed and nothing has to tear it down.

## Quick check (headless)

Run from anywhere:

```bash
nvim --headless "+lua vim.v.errmsg=''; vim.cmd('silent! edit /tmp'); print('errmsg=['..vim.v.errmsg..']')" +qa
```

Expected: `errmsg=[]`. A non-empty `[E216: ...]` means netrw is still being
disabled too late (the flags aren't set before `require('config.lazy')`).

## Interactive check

1. Open nvim: `nvim`.
2. `:messages` — should contain no `E216`.
3. `:edit /tmp` (or any directory) — snacks.explorer opens it; no error flashes.
4. `:echo v:errmsg` — should be empty (or unrelated to FileExplorer).
5. `<leader>e` — snacks explorer opens. This is the only file explorer now;
   nvim-tree and neo-tree were removed.

## Confirm netrw is off and only snacks handles files

```vim
:echo g:loaded_netrwPlugin   " -> 1  (netrw disabled, not the 'v184' version tag)
:lua =type(Snacks.explorer)  " -> 'table'
```

If `g:loaded_netrwPlugin` shows a version string like `v184`, the disable flags
aren't running early enough.
