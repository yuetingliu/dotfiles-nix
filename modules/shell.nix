{ config, pkgs, ... }:

{
  ############################################################
  # set env vars and PATH
  ############################################################
  home.sessionVariables = {
    BUN_INSTALL = "${config.home.homeDirectory}/.bun";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.config/emacs/bin"
    "${config.home.homeDirectory}/.bun/bin"
  ];

  ############################################################
  # Fish + shell UX
  ############################################################

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -gx EDITOR nvim
      set -gx VISUAL nvim
      set -gx SHELL (command -v fish)

      alias ll="eza -lah --group-directories-first"
      alias cat="bat"
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
