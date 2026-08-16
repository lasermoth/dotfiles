{
  description = "Personal macOS dotfiles and system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nix-homebrew,
    ...
  }: let
    envOr = name: default: let
      value = builtins.getEnv name;
    in
      if value == ""
      then default
      else value;

    username = envOr "DOTFILES_USERNAME" "nduff";
    hostname = envOr "DOTFILES_HOSTNAME" "mac";
    system = "aarch64-darwin";

    mkDarwinConfiguration = nix-darwin.lib.darwinSystem {
      inherit system;

      specialArgs = {
        inherit inputs username hostname;
      };

      modules = [
        ./hosts/current

        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
      ];
    };
  in {
    darwinConfigurations = {
      # Scripts populate DOTFILES_USERNAME/DOTFILES_HOSTNAME from .machine.env
      # and build this generic config for whichever Mac is running them.
      current = mkDarwinConfiguration;

      # Backwards-compatible alias for existing commands while migrating.
      lobster = mkDarwinConfiguration;
    };
  };
}
