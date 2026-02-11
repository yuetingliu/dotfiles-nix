{ config, pkgs, ... }:

{
  # Enable per-user fontconfig so apps (kitty/emacs/etc.) can see fonts installed by Nix
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    ############################################################
    # Fonts (Nerd Fonts)
    ############################################################
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # Later, GUI apps can live here too (optional)
  # home.packages = with pkgs; [
  #   gimp
  # ];
}

