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
unset prepend
export PATH

