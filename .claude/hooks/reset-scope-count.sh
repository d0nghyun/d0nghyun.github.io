#!/bin/bash
# reset-scope-count.sh
# Event: UserPromptSubmit
# Resets the per-turn scope counter for scope-guard.sh.
# Per A11 (One Request, One Scope), each new user prompt starts a fresh
# scope window.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo 0 > "$SCRIPT_DIR/.scope-count"

exit 0
