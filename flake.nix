{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixvim = { url = "github:nix-community/nixvim/nixos-24.05"; };

    # disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs:
    let inherit (self) outputs;
    in {
      nixosConfigurations = {
        ludnix = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          modules = [
            ./nixos/machines/x86_64-linux-t480s/configuration.nix
            ./nixos/machines/disko_config.nix
            disko.nixosModules.disko
          ];
        };

        vm_test = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/machines/x86_64-vm/configuration.nix ];
        };
      };

      # Standalone home-manager configuration entrypoint
      homeConfigurations = {
        "ludvi@ludnix" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance

          # These get passed to home.nix
          extraSpecialArgs = {
            inherit inputs outputs;
            rootPath = ./.;
          };
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
