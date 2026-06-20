{ ... }:

{
  # Determinate manages the Nix daemon and /etc/nix configuration.
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.yueting.home = "/Users/yueting";
  programs.fish.enable = true;

  system.stateVersion = 6;
}
