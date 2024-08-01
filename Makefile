

home:
	home-manager switch --flake .#ludvi@ludnix --impure

nix:
	sudo nixos-rebuild switch --flake .#ludnix --impure

.PHONY: home, nix
