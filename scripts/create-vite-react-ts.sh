#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${1:-}"
DEST_DIR="${2:-}"

if [[ -z "$APP_NAME" ]]; then
  read -r -p "Project name: " APP_NAME
fi
if [[ -z "$APP_NAME" ]]; then
  echo "Project name is required."
  exit 1
fi

if [[ -z "$DEST_DIR" ]]; then
  read -r -p "Destination folder (default: ../): " DEST_DIR
fi

DEST_DIR="${DEST_DIR:-../}"
DEST_DIR="${DEST_DIR/#\~/$HOME}"

mkdir -p "$DEST_DIR"
cd "$DEST_DIR"

echo "▶ Creating Vite React+TS app in: $(pwd)"
npm create vite@latest "$APP_NAME" -- --template react-ts

echo ""
echo "✅ Created: $(pwd)/$APP_NAME"
echo "Next:"
echo "  cd \"$DEST_DIR/$APP_NAME\""
echo "  /path/to/your-template/scripts/apply-scaffold.sh"
