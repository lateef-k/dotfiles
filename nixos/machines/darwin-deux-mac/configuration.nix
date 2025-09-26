{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../../common-darwin.nix ];

  networking.hostName = "deux-mac";

  system.stateVersion = 5;
}
