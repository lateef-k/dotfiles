

home:
	home-manager switch --flake .#ludvi-full --impure

nix:
	sudo nixos-rebuild switch --flake .#ludnix --impure

init-disk:
	sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --write-efi-boot-entries --flake '.#ludnix' --disk main /dev/vda

.PHONY: home, nix
