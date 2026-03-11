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

## Oh My ZSH setup

Since oh-my-zsh is a git repository, you can clone it and stow it like the rest of the dotfiles. This way, you can keep your custom plugins and themes in sync across machines.

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

### Install Plugins

#### ZSH Autosuggestions

[Installation guide](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

#### ZSH Syntax Highlighting

[Installation guide](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh)

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

