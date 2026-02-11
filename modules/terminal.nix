{ config, pkgs, ... }:

{
  ############################################################
  # Terminal emulator(s)
  ############################################################

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = "no";
      confirm_os_window_close = "0";
      # Example if you want to set Nerd Font:
      font_family = "JetBrainsMono Nerd Font";
    };
  };

# Ghostty: install so you can try it. Config left default for now.
  home.packages = with pkgs; [
    ghostty
  ];

  ############################################################
  # “Hook” shell: set fish as default shell for interactive terminals
  # (This does not change login shell; it makes HM manage fish integration)
  ############################################################
  programs.fish.enable = true;
}

