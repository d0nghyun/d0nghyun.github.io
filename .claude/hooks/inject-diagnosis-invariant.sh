#!/bin/bash
# inject-diagnosis-invariant.sh
# Event: UserPromptSubmit
# Per T-G1, injects behavioral invariants every turn so axioms A10–A12 are
# never forgotten. Stdout is appended to the user prompt context.

set -euo pipefail

cat <<'EOF'
Behavioral invariants (always apply):
- Diagnose before hypothesizing (A10): identify file:line, structural unit, or direct evidence before stating a cause. Hedging language ("seems like", "probably", "looks like", "아마", "~로 보인다") signals incomplete investigation. When evidence is missing, output "investigation required" instead of a guess.
- Fail loud, never silent (A12): no bare except, no except: pass, no default-on-error. Surface unexpected errors; if a fallback is necessary, report it explicitly.
- One request, one scope (A11): side-quest refactors, deletions, renames, or cleanups not in the original request are forbidden as silent acts. Surface scope expansion as an explicit option.
- Pinpoint, don't proxy-match: for identifiers, file:line, or structural references, use exact identifiers — not regex/substring.
- Confidence floor: if confidence < 80%, stop and ask instead of guessing.
EOF

exit 0
