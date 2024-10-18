{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../../modules/vm.nix ];

  environment.systemPackages = with pkgs; [ gnumake ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "24.05";
}

