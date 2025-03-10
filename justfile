# Main commands
# --------------------------------------------------------------------------------
system := `uname`
hostname := `hostname -s` #-s remove .local from macos

nix NIXOS_OUTPUT:
	#!/usr/bin/env sh
	if [ "{{system}}" = "Darwin" ]; then
		cmd="darwin-rebuild"
	elif [ "{{system}}" = "Linux" ]; then
		cmd="sudo nixos-rebuild"
	else
		echo "Unsupported operating system: {{system}}"
		exit 1
	fi
	$cmd switch --flake .#{{NIXOS_OUTPUT}}

home HOME_PROFILE:
	# Example usage: just home HOME_PROFILE=ludvi-headless
	home-manager switch --flake .#{{HOME_PROFILE}} --impure

bump INPUT:
	#!/usr/bin/env sh
	nix flake lock --update-input {{INPUT}}
	git add flake.lock
	LOCKED_JSON=$(nix flake metadata --json | jq --arg input "{{INPUT}}" '.locks.nodes[.locks.nodes.root.inputs[$input]].locked')
	REV=$(echo "$LOCKED_JSON" | jq -r '.rev')
	DATE=$(echo "$LOCKED_JSON" | jq -r '.lastModified | strftime("%Y-%m-%d")')
	COMMIT_MSG="bump({{INPUT}}): rev-$REV on $DATE"
	git commit -m "$COMMIT_MSG" flake.lock


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
