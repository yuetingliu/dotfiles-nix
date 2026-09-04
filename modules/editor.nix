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
    # Keep Home Manager's provider setup in wrapper arguments because the
    # checked-in LazyVim directory owns init.lua.
    sideloadInitLua = true;
    # None of the configured plugins require Neovim's Ruby provider.
    withRuby = false;
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
