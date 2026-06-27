{ pkgs, ... }:

{
  # Determinate manages the Nix daemon and /etc/nix configuration.
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.yueting.home = "/Users/yueting";
  system.primaryUser = "yueting";
  programs.fish.enable = true;

  environment.variables.LIBRARY_PATH = [
    "/opt/homebrew/opt/gcc/lib/gcc/current"
    "/opt/homebrew/opt/gcc/lib/gcc/current/gcc/aarch64-apple-darwin25/16"
  ];

  launchd.user.envVariables.LIBRARY_PATH = [
    "/opt/homebrew/opt/gcc/lib/gcc/current"
    "/opt/homebrew/opt/gcc/lib/gcc/current/gcc/aarch64-apple-darwin25/16"
  ];

  # GUI apps launched from Spotlight/Raycast do not inherit shell startup files.
  # Keep their PATH aligned with Nix, Homebrew, and macOS system paths.
  launchd.user.envVariables.PATH = [
    "/etc/profiles/per-user/yueting/bin"
    "/run/current-system/sw/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];

  fonts.packages = import ./modules/font-packages.nix { inherit pkgs; };

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
      "raycast"
      "spotify"
      "bitwarden"
      "chatgpt"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };

  system.stateVersion = 6;
}
