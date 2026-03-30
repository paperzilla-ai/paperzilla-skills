#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/src"
DIST="$ROOT/dist"
CATALOG="$ROOT/catalog"
ROOT_SKILL="$ROOT/SKILL.md"

strip_quotes() {
  local value="$1"
  value="${value%\"}"
  value="${value#\"}"
  value="${value%\'}"
  value="${value#\'}"
  printf '%s' "$value"
}

yaml_get() {
  local file="$1"
  local key="$2"
  local value

  value="$(
    awk -v key="$key" '
      index($0, key ":") == 1 {
        sub(/^[^:]+:[[:space:]]*/, "", $0)
        print
        exit
      }
    ' "$file"
  )"

  strip_quotes "$value"
}

yaml_list() {
  local file="$1"
  local key="$2"

  awk -v key="$key" '
    index($0, key ":") == 1 { in_list = 1; next }
    in_list && /^[[:space:]]*-[[:space:]]*/ {
      sub(/^[[:space:]]*-[[:space:]]*/, "", $0)
      print
      next
    }
    in_list && /^[[:space:]]*$/ { next }
    in_list { exit }
  ' "$file" | while IFS= read -r line; do
    strip_quotes "$line"
    printf '\n'
  done
}

emit_skill_markdown() {
  local out_file="$1"
  local frontmatter_name="$2"
  local frontmatter_description="$3"
  local version="$4"
  local requires_bins="$5"
  local homepage="$6"
  local body_file="$7"

  {
    echo "---"
    echo "name: $frontmatter_name"
    echo "description: $frontmatter_description"
    if [ -n "$version" ]; then
      echo "version: $version"
    fi
    if [ -n "$requires_bins" ] || [ -n "$homepage" ]; then
      echo "metadata:"
      echo "  openclaw:"
      if [ -n "$requires_bins" ]; then
        echo "    requires:"
        echo "      bins:"
        IFS=',' read -r -a bins <<< "$requires_bins"
        for bin in "${bins[@]}"; do
          bin="$(echo "$bin" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
          [ -n "$bin" ] && echo "        - $bin"
        done
      fi
      if [ -n "$homepage" ]; then
        echo "    homepage: $homepage"
      fi
    fi
    echo "---"
    echo
    cat "$body_file"
  } > "$out_file"
}

rm -rf "$DIST"
mkdir -p "$DIST" "$CATALOG"

declare -a CATALOG_ROWS=()

for skill_dir in "$SRC"/*; do
  [ -d "$skill_dir" ] || continue

  skill_manifest="$skill_dir/skill.yml"
  body_file="$skill_dir/base/BODY.md"

  if [ ! -f "$skill_manifest" ]; then
    echo "Missing skill.yml for $(basename "$skill_dir")" >&2
    exit 1
  fi

  if [ ! -f "$body_file" ]; then
    echo "Missing BODY.md for $(basename "$skill_dir")" >&2
    exit 1
  fi

  skill_id="$(yaml_get "$skill_manifest" "id")"
  package_root="$(yaml_get "$skill_manifest" "package_root")"
  frontmatter_name_default="$(yaml_get "$skill_manifest" "frontmatter_name")"
  frontmatter_description_default="$(yaml_get "$skill_manifest" "frontmatter_description")"

  if [ -z "$skill_id" ]; then
    echo "Missing id in $skill_manifest" >&2
    exit 1
  fi

  if [ -z "$package_root" ]; then
    package_root="$skill_id"
  fi

  profiles=()
  while IFS= read -r profile_name; do
    [ -n "$profile_name" ] && profiles+=("$profile_name")
  done < <(yaml_list "$skill_manifest" "profiles")

  if [ "${#profiles[@]}" -eq 0 ]; then
    echo "No profiles declared in $skill_manifest" >&2
    exit 1
  fi

  for profile_name in "${profiles[@]}"; do
    profile_dir="$skill_dir/profiles/$profile_name"
    profile_manifest="$profile_dir/profile.yml"

    if [ ! -f "$profile_manifest" ]; then
      echo "Missing profile.yml for $skill_id/$profile_name" >&2
      exit 1
    fi

    profile_id="$(yaml_get "$profile_manifest" "id")"
    agent="$(yaml_get "$profile_manifest" "agent")"
    transport="$(yaml_get "$profile_manifest" "transport")"
    package_type="$(yaml_get "$profile_manifest" "package_type")"
    artifact_name="$(yaml_get "$profile_manifest" "artifact_name")"
    version="$(yaml_get "$profile_manifest" "version")"
    install_command="$(yaml_get "$profile_manifest" "install_command")"
    requires_bins="$(yaml_get "$profile_manifest" "requires_bins")"
    homepage="$(yaml_get "$profile_manifest" "homepage")"
    source_note="$(yaml_get "$profile_manifest" "source_note")"
    sync_repo_root_skill="$(yaml_get "$profile_manifest" "sync_repo_root_skill")"
    frontmatter_name="$(yaml_get "$profile_manifest" "frontmatter_name")"
    frontmatter_description="$(yaml_get "$profile_manifest" "frontmatter_description")"

    [ -z "$profile_id" ] && profile_id="$profile_name"
    [ -z "$package_type" ] && package_type="zip"
    [ -z "$artifact_name" ] && artifact_name="$skill_id-$profile_id"
    [ -z "$frontmatter_name" ] && frontmatter_name="$frontmatter_name_default"
    [ -z "$frontmatter_description" ] && frontmatter_description="$frontmatter_description_default"

    out_dir="$DIST/$skill_id/$profile_id/$package_root"
    mkdir -p "$out_dir"

    emit_skill_markdown \
      "$out_dir/SKILL.md" \
      "$frontmatter_name" \
      "$frontmatter_description" \
      "$version" \
      "$requires_bins" \
      "$homepage" \
      "$body_file"

    for folder in references scripts assets; do
      if [ -d "$skill_dir/base/$folder" ]; then
        cp -R "$skill_dir/base/$folder" "$out_dir/$folder"
      fi
    done

    if [ -d "$profile_dir/files" ]; then
      cp -R "$profile_dir/files/." "$out_dir/"
    fi

    if [ "$sync_repo_root_skill" = "true" ]; then
      cp "$out_dir/SKILL.md" "$ROOT_SKILL"
    fi

    case "$package_type" in
      zip)
        zip_name="$artifact_name.zip"
        if [ -n "$version" ]; then
          zip_name="$artifact_name-v$version.zip"
        fi
        zip_path="$DIST/$zip_name"
        (
          cd "$DIST/$skill_id/$profile_id"
          zip -qr "$zip_path" "$package_root"
        )
        CATALOG_ROWS+=("| $skill_id | $profile_id | $agent | $transport | ZIP: [$zip_name](../dist/$zip_name) |")
        ;;
      openclaw)
        if [ -z "$install_command" ]; then
          echo "Missing install_command for $skill_id/$profile_id" >&2
          exit 1
        fi
        CATALOG_ROWS+=("| $skill_id | $profile_id | $agent | $transport | ClawHub: \`$install_command\` |")
        ;;
      source)
        if [ -z "$source_note" ]; then
          source_note="source-only profile in this repo"
        fi
        CATALOG_ROWS+=("| $skill_id | $profile_id | $agent | $transport | $source_note |")
        ;;
      *)
        echo "Unsupported package_type '$package_type' for $skill_id/$profile_id" >&2
        exit 1
        ;;
    esac
  done
done

{
  echo "# Skill Downloads"
  echo
  echo "This file is generated by tools/build-distributions.sh."
  echo
  echo "| Skill | Profile | Agent | Transport | Availability |"
  echo "|---|---|---|---|---|"
  for row in "${CATALOG_ROWS[@]}"; do
    echo "$row"
  done
} > "$CATALOG/downloads.md"

echo "Built distributions in $DIST"
echo "Updated catalog at $CATALOG/downloads.md"
