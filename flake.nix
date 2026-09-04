{
  description = "Yueting's dev environment (Nix + Home Manager + flakes)";

  inputs = {
    # Use each platform's binary-cached Nixpkgs branch from the same stable
    # release. Keeping separate inputs avoids making Linux consume the Darwin
    # branch (or vice versa) merely to satisfy nix-darwin's release check.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.7.0";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # Keep Nix-managed Homebrew compatible with the current cask DSL.
    nix-homebrew.inputs.brew-src.url = "github:Homebrew/brew";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, nix-darwin, nix-homebrew, ... }:
    let
      userName = "yueting";
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      homeModules = {
        linux = [
          ./modules/common.nix
          ./modules/linux.nix
          ./modules/flatpak.nix
          nix-flatpak.homeManagerModules.nix-flatpak
          {
            home.username = userName;
            home.homeDirectory = "/home/${userName}";
          }
        ];
        darwin = [
          ./modules/common.nix
          ./modules/darwin.nix
          {
            home.username = userName;
            home.homeDirectory = "/Users/${userName}";
          }
        ];
      };
    in
    {
      homeConfigurations.linux = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = homeModules.linux;
      };

      # Bootstrap and apply with the exact Home Manager revision in flake.lock.
      apps.x86_64-linux.home-manager = {
        type = "app";
        program = "${home-manager.packages.x86_64-linux.home-manager}/bin/home-manager";
      };

      devShells.x86_64-linux.default = linuxPkgs.mkShell {
        packages = [ linuxPkgs.gnumake ];
      };

      apps.aarch64-darwin.home-manager = {
        type = "app";
        program = "${home-manager.packages.aarch64-darwin.home-manager}/bin/home-manager";
      };

      apps.aarch64-darwin.darwin-rebuild = {
        type = "app";
        program = "${nix-darwin.packages.aarch64-darwin.darwin-rebuild}/bin/darwin-rebuild";
      };

      darwinConfigurations.macbook-pro = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit userName; };
        modules = [
          ./darwin-configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = userName;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userName}.imports = homeModules.darwin;
          }
        ];
      };
    };
}
