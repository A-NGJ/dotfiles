prepend() {
  [ -d "$1" ] && PATH="$1:$PATH"
}
prepend '/usr/local/bin'
prepend '/opt/homebrew/bin'
prepend '/opt/homebrew/sbin'
prepend "$HOME/bin"
prepend "$HOME/.local/bin"
prepend '/home/linuxbrew/.linuxbrew/bin'
prepend "$(go env GOPATH)/bin"

MASON_BIN="$HOME/.local/share/nvim/mason/bin"
[ -d "$MASON_BIN" ] && prepend "$MASON_BIN"

unset prepend

export PATH

