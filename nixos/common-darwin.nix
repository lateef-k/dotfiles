

{ inputs, lib, config, pkgs, ... }: {
  nix.enable = false;

  imports = [ ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

  networking = {
    dns = [ "1.1.1.1" "1.0.0.1" ];
    knownNetworkServices =
      [ "Thunderbolt Bridge" "Ethernet" "USB 10/100/1000 LAN" "Wi-Fi" ];
  };

  environment.systemPackages = with pkgs; [ just rsync ];

  users.users.ludvi = {
    home = "/Users/ludvi";
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINS0KKNvykU3vD9MAmNAR6TRTOUwxiB5CIUjuDBrnOBK lutfi@lutfis-MBP"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIsweTazEmuWG1IEEuzepI5vprijq5RwIWmx/hEiI+M ludvi@tnovo"
    ];
  };

  services.openssh.enable = true;
  programs.fish.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  documentation.info.enable = true;
  services.tailscale.enable = true;
}
