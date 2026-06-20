{ lib, pkgs, ... }:

{
  # Enable per-user fontconfig so apps (kitty/emacs/etc.) can see fonts installed by Nix
  fonts.fontconfig.enable = true;

  # macOS fonts are registered system-wide by nix-darwin.
  home.packages = lib.optionals pkgs.stdenv.isLinux (
    import ./font-packages.nix { inherit pkgs; }
  );

  # Later, GUI apps can live here too (optional)
  # home.packages = with pkgs; [
  #   gimp
  # ];
}
