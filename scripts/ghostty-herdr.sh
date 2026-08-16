#!/usr/bin/env bash
set -euo pipefail

HERDR="/opt/homebrew/bin/herdr"
SHELL_BIN="${SHELL:-/bin/zsh}"

if [[ ! -x "$HERDR" ]]; then
  echo "Herdr is not installed at $HERDR. Starting a login shell instead."
  exec "$SHELL_BIN" -l
fi

set +e
"$HERDR"
status=$?
set -e

# If Herdr exits non-zero, keep the Ghostty window open with a usable shell.
# This is especially helpful after Herdr upgrades, where an old background server
# may need to be stopped before the new client can attach.
if [[ $status -ne 0 ]]; then
  cat <<EOF

Herdr exited with status $status.

If this happened after an upgrade and you saw a protocol/version mismatch, run:

  herdr server stop
  herdr

Stopping the server exits existing Herdr pane processes.
Starting an interactive login shell now so this window stays usable.

EOF
fi

exec "$SHELL_BIN" -l
