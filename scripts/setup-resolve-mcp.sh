#!/usr/bin/env bash
# Install samuelgursky/davinci-resolve-mcp and its in-app bridge (macOS).
# The bridge lets the MCP work with the free edition of DaVinci Resolve,
# which blocks external scripting.
set -euo pipefail

REPO_URL="https://github.com/samuelgursky/davinci-resolve-mcp.git"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$ROOT/davinci-resolve-mcp"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script targets macOS." >&2
  exit 1
fi
command -v git >/dev/null || { echo "git is required." >&2; exit 1; }
command -v python3 >/dev/null || { echo "python3 (3.10+) is required." >&2; exit 1; }

if [[ -d "$TARGET/.git" ]]; then
  git -C "$TARGET" pull --ff-only
else
  git clone "$REPO_URL" "$TARGET"
fi
cd "$TARGET"

# Creates a venv and registers the server in Claude Desktop's config.
python3 install.py --clients claude-desktop

# Installs the bridge script into Resolve's Workspace > Scripts menu.
python3 scripts/install_resolve_bridge.py

# Resolve only finds Python 3 via PYTHON3HOME or /usr/local/bin/python3.
if [[ ! -x /usr/local/bin/python3 ]]; then
  PREFIX="$(python3 -c 'import sys; print(sys.prefix)')"
  launchctl setenv PYTHON3HOME "$PREFIX"
  echo "Set PYTHON3HOME=$PREFIX for this login session (lost on reboot)."
  echo "Persistent alternative: sudo ln -s \"\$(command -v python3)\" /usr/local/bin/python3"
fi

cat <<'MSG'

Next steps:
  1. Quit and reopen DaVinci Resolve, then open a project.
  2. In Resolve choose Workspace > Scripts > resolve_bridge (each time you open Resolve).
  3. Quit and reopen Claude Desktop.
MSG
