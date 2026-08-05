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

## Agent skills setup

Skills live in the `agents` package (`agents/.agents/skills`), and `claude/.claude/skills`
holds symlinks to them so Claude Code picks them up.

```bash
stow -t "$HOME" agents claude
```

The `skills` CLI writes its symlinks relative to `~/.claude/skills`, but that path is a
symlink into this repo, so links for newly added skills resolve from the wrong directory
and end up broken. `skills-relink` (in the `bin` package) repairs them:

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
