{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../common.nix ./hardware-configuration.nix ];
  networking.hostName = "tnovo";
  services.logrotate.checkConfig = false;
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = true;
      xfce.enable = true;
    };
  };
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      clickMethod = "clickfinger";
      naturalScrolling = true;
    };
  };
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;
  virtualisation.containers.enable = true;
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp -s 192.168.8.0/24 -j nixos-fw-accept
  '';

  system.stateVersion = "24.05";

}
