{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../../common.nix ];

  environment.systemPackages = with pkgs; [ gnumake ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/some-disk-id";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  system.stateVersion = "24.05";
}

