#!/usr/bin/env bash

# This script is used to install remaining binaries
# It should be run after installing brew packages found in homebrew/leaves.txt

uv tool install ty@latest
uv tool install ruff@latest

# Set brew auto update
brew tap domt4/autoupdate
brew autoupdate start 86400  # update every 24 hours (in seconds)
# Other commands
# brew autoupdate stop     # disable it
# brew autoupdate status   # check current config
# brew autoupdate delete   # remove the launchd job entirely
