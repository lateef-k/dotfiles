{ inputs, lib, config, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/extra.nix
    ../../modules/secret.nix
  ];

  environment.systemPackages = with pkgs; [ virt-manager ];

  sys-extra.docker.enable = true;

  services.fwupd.enable = true;
  sops.age.sshKeyPaths = [ "/home/ludvi/.ssh/sops-nix" ];

  # networking.wireguard.enable = false;
  # networking.wg-quick.interfaces.wg3.configFile =
  #   "/etc/wireguard/MullvadConfig/fi-hel-wg-001.conf";

  services.openvpn.servers = {
    htb = { config = "config /home/ludvi/Desktop/labs_aakp640.ovpn "; };
  };

  networking = { hostName = "nix-t480s"; };

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
