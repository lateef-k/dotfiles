{ inputs, lib, config, pkgs, pkgs-unstable, rootPath, ... }:

let util = (import ../../lib/util.nix config.lib);

in {

  home.packages = (with pkgs; [
    cachix
    ripgrep
    fd
    fzf
    xclip
    mosh
    pipx
    file
    wget
    binutils
    htop
    rlwrap
    libarchive
  ]) ++ (with pkgs-unstable; [ uv ]);

  programs.zoxide.enable = true;

  programs.vim = {
    enable = true;
    extraConfig = ''
            " Map jk and kj to Escape in insert mode
      			      inoremap jk <Esc>
      						      inoremap kj <Esc>

      									      " Use the system clipboard
      												      set clipboard=unnamedplus
      															    '';
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    mouse = true;
    escapeTime = 10;
    extraConfig = lib.strings.fileContents "${rootPath}/config/tmux.conf";
    shell = "${pkgs.fish}/bin/fish";
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.sensible
      tmuxPlugins.extrakto
      tmuxPlugins.yank
      tmuxPlugins.continuum
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = { global = { load_dotenv = true; }; };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit =
      lib.strings.fileContents "${rootPath}/config/fish/config.fish";
    plugins = [{
      name = "pure";
      src = pkgs.fishPlugins.pure;
    }];
  };

  xdg.configFile = util.symlinkFiles {
    sourceDir = "${config.home.homeDirectory}/Dotfiles/config/fish/conf.d";
    targetDir = "fish/conf.d";
  };

  programs.readline = {
    enable = true;
    extraConfig = lib.strings.fileContents "${rootPath}/config/inputrc";
  };

}
