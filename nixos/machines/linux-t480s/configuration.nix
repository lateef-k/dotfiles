{ inputs, lib, config, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ../../modules/docker.nix
    ../../common-linux.nix
  ];

  environment.systemPackages = with pkgs; [ virt-manager ];

  # services.tailscale.enable = true;

  services.fwupd.enable = true;
  # nixpkgs.config.pulseaudio = true;
  # hardware.pulseaudio.enable = true;

  # networking.wireguard.enable = false;
  # networking.wg-quick.interfaces.wg3.configFile =
  #   "/etc/wireguard/MullvadConfig/fi-hel-wg-001.conf";

  networking = {
    hostName = "nix-t480s";
    firewall.extraCommands =
      "	iptables -A nixos-fw -p tcp -s 192.168.8.0/24 -j nixos-fw-accept\n";
    networkmanager.enable = true;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    extraHosts = ''
            107.172.145.108 racknerd_vps	
            192.168.68.69 thinkcenter
            192.168.8.69 thinkcenter-wifi
      			192.168.68.59 uno-mac 

    '';
  };

  fileSystems."/mnt/synology" = {
    device = "fatboy.local:/volume1/main";
    fsType = "nfs";
    options = [ "defaults" "nfsvers=4" "x-systemd.automount" "noauto" ];
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = { package = pkgs.qemu_kvm; };
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = true;
      xfce.enable = true;
    };
  };
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      clickMethod = "clickfinger";
      naturalScrolling = true;
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

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 1; # Needs to be first partition
            };
            ESP = {
              size = "512M";
              type = "EF00";
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

  system.stateVersion = "24.05";

}
