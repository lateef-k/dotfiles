# ============================================================
# Makefile for Nix / NixOS / Home Manager workflows
# ============================================================

SYSTEM := $(shell uname)
HOSTNAME := $(shell hostname -s)

FLAKE := .
SUBCOMMAND ?= switch

ifeq ($(SYSTEM),Darwin)
	CMD = sudo darwin-rebuild
else ifeq ($(SYSTEM),Linux)
	CMD = sudo nixos-rebuild
else
	CMD = $(error Unsupported OS: $(SYSTEM))
endif
# ============================================================
# [ NIX SYSTEM BUILD / REBUILD ]
# ============================================================

# Usage: make nix NIXOS_OUTPUT=myhost

nix:
	@echo "==> Running $(CMD) $(SUBCOMMAND) for flake $(FLAKE)#$(NIXOS_OUTPUT)"
	@$(CMD) $(SUBCOMMAND) --impure --flake $(FLAKE)#$(NIXOS_OUTPUT) --show-trace


# ============================================================
# [ HOME MANAGER ]
# ============================================================

# Usage: make home HOME_PROFILE=latif@laptop
home:
	@echo "==> Switching home configuration: $(HOME_PROFILE)"
	@home-manager switch --flake $(FLAKE)#$(HOME_PROFILE) --impure


# ============================================================
# [ FLAKE INPUT BUMPING ]
# ============================================================

# Usage: make bump INPUT=nixpkgs
bump:
	@echo "==> Bumping input: $(INPUT)"
	@nix flake lock --update-input $(INPUT)
	@git add flake.lock
	@LOCKED_JSON=$$(nix flake metadata --json | jq --arg input "$(INPUT)" '.locks.nodes[.locks.nodes.root.inputs[$$input]].locked'); \
	REV=$$(echo $$LOCKED_JSON | jq -r '.rev'); \
	DATE=$$(echo $$LOCKED_JSON | jq -r '.lastModified | strftime("%Y-%m-%d")'); \
	COMMIT_MSG="bump($(INPUT)): rev-$$REV on $$DATE"; \
	echo "==> Committing: $$COMMIT_MSG"; \
	git commit -m "$$COMMIT_MSG" flake.lock


# ============================================================
# [ GENERATIONS MANAGEMENT ]
# ============================================================

list-generations:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Usage: make rollback GENERATION_NUM=42
rollback:
	sudo nix-env --switch-generation $(GENERATION_NUM) --profile /nix/var/nix/profiles/system


# ============================================================
# [ VM BUILDS ]
# ============================================================

# Usage: make vm NIXOS_OUTPUT=vm-test
vm:
	sudo nixos-rebuild build-vm --flake $(FLAKE)#$(NIXOS_OUTPUT) --impure

vm-with-boot:
	sudo nix --show-trace build -L '.#nixosConfigurations.vm-test.config.system.build.vmWithBootLoader'


# ============================================================
# [ UTILS ]
# ============================================================
#
update-sops-keys:
	# make sure to update .sops.yaml file
	sops updatekeys ./secrets/user.yaml

.PHONY: nix home bump list-generations rollback vm vm-with-boot

