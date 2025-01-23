# Main commands
# --------------------------------------------------------------------------------
home HOME_PROFILE:
	# Example usage: just home HOME_PROFILE=ludvi-headless
	home-manager switch --flake .#{{HOME_PROFILE}} --impure

nix NIXOS_OUTPUT:
	# Example usage: just nix NIXOS_OUTPUT=ludnix
	sudo nixos-rebuild switch --flake .#{{NIXOS_OUTPUT}} --impure


home-debug HOME_PROFILE:
	# Example usage: just home-debug HOME_PROFILE=ludvi-headless
	home-manager switch --show-trace --flake .#{{HOME_PROFILE}} --impure
# --------------------------------------------------------------------------------

# Generations
# --------------------------------------------------------------------------------
list-generations:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

rollback GENERATION_NUM:
	sudo nix-env --switch-generation {{GENERATION_NUM}} --profile /nix/var/nix/profiles/system
# --------------------------------------------------------------------------------

# Initial setup
# --------------------------------------------------------------------------------
home-init HOME_MANAGER_RELEASE='release-24.05':
	nix run github:nix-community/home-manager/{{HOME_MANAGER_RELEASE}} -- init --switch


init-disk NIXOS_OUTPUT DISK:
	# Example usage: just init-disk NIXOS_OUTPUT=ludnix DISK=/dev/sda
	sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --show-trace --write-efi-boot-entries --flake '.#{{NIXOS_OUTPUT}}' --disk main {{DISK}}
# --------------------------------------------------------------------------------


# VMs
# --------------------------------------------------------------------------------
vm NIXOS_OUTPUT:
	sudo nixos-rebuild build-vm --flake .#{{NIXOS_OUTPUT}} --impure

vm-with-boot:
	sudo nix --show-trace build -L '.#nixosConfigurations.vm-test.config.system.build.vmWithBootLoader'
# --------------------------------------------------------------------------------
