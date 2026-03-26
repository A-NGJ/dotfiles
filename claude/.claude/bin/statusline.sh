#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH_NAME=$(git branch --show-current 2>/dev/null)
  if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
    DIRTY=""
  else
    DIRTY=" \033[33m✗\033[0m"
  fi
  BRANCH=" | \033[31mgit:\033[0m(\033[34m${BRANCH_NAME}\033[0m)${DIRTY}"
fi

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; MAGENTA='\033[35m'; BLUE='\033[34m'; RESET='\033[0m'

# Pick bar color based on context usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

echo -e "${CYAN}[$MODEL]${RESET} ${BLUE}${DIR##*/}${RESET}$BRANCH"
echo -e "${BAR_COLOR}${BAR}${RESET} ${PCT}%"
