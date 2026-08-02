#!/bin/bash
# enforce-doc-line-cap.sh
# Event: PostToolUse (Write | Edit)
# Policy: dhlee-brain thin-layer — root-level .md files capped at 200 lines.
#         If a root .md exceeds the cap, warn loudly. Splitting into
#         knowledge/architecture/ (or another sub-location) is the next move.
# Not a blocking hook (PostToolUse cannot block); surfaces the violation
# so the next turn can address it. Aligns with A3 (Memory is Routing) and
# A7 (Every Block Implies a Next Move).

set -euo pipefail

CAP=200
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [[ -z "$file_path" ]]; then
    exit 0
fi

# Only root-level .md files (no subdirectories) belong to the thin layer.
case "$file_path" in
    "$ROOT"/*.md)
        # Confirm there is no further '/' after $ROOT/ — i.e. it is a root file.
        rel="${file_path#$ROOT/}"
        case "$rel" in
            */*) exit 0 ;;  # In a subdirectory — out of scope.
        esac
        ;;
    *)
        exit 0
        ;;
esac

if [[ ! -f "$file_path" ]]; then
    exit 0
fi

lines=$(wc -l < "$file_path" | tr -d ' ')

if (( lines > CAP )); then
    cat >&2 <<EOF
[enforce-doc-line-cap] $rel is $lines lines (cap: $CAP).
dhlee-brain thin-layer policy: a root document this long has stopped routing
and started describing. Next move:
  1. Convert this file into a router (titles + one-line bodies + links).
  2. Move full bodies into knowledge/architecture/ or knowledge/<topic>/.
  3. Update CLAUDE.md routing table.
  4. Append the split to CHANGELOG.md.
References: A3 (Memory is Routing), A7 (Every Block Implies a Next Move).
EOF
fi

exit 0
