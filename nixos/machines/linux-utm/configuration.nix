# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, lib, config, pkgs, rootPath, ... }: {

  imports = [ ./hardware-configuration.nix ../../common-linux.nix ];

  networking = {
    defaultGateway = "192.168.64.1";
    networkmanager.enable = true;
    hostName = "nix-utm";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    interfaces.enp0s1.ipv4.addresses = [{
      address = "192.168.64.42";
      prefixLength = 24;
    }];
    extraHosts = ''
            107.172.145.108 racknerd_vps	
            192.168.68.69 thinkcenter
            192.168.8.69 thinkcenter-wifi
      			192.168.68.59 uno-mac 
    '';
  };

  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
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

  services.nginx = {
    enable = true;
    config = builtins.readFile
      "${rootPath}/config/nginx-cache/nginx-client-linux.conf";
  };

  disko.devices = {
    disk = {
      main = {
        # When using disko-install, we will overwrite this value from the commandline
        device = "/dev/disk/by-id/some-disk-id";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            MBR = {
              type = "EF02"; # for grub MBR
              size = "1M";
              priority = 1; # Needs to be first partition
            };
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
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

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
