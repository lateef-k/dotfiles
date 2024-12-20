{ inputs, lib, config, pkgs, pkgs-unstable, rootPath, ... }:

let util = (import ../../lib/util.nix config.lib);

in {

  home.packages = (with pkgs; [
    fzf
    wget
    binutils
    just
    libarchive
    pipx
    ncdu
    gh
    tldr
    nix-doc
    gocryptfs
    nerdfonts
  ]) ++ (with pkgs.python311Packages; [ llm ])
    ++ (with pkgs-unstable; [ uv lazygit ]);

  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-hard";
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = { modi = "window,drun,ssh,combi"; };
  };

  programs.git = {
    enable = true;
    includes = [{ path = "${rootPath}/config/gitconfig"; }];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = { global = { load_dotenv = true; }; };
  };

}
