{ pkgs, username, ... }:

{
  nix = {
    enable = false;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];

  system = {
    # Used by nix-darwin for backwards compatibility. Do not change after initial setup.
    stateVersion = 5;
  };
}
