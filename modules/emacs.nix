{ config, lib, pkgs, ... }:

let
  doomDir = "${config.home.homeDirectory}/.config/emacs";
  linuxEmacs = pkgs.emacs-pgtk.pkgs.withPackages (epkgs: with epkgs; [
    pdf-tools
  ]);
in
{
  ############################################################
  # Emacs + Doom prerequisites
  ############################################################

  home.packages = lib.optionals pkgs.stdenv.isLinux [
    linuxEmacs   # macOS uses Homebrew Emacs Plus from nix-darwin.
  ] ++ (with pkgs; [
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
  ]);

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
