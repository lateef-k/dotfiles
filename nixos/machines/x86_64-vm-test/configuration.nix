{ inputs, lib, config, pkgs, ... }@args: {
  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;

  in {
    settings = {
      auto-optimise-store = true;
      flake-registry = "";
      nix-path = config.nix.nixPath;
      trusted-users = [ "ludvi" ];
      # substituters =
      #   [ "https://nix-community.cachix.org" "https://cache.nixos.org/" ];
      # trusted-public-keys = [
      #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # ];
      keep-outputs = true;
      keep-derivations = true;
      experimental-features = "nix-command flakes";
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Notes: 
  # just vm vm-test
  # Run `sway` when you start

  time.timeZone = "Asia/Kuwait";
  i18n.defaultLocale = "en_US.UTF-8";
  programs.fish.enable = true;
  programs.ssh.startAgent = true;
  programs.git.enable = true;

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

  users.users = {
    ludvi = {
      initialPassword = "correcthorse";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINS0KKNvykU3vD9MAmNAR6TRTOUwxiB5CIUjuDBrnOBK lutfi@lutfis-MBP"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIsweTazEmuWG1IEEuzepI5vprijq5RwIWmx/hEiI+M ludvi@tnovo"
      ];
      extraGroups = [ "wheel" "audio" "libvirt" ];
      shell = pkgs.fish;
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
