# video-editing

Setup for controlling DaVinci Resolve from Claude Desktop through
[davinci-resolve-mcp](https://github.com/samuelgursky/davinci-resolve-mcp) (MIT).

Works with the **free edition** of Resolve through that project's in-app
bridge, and with Studio through external scripting. Blackmagic blocks external
scripting on the free edition, which is why the "External scripting using"
preference is missing there.

Use at your own risk and work on project backups, since the tools can modify
project data.

## Quick start (macOS)

```bash
./scripts/setup-resolve-mcp.sh
```

The script:

1. clones davinci-resolve-mcp into `./davinci-resolve-mcp` (git-ignored) or updates it,
2. runs its `install.py --clients claude-desktop` to create a venv and register the server,
3. runs `scripts/install_resolve_bridge.py` to add the bridge to Resolve's Scripts menu,
4. points `PYTHON3HOME` at your Python if `/usr/local/bin/python3` is missing.

Then:

1. Quit and reopen DaVinci Resolve and open a project.
2. Choose **Workspace > Scripts > resolve_bridge**. Do this each time you open Resolve.
3. Quit and reopen Claude Desktop.

## Notes

- **Resolve versions:** the upstream README reports the bridge working on free
  20.3.2.9, 21.0.1.11 and 21.0.3.7. It says Resolve 21.1 moved Python scripting
  to Studio, so the bridge won't work on free 21.1. I haven't verified 20.0.1.
- **`PYTHON3HOME` is lost on reboot.** If `resolve_bridge` disappears from the
  Scripts menu, rerun the script or create the persistent symlink:
  `sudo ln -s "$(command -v python3)" /usr/local/bin/python3`.
- **Homebrew Python:** Resolve needs both `lib/libpython3.X.dylib` and an
  unversioned `bin/python3` under the prefix. Some Homebrew builds ship only
  `bin/python3.13`. If the script never appears, install Python from python.org.
- **Studio users:** set **Preferences > System > General > External scripting
  using** to **Local**. The bridge is then optional.
- Full details: the upstream
  [README](https://github.com/samuelgursky/davinci-resolve-mcp#free-edition-in-app-bridge)
  and `docs/install.md`.

## Requirements

- macOS, git, Python 3.10+
- DaVinci Resolve (free or Studio) and Claude Desktop
