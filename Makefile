

home:
	home-manager switch --flake .#ludvi@ludnix --impure

nix:
	sudo nixos-rebuild switch --flake .#ludnix --impure

init-disk:
	sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./nixos/disk-config.nix

.PHONY: home, nix
