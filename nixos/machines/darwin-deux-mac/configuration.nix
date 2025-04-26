{ inputs, lib, config, pkgs, ... }: {

  imports = [
    ../../common-darwin.nix
    ../../modules/cache-proxy.nix
    inputs.nix-orbstack.darwinModules.nix-orbstack
  ];

  services.nix-orbstack.enable = true;

  system.stateVersion = 5;
}
