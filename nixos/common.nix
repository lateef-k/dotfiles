{ inputs, lib, config, pkgs, ... }@args: {
  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;

  in {
    settings = {
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
      # given the users in this list the right to specify additional substituters via:
      #    1. `nixConfig.substituters` in `flake.nix`
      trusted-users = [ "ludvi" ];
      substituters =
        [ "https://nix-community.cachix.org" "https://cache.nixos.org/" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      keep-outputs = true;
      keep-derivations = true;
      experimental-features = "nix-command flakes";
    };
    # Opinionated: disable channels
    channel.enable = false;
    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  environment.systemPackages = with pkgs; [
    # #Other packages
    # vscode # Add Visual Studio Code
    elfutils
    ranger
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

  system.stateVersion = "24.05";
  time.timeZone = "Asia/Kuwait";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users = {
    ludvi = {
      initialPassword = "correcthorse";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINS0KKNvykU3vD9MAmNAR6TRTOUwxiB5CIUjuDBrnOBK lutfi@lutfis-MBP"
      ];
      extraGroups = [ "wheel" "docker" "audio" ];
      shell = pkgs.fish;
    };
  };
  programs.fish.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    networkmanager.enable = true;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
  #
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     PermitRootLogin = "no";
  #     PasswordAuthentication = false;
  #   };
  # };
  #
  programs.ssh.startAgent = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    # openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };

  };
}
