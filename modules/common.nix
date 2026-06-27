{
  imports = [
    ./shell.nix
    ./ui.nix
    ./editor.nix
    ./emacs.nix
    ./terminal.nix
    ./tools.nix
    ./dotfiles.nix
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
