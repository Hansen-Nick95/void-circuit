#!/usr/bin/env bash
# Installs the harness toolchain. Idempotent: safe to run every session.
#   Linux (Claude cloud, CI): downloads the pinned headless Godot into .tools/
#   macOS: checks the installed Godot.app matches the pin
# Both: installs gdtoolkit (gdlint/gdformat) at the pinned version.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GODOT_VERSION="$(tr -d '[:space:]' < "$ROOT/.godot-version")"   # e.g. 4.7.2-stable
GODOT_SHORT="${GODOT_VERSION%-stable}"                             # e.g. 4.7.2
GDTOOLKIT_VERSION="${GDTOOLKIT_VERSION:-4.5.0}"

case "$(uname -s)" in
  Linux)
    TOOLS="$ROOT/.tools"
    mkdir -p "$TOOLS"
    if [[ -x "$TOOLS/godot" ]] && "$TOOLS/godot" --version | grep -q "^${GODOT_SHORT}\.stable"; then
      echo "Godot $GODOT_SHORT already in .tools/"
    else
      echo "Downloading Godot $GODOT_VERSION (headless use)..."
      url="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_linux.x86_64.zip"
      curl -fsSL "$url" -o "$TOOLS/godot.zip"
      unzip -o -q "$TOOLS/godot.zip" -d "$TOOLS"
      mv -f "$TOOLS/Godot_v${GODOT_VERSION}_linux.x86_64" "$TOOLS/godot"
      rm -f "$TOOLS/godot.zip"
    fi
    "$TOOLS/godot" --version
    ;;
  Darwin)
    APP="/Applications/Godot.app/Contents/MacOS/Godot"
    if [[ ! -x "$APP" ]]; then
      echo "Godot.app not found. Install it with: brew install --cask godot" >&2
      exit 1
    fi
    installed="$("$APP" --version)"
    if [[ "$installed" != "${GODOT_SHORT}.stable"* ]]; then
      echo "WARNING: Godot.app is $installed but .godot-version pins $GODOT_VERSION." >&2
      echo "         Install the pinned version, or bump .godot-version and log it in docs/DECISIONS.md." >&2
    else
      echo "Godot.app $installed matches the pin"
    fi
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

if gdlint --version 2>/dev/null | grep -q "$GDTOOLKIT_VERSION"; then
  echo "gdtoolkit $GDTOOLKIT_VERSION already installed"
elif command -v pipx >/dev/null 2>&1; then
  pipx install --force "gdtoolkit==$GDTOOLKIT_VERSION"
else
  python3 -m pip install --quiet "gdtoolkit==$GDTOOLKIT_VERSION"
fi
