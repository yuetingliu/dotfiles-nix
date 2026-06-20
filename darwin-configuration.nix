{ pkgs, ... }:

{
  # Determinate manages the Nix daemon and /etc/nix configuration.
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.yueting.home = "/Users/yueting";
  system.primaryUser = "yueting";
  programs.fish.enable = true;

  fonts.packages = import ./modules/font-packages.nix { inherit pkgs; };

  homebrew = {
    enable = true;
    casks = [
      "brave-browser"
      "dropbox"
      "ghostty"
      "kitty"
      "raycast"
      "spotify"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };

  system.stateVersion = 6;
}
