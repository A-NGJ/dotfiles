#!/usr/bin/env bash
# Claude Code statusline — Catppuccin Macchiato
#
#   <model> │ <tokens (ctx%)> │ <branch> │ <cwd>
#
# Reads the session JSON payload on stdin. Fields documented at
# https://docs.claude.com/en/docs/claude-code/statusline

set -uo pipefail

input=$(cat)

# ── Catppuccin Macchiato ─────────────────────────────────────────────────────
fg() { printf '\033[38;2;%d;%d;%dm' "$1" "$2" "$3"; }

MAUVE=$(fg 198 160 246)    # #c6a0f6  model
GREEN=$(fg 166 218 149)    # #a6da95  branch, ctx ok
YELLOW=$(fg 238 212 159)   # #eed49f  ctx warm
PEACH=$(fg 245 169 127)    # #f5a97f  ctx hot
RED=$(fg 237 135 150)      # #ed8796  ctx critical
BLUE=$(fg 138 173 244)     # #8aadf4  cwd
OVERLAY0=$(fg 110 115 141) # #6e738d  separators, unknown values
RESET=$'\033[0m'

SEP="${OVERLAY0} │ ${RESET}"

# ── Parse payload (one jq pass, tab-separated so spaces survive) ─────────────
IFS=$'\t' read -r MODEL PCT USED DIR < <(
  jq -r '[
    (.model.display_name // "?"),
    (.context_window.used_percentage // -1),
    (.context_window.total_input_tokens // 0),
    (.workspace.current_dir // .cwd // ".")
  ] | @tsv' <<<"$input"
)

PCT_INT=${PCT%%.*}
[[ $PCT_INT =~ ^-?[0-9]+$ ]] || PCT_INT=-1

# ── Segment: context window ──────────────────────────────────────────────────
# Live window occupancy from the most recent API response, not cumulative
# session spend. total_input_tokens = input + cache_creation + cache_read; it
# matches used_percentage's basis, which excludes output tokens. Percentage is
# over the full context_window_size — no autocompact reserve is subtracted.
# context_window is null before the first API call, and again after /compact.
if ((PCT_INT >= 0)); then
  if   ((PCT_INT >= 90)); then CTX_COLOR=$RED
  elif ((PCT_INT >= 70)); then CTX_COLOR=$PEACH
  elif ((PCT_INT >= 50)); then CTX_COLOR=$YELLOW
  else                         CTX_COLOR=$GREEN
  fi
  TOKENS=$(awk -v n="$USED" 'BEGIN {
    if      (n >= 1000000) printf "%.1fM", n / 1000000
    else if (n >= 1000)    printf "%.1fk", n / 1000
    else                   printf "%d",    n
  }')
  CTX="${CTX_COLOR}${TOKENS} (${PCT_INT}%)${RESET}"
else
  CTX="${OVERLAY0}—${RESET}"
fi

# ── Segment: git branch (omitted entirely outside a repo) ────────────────────
BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
if [[ -z $BRANCH ]] && git -C "$DIR" rev-parse --git-dir &>/dev/null; then
  BRANCH=$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null) # detached HEAD
fi

# ── Segment: cwd ─────────────────────────────────────────────────────────────
PRETTY_DIR=${DIR/#$HOME/\~}

# ── Assemble ─────────────────────────────────────────────────────────────────
segments=("${MAUVE}${MODEL}${RESET}" "$CTX")
[[ -n $BRANCH ]] && segments+=("${GREEN}${BRANCH}${RESET}")
segments+=("${BLUE}${PRETTY_DIR}${RESET}")

out=""
for s in "${segments[@]}"; do
  [[ -n $out ]] && out+="$SEP"
  out+="$s"
done

printf '%s\n' "$out"
