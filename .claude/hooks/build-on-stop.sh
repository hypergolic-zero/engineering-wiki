#!/usr/bin/env bash
# Stop hook. Before the agent ends its turn, run the strict MkDocs build if the
# site's sources changed. On failure, send the output back so the agent keeps
# working instead of reporting success. It never edits files.
set -u

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$root" || exit 0

# Avoid a loop: if this hook already sent the agent back once, let it stop.
active=$(python3 -c 'import json, sys
try:
    print(json.load(sys.stdin).get("stop_hook_active", False))
except Exception:
    print(False)')
[ "$active" = "True" ] && exit 0

py="$root/.venv/bin/python"
[ -x "$py" ] || exit 0   # no virtual environment: stay out of the way

# Changed files: uncommitted work, plus commits on this branch not yet on main.
changed=$( { git status --porcelain | cut -c4-; git diff --name-only origin/main...HEAD 2>/dev/null; } | sort -u )
echo "$changed" | grep -qE '^docs/|^mkdocs\.yml$|^requirements\.txt$' || exit 0

if ! out=$("$py" -m mkdocs build --strict 2>&1); then
  {
    echo "The strict MkDocs build fails, so the task is not finished."
    echo "$out" | grep -E 'WARNING|ERROR|Aborted|Error|Traceback' | head -40
    echo "Fix the cause: a broken link or anchor, or a page missing from nav in mkdocs.yml."
  } >&2
  exit 2   # exit 2 keeps the agent working and shows it stderr
fi
exit 0
