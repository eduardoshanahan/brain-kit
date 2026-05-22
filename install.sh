#!/usr/bin/env bash
# Install brainctl to ~/.local/bin/ (or a custom destination)
# Usage: ./install.sh [destination]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="${1:-$HOME/.local/bin}"

mkdir -p "$DEST"
cp "$SCRIPT_DIR/brainctl" "$DEST/brainctl"
chmod +x "$DEST/brainctl"

echo "brainctl installed to $DEST/brainctl"

if ! echo "$PATH" | grep -q "$DEST"; then
  echo ""
  echo "NOTE: $DEST is not in your PATH."
  echo "Add this to your shell profile (~/.bashrc or ~/.zshrc):"
  echo '  export PATH="'"$DEST"':$PATH"'
fi

echo ""
echo "Quick start:"
echo "  brainctl init --global ~/brain       # create your global brain"
echo "  cd <your-project>"
echo "  brainctl init --type private         # scaffold local .brain/ + .envrc"
