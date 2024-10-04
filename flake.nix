{
  description = "Ludvi's Nix Config";

  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { ... }@inputs:
    let
      mkSystem = (import ./mkconfig.nix { inherit inputs; }).mkSystem;
      mkHome = (import ./mkconfig.nix { inherit inputs; }).mkHome;
    in {
      nixosConfigurations.ludnix = mkSystem { name = "x86_64-linux-t480s"; };
      nixosConfigurations.vm-test = mkSystem { name = "x86_64-vm"; };
      nixosConfigurations.aarch64-ludnix-utm =
        mkSystem { name = "aarch64-linux-utm"; };

      # Standalone home-manager configuration entrypoint
      homeConfigurations."ludvi-full" = mkHome [
        ./home-manager/modules/shell.nix
        ./home-manager/modules/editor.nix
        ./home-manager/modules/applications.nix
      ];

      homeConfigurations."ludvi-headless" = mkHome [
        ./home-manager/modules/shell.nix
        ./home-manager/modules/editor.nix
      ];

    };
}
