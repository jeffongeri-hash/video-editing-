# video-editing

Setup for controlling DaVinci Resolve Studio from Claude Desktop through
[resolve-claude-mcp](https://github.com/barckley75/resolve-claude-mcp) (MIT).

Tested upstream on macOS (Apple Silicon) only. Use at your own risk and work
on project backups, since the tools can modify or delete project data.

## Quick start (macOS)

```bash
./scripts/setup-resolve-mcp.sh
```

The script:

1. clones resolve-claude-mcp into `./resolve-claude-mcp` (git-ignored) or updates it,
2. runs `uv sync`,
3. adds a `resolve` entry to
   `~/Library/Application Support/Claude/claude_desktop_config.json`, keeping
   your other servers and saving a `.bak` copy first.

Then:

1. In Resolve, set **Preferences > System > General > External scripting using** to **Local**.
2. Start DaVinci Resolve Studio. The scripting API needs the Studio edition.
3. Quit and reopen Claude Desktop.

## Manual setup

```bash
git clone https://github.com/barckley75/resolve-claude-mcp.git
cd resolve-claude-mcp
uv sync
open -e "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
```

Paste in [`claude_desktop_config.example.json`](claude_desktop_config.example.json)
and replace `/absolute/path/to/resolve-claude-mcp` with the real clone path.
If the file already has `mcpServers`, add only the `resolve` entry.

## Requirements

- macOS, [uv](https://docs.astral.sh/uv/), git, Python 3
- DaVinci Resolve Studio at `/Applications/DaVinci Resolve/`
- Claude Desktop
