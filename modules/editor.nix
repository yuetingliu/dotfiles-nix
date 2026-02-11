{ config, pkgs, ... }:

{
  ############################################################
  # Neovim (LazyVim config lives in ~/.config/nvim via dotfiles)
  ############################################################

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
  };

  home.packages = with pkgs; [
    # LazyVim essentials
    git
    ripgrep
    fd
    fzf

    # Common runtimes / tooling
    nodejs
    python3

    # Common format/lint tools (LazyVim integrates nicely)
    stylua
    shellcheck
    shfmt
  ];
}
