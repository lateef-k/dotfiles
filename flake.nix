{
  description = "Ludvi's Nix Config";

  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { ... }@inputs:
    let
      mkSystem = (import ./lib/mkconfig.nix { inherit inputs; }).mkSystem;
      mkHome = (import ./lib/mkconfig.nix { inherit inputs; }).mkHome;
    in {
      # t480 thinkpad
      nixosConfigurations.ludnix = mkSystem {
        name = "x86_64-linux-t480s";
        system = "x86_64-linux";
      };

      # Generic VM base
      nixosConfigurations.vm-test = mkSystem {
        name = "x86_64-vm";
        system = "x86_64-linux";
      };

      # Thinkcentre Server
      nixosConfigurations.thinkcentre = mkSystem {
        name = "x86_64-thinkcentre";
        system = "x86_64-linux";
      };

      # linux VM on aarch64 mac
      nixosConfigurations.aarch64-ludnix-utm = mkSystem {
        name = "aarch64-linux-utm";
        system = "aarch64-linux";
      };

      # Home config with gui
      homeConfigurations."ludvi-full" = mkHome [
        ./home-manager/modules/shell.nix
        ./home-manager/modules/editor.nix
        ./home-manager/modules/applications.nix
      ];

      # shell only environment
      homeConfigurations."ludvi-headless" = mkHome [
        ./home-manager/modules/shell.nix
        ./home-manager/modules/editor.nix
      ];
    };
}
