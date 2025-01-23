{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../../common.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = true;
    };
  };
  networking = {
    hostName = "mac-uno";
    interfaces.en0.ipv4.addresses = [{
      address = "192.168.68.59";
      prefixLength = 24;
    }];
  };
}
