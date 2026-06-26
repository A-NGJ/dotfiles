#!/usr/bin/env bash
# PostToolUse hook: run a project's check.sh after a file is written/edited.
#
# Walks up from the edited file's directory looking for a `check.sh`. If one is
# found, it is executed; a non-zero exit blocks the tool result and surfaces the
# script output so the model can fix the issue. If no check.sh exists, the hook
# is a no-op (this is the "if it detects that check.sh is present" condition).
#
# check.sh is whatever quality gate a repo defines (lint, types, tests, build,
# ...) in any language — this hook is deliberately not coupled to Python.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# No path or missing file -> nothing to do.
if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Walk up from the file's directory to find the nearest check.sh.
dir=$(cd "$(dirname "$FILE_PATH")" && pwd)
check_script=""
while [ -n "$dir" ] && [ "$dir" != "/" ]; do
  if [ -f "$dir/check.sh" ]; then
    check_script="$dir/check.sh"
    break
  fi
  dir=$(dirname "$dir")
done

# No check.sh present -> no-op.
if [ -z "$check_script" ]; then
  exit 0
fi

# Run the gate. Block on failure with the captured output.
OUTPUT=$(bash "$check_script" 2>&1)
if [ $? -ne 0 ]; then
  REASON="check.sh failed (${check_script}):
${OUTPUT}"
  ESCAPED=$(echo "$REASON" | jq -Rs .)
  echo "{\"decision\": \"block\", \"reason\": $ESCAPED}"
fi

exit 0
