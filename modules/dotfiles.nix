{ config, lib, ... }:

let
  oos = config.lib.file.mkOutOfStoreSymlink;
in
{
  options.dotfiles.repoPath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/src/dotfiles-nix";
    description = "Absolute path to this dotfiles repository.";
  };

  config = {
    ############################################################
    # Big configs as editable out-of-store symlinks
    ############################################################

    # LazyVim config directory
    xdg.configFile."nvim".source = oos "${config.dotfiles.repoPath}/dotfiles/config/nvim";

    # Doom user config directory (init.el/config.el/packages.el)
    xdg.configFile."doom".source = oos "${config.dotfiles.repoPath}/dotfiles/config/doom";
  };
}
