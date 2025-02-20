{ inputs, lib, config, pkgs, ... }@args: {

  # Notes: 
  # just vm vm-test
  # Run `sway` when you start

  imports = [
    ./hardware-configuration.nix
    ../../modules/docker.nix
    ../../common-linux.nix
  ];

  networking = {
    networkmanager.enable = true;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    extraHosts = ''
            107.172.145.108 racknerd_vps	
            192.168.68.69 thinkcenter
            192.168.8.69 thinkcenter-wifi
      			192.168.68.59 uno-mac 

    '';
  };

  virtualisation.vmVariant = {
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
      sharedDirectories = {
        config = {
          source = "/home/ludvi/Dotfiles";
          target = "/home/ludvi/Dotfiles";
        };
      };
    };
  };

  # Enable Wayland/Sway-related services
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      wofi
      waybar
    ];
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
