

{ inputs, lib, config, pkgs, ... }: {
  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {

    settings = {
      flake-registry = "";
      nix-path = config.nix.nixPath;
      trusted-users = [ "ludvi" ];
      substituters = [
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
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    optimise.automatic = true;
  };

  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

  networking = {
    dns = [ "1.1.1.1" "1.0.0.1" ];
    knownNetworkServices =
      [ "Thunderbolt Bridge" "Ethernet" "USB 10/100/1000 LAN" "Wi-Fi" ];
  };

  environment.systemPackages = with pkgs; [ just rsync ];

  users.users.ludvi = {
    home = "/Users/ludvi";
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINS0KKNvykU3vD9MAmNAR6TRTOUwxiB5CIUjuDBrnOBK lutfi@lutfis-MBP"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIsweTazEmuWG1IEEuzepI5vprijq5RwIWmx/hEiI+M ludvi@tnovo"
    ];
  };

  services.openssh.enable = true;
  programs.fish.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  documentation.info.enable = true;
  services.tailscale.enable = true;
}
