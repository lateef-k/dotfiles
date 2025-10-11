{
  description = "Ludvi's Nix Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  };

  nixConfig = { download-buffer-size = 100000000; }; # 100mb

  outputs = { self, home-manager, ... }@inputs:
    let
      mkConfig = (import ./lib/mkconfig.nix { inherit inputs; });
      mkSystem = mkConfig.mkSystem;
      mkHome = mkConfig.mkHome;
    in {
      # t480 thinkpad
      nixosConfigurations.ludnix = mkSystem {
        name = "linux-t480s";
        system = "x86_64-linux";
      };

      # linux VM on aarch64 mac
      nixosConfigurations.nix-utm = mkSystem {
        name = "linux-utm";
        system = "aarch64-linux";
      };

      # Generic VM base
      nixosConfigurations.vm-test = mkSystem {
        name = "x86_64-vm-test";
        system = "x86_64-linux";
        # home-modules =
        #   [ ./home-manager/modules/base.nix ./home-manager/modules/sway.nix ];
      };

      darwinConfigurations."uno-mac" = mkSystem {
        name = "darwin-uno-mac";
        system = "aarch64-darwin";
      };

      darwinConfigurations."deux-mac" = mkSystem {
        name = "darwin-deux-mac";
        system = "aarch64-darwin";
      };
      #
      # # Home config with gui
      homeConfigurations."full" = mkHome {
        bundle.extra.neovim.enable = true;
        bundle.extra.dev.enable = true;
        bundle.extra.obsidian.enable = true;
        bundle.extra.gui.enable = true;
        bundle.shell.enable = true;
      };
      #
      homeConfigurations."headless" = mkHome {
        bundle.extra.neovim.enable = true;
        bundle.extra.dev.enable = true;
        bundle.shell.enable = true;
      };
      #
      homeConfigurations."headless-notes" = mkHome {
        bundle.extra.neovim.enable = true;
        bundle.extra.dev.enable = true;
        bundle.extra.obsidian.enable = true;
        bundle.shell.enable = true;
      };
      #
      homeConfigurations."minimal" = mkHome [ ];

    };
}
