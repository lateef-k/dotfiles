# Main commands
# --------------------------------------------------------------------------------
system := `uname`
hostname := `hostname -s` #-s remove .local from macos

nix NIXOS_OUTPUT:
	#!/usr/bin/env sh
	if [ "{{system}}" = "Darwin" ]; then
		cmd="darwin-rebuild"
	elif [ "{{system}}" = "Linux" ]; then
		cmd="nixos-rebuild"
	else
		echo "Unsupported operating system: {{system}}"
		exit 1
	fi
	sudo $cmd switch --flake .#{{NIXOS_OUTPUT}}

home HOME_PROFILE:
	# Example usage: just home HOME_PROFILE=ludvi-headless
	home-manager switch --flake .#{{HOME_PROFILE}} --impure

bump:
	#!/usr/bin/env sh
	nix flake lock --update-input nixpkgs
	git add flake.lock
	COMMIT_MSG=$(nix flake info | rg '.+(github:nixos/nixpkgs[^?]+)[^(]+(.+)' -r '$1 $2')
	git commit -m "bump $COMMIT_MSG" flake.lock
	echo "bump(nixpkgs): $COMMIT_MSG"

# [ GENERATIONS ]
# ******************************
list-generations:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

rollback GENERATION_NUM:
	sudo nix-env --switch-generation {{GENERATION_NUM}} --profile /nix/var/nix/profiles/system
# ******************************

# [VMs]
# ******************************
vm NIXOS_OUTPUT:
	sudo nixos-rebuild build-vm --flake .#{{NIXOS_OUTPUT}} --impure

vm-with-boot:
	sudo nix --show-trace build -L '.#nixosConfigurations.vm-test.config.system.build.vmWithBootLoader'
# ******************************
