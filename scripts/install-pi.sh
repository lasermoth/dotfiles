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

# Home Manager has just activated during bootstrap, but the current shell may not
# have the new Nix profile on PATH yet. Add it explicitly so mise/npm shims can
# call `mise`, and so tools like `gpg` are visible during mise installs.
export PATH="$(dirname "$mise_bin"):/etc/profiles/per-user/$(id -un)/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$HOME/.local/bin:$PATH"

if command -v pi >/dev/null 2>&1; then
  echo "pi is already installed at $(command -v pi). Use 'pi update' to update it."
  exit 0
fi

echo "Installing mise-managed tools from ~/.config/mise/config.toml..."
"$mise_bin" install --yes

echo "Installing pi via npm. Future updates should use: pi update"
"$mise_bin" exec node@lts -- npm install -g --ignore-scripts @earendil-works/pi-coding-agent

echo "pi installed. Open a new shell before using it."
echo "If you need it in the current shell, run: eval \"\$(mise activate zsh)\""
