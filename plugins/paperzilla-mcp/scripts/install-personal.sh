#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="paperzilla-mcp"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_PLUGIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PLUGIN_SOURCE="${1:-$DEFAULT_PLUGIN_DIR}"
TARGET_PLUGIN_DIR="$HOME/.codex/plugins/$PLUGIN_NAME"
MARKETPLACE_PATH="$HOME/.agents/plugins/marketplace.json"

if [ ! -d "$PLUGIN_SOURCE" ]; then
  echo "Plugin source directory does not exist: $PLUGIN_SOURCE" >&2
  exit 1
fi

mkdir -p "$HOME/.codex/plugins" "$HOME/.agents/plugins"
ln -sfn "$PLUGIN_SOURCE" "$TARGET_PLUGIN_DIR"

python3 - "$MARKETPLACE_PATH" <<'PY'
import json
import sys
from pathlib import Path

marketplace_path = Path(sys.argv[1]).expanduser()

entry = {
    "name": "paperzilla-mcp",
    "source": {
        "source": "local",
        "path": "./plugins/paperzilla-mcp",
    },
    "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL",
    },
    "category": "Productivity",
}

if marketplace_path.exists():
    payload = json.loads(marketplace_path.read_text())
    if not isinstance(payload, dict):
        raise SystemExit(f"{marketplace_path} must contain a JSON object.")
else:
    payload = {
        "name": "paperzilla",
        "interface": {
            "displayName": "Paperzilla",
        },
        "plugins": [],
    }

plugins = payload.setdefault("plugins", [])
if not isinstance(plugins, list):
    raise SystemExit(f"{marketplace_path} field 'plugins' must be an array.")

interface = payload.setdefault("interface", {})
if not isinstance(interface, dict):
    raise SystemExit(f"{marketplace_path} field 'interface' must be an object if present.")

payload.setdefault("name", "paperzilla")
interface.setdefault("displayName", "Paperzilla")

for index, existing in enumerate(plugins):
    if isinstance(existing, dict) and existing.get("name") == entry["name"]:
        plugins[index] = entry
        break
else:
    plugins.append(entry)

marketplace_path.parent.mkdir(parents=True, exist_ok=True)
marketplace_path.write_text(json.dumps(payload, indent=2) + "\n")
PY

echo "Installed $PLUGIN_NAME into $TARGET_PLUGIN_DIR"
echo "Restart Codex, open Plugins, choose Paperzilla, and install $PLUGIN_NAME."
