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

if ! command -v nix >/dev/null 2>&1; then
  echo "Nix is not installed. Run ./scripts/bootstrap-macos.sh first."
  exit 1
fi

ensure_machine_env "$CONFIGURE_MACHINE"

sudo -H env \
  DOTFILES_USERNAME="$DOTFILES_USERNAME" \
  DOTFILES_HOSTNAME="$DOTFILES_HOSTNAME" \
  nix run github:LnL7/nix-darwin -- switch --impure --flake ".#${CONFIG}"
