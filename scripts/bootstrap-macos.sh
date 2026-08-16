#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

CONFIG="current"
CONFIGURE_MACHINE=false

if [[ "${1:-}" == "--configure" ]]; then
  CONFIGURE_MACHINE=true
  shift
fi

if [[ $# -gt 0 ]]; then
  CONFIG="$1"
fi

# shellcheck source=scripts/machine-env.sh
source ./scripts/machine-env.sh

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap script currently supports macOS only."
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Re-run this script after the Command Line Tools installation finishes."
  exit 0
fi

if ! command -v nix >/dev/null 2>&1; then
  ensure_machine_env "$CONFIGURE_MACHINE"

  echo "Installing Nix using the Determinate Systems installer..."
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install
  echo "Nix installed. Open a new shell, then re-run this script."
  exit 0
fi

ensure_machine_env "$CONFIGURE_MACHINE"

sudo -H env \
  DOTFILES_USERNAME="$DOTFILES_USERNAME" \
  DOTFILES_HOSTNAME="$DOTFILES_HOSTNAME" \
  nix run github:LnL7/nix-darwin -- switch --impure --flake ".#${CONFIG}"

./scripts/install-pi.sh
