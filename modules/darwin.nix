{ config, lib, ... }:

let
  guiPath = [
    "/etc/profiles/per-user/${config.home.username}/bin"
    "/run/current-system/sw/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];
  guiPathString = lib.concatStringsSep ":" guiPath;
in
{
  home.username = "yueting";
  home.homeDirectory = "/Users/yueting";

  # GUI apps launched from Spotlight/Raycast do not inherit shell startup files.
  # Set user launchd PATH from Home Manager so apps like Kitty can resolve
  # commands from the Nix user profile without changing the account login shell.
  home.activation.setLaunchdGuiEnvironment =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      /bin/launchctl setenv PATH "${guiPathString}"
    '';

  launchd.agents.set-gui-path = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/launchctl"
        "setenv"
        "PATH"
        guiPathString
      ];
      RunAtLoad = true;
      StandardOutPath = "/tmp/home-manager-set-gui-path.log";
      StandardErrorPath = "/tmp/home-manager-set-gui-path.err.log";
    };
  };
}
