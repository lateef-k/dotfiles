{ inputs, lib, config, pkgs, system, ... }:
let
  # Avoid referencing `pkgs` in conditions to prevent recursion during evaluation.
  isDarwin = lib.strings.hasSuffix "-darwin" system;
  isLinux = lib.strings.hasSuffix "-linux" system;
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINS0KKNvykU3vD9MAmNAR6TRTOUwxiB5CIUjuDBrnOBK lutfi@lutfis-MBP"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIsweTazEmuWG1IEEuzepI5vprijq5RwIWmx/hEiI+M ludvi@tnovo"
  ];

in lib.mkMerge [
  # ---------------------------------------- Shared  ------------------------------------
  {

    environment.systemPackages = with pkgs; [ ssh-to-age sops ];

    nixpkgs.config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };

    services.tailscale.enable = true;
    programs.fish.enable = true;
  }

  # ---------------------------------------- Linux --------------------------------------

  (lib.optionalAttrs isLinux
    (let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      nix = {
        settings = {
          auto-optimise-store = true;
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
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        channel.enable = false;
        registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
        nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      };

      networking = {
        networkmanager.enable = true;
        nameservers = [ "1.1.1.1" "1.0.0.1" ];
      };

      users.users.ludvi = {
        hashedPasswordFile = config.sops.secrets.default-user-password.path;
        isNormalUser = true;
        openssh.authorizedKeys.keys = authorizedKeys;
        extraGroups = [ "wheel" "audio" "libvirt" ];
        shell = pkgs.fish;
      };

      time.timeZone = "Asia/Kuwait";
      i18n.defaultLocale = "en_US.UTF-8";
      programs.git.enable = true;
      programs.ssh.startAgent = true;
      programs.nix-ld.enable = true;
    }))

  # ---------------------------------------- Macos --------------------------------------

  (lib.optionalAttrs isDarwin {

    nix.enable = false;

    networking = {
      dns = [ "1.1.1.1" "1.0.0.1" ];
      knownNetworkServices =
        [ "Thunderbolt Bridge" "Ethernet" "USB 10/100/1000 LAN" "Wi-Fi" ];
    };

    environment.systemPackages = with pkgs; [ just rsync ];

    users.users.ludvi = {
      home = "/Users/ludvi";
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = authorizedKeys;
    };

    services.openssh.enable = true;
    nixpkgs.hostPlatform = "aarch64-darwin";
    documentation.info.enable = true;
  })
]
