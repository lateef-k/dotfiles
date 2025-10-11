{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../../modules/base.nix ../../modules/secret.nix ];

  networking.hostName = "uno-mac";

  sops.age.sshKeyPaths = [ "/Users/ludvi/.ssh/id_ed25519" ];

  system.stateVersion = 5;
}
