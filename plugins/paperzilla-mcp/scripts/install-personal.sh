#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="paperzilla-mcp"
MCP_URL="https://paperzilla.ai/api/mcp"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_PLUGIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PLUGIN_SOURCE="$DEFAULT_PLUGIN_DIR"
TARGET_PLUGIN_DIR="$HOME/.codex/plugins/$PLUGIN_NAME"
MARKETPLACE_PATH="$HOME/.agents/plugins/marketplace.json"
CODEX_CONFIG_PATH="$HOME/.codex/config.toml"
CONFIGURE_MCP=1
MCP_API_KEY=""

usage() {
  cat <<USAGE
Usage: $0 [plugin-source] [--api-key <paperzilla-mcp-api-key>] [--skip-mcp-config]

Installs the Paperzilla Codex plugin into your personal marketplace.
By default it also prompts for a Paperzilla MCP API key and writes the
Codex MCP config block that Paperzilla needs for live access.
USAGE
}

POSITIONAL_SEEN=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --api-key|--mcp-api-key)
      shift
      if [ "$#" -eq 0 ]; then
        echo "Missing value for --api-key" >&2
        exit 1
      fi
      MCP_API_KEY="$1"
      ;;
    --skip-mcp-config)
      CONFIGURE_MCP=0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [ "$POSITIONAL_SEEN" -eq 1 ]; then
        echo "Unexpected extra positional argument: $1" >&2
        usage >&2
        exit 1
      fi
      PLUGIN_SOURCE="$1"
      POSITIONAL_SEEN=1
      ;;
  esac
  shift
done

if [ ! -d "$PLUGIN_SOURCE" ]; then
  echo "Plugin source directory does not exist: $PLUGIN_SOURCE" >&2
  exit 1
fi

mkdir -p "$HOME/.codex/plugins" "$HOME/.agents/plugins"
if [ -e "$TARGET_PLUGIN_DIR" ] && [ ! -L "$TARGET_PLUGIN_DIR" ]; then
  echo "Target plugin path exists and is not a symlink: $TARGET_PLUGIN_DIR" >&2
  echo "Move it aside before reinstalling, or install from Codex Plugins directly." >&2
  exit 1
fi
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
        "path": "./.codex/plugins/paperzilla-mcp",
    },
    "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_USE",
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

if [ "$CONFIGURE_MCP" -eq 1 ]; then
  if [ -z "$MCP_API_KEY" ] && [ -t 0 ]; then
    read -r -s -p "Paperzilla MCP API key (leave blank to skip MCP config): " MCP_API_KEY || true
    echo
  fi

  if [ -n "$MCP_API_KEY" ]; then
    python3 - "$CODEX_CONFIG_PATH" "$MCP_URL" "$MCP_API_KEY" <<'PY'
import json
import re
import shutil
import sys
import time
from pathlib import Path

config_path = Path(sys.argv[1]).expanduser()
mcp_url = sys.argv[2]
api_key = sys.argv[3].strip()

if not api_key:
    raise SystemExit(0)

authorization = api_key if api_key.lower().startswith("bearer ") else f"Bearer {api_key}"

config_path.parent.mkdir(parents=True, exist_ok=True)
original = config_path.read_text() if config_path.exists() else ""
lines = original.splitlines(keepends=True)
output = []
skipping = False

header_re = re.compile(r"^\s*\[[^\]]+\]\s*(?:#.*)?$")
paperzilla_re = re.compile(r"^\s*\[mcp_servers\.paperzilla(?:\.[^\]]+)?\]\s*(?:#.*)?$")

for line in lines:
    if paperzilla_re.match(line):
        skipping = True
        continue
    if skipping and header_re.match(line):
        skipping = False
    if not skipping:
        output.append(line)

text = "".join(output).rstrip() + "\n\n" if output else ""
text += "[mcp_servers.paperzilla]\n"
text += f"url = {json.dumps(mcp_url)}\n"
text += f"http_headers = {{ Authorization = {json.dumps(authorization)} }}\n"

if config_path.exists() and original != text:
    backup_path = config_path.with_name(f"{config_path.name}.bak.{int(time.time())}")
    shutil.copy2(config_path, backup_path)
    print(f"Backed up existing Codex config to {backup_path}")

config_path.write_text(text)
print(f"Configured Paperzilla MCP in {config_path}")
PY
  else
    cat <<'MSG'
Skipped Codex MCP API key config.
Add this block to ~/.codex/config.toml before using Paperzilla live tools:

[mcp_servers.paperzilla]
url = "https://paperzilla.ai/api/mcp"
http_headers = { Authorization = "Bearer pzmcp_..." }
MSG
  fi
fi

echo "Installed $PLUGIN_NAME into $TARGET_PLUGIN_DIR"
echo "Restart Codex, open Plugins, choose Paperzilla, and install $PLUGIN_NAME."
echo "After restart, run /mcp paperzilla or ask Codex to list your Paperzilla projects."
