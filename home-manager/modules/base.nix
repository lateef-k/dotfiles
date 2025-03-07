{ inputs, lib, config, pkgs, ... }:

let util = (import ../../lib/util.nix config.lib);

in {
  home.packages =
    (with pkgs; [ just libarchive cachix ripgrep fd mosh rlwrap file fzf ]);

  programs.git = {
    enable = true;
    includes = [{ path = "${inputs.self}/config/gitconfig"; }];
  };
  programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      " Map jk and kj to Escape in insert mode
      inoremap jk <Esc>
      inoremap kj <Esc>

      " Use the system clipboard
      set clipboard=unnamedplus
    '';
  };
  programs.zoxide.enable = true;

  home.sessionVariables.EDITOR = lib.mkDefault "vim";

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    mouse = true;
    escapeTime = 10;
    extraConfig = lib.strings.fileContents "${inputs.self}/config/tmux.conf";
    shell = "${pkgs.fish}/bin/fish";
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.sensible
      tmuxPlugins.extrakto
      tmuxPlugins.yank
      tmuxPlugins.continuum
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit =
      lib.strings.fileContents "${inputs.self}/config/fish/config.fish";
  };

  programs.starship = { enable = true; };

  xdg.configFile = util.symlinkFiles {
    sourceDir = "${inputs.self}/config/fish/conf.d";
    targetDir = "fish/conf.d";
  } // {
    "starship.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${inputs.self}/config/starship.toml";
  };

  programs.readline = {
    enable = true;
    extraConfig = lib.strings.fileContents "${inputs.self}/config/inputrc";
  };

}
