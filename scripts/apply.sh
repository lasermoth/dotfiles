#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

CONFIG="current"
CONFIGURE_MACHINE=false

usage() {
  cat <<'EOF'
Usage: ./scripts/apply.sh [--configure] [config]

Single entrypoint for both first-time bootstrap and later updates.

Options:
  --configure   Re-prompt for machine-local username/hostname
  -h, --help    Show this help

Arguments:
  config        nix-darwin flake config to apply; defaults to "current"
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --configure)
      CONFIGURE_MACHINE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      CONFIG="$1"
      shift
      ;;
  esac
done

# shellcheck source=scripts/machine-env.sh
source ./scripts/machine-env.sh

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This setup currently supports macOS only."
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Re-run this same command after the Command Line Tools installation finishes:"
  echo "  ./scripts/apply.sh"
  exit 0
fi

if ! command -v nix >/dev/null 2>&1; then
  ensure_machine_env "$CONFIGURE_MACHINE"

  echo "Installing Nix using the Determinate Systems installer..."
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install
  echo "Nix installed. Open a new shell, then re-run this same command:"
  echo "  ./scripts/apply.sh"
  exit 0
fi

ensure_machine_env "$CONFIGURE_MACHINE"

sudo -H env \
  DOTFILES_USERNAME="$DOTFILES_USERNAME" \
  DOTFILES_HOSTNAME="$DOTFILES_HOSTNAME" \
  nix run github:LnL7/nix-darwin -- switch --impure --flake ".#${CONFIG}"

./scripts/install-pi.sh
