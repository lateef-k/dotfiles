{ inputs, lib, config, pkgs, ... }: {

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      auto-optimise-store = true;
      flake-registry = "";
      nix-path = config.nix.nixPath;
      trusted-users = [ "ludvi" ];
      substituters = [
        # these priorities override the cache-info
        "http://localhost:8444?priority=10"
        "https://nix-community.cachix.org?priority=20"
        "https://cache.nixos.org?priority=30"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
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

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
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

  environment.systemPackages = with pkgs; [ parallel ];

  time.timeZone = "Asia/Kuwait";
  i18n.defaultLocale = "en_US.UTF-8";
  programs.fish.enable = true;
  programs.git.enable = true;
  programs.ssh.startAgent = true;
  programs.nix-ld.enable = true;

}
