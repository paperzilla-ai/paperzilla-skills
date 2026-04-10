#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/src"
DIST="$ROOT/dist"
CATALOG="$ROOT/catalog"
AGENTSKILLS_EXPORT="$CATALOG/agentskills"
ROOT_SKILLS_EXPORT="$ROOT/skills"
ROOT_SKILL="$ROOT/SKILL.md"
REPO_WEB="https://github.com/paperzilla-ai/paperzilla-skills"

asset_alias_name() {
  local filename="$1"
  local stem
  local ext

  case "$filename" in
    *.tar.gz)
      stem="${filename%.tar.gz}"
      ext=".tar.gz"
      ;;
    *.zip)
      stem="${filename%.zip}"
      ext=".zip"
      ;;
    *)
      printf '%s' "$filename"
      return
      ;;
  esac

  stem="$(printf '%s' "$stem" | sed -E 's/-v[0-9][0-9A-Za-z._-]*$//')"
  printf '%s%s' "$stem" "$ext"
}

latest_asset_url() {
  local filename="$1"
  local alias_name

  alias_name="$(asset_alias_name "$filename")"
  printf '%s/releases/latest/download/%s' "$REPO_WEB" "$alias_name"
}

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
  local license="$4"
  local skill_author="$5"
  local requires_bins="$6"
  local homepage="$7"
  local body_file="$8"

  {
    echo "---"
    echo "name: $frontmatter_name"
    echo "description: $frontmatter_description"
    if [ -n "$license" ]; then
      echo "license: $license"
    fi
    if [ -n "$skill_author" ] || [ -n "$requires_bins" ] || [ -n "$homepage" ]; then
      echo "metadata:"
      if [ -n "$skill_author" ]; then
        echo "  skill-author: \"$skill_author\""
      fi
    fi
    if [ -n "$requires_bins" ] || [ -n "$homepage" ]; then
      if [ -z "$skill_author" ]; then
        echo "metadata:"
      fi
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
rm -rf "$AGENTSKILLS_EXPORT"
rm -rf "$ROOT_SKILLS_EXPORT"
mkdir -p "$DIST" "$CATALOG" "$AGENTSKILLS_EXPORT" "$ROOT_SKILLS_EXPORT"

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
  frontmatter_license_default="$(yaml_get "$skill_manifest" "frontmatter_license")"
  frontmatter_skill_author_default="$(yaml_get "$skill_manifest" "frontmatter_skill_author")"
  recommended_profile="$(yaml_get "$skill_manifest" "recommended_profile")"

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

  if [ -z "$recommended_profile" ]; then
    recommended_profile="${profiles[0]}"
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
    frontmatter_license="$(yaml_get "$profile_manifest" "frontmatter_license")"
    frontmatter_skill_author="$(yaml_get "$profile_manifest" "frontmatter_skill_author")"

    [ -z "$profile_id" ] && profile_id="$profile_name"
    [ -z "$package_type" ] && package_type="zip"
    [ -z "$artifact_name" ] && artifact_name="$skill_id-$profile_id"
    [ -z "$frontmatter_name" ] && frontmatter_name="$frontmatter_name_default"
    [ -z "$frontmatter_description" ] && frontmatter_description="$frontmatter_description_default"
    [ -z "$frontmatter_license" ] && frontmatter_license="$frontmatter_license_default"
    [ -z "$frontmatter_skill_author" ] && frontmatter_skill_author="$frontmatter_skill_author_default"

    out_dir="$DIST/$skill_id/$profile_id/$package_root"
    mkdir -p "$out_dir"

    emit_skill_markdown \
      "$out_dir/SKILL.md" \
      "$frontmatter_name" \
      "$frontmatter_description" \
      "$frontmatter_license" \
      "$frontmatter_skill_author" \
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

    export_dir="$AGENTSKILLS_EXPORT/$skill_id/$profile_id/$package_root"
    mkdir -p "$export_dir"
    cp -R "$out_dir/." "$export_dir/"

    if [ "$profile_id" = "$recommended_profile" ] || [ "$profile_name" = "$recommended_profile" ]; then
      root_export_dir="$ROOT_SKILLS_EXPORT/$package_root"
      mkdir -p "$root_export_dir"
      cp -R "$out_dir/." "$root_export_dir/"
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
        CATALOG_ROWS+=("| $skill_id | $profile_id | $agent | $transport | [Latest ZIP]($(latest_asset_url "$zip_name")) |")
        ;;
      openclaw)
        if [ -z "$install_command" ]; then
          echo "Missing install_command for $skill_id/$profile_id" >&2
          exit 1
        fi
        CATALOG_ROWS+=("| $skill_id | $profile_id | $agent | $transport | ClawHub: \`$install_command\` |")
        ;;
      source)
        source_name="$artifact_name.tar.gz"
        if [ -n "$version" ]; then
          source_name="$artifact_name-v$version.tar.gz"
        fi
        source_path="$DIST/$source_name"
        (
          cd "$DIST/$skill_id/$profile_id"
          tar -czf "$source_path" "$package_root"
        )
        if [ -z "$source_note" ]; then
          source_note="Source bundle"
        fi
        CATALOG_ROWS+=("| $skill_id | $profile_id | $agent | $transport | [$source_note]($(latest_asset_url "$source_name")) |")
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
