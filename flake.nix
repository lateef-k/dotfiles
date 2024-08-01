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

   disko.url = "github:nix-community/disko";
   disko.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  nixConfig = {
    substituters = [ 
      "https://cache.nixos.org"
      "https://nix-community.cachix.org" 
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };


  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs:
    let inherit (self) outputs;
    in {
      nixosConfigurations = {
        system = "aarch64-linux";
        ludnix = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ 
            ./nixos/configuration.nix 
            disko.nixosModules.disko
          {
            # given the users in this list the right to specify additional substituters via:
            #    1. `nixConfig.substituters` in `flake.nix`
            nix.settings.trusted-users = [ "ludvi" ];
          }
                  {
        disko.devices = {
          disk = {
            main = {
              # When using disko-install, we will overwrite this value from the commandline
              device = "/dev/disk/by-id/some-disk-id";
              type = "disk";
              content = {
                type = "gpt";
                partitions = {
                  MBR = {
                    type = "EF02"; # for grub MBR
                    size = "1M";
                    priority = 1; # Needs to be first partition
                  };
                  ESP = {
                    type = "EF00";
                    size = "500M";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                    };
                  };
                  root = {
                    size = "100%";
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/";
                    };
                  };
                };
              };
            };
          };
        };
      }

          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      homeConfigurations = {
        "ludvi@ludnix" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
