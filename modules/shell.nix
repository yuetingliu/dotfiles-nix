{ config, pkgs, ... }:

{
  ############################################################
  # Fish + shell UX
  ############################################################

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -gx EDITOR nvim
      set -gx VISUAL nvim

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
