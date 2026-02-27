#!/bin/bash

# Read JSON input from stdin to get the file path
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Skip if no file path or not a Python file
if [ -z "$FILE_PATH" ] || [[ ! "$FILE_PATH" == *.py ]]; then
  exit 0
fi

# Skip if file doesn't exist
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Check if ruff and ty are available
WARNINGS=""
HAS_RUFF=true
HAS_TY=true

if ! command -v uv &>/dev/null; then
  echo "{\"decision\": \"warn\", \"reason\": \"uv is not installed. Skipping Python code quality checks.\"}"
  exit 0
fi

if ! uv run ruff --version &>/dev/null; then
  WARNINGS="${WARNINGS}ruff is not available. Skipping ruff checks.\n"
  HAS_RUFF=false
fi

if ! uv run ty --version &>/dev/null; then
  WARNINGS="${WARNINGS}ty is not available. Skipping type checks.\n"
  HAS_TY=false
fi

if [ "$HAS_RUFF" = false ] && [ "$HAS_TY" = false ]; then
  echo "{\"decision\": \"warn\", \"reason\": \"ruff and ty are not available. Skipping Python code quality checks.\"}"
  exit 0
fi

ERRORS=""

if [ "$HAS_RUFF" = true ]; then
  # Run ruff format (without fixing)
  uv run ruff format "$FILE_PATH" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    ERRORS="${ERRORS}Ruff format check failed: File is not properly formatted.
"
  fi

  # Check for remaining ruff issues
  RUFF_OUTPUT=$(uv run ruff check --fix --ignore F401 "$FILE_PATH" 2>&1)
  if [ $? -ne 0 ]; then
    ERRORS="${ERRORS}Ruff check failed:
${RUFF_OUTPUT}

"
  fi
fi

if [ "$HAS_TY" = true ]; then
  # Run ty type checker
  TY_OUTPUT=$(uv run ty check "$FILE_PATH" 2>&1)
  if [ $? -ne 0 ]; then
    ERRORS="${ERRORS}Ty check failed:
${TY_OUTPUT}

"
  fi
fi

# Block if errors exist
if [ -n "$ERRORS" ]; then
  FULL_MESSAGE="${WARNINGS}${ERRORS}"
  ESCAPED=$(echo "$FULL_MESSAGE" | jq -Rs .)
  echo "{\"decision\": \"block\", \"reason\": $ESCAPED}"
elif [ -n "$WARNINGS" ]; then
  ESCAPED=$(echo -e "$WARNINGS" | jq -Rs .)
  echo "{\"decision\": \"warn\", \"reason\": $ESCAPED}"
fi

