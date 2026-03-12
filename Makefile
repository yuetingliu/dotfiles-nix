PROFILE ?= yueting
FLAKE   := .#$(PROFILE)

.PHONY: init apply update build check generations rollback doctor

# Bootstrap on a fresh machine:
# uses nix run so home-manager does not need to be preinstalled
init:
	nix run github:nix-community/home-manager -- switch --flake $(FLAKE)

# Normal day-to-day apply after home-manager is present
apply:
	home-manager switch --flake $(FLAKE)

update:
	nix flake update
	home-manager switch --flake $(FLAKE)

build:
	nix build .#homeConfigurations.$(PROFILE).activationPackage

check:
	nix flake check

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
