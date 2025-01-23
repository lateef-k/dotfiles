{ inputs }: {

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
      pkgs =
        inputs.nixpkgs.legacyPackages.${builtins.currentSystem}; # Home-manager requires 'pkgs' instance
      # These get passed to home.nix
      extraSpecialArgs = {
        inherit inputs;
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
