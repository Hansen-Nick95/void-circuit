#!/usr/bin/env bash
# SessionStart hook: in Claude Code cloud sessions, install the toolchain so `make check` works.
# Local sessions on the Mac skip it (you install Godot yourself; see docs/MAC_SETUP.md).
set -euo pipefail
if [[ "${CLAUDE_CODE_REMOTE:-}" != "true" ]]; then
  exit 0
fi
cd "$CLAUDE_PROJECT_DIR"
./scripts/setup.sh
