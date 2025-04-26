# flake.nix
{
  description =
    "A Nix flake providing a nix-darwin module to manage OrbStack NixOS VMs on aarch64-darwin";

  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs/nixos-unstable"; # Or your preferred channel
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin }:
    let
      # Explicitly target aarch64-darwin, removing the need for flake-utils
      system = "aarch64-darwin";

      # Use pkgs specific to the target system (aarch64-darwin)
      pkgs = import nixpkgs {
        inherit system;
        # Keep allowUnfree for orbstack CLI just in case, user can override downstream
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;

    in {
      # --- Nix-Darwin Module ---
      # This is the primary output of this flake: the reusable module.
      darwinModules.nix-orbstack = import ./module.nix {
        # Pass necessary arguments (lib, pkgs for aarch64-darwin, self) to the module file
        # inherit lib pkgs self;
      };

      # Default module output for convenience. Consumers can import `flake-input.darwinModules.default`.
      darwinModules.default = self.outputs.darwinModules.nix-orbstack;

      # --- Development Shell (Optional but recommended) ---
      # Provides a shell for working *on this flake* itself on aarch64-darwin
      devShells.${system}.default = pkgs.mkShell { };

    }; # End main outputs map
}
