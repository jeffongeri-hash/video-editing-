#!/usr/bin/env bash
# Install resolve-claude-mcp and register it with Claude Desktop (macOS).
set -euo pipefail

REPO_URL="https://github.com/barckley75/resolve-claude-mcp.git"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$ROOT/resolve-claude-mcp"
CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script targets macOS (paths and Claude Desktop config location)." >&2
  exit 1
fi
command -v uv >/dev/null || { echo "uv is required: https://docs.astral.sh/uv/" >&2; exit 1; }
command -v git >/dev/null || { echo "git is required." >&2; exit 1; }

if [[ -d "$TARGET/.git" ]]; then
  git -C "$TARGET" pull --ff-only
else
  git clone "$REPO_URL" "$TARGET"
fi
(cd "$TARGET" && uv sync)

mkdir -p "$(dirname "$CONFIG")"
[[ -f "$CONFIG" ]] && cp "$CONFIG" "$CONFIG.bak"

# Merge the "resolve" server into the config, keeping any other servers.
python3 - "$CONFIG" "$TARGET" "$ROOT/claude_desktop_config.example.json" <<'PY'
import json, os, sys
config_path, target, example_path = sys.argv[1:4]
cfg = {}
if os.path.exists(config_path) and os.path.getsize(config_path):
    with open(config_path) as f:
        cfg = json.load(f)
with open(example_path) as f:
    server = json.load(f)["mcpServers"]["resolve"]
server["args"][1] = target
cfg.setdefault("mcpServers", {})["resolve"] = server
with open(config_path, "w") as f:
    json.dump(cfg, f, indent=2)
    f.write("\n")
print(f"Registered 'resolve' in {config_path}")
PY

echo "Done. Quit and reopen Claude Desktop, with DaVinci Resolve Studio running."
echo "In Resolve: Preferences > System > General > External scripting using = Local."
