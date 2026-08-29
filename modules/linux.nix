{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.keychain ];

  programs.fish.interactiveShellInit = lib.mkAfter ''
    if command -q keychain
      if not set -q SSH_AUTH_SOCK; or not test -S "$SSH_AUTH_SOCK"
        eval (keychain --quiet --eval --nogui --ignore-missing -Q id_ed25519 id_rsa)
      end
    end
  '';
}
