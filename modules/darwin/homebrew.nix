{username, ...}: {
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;

    onActivation = {
      # Keep activation conservative while this repo is being bootstrapped.
      # `cleanup = "uninstall"` removes every Homebrew package not listed here,
      # which is too destructive until this file fully describes the machine.
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    brews = [
      # GNU-compatible core utilities; Homebrew exposes unprefixed binaries in
      # each formula's libexec/gnubin directory, which we add to PATH in zsh.nix.
      "coreutils"
      "diffutils"
      "findutils"
      "gawk"
      "gpatch"
      "gnu-getopt"
      "gnu-sed"
      "gnu-tar"
      "gnu-time"
      "gnu-which"
      "grep"
      "gzip"
      "make"

      # Terminal workspace/session manager used with Ghostty.
      "herdr"
    ];

    casks = [
      "1password"
      "1password-cli"
      "ghostty"
      "font-jetbrains-mono-nerd-font"
      "opensuperwhisper"
      "raycast"
    ];
  };
}
