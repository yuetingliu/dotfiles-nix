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
    mosh
    rsync
    dig
    nmap
    iperf

    ############################################################
    # Sync & background tools
    ############################################################
    syncthing

    ############################################################
    # Developer runtimes / package managers
    ############################################################
    bun
    uv       # Python package and project manager
    mise     # Runtime and task manager

    ############################################################
    # Terminal multiplexing
    ############################################################
    tmux
    byobu
  ];

  # Byobu supports screen and tmux backends. Keep its stateful user config
  # explicit so a new machine consistently opens tmux sessions.
  home.file.".byobu/backend".text = "BYOBU_BACKEND=tmux\n";

  # Syncthing as user service (runs when you're logged in)
  services.syncthing.enable = true;

  # Later we can add:
  # programs.ssh.enable = true;
  # and matchBlocks / includes for host config.
}
