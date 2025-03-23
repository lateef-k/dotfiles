{ inputs, lib, config, pkgs, ... }:

let util = (import ../../lib/util.nix config.lib);

in {

  home.packages = (with pkgs; [
    iw
    wget
    binutils
    pipx
    ncdu
    gh
    tldr
    nix-doc
    gocryptfs
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    uv
    lazygit
    xclip
    jq
  ]) ++ (with pkgs.python311Packages; [ llm ]);

  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-hard";
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = { modi = "window,drun,ssh,combi"; };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = { global = { load_dotenv = true; }; };
  };

}
