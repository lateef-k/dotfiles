{ inputs, lib, config, pkgs, ... }: {

  # Notes: 
  # just vm vm-test
  # Run `sway` when you start

  imports = [ ../../common.nix ];

  users.users = {
    ludvi = {
      initialPassword = "correcthorse";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINS0KKNvykU3vD9MAmNAR6TRTOUwxiB5CIUjuDBrnOBK lutfi@lutfis-MBP"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIsweTazEmuWG1IEEuzepI5vprijq5RwIWmx/hEiI+M ludvi@tnovo"
      ];
      extraGroups = [ "wheel" ];
    };
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
  # fileSystems."/" = {
  #   device = "/dev/vda";
  #   autoResize = true;
  #   fsType = "ext4";
  # };

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
