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
	nix run github:nix-community/home-manager -- switch --flake $(LINUX_FLAKE)

apply:
	@case "$$(uname -s)" in \
		Darwin) $(MAKE) apply-mac ;; \
		Linux) $(MAKE) apply-linux ;; \
		*) echo "Unsupported platform: $$(uname -s)"; exit 1 ;; \
	esac

apply-linux:
	home-manager switch --flake $(LINUX_FLAKE)

# Bootstrap nix-darwin and its integrated Home Manager configuration.
init-mac:
	sudo nix run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake $(MAC_FLAKE)

apply-mac:
	sudo darwin-rebuild switch --flake $(MAC_FLAKE)

update:
	nix flake update
	$(MAKE) apply

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
	home-manager generations

# usage: make rollback GEN=3
rollback:
	home-manager switch --generation $(GEN)

# Quick environment diagnostics
doctor:
	@echo "=== Checking Nix installation ==="
	@nix --version || (echo "Nix not installed"; exit 1)

	@echo "=== Checking flake support ==="
	@nix flake --help >/dev/null 2>&1 && echo "Flakes enabled" || echo "Flakes NOT enabled"

	@echo "=== Checking repo flake ==="
	@nix flake show || echo "Flake evaluation failed"

	@echo "=== Checking Home Manager ==="
	@command -v home-manager >/dev/null && home-manager --version || echo "Home Manager not installed (run make init)"

	@echo "=== Checking profile packages ==="
	@nix profile list || true

	@echo "=== Checking garbage collection status ==="
	@nix store gc --dry-run || true

	@echo "Doctor check complete."
