# Variables for configuration
NIXOS_OUTPUT ?= NOT_SET
HOME_PROFILE ?= NOT_SET
DISK ?= NOT_SET
HOME_MANAGER_RELEASE ?= release-24.05

home-init:
	nix run github:nix-community/home-manager/$(HOME_MANAGER_RELEASE) -- init --switch

home:
	# Example usage: make home HOME_PROFILE=ludvi-headless
	home-manager switch --flake .#$(HOME_PROFILE) --impure
home-debug:
	# Example usage: make home HOME_PROFILE=ludvi-headless
	home-manager switch --show-trace --flake .#$(HOME_PROFILE) --impure

nix:
	# Example usage: make nix NIXOS_OUTPUT=ludnix
	sudo nixos-rebuild switch --flake .#$(NIXOS_OUTPUT) --impure

init-disk:
	# Example usage: make init-disk DISK=/dev/sda
	sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --write-efi-boot-entries --flake '.#$(NIXOS_OUTPUT)' --disk main $(DISK)

.PHONY: home nix init-disk
