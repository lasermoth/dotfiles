# Dotfiles

Personal macOS system configuration and dotfiles managed with:

- [Nix flakes](https://nixos.wiki/wiki/Flakes)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [Home Manager](https://github.com/nix-community/home-manager)
- Homebrew Casks, managed declaratively through nix-darwin

The goal is to make a new Mac feel like home with a small number of repeatable commands.

## What this currently manages

This repo starts intentionally small:

- Installs GUI apps via Homebrew Cask: Ghostty, 1Password, 1Password CLI, Raycast, OpenSuperWhisper, and JetBrains Mono Nerd Font
- Installs Herdr via Homebrew
- Installs GNU-compatible Linux-style CLI tools via Homebrew, preferring their unprefixed versions in zsh: coreutils, grep, findutils, gawk, GNU sed/tar/time/which/getopt, diffutils, gzip, make, and patch
- Installs `mise` via Nix/Home Manager and manages global mise tools: Node LTS, Python, Go, Bun, Supabase CLI, and Talos CLI
- Bootstraps Pi via mise-managed Node/npm if `pi` is not already installed; Pi then manages its own updates with `pi update`
- Links Ghostty config from `dotfiles/ghostty/config`
- Manages a fresh Zsh, Starship, Atuin, direnv, fzf, zoxide, SSH, Git, and CLI-tool foundation with Home Manager
- Manages global coding-agent instruction files for Pi, opencode, Codex CLI, Claude Code, and Gemini CLI
- Installs `git` as a basic system package
- Sets up the current macOS host configuration from machine-local settings

More packages and dotfiles can be added incrementally.

## Repository layout

```txt
flake.nix                 # Nix flake entrypoint
hosts/current/            # Generic macOS host config using machine-local settings
modules/darwin/           # Machine-level nix-darwin modules
modules/home/             # User-level Home Manager modules
dotfiles/                 # Source files linked into $HOME
scripts/apply.sh          # Single entrypoint for first-time setup and later updates
scripts/bootstrap-macos.sh # Backwards-compatible wrapper around apply.sh
scripts/install-pi.sh     # One-time Pi bootstrap via mise-managed Node/npm
scripts/machine-env.sh    # First-run machine identity prompts/helpers
scripts/switch.sh         # Backwards-compatible wrapper around apply.sh
secrets/                  # Notes only; do not commit secrets
```

## First-time setup on a new Mac

1. Install Xcode Command Line Tools:

   ```sh
   xcode-select --install
   ```

2. Clone this repo:

   ```sh
   mkdir -p ~/repositories
   git clone <your-repo-url> ~/repositories/dotfiles
   cd ~/repositories/dotfiles
   ```

3. Run the apply script:

   ```sh
   ./scripts/apply.sh
   ```

The apply script is the single entrypoint for both first-time setup and later updates. It will install Nix if needed, then apply the nix-darwin configuration once Nix is available.

On first run, the script asks you to confirm the detected macOS username and choose a machine hostname. It writes the answers to a gitignored `.machine.env` file:

```sh
DOTFILES_USERNAME=your-user
DOTFILES_HOSTNAME=your-mac
```

Those values are passed to Nix via environment variables during `--impure` flake evaluation, so machine-specific names do not need to be committed. The hostname is applied to `networking.computerName`, `networking.hostName`, and `networking.localHostName`.

If Xcode Command Line Tools or Nix were just installed, open a new shell if prompted and rerun the same command:

```sh
./scripts/apply.sh
```

After nix-darwin activation, the scripts run `scripts/install-pi.sh`. This installs tools from `~/.config/mise/config.toml` and installs Pi from npm only when `pi` is missing. Pi is intentionally not pinned by Nix so `pi update` can update the CLI and its packages normally.

## Applying changes

After editing the repo, apply the current configuration with:

```sh
./scripts/apply.sh
```

By default this applies the generic `current` config using `.machine.env`.

To update the username or machine hostname later, rerun with:

```sh
./scripts/apply.sh --configure
```

You can also manually edit `.machine.env` and rerun the apply script.

## Adding GUI apps

GUI apps are managed in:

```txt
modules/darwin/homebrew.nix
```

For example:

```nix
homebrew.casks = [
  "ghostty"
  "raycast"
  "1password"
];
```

Then run:

```sh
./scripts/apply.sh
```

## Shell and terminal setup

The shell is intentionally managed from scratch rather than importing existing local shell files.

Managed files/modules:

```txt
modules/home/zsh.nix       # Zsh options, aliases, history, startup foundation
modules/home/starship.nix  # Prompt theme/config
modules/home/atuin.nix     # Local-only shell history search with secret filtering
modules/home/agents.nix    # Global coding-agent instruction links
modules/home/herdr.nix     # Herdr config link
modules/home/mise.nix      # Global mise config link
modules/home/git.nix       # Git defaults and Delta integration
modules/home/ssh.nix       # Minimal SSH config for 1Password agent
modules/home/cli-tools.nix # CLI utilities and shell integrations
modules/home/ghostty.nix   # Ghostty config link
dotfiles/ghostty/config    # Ghostty config source
dotfiles/herdr/config.toml # Herdr config source
dotfiles/mise/config.toml  # Global mise tools source
```

Prompt/theme stack:

- Zsh for the interactive shell
- Starship for the prompt
- JetBrains Mono Nerd Font for icons/glyphs
- Catppuccin Mocha-inspired colors
- Ghostty starts `scripts/ghostty-herdr.sh`, which launches Herdr and falls back to a login shell if Herdr exits
- Atuin sync is disabled; history is local-only and filtered for common secret/token patterns
- SSH uses the 1Password SSH agent socket by default
- GNU Homebrew tools are placed ahead of macOS BSD defaults in zsh, so commands like `grep`, `sed`, `find`, `xargs`, `date`, `stat`, `tar`, `patch`, `make`, and `timeout` behave closer to Linux defaults
- Global agent instructions are sourced from `modules/home/AGENTS.md` and linked into common tool-specific locations such as `~/.pi/agent/AGENTS.md`, `~/.config/opencode/AGENTS.md`, `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`, and `~/.gemini/GEMINI.md`

## Adding dotfiles

Put source files under `dotfiles/`, then link them with Home Manager in `modules/home/`.

Example:

```nix
home.file.".config/example/config".source = ../../dotfiles/example/config;
```

## Secrets

Do not commit private keys, tokens, passwords, or other secrets. See `secrets/README.md`.
