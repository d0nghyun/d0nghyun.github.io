#!/bin/bash
# lint-silent-fallback.sh
# Event: PostToolUse (Write | Edit)
# Per A12 (No Silent Fallback), surfaces silent-fallback patterns in
# Python files after a write. Warns to stderr; does not block (PostToolUse
# cannot block). The agent is expected to address the warning on the next
# turn.

set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [[ -z "$file_path" || ! -f "$file_path" ]]; then
    exit 0
fi

case "$file_path" in
    *.py) ;;
    *) exit 0 ;;
esac

# Patterns: bare except, except returning a default, except: pass
matches=$(grep -nE \
    -e '^[[:space:]]*except[[:space:]]*:[[:space:]]*$' \
    -e '^[[:space:]]*except[[:space:]]*:[[:space:]]*pass[[:space:]]*$' \
    -e '^[[:space:]]*except[[:space:]]+[A-Za-z_][A-Za-z0-9_.]*([[:space:]]+as[[:space:]]+[A-Za-z_][A-Za-z0-9_]*)?[[:space:]]*:[[:space:]]*pass[[:space:]]*$' \
    "$file_path" 2>/dev/null || true)

if [[ -n "$matches" ]]; then
    cat >&2 <<EOF
[lint-silent-fallback] A12 candidates in $file_path:
$matches
Fail-loud principle: surface errors. If a fallback is genuinely required,
report it explicitly to the user. Reference: ARCHITECTURE.md A12,
THINKING.md "Fail loud, never silent".
EOF
fi

exit 0
