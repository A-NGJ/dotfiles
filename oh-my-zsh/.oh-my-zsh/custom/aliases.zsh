alias tf='terraform'
alias dc='docker-compose'
alias d='docker'

alias gc="git commit"
alias g="git"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

export LANG=en_US.UTF-8
export EDITOR=/opt/homebrew/bin/nvim

alias cat=bat
alias vim=nvim

# Eza
alias ls="eza --icons auto"
alias ll="eza -lh --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# FZF
alias inv='nvim $(fzf -m)'

# alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'

# Zscaler
alias zuload="sudo launchctl unload /Library/LaunchDaemons/com.zscaler.service.plist && sudo launchctl unload /Library/LaunchDaemons/com.zscaler.tunnel.plist"
alias zload="sudo launchctl load /Library/LaunchDaemons/com.zscaler.service.plist && sudo launchctl load /Library/LaunchDaemons/com.zscaler.tunnel.plist"

# Git
# Fuzzy checkout branch
alias gitcheckout="git branch | fzf | xargs git checkout"

tempe () {
  cd "$(mktemp -d)"
  chmod -R 0700 .
  if [[ $# -eq 1 ]]; then
    \mkdir -p "$1"
    cd "$1"
    chmod -R 0700 .
  fi
}
