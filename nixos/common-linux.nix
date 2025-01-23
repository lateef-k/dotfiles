{ inputs, lib, config, pkgs, ... }@args: {

  imports = [ ../../common.nix ];
  networking = {
    networkmanager.enable = true;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    extraHosts = ''
      107.172.145.108 racknerd_vps	
      192.168.68.69 thinkcenter
      192.168.8.69 thinkcenter-wifi
    '';
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    # openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  # fileSystems."/mnt/synology" = {
  #   device = "fatboy.local:/volume1/main";
  #   fsType = "nfs";
  #   options = [ "defaults" "nfsvers=4" "x-systemd.automount" "noauto" ];
  # };
  #
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
