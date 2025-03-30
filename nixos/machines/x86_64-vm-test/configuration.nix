{ inputs, lib, config, pkgs, ... }@args: {

  # Notes: 
  # just vm vm-test
  # Run `sway` when you start

  imports = [ ../../common-linux.nix ];

  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
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

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation.fileSystems."/persist".neededForBoot = true;
    virtualisation = {
      forwardPorts = [{
        from = "host";
        host.port = 8888;
        guest.port = 22;
      }];
      memorySize = 8192; # Use 2048MiB memory.
      diskSize = 1024 * 50;
      cores = 4;
      graphics = true;
      sharedDirectories = {
        config = {
          source = "/home/ludvi/Admin";
          target = "/home/ludvi/Admin";
        };
      };
    };
  };

  # XDG Portal for screen sharing and better desktop integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  virtualisation.vmVariantWithBootLoader = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      forwardPorts = [{
        from = "host";
        host.port = 8888;
        guest.port = 22;
      }];
      memorySize = 8192; # Use 2048MiB memory.
      diskSize = 1024 * 50;
      cores = 4;
      graphics = true;
    };
  };
  #
  fileSystems."/" = {
    device = "/dev/vda";
    autoResize = true;
    fsType = "ext4";
  };

  boot = {
    growPartition = true;
    kernelParams = [ "console=ttyS0" ];
    loader = {
      timeout = 0;
      grub.device = "/dev/vda";
    };
  };
  system.stateVersion = "24.05";
}
