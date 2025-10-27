# Dotfiles symlinked on my machine

## General setup

1. Install `stow`
2. Stow whatever you want. For example, `stopw -t "$HOME" tmux vim` grabs tmux and vim config.

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
