{pkgs, ...}: {
  home.packages = with pkgs; [
    age
    alejandra
    bat
    bottom
    coreutils
    curl
    deadnix
    dust
    duf
    eza
    fd
    gh
    gnupg
    jless
    jq
    lazygit
    mise
    neovim
    nix-output-monitor
    nvd
    procs
    ripgrep
    sops
    statix
    tldr
    tree
    unzip
    wget
    xh
    yq
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Atuin owns Ctrl-R for shell history search; fzf remains available as `fzf`.
    historyWidget.command = "";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
