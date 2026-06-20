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

      # The SSH kitten installs Kitty terminfo and shell integration remotely.
      if set -q KITTY_PID
        if command -q kitten
          alias ssh="kitten ssh"
        else if command -q kitty
          # Compatibility with Kitty versions before the standalone kitten binary.
          alias ssh="kitty +kitten ssh"
        end
      end
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
