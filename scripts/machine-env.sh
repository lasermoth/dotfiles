#!/usr/bin/env bash

MACHINE_ENV="${MACHINE_ENV:-.machine.env}"

is_interactive() {
  [[ -t 0 && -t 1 ]]
}

detect_hostname() {
  scutil --get LocalHostName 2>/dev/null \
    || hostname -s 2>/dev/null \
    || echo "mac"
}

sanitize_hostname() {
  local value="$1"
  value="$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')"
  value="$(printf '%s' "$value" | sed -E 's/[^a-z0-9-]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')"
  printf '%s' "${value:-mac}"
}

write_machine_env() {
  local username="$1"
  local hostname="$2"

  {
    printf '# Machine-local dotfiles settings. This file is gitignored.\n'
    printf '# Re-run ./scripts/apply.sh --configure to update these values.\n'
    printf 'DOTFILES_USERNAME=%q\n' "$username"
    printf 'DOTFILES_HOSTNAME=%q\n' "$hostname"
  } >"$MACHINE_ENV"
}

prompt_machine_env() {
  local detected_username detected_hostname username hostname_input hostname
  detected_username="${DOTFILES_USERNAME:-$(id -un)}"
  detected_hostname="${DOTFILES_HOSTNAME:-$(detect_hostname)}"
  detected_hostname="$(sanitize_hostname "$detected_hostname")"

  if is_interactive; then
    printf 'Confirm macOS username [%s]: ' "$detected_username"
    read -r username
    username="${username:-$detected_username}"

    printf 'Machine hostname [%s]: ' "$detected_hostname"
    read -r hostname_input
    hostname="$(sanitize_hostname "${hostname_input:-$detected_hostname}")"
  else
    username="$detected_username"
    hostname="$detected_hostname"
  fi

  write_machine_env "$username" "$hostname"
  echo "Wrote $MACHINE_ENV for user '$username' on host '$hostname'."
}

ensure_machine_env() {
  local configure="${1:-false}"

  if [[ "$configure" == "true" || ! -f "$MACHINE_ENV" ]]; then
    prompt_machine_env
  fi

  # shellcheck disable=SC1090
  source "$MACHINE_ENV"
}
