#!/usr/bin/env bash
set -euo pipefail

mise_bin="${MISE_BIN:-}"

if [[ -z "$mise_bin" ]]; then
  if command -v mise >/dev/null 2>&1; then
    mise_bin="$(command -v mise)"
  elif [[ -x "/etc/profiles/per-user/$(id -un)/bin/mise" ]]; then
    mise_bin="/etc/profiles/per-user/$(id -un)/bin/mise"
  else
    echo "mise is not available yet; skipping pi install. Re-run ./scripts/switch.sh after activation."
    exit 0
  fi
fi

if command -v pi >/dev/null 2>&1; then
  echo "pi is already installed at $(command -v pi). Use 'pi update' to update it."
  exit 0
fi

echo "Installing mise-managed tools from ~/.config/mise/config.toml..."
"$mise_bin" install --yes

echo "Installing pi via npm. Future updates should use: pi update"
"$mise_bin" exec node@lts -- npm install -g --ignore-scripts @earendil-works/pi-coding-agent

echo "pi installed. Open a new shell, or run 'eval \"$(mise activate zsh)\"', before using it."
