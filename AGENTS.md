# Repository Guidelines

## Project Structure & Module Organization

This repository defines a Linux development environment with Nix flakes and Home Manager. `flake.nix` pins the `x86_64-linux` system and exposes the `yueting` Home Manager configuration. `home.nix` is the entry point and imports focused modules from `modules/`:

- `shell.nix`, `editor.nix`, and `emacs.nix` configure interactive tools.
- `tools.nix` and `ui.nix` install shared packages and fonts.
- `dotfiles.nix` links editable application configuration into `$XDG_CONFIG_HOME`.

Application-owned files live under `dotfiles/config/`, currently for Neovim, Doom Emacs, and Kitty. Keep package declarations in Nix modules and detailed application settings in their corresponding config directory.

## Build, Test, and Development Commands

- `make check` runs `nix flake check` and should be the first validation step.
- `make build` builds the Home Manager activation package without applying it.
- `make apply` activates the current configuration for `PROFILE=yueting`.
- `make init` bootstraps Home Manager on a fresh machine.
- `make doctor` reports common Nix, flake, Home Manager, and profile problems.
- `make update` updates `flake.lock` and applies the result; review lock-file changes before committing.

Override the profile when needed, for example `make build PROFILE=yueting`.

## Coding Style & Naming Conventions

Use two-space indentation in Nix and Lua files, matching the surrounding code. Name Nix modules by responsibility with lowercase filenames. Keep attribute sets readable, group package lists by purpose, and add comments only where intent is not evident. Format Lua with StyLua using `dotfiles/config/nvim/stylua.toml`. Preserve the existing idioms in Emacs Lisp: feature-specific sections, `setq` for configuration, and `my/` prefixes for personal functions.

## Testing Guidelines

There is no separate unit-test framework. For every Nix change, run `make check` and `make build`. For application configuration, also start the affected application after applying changes and verify key startup paths manually. Do not use `make apply` as the only test because it mutates the active user environment.

## Commit & Pull Request Guidelines

Recent commits use short, imperative subjects such as `add uv into tools.nix` and `Fix pdf-tools issue`. Keep each commit focused and name the affected feature when useful. Pull requests should explain the behavioral change, list validation commands, and call out changes to `flake.lock`. Include screenshots only for visible UI changes. Never commit API keys or credentials; follow the existing `auth-source` pattern for secrets.
