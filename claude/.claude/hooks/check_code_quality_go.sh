#!/bin/bash

# Read JSON input from stdin to get the file path
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Skip if no file path or not a Go file
if [ -z "$FILE_PATH" ] || [[ ! "$FILE_PATH" == *.go ]]; then
  exit 0
fi

# Skip if file doesn't exist
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Check if gofmt is available
if ! command -v gofmt &>/dev/null; then
  echo "{\"decision\": \"warn\", \"reason\": \"gofmt is not installed. Skipping Go code quality checks.\"}"
  exit 0
fi

# Auto-format the file
gofmt -w "$FILE_PATH" 2>/dev/null
