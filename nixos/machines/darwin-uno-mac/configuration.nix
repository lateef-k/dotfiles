{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../../common-darwin.nix ];

  networking.hostName = "uno-mac";

  system.stateVersion = 5;
}
