

home:
	home-manager switch --flake .#ludvi@ludnix --impure

nix:
	sudo nixos-rebuild switch --flake .#ludnix --impure

init-disk:
	sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --flake '.#ludnix' --disk main /dev/vda

.PHONY: home, nix
