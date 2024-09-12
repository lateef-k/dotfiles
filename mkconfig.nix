{ nixpkgs, inputs }: {
  mkSystem = { name }:
    nixpkgs.lib.nixosSystem {
      system = builtins.currentSystem;
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/machines/${name}/configuration.nix
        inputs.disko.nixosModules.disko
      ];
    };

  mkHome = home-modules:
    # Standalone home-manager configuration entrypoint
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs =
        nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      # These get passed to home.nix
      extraSpecialArgs = {
        inherit inputs;
        rootPath = ./.;
        pkgs-unstable =
          import inputs.nixpkgs-unstable { system = builtins.currentSystem; };
      };
      modules = [ ./home-manager/home.nix ] ++ home-modules;
    };

}
