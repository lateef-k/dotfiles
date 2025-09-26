{ config, pkgs, ... }:

{

  # imports = [ ./modules/base.nix ];

  home.username = "ludvi";
  home.homeDirectory = "/Users/ludvi";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
