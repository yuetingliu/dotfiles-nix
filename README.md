# dotfiles-nix

Personal development environment for:

- x86-64 Linux using standalone Home Manager
- Apple Silicon macOS using nix-darwin and Home Manager

Linux and macOS use the platform-specific Nixpkgs branches from the same stable
release. The flake lock file pins Nixpkgs, Home Manager, nix-darwin,
nix-homebrew, and nix-flatpak. Bootstrap commands use those locked tools rather
than unrelated global versions.

## Repository location

Application configurations use editable out-of-store links and expect this
repository at:

```text
~/src/dotfiles-nix
```

The path may contain a symlink. For example, keeping the real data under
`~/data` works with:

```sh
mkdir -p ~/data/src
ln -s ~/data/src ~/src
git clone <repository-url> ~/src/dotfiles-nix
```

Create the parent-path symlink before the first activation. If the repository
must live at another logical path, override `dotfiles.repoPath` instead. If
`~/src` already exists, inspect it first rather than running `ln` again.

## First installation

1. Install Git and clone the repository at the path above.
2. Install [Determinate Nix](https://docs.determinate.systems/).
3. Enter the repository and bootstrap the configuration.

Linux needs no separately installed Home Manager or Make:

```sh
cd ~/src/dotfiles-nix
nix develop -c make init
```

On macOS, install the Xcode Command Line Tools first so `git` and `make` are
available, then run:

```sh
cd ~/src/dotfiles-nix
make init
```

Activation can download a large initial environment. Doom Emacs is cloned on
first activation and therefore requires network access.

Linux GUI applications are installed as user Flatpaks. The desktop environment
must provide working XDG desktop portals; most standard Fedora installations do
so already.

Ghostty and Kitty configuration is managed on both platforms, but their Linux
applications are intentionally not installed by this flake. Install a terminal
separately on Linux before expecting those configurations to be usable. On
macOS, nix-darwin installs both applications through Homebrew.

## Routine commands

```sh
make check       # evaluate all configured systems
make build       # build the current system without activating it
make apply       # activate the current configuration
make doctor      # report local Nix and configuration diagnostics
make generations # list Linux Home Manager or macOS nix-darwin generations
make rollback GEN=3 # Linux: activate generation 3
make rollback       # macOS: roll back the nix-darwin system
```

Run `make update` only when deliberately updating locked inputs. It checks and
builds the updated configuration before activation; a failure leaves the new
lock file for inspection but does not activate it. Review `flake.lock`
afterward. On macOS this command also refreshes Homebrew metadata and upgrades
packages declared in the newly evaluated nix-darwin Brewfile.
Homebrew package versions are intentionally not pinned in `flake.lock`; regular
`make apply` does not update or upgrade them.

## Why Linux commands use `nix run`

`nix run .#home-manager` executes the Home Manager package exported by this
flake. Its source revision is recorded in `flake.lock`. Nix downloads it into
the Nix store when absent and reuses the stored result afterward.

Home Manager is also installed into the activated user profile, but using the
flake app keeps the command version matched with the configuration modules. This
matters directly after `nix flake update`, when the currently installed command
still belongs to the previous generation. It also avoids depending on whether a
new shell has picked up the profile `PATH` yet.

The macOS bootstrap and apply commands use `nix run .#darwin-rebuild` for the
same reason: the command and nix-darwin modules always come from the same locked
input.

## Local configuration

- Put shared, version-controlled SSH hosts in `dotfiles/config/ssh/hosts`.
- Put machine-local SSH hosts or secrets in `~/.ssh/hosts.local`.
- Put Fish overrides in `dotfiles/config/fish/local.fish`.
- Put Kitty and Ghostty overrides in their respective `local.conf` files.
- Do not edit Home Manager-generated configuration files under `~/.config`.
