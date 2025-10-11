{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../../modules/base.nix ../../modules/secret.nix ];
  networking.hostName = "deux-mac";

  system.stateVersion = 5;
}
