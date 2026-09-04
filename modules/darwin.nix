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
  # GUI apps launched from Spotlight/Raycast do not inherit shell startup files.
  # Set user launchd PATH from Home Manager so apps like Kitty can resolve
  # commands from the Nix user profile without changing the account login shell.
  home.activation.setLaunchdGuiEnvironment =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      /bin/launchctl setenv PATH "${guiPathString}"
    '';

  # Store SSH key passphrases in the macOS Keychain and load the corresponding
  # identities into the launchd-managed agent. Once loaded, keys are available
  # even to SSH invocations that replace the normal config with `ssh -F`.
  programs.ssh.settings."*" = {
    AddKeysToAgent = "yes";
    UseKeychain = "yes";
  };

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

  launchd.agents.load-ssh-keychain = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/ssh-add"
        "--apple-load-keychain"
      ];
      RunAtLoad = true;
      ProcessType = "Background";
      StandardOutPath = "/tmp/home-manager-load-ssh-keychain.log";
      StandardErrorPath = "/tmp/home-manager-load-ssh-keychain.err.log";
    };
  };
}
