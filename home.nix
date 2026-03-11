{ config, pkgs, ... }:

{
  home.username = "yueting";
  home.homeDirectory = "/home/yueting";
  home.stateVersion = "24.05";

  imports = [
    ./modules/shell.nix
    ./modules/ui.nix
    ./modules/editor.nix
    ./modules/emacs.nix
    ./modules/tools.nix
    ./modules/dotfiles.nix
  ];

  programs.home-manager.enable = true;
}

