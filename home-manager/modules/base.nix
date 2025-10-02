{ inputs, lib, config, pkgs, ... }:

{
  home.packages = (with pkgs; [
    zoxide
    just
    libarchive
    cachix
    ripgrep
    fd
    mosh
    rlwrap
    file
    fzf
    starship
  ]);

  programs.git = {
    enable = true;
    lfs.enable = true;
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

  programs.readline = {
    enable = true;
    extraConfig = lib.strings.fileContents "${inputs.self}/config/inputrc";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile = {
    "starship.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${inputs.self}/config/starship.toml";
  };

}
