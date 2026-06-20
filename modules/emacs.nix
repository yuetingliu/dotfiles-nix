{ config, pkgs, ... }:

let
  doomDir = "${config.home.homeDirectory}/.config/emacs";
  emacs = if pkgs.stdenv.isDarwin then pkgs.emacs else pkgs.emacs-pgtk;

  emacsWithPackages = emacs.pkgs.withPackages (epkgs: with epkgs; [
    pdf-tools
  ]);
in
{
  ############################################################
  # Emacs + Doom prerequisites
  ############################################################

  home.packages = with pkgs; [
    emacsWithPackages   # PGTK on Linux; standard Emacs on macOS

    # latex
    texlab
    texlive.combined.scheme-full

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
