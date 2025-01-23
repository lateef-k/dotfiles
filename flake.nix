{
  description = "Ludvi's Nix Config";

  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    ghostty = { url = "github:ghostty-org/ghostty"; };
  };

  outputs = { ... }@inputs:
    let
      mkSystem = (import ./lib/mkconfig.nix { inherit inputs; }).mkSystem;
      mkHome = (import ./lib/mkconfig.nix { inherit inputs; }).mkHome;
      mkVirtualMachine =
        (import ./lib/mkconfig.nix { inherit inputs; }).mkVirtualMachine;
    in {
      # t480 thinkpad
      nixosConfigurations.ludnix = mkSystem {
        name = "x86_64-linux-t480s";
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

      nixosConfigurations.vps = mkSystem {
        name = "x86_64-vps";
        system = "x86_64-linux";
      };

      # Generic VM base
      nixosConfigurations.vm-test = mkVirtualMachine {
        name = "x86_64-vm-test";
        system = "x86_64-linux";
        home-modules =
          [ ./home-manager/modules/base.nix ./home-manager/modules/sway.nix ];
      };

      darwinConfigurations."mini" = inputs.nix-darwin.lib.darwinSystem {
        modules = [ ./nixos/machines/aarch64-darwin-mini/configuration.nix ];
      };

      # Home config with gui
      homeConfigurations."ludvi-full" = mkHome [
        ./home-manager/modules/shell.nix
        ./home-manager/modules/editor.nix
        ./home-manager/modules/applications.nix
        ./home-manager/modules/pentest.nix
        ./home-manager/modules/base.nix
      ];

      homeConfigurations."ludvi-headless" = mkHome [
        ./home-manager/modules/shell.nix
        ./home-manager/modules/editor.nix
        ./home-manager/modules/base.nix
      ];

      homeConfigurations."ludvi-minimal" =
        mkHome [ ./home-manager/modules/base.nix ];
    };
}
