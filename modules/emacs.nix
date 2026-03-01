{ config, pkgs, ... }:

let
  doomDir = "${config.home.homeDirectory}/.config/emacs";
in
{
  ############################################################
  # Emacs + Doom prerequisites
  ############################################################

  home.packages = with pkgs; [
    emacs

    git
    ripgrep
    fd
    fzf

    gcc
    gnumake
    cmake
    pkg-config
    libtool  # needed to compile vterm

    nodejs
    python3
    sqlite
  ];

  ############################################################
  # Ensure Doom framework is present (~/.config/emacs)
  # Idempotent: clones only if directory missing
  ############################################################
  home.activation.ensureDoomFramework =
    config.lib.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d "${doomDir}" ]; then
        echo "Cloning Doom Emacs into ${doomDir}..."
        ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs "${doomDir}"
      fi
    '';
}
