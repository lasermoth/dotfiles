{username, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.${username} = {pkgs, ...}: {
      imports = [
        ./agents.nix
        ./atuin.nix
        ./cli-tools.nix
        ./ghostty.nix
        ./git.nix
        ./herdr.nix
        ./ssh.nix
        ./starship.nix
        ./zsh.nix
      ];

      home = {
        username = username;
        homeDirectory = "/Users/${username}";
        stateVersion = "24.11";
      };

      programs.home-manager.enable = true;
    };
  };
}
