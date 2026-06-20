{
  description = "Yueting's dev environment (Nix + Home Manager + flakes)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, nix-homebrew, ... }:
    let
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      homeModules = {
        linux = [
          ./modules/common.nix
          ./modules/linux.nix
        ];
        darwin = [
          ./modules/common.nix
          ./modules/darwin.nix
        ];
      };
    in
    {
      homeConfigurations.linux = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = homeModules.linux;
      };

      darwinConfigurations.macbook-pro = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = "yueting";
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yueting.imports = homeModules.darwin;
          }
        ];
      };
    };
}
