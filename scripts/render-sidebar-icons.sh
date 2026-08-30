#!/bin/zsh
set -euo pipefail

ROOT="${0:A:h:h}"
ICON_TEMPLATE="$ROOT/Resources/SidebarIcons/SidebarIconTemplate.icon"
SOURCE_DIR="$ROOT/Resources/SidebarIcons/Layers"
OUTPUT_DIR="$ROOT/Resources/SidebarIcons/Rendered"
ICON_TOOL="${ICON_COMPOSER_TOOL:-/Applications/Xcode-beta.app/Contents/Applications/Icon Composer.app/Contents/Executables/ictool}"

if [[ "$#" -ne 0 ]]; then
  print -u2 "usage: $0"
  exit 1
fi
if [[ ! -d "$ICON_TEMPLATE" || ! -f "$ICON_TEMPLATE/icon.json" ]]; then
  print -u2 "Icon Composer template is missing: $ICON_TEMPLATE"
  exit 1
fi
if [[ ! -x "$ICON_TOOL" ]]; then
  print -u2 "Icon Composer command-line tool is unavailable: $ICON_TOOL"
  exit 1
fi

typeset -a ICON_NAMES=(
  connection
  private-feature
  macros
  mapping
  statistics
  transcripts
  permissions
  about
)

STAGING_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sayall-sidebar-icons.XXXXXX")"
trap 'rm -rf -- "$STAGING_ROOT"' EXIT
mkdir -p "$OUTPUT_DIR"

for name in "${ICON_NAMES[@]}"; do
  source_svg="$SOURCE_DIR/$name.svg"
  working_icon="$STAGING_ROOT/$name.icon"
  if [[ ! -f "$source_svg" ]]; then
    print -u2 "sidebar icon source is missing: $source_svg"
    exit 1
  fi

  ditto --norsrc --noextattr --noqtn --noacl "$ICON_TEMPLATE" "$working_icon"
  /usr/bin/install -m 0644 "$source_svg" "$working_icon/Assets/connection.svg"
  /usr/bin/install -m 0644 "$SOURCE_DIR/background.svg" "$working_icon/Assets/background.svg"

  "$ICON_TOOL" "$working_icon" \
    --export-image \
    --output-file "$OUTPUT_DIR/$name.png" \
    --platform macOS \
    --rendition Default \
    --width 20 \
    --height 20 \
    --scale 1
  "$ICON_TOOL" "$working_icon" \
    --export-image \
    --output-file "$OUTPUT_DIR/$name@2x.png" \
    --platform macOS \
    --rendition Default \
    --width 20 \
    --height 20 \
    --scale 2
done

print "Rendered ${#ICON_NAMES[@]} Icon Composer sidebar icons in $OUTPUT_DIR"
