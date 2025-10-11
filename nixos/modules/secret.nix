

{ inputs, config, pkgs, lib, system, ... }:
let
  isDarwin = lib.strings.hasSuffix "-darwin" system;
  isLinux = lib.strings.hasSuffix "-linux" system;

in {
  imports = (if isLinux then
    [ inputs.sops-nix.nixosModules.sops ]
  else
    [ inputs.sops-nix.darwinModules.sops ]);
  sops = {
    defaultSopsFile = "${inputs.self}/secrets/user.yaml";
    secrets = {
      ssh-keys = { };
      default-user-password = { neededForUsers = true; };
    };
  };
}
