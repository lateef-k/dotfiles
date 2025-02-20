{ inputs }:

{

  mkSystem = { name, system }:
    if (system == "aarch64-darwin") then
      inputs.nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [ "${inputs.self}/nixos/machines/${name}/configuration.nix" ];
      }
    else
      inputs.nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          inputs.disko.nixosModules.disko
          inputs.nix-index-database.nixosModules.nix-index
          "${inputs.self}/nixos/machines/${name}/configuration.nix"
        ];
      };

  mkHome = home-modules:
    # Standalone home-manager configuration entrypoint
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs =
        inputs.nixpkgs.legacyPackages.${builtins.currentSystem}; # Home-manager requires 'pkgs' instance
      # These get passed to home.nix
      extraSpecialArgs = { inherit inputs; };
      modules = [
        (if (builtins.currentSystem == "aarch64-darwin") then
          "${inputs.self}/home-manager/home-darwin.nix"
        else
          "${inputs.self}/home-manager/home.nix")
      ] ++ home-modules;
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
        {
          home-manager = {
            users.ludvi = { pkgs, ... }: {
              imports = home-modules;
              home.stateVersion = "24.05";
            };
          };
        }
      ];
    };
}
