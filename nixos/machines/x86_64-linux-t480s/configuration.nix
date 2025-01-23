{ inputs, lib, config, pkgs, ... }: {

  imports = [
    ../../common-linux.nix
    ./hardware-configuration.nix
    ../../modules/docker.nix
  ];

  environment.systemPackages = with pkgs; [ virt-manager ];
  networking.hostName = "nix-t480s";
  services.logrotate.checkConfig = false;

  # services.tailscale.enable = true;
  # networking.wireguard.enable = false;
  # networking.wg-quick.interfaces.wg3.configFile =
  #   "/etc/wireguard/MullvadConfig/fi-hel-wg-001.conf";

  services.fwupd.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;

  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp -s 192.168.8.0/24 -j nixos-fw-accept
  '';

  networking.extraHosts = ''
    192.168.122.246 kali	
  '';

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

  system.stateVersion = "24.05";

}
