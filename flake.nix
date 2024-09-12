{
  description = "Your new nix config";

  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs:
    let
      inherit (self) outputs;
      mkSystem = (import ./mkconfig.nix { inherit nixpkgs inputs; }).mkSystem;
      mkHome = (import ./mkconfig.nix { inherit nixpkgs inputs; }).mkHome;
    in {
      nixosConfigurations.ludnix = mkSystem { name = "x86_64-linux-t480s"; };
      nixosConfigurations.vm_test = mkSystem { name = "x86_64-vm"; };

      # Standalone home-manager configuration entrypoint
      homeConfigurations."ludvi-full" = mkHome [
        ./home-manager/modules/shell.nix
        ./home-manager/modules/editor.nix
        ./home-manager/modules/applications.nix
      ];
    };
}
