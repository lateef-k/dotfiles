# This is our system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, lib, config, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ../../common-linux.nix
    ../../modules/docker.nix
  ];

  networking = {
    defaultGateway = "192.168.64.1";
    hostName = "nix-utm";
    interfaces.enp0s1.ipv4.addresses = [{
      address = "192.168.64.42";
      prefixLength = 24;
    }];
  };

  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp -s 192.168.64.0/24 -j nixos-fw-accept
  '';
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

  programs.ssh = {
    # equivalent to `ssh -t ludvi@uno-mac ssh orb`
    extraConfig = ''
                  						Host uno-mac
                  							HostName uno-mac
                  							User ludvi
      													RequestTTY yes
            										# RemoteCommand fish
                  						Host deux-mac
                  							HostName deux-mac
                  							User ludvi
      													RequestTTY yes
            										# RemoteCommand fish
    '';
    # 
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };

  };

  services.displayManager.defaultSession = "xfce";

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  disko.devices = {
    disk = {
      main = {
        # When using disko-install, we will overwrite this value from the commandline
        device = "/dev/disk/by-id/6e3af812-4e1d-43ea-a677-699bb9f15945";
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
