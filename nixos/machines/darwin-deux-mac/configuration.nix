{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../../common-darwin.nix ../../modules/cache-proxy.nix ];

  networking = {
    dns = [ "1.1.1.1" "1.0.0.1" ];
    search = [ "home" ];
    knownNetworkServices =
      [ "Thunderbolt Bridge" "Ethernet" "USB 10/100/1000 LAN" "Wi-Fi" ];

  };

  system.stateVersion = 5;
}
