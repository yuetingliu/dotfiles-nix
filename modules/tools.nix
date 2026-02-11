{ config, pkgs, ... }:

{
  home.packages = with pkgs; [

    ############################################################
    # Core CLI Utilities (essentials)
    ############################################################
    git
    curl
    wget
    unzip
    gnutar
    gnupg

    ############################################################
    # Modern CLI UX
    ############################################################
    ripgrep   # used by Doom/Neovim too
    fd        # used by Doom/Neovim too
    fzf
    bat
    eza
    jq
    yq
    tree
    htop
    btop
    ncdu

    ############################################################
    # Remote / Network / Ops Tools
    ############################################################
    openssh
    mosh
    rsync
    dig
    nmap
    iperf

    ############################################################
    # Sync & background tools
    ############################################################
    syncthing
  ];

  # Syncthing as user service (runs when you're logged in)
  services.syncthing.enable = true;

  # Later we can add:
  # programs.ssh.enable = true;
  # and matchBlocks / includes for host config.
}
