PROFILE ?= yueting
FLAKE   := .#$(PROFILE)

.PHONY: init apply update check rollback generations

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

check:
	nix flake check

generations:
	home-manager generations

# usage: make rollback GEN=3
rollback:
	home-manager switch --generation $(GEN)
