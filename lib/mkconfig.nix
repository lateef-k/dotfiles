{ inputs }:
let
  nixpkgs-config = {
    # Disable if you don't want unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };
  # Instantiate nixpkgs
  pkgs = import inputs.nixpkgs {
    system = builtins.currentSystem;
    config = nixpkgs-config;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = builtins.currentSystem;
    config = nixpkgs-config;
  };
in {

  mkSystem = { name, system }:
    inputs.nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = { inherit inputs; };
      modules = [
        inputs.disko.nixosModules.disko
        inputs.nix-index-database.nixosModules.nix-index
        ../nixos/machines/${name}/configuration.nix
      ];
    };

  mkHome = home-modules:
    # Standalone home-manager configuration entrypoint
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs; # Home-manager requires 'pkgs' instance
      # These get passed to home.nix
      extraSpecialArgs = {
        inherit inputs;
        inherit pkgs-unstable;
        rootPath = ../.;
      };
      modules = [ ../home-manager/home.nix ] ++ home-modules;
    };

  # Use home-manager as a module when testing with VMs
  # Use home-manager as a module when testing with VMs
  mkVirtualMachine = { name, system, home-modules }:
    let rootPath = toString ../.;
    in inputs.nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = { inherit inputs; };
      modules = [
        ../nixos/machines/${name}/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = { inherit rootPath; };
            users.ludvi = { pkgs, ... }: {
              imports = home-modules;
              home.stateVersion = "24.05";
            };
          };
        }
      ];
    };
}
