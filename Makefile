PROFILE ?= yueting
FLAKE   := .#$(PROFILE)

.PHONY: apply update check rollback generations

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
