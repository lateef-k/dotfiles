{ inputs }:

let
  pkg-config = {
    nixpkgs = {
      overlays = [ ];
      config = {
        allowUnfree = true;
        # Workaround for https://github.com/nix-community/home-manager/issues/2942
        allowUnfreePredicate = _: true;
      };
    };
  };

in {

  mkSystem = { name }:
    inputs.nixpkgs.lib.nixosSystem {
      system = builtins.currentSystem;
      specialArgs = { inherit inputs; };
      modules = [
        pkg-config
        inputs.disko.nixosModules.disko
        ./nixos/machines/${name}/configuration.nix
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
        pkgs-unstable =
          inputs.nixpkgs-unstable.legacyPackages.${builtins.currentSystem};
        rootPath = ./.;
      };
      modules = [ pkg-config ./home-manager/home.nix ] ++ home-modules;
    };

}
