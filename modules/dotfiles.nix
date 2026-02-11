{ config, pkgs, ... }:

let
  repo = "${config.home.homeDirectory}/dotfiles-nix";
  oos  = config.lib.file.mkOutOfStoreSymlink;
in
{
  ############################################################
  # Big configs as editable out-of-store symlinks
  ############################################################

  # LazyVim config directory
  xdg.configFile."nvim".source = oos "${repo}/dotfiles/config/nvim";

  # Doom user config directory (init.el/config.el/packages.el)
  xdg.configFile."doom".source = oos "${repo}/dotfiles/config/doom";
}
