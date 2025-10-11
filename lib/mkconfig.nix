{ inputs }: {

  mkSystem = { name, system, extra-modules ? [ ] }:
    if (system == "aarch64-darwin") then
      inputs.nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs system; };
        modules = [ "${inputs.self}/nixos/machines/${name}/configuration.nix" ];
      }
    else
      inputs.nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs system; };
        modules = [
          inputs.disko.nixosModules.disko
          inputs.nix-index-database.nixosModules.nix-index
          "${inputs.self}/nixos/machines/${name}/configuration.nix"
        ];
      };

  mkHome = home-config:
    # Standalone home-manager configuration entrypoint
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs =
        inputs.nixpkgs.legacyPackages.${builtins.currentSystem}; # Home-manager requires 'pkgs' instance
      # These get passed to home.nix
      extraSpecialArgs = { inherit inputs; };
      modules = [ "${inputs.self}/home" home-config ];
    };

  # Use home-manager as a module when testing with VMs
  # Use home-manager as a module when testing with VMs
  mkVirtualMachine = { name, system, home-modules }:
    inputs.nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = { inherit inputs; };
      modules = [
        "${inputs.self}/nixos/machines/${name}/configuration.nix"
        inputs.home-manager.nixosModules.home-manager
        "${inputs.self}/home"
      ];
    };
}
