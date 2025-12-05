{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../../modules/base.nix ../../modules/secret.nix ];

  environment.systemPackages = with pkgs; [
    fd
    ripgrep
    node
    (pkgs.writeShellScriptBin "opencode" ''
      npx opencode-ai@1.0.133 "$@"
    '')
  ];

  networking.hostName = "uno-mac";

  sops.age.sshKeyPaths = [ "/Users/ludvi/.ssh/id_ed25519" ];

  system.stateVersion = 5;
}
