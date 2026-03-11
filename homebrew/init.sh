#!/usr/bin/env bash

# This script is used to install remaining binaries
# It should be run after installing brew packages found in homebrew/leaves.txt

uv tool install ty@latest
uv tool install ruff@latest
