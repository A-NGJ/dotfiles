#!/usr/bin/env bash

# This script is used to install remaining binaries
# It should be run after installing brew packages found in homebrew/leaves.txt

uv tool install ty@latest
uv tool install ruff@latest

# Set brew auto update + upgrade, every 72 hours.
# Deliberately not --leaves-only: the packages most likely to carry a remotely
# exploitable CVE (openssl, libssh, unbound, zlib) are dependencies, not leaves,
# so that flag would skip exactly the ones worth patching. The pins below cover
# the packages that actually break when upgraded unattended.
brew tap domt4/autoupdate
brew autoupdate start 259200 \
  --upgrade \
  --cleanup \
  --ac-only \
  --notify-on-error  # every 72 hours (in seconds)
# Other commands
# brew autoupdate stop     # disable it
# brew autoupdate status   # check current config
# brew autoupdate delete   # remove the launchd job entirely

# Hold back the stateful services. An unattended major bump swaps the binaries
# while the on-disk data directory stays on the old format, so the service just
# stops starting. These need a hands-on upgrade + migration.
# Trade-off: pinned means no security patches either — check them by hand.
brew pin mysql redis postgresql@16
# brew unpin mysql         # when you're ready to migrate one
# brew list --pinned       # see what's held back

# Daily CVE scan over the Cellar, notifying only on new high/critical findings
# in brew-owned artifacts. Covers the blind spot left by the pins above.
ln -sf "${HOME}/.config/homebrew/com.alen.brew-cve-scan.plist" \
  "${HOME}/Library/LaunchAgents/com.alen.brew-cve-scan.plist"
launchctl bootstrap "gui/$(id -u)" \
  "${HOME}/Library/LaunchAgents/com.alen.brew-cve-scan.plist"
# launchctl kickstart -p gui/$(id -u)/com.alen.brew-cve-scan  # run it now
# launchctl bootout gui/$(id -u)/com.alen.brew-cve-scan       # disable it
