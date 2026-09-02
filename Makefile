LINUX_HOST  ?= linux
LINUX_FLAKE := .\#$(LINUX_HOST)
MAC_HOST    ?= macbook-pro
MAC_FLAKE   := .\#$(MAC_HOST)

.PHONY: init init-linux init-mac apply apply-linux apply-mac update build build-linux build-mac check generations rollback doctor

init:
	@case "$$(uname -s)" in \
		Darwin) $(MAKE) init-mac ;; \
		Linux) $(MAKE) init-linux ;; \
		*) echo "Unsupported platform: $$(uname -s)"; exit 1 ;; \
	esac

# Bootstrap standalone Home Manager on Linux.
init-linux:
	nix run .#home-manager -- switch --flake $(LINUX_FLAKE)

apply:
	@case "$$(uname -s)" in \
		Darwin) $(MAKE) apply-mac ;; \
		Linux) $(MAKE) apply-linux ;; \
		*) echo "Unsupported platform: $$(uname -s)"; exit 1 ;; \
	esac

apply-linux:
	nix run .#home-manager -- switch --flake $(LINUX_FLAKE)

# Bootstrap nix-darwin and its integrated Home Manager configuration.
init-mac:
	sudo nix run .#darwin-rebuild -- switch --flake $(MAC_FLAKE)

apply-mac:
	sudo nix run .#darwin-rebuild -- switch --flake $(MAC_FLAKE)

update:
	nix flake update
	$(MAKE) apply
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		brewfile="$$(nix eval --raw .#darwinConfigurations.$(MAC_HOST).config.environment.variables.HOMEBREW_BUNDLE_FILE)"; \
		HOMEBREW_NO_AUTO_UPDATE=1 brew update; \
		HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file="$$brewfile"; \
	fi

build:
	@case "$$(uname -s)" in \
		Darwin) $(MAKE) build-mac ;; \
		Linux) $(MAKE) build-linux ;; \
		*) echo "Unsupported platform: $$(uname -s)"; exit 1 ;; \
	esac

build-linux:
	nix build .#homeConfigurations.$(LINUX_HOST).activationPackage

build-mac:
	nix build .#darwinConfigurations.$(MAC_HOST).system

check:
	nix flake check --all-systems

generations:
	@case "$$(uname -s)" in \
		Darwin) nix run .#darwin-rebuild -- --list-generations ;; \
		Linux) nix run .#home-manager -- generations ;; \
		*) echo "Unsupported platform: $$(uname -s)"; exit 1 ;; \
	esac

# usage: make rollback GEN=3
rollback:
	@case "$$(uname -s)" in \
		Darwin) sudo nix run .#darwin-rebuild -- --rollback ;; \
		Linux) test -n "$(GEN)" || { echo "Usage: make rollback GEN=<generation>"; exit 1; }; \
			nix run .#home-manager -- switch --generation $(GEN) ;; \
		*) echo "Unsupported platform: $$(uname -s)"; exit 1 ;; \
	esac

# Quick environment diagnostics
doctor:
	@echo "=== Checking Nix installation ==="
	@nix --version || (echo "Nix not installed"; exit 1)

	@echo "=== Checking flake support ==="
	@nix flake --help >/dev/null 2>&1 && echo "Flakes enabled" || echo "Flakes NOT enabled"

	@echo "=== Checking repo flake ==="
	@nix flake show || echo "Flake evaluation failed"

	@echo "=== Checking Home Manager ==="
	@nix run .#home-manager -- --version || echo "Home Manager command failed (run make init)"

	@echo "=== Checking active generations and GUI applications ==="
	@case "$$(uname -s)" in \
		Darwin) \
			nix run .#darwin-rebuild -- --list-generations; \
			echo "--- Homebrew formulae ---"; \
			command -v brew >/dev/null && brew list --formula || echo "Homebrew not available"; \
			echo "--- Homebrew casks ---"; \
			command -v brew >/dev/null && brew list --cask || echo "Homebrew not available" ;; \
		Linux) \
			nix run .#home-manager -- generations; \
			echo "--- Flatpak applications ---"; \
			command -v flatpak >/dev/null && flatpak list --app --columns=application,name,version || echo "Flatpak not available" ;; \
		*) echo "Unsupported platform: $$(uname -s)" ;; \
	esac

	@echo "=== Checking garbage collection status ==="
	@nix store gc --dry-run || true

	@echo "Doctor check complete."
