#!/bin/bash
# scope-guard.sh
# Event: PreToolUse (Write | Edit)
# Per A11 (One Request, One Scope), counts Write/Edit invocations within
# one user turn and blocks once the count exceeds THRESHOLD.
# Exit 2 is a blocking exit for PreToolUse hooks.

set -euo pipefail

THRESHOLD=5
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COUNT_FILE="$SCRIPT_DIR/.scope-count"

# A11 scope is per-repository. This guard belongs to the repo the hook lives
# in; edits to a *different* repo worked on from the same session (e.g. a
# docked project, or parallel git worktrees of another repo) are out of this
# repo's scope and must neither be counted nor race on this single counter.
# Without this gate, N parallel worktree edits all increment one shared file
# (read-modify-write race) — the exact failure observed during parallel dev.
input=$(cat 2>/dev/null || true)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)
hook_repo="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR")"

if [[ -n "$file_path" ]]; then
    case "$file_path" in
        "$hook_repo"/*) ;;  # inside this repo → guard it
        *) exit 0 ;;        # outside this repo → not this guard's scope
    esac
fi

count=0
if [[ -f "$COUNT_FILE" ]]; then
    count=$(cat "$COUNT_FILE")
fi
count=$((count + 1))
echo "$count" > "$COUNT_FILE"

if (( count > THRESHOLD )); then
    cat >&2 <<EOF
[scope-guard] Write/Edit count in this turn: $count (threshold: $THRESHOLD).
A11 (One Request, One Scope) — broad scope changes need explicit confirmation.
Next move:
  1. Stop. Summarize what was changed so far and what additional changes you intend.
  2. Ask the user to approve the expanded scope.
  3. After approval, the threshold resets on the next user prompt automatically.
Reference: ARCHITECTURE.md A11, THINKING.md "One request, one scope".
EOF
    exit 2
fi

exit 0
