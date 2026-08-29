{ pkgs, userName, ... }:

{
  # Determinate manages the Nix daemon and /etc/nix configuration.
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.${userName}.home = "/Users/${userName}";
  system.primaryUser = userName;
  programs.fish.enable = true;

  environment.variables.LIBRARY_PATH = [
    "/opt/homebrew/opt/gcc/lib/gcc/current"
    "/opt/homebrew/opt/gcc/lib/gcc/current/gcc/aarch64-apple-darwin25/16"
  ];

  launchd.user.envVariables.LIBRARY_PATH = [
    "/opt/homebrew/opt/gcc/lib/gcc/current"
    "/opt/homebrew/opt/gcc/lib/gcc/current/gcc/aarch64-apple-darwin25/16"
  ];

  fonts.packages = import ./modules/font-packages.nix { inherit pkgs; };

  # Keep Spaces stable and make native window management feel closer to a
  # lightweight tiling workflow without replacing the macOS window manager.
  system.defaults = {
    dock.mru-spaces = false;
    spaces.spans-displays = false;

    WindowManager = {
      GloballyEnabled = false;
      EnableTiledWindowMargins = true;
      EnableTilingByEdgeDrag = true;
      EnableTilingOptionAccelerator = true;
      EnableTopTilingByEdgeDrag = true;
    };
  };

  homebrew = {
    enable = true;
    taps = [
      {
        name = "d12frosted/emacs-plus";
        trusted = true;
      }
    ];
    brews = [
      "autoconf"
      "automake"
      "gcc"
      "libgccjit"
      "libtool"
      "pkgconf"
      "poppler"
    ];
    casks = [
      "emacs-plus-app"
      "brave-browser"
      "dropbox"
      "ghostty"
      "kitty"
      "microsoft-teams"
      "raycast"
      "spotify"
      "zoom"
      "bitwarden"
      "chatgpt"
    ];
    onActivation = {
      # Homebrew itself and upgrades are pinned by flake.lock. This keeps
      # darwin-rebuild idempotent and avoids mixing a pinned brew client with
      # newer, imperatively fetched cask metadata.
      autoUpdate = false;
      upgrade = false;
    };

    # Expose nix-darwin's generated Brewfile for the explicit `make update`
    # workflow. Regular activation remains non-updating.
    global.brewfile = true;
  };

  system.stateVersion = 6;
}
