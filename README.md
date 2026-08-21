# Dotfiles symlinked on my machine

## General setup

1. Install `stow`
2. Stow whatever you want. For example, `stow -t "$HOME" tmux vim` grabs tmux and vim config.

### Install with stow:
```bash
stow --target 
```

### Homebrew installation:
```bash
# Leaving a machine
brew leaves > leaves.txt

# Fresh installation
xargs brew install < leaves.txt
```

## Tmux setup

After stowing, install TPM and plugins:
```bash
stow -t "$HOME" tmux
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then start tmux and press `prefix + I` to install all plugins.

## Neovim keymaps

Search and replacement use separate prefixes: `<leader>f` opens find pickers,
while `<leader>s` is reserved for Spectre.

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Find by grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Find command history |
| `<leader>fn` | Find notification history |
| `<leader>fd` | Find diagnostics |
| `<leader>cf` | Format code |
| `<leader>ss` | Open/close Spectre project search |
| `<leader>sw` | Open Spectre with the word or selection |
| `<leader>sf` | Open Spectre for the current file |

## Agent setup

`agents/.agents` is the single source of truth for shared skills and custom agents.
Consumer-specific directories link back to it: Claude Code uses
`claude/.claude/skills`, Pi uses `pi/.pi/agent/skills` and
`pi/.pi/agent/agents`, and OpenCode can discover `~/.agents` directly. Pi also
uses the global `claude/.claude/CLAUDE.md` through `pi/.pi/agent/CLAUDE.md`;
a future `pi/.pi/agent/AGENTS.md` will take precedence as Pi's global context.
Pi's MCP adapter imports Claude Code's global `~/.claude.json`, so Claude's
user-scoped `mcpServers` is the single source of truth. Project-scoped servers
remain local to Claude projects; use a shared project `.mcp.json` when both
clients should load one.

```bash
stow -t "$HOME" agents claude pi
```

The `skills` CLI writes its Claude symlinks relative to `~/.claude/skills`, but that
path is itself a symlink into this repo, so links for newly added skills resolve from
the wrong directory and end up broken. `skills-relink` (in the `bin` package) repairs
them:

```bash
# Add a skill collection, then repair the new links
npx skills@latest add mattpocock/skills && skills-relink

# Update installed skills (existing links are left alone)
npx skills@latest update

# Repair links at any time; --dry-run shows what would change
skills-relink --dry-run
```

Note that `skills update` wipes and rewrites each skill directory, so commit your own
edits to skill files first — that way an update shows up as a reviewable diff.

## Oh My ZSH setup

Since oh-my-zsh is a git repository, you can't clone it and stow it like the rest of the dotfiles. 

### Install Oh My ZSH:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Move custom config

Copy `custom` and `themes` folders from the oh-my-zsh repository to your dotfiles directory, and then stow them:

```bash
cp -a themes/* ~/.oh-my-zsh/themes/
cp -a custom/* ~/.oh-my-zsh/custom/
```
