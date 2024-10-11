{ inputs, lib, config, pkgs, pkgs-unstable, rootPath, ... }: {
  imports = [
    # "${
    #   fetchTarball
    #   "https://github.com/msteen/nixos-vscode-server/tarball/master"
    # }/modules/vscode-server/home.nix"
  ];

  home.packages = (with pkgs; [
    cachix
    ripgrep
    fd
    fzf
    xclip
    just
    tldr
    mosh
    obsidian
    nerdfonts
    iw
    pipx
    gh
  ]) ++ (with pkgs-unstable; [ uv lazygit ]);

  programs.zoxide.enable = true;

  programs.git = {
    enable = true;
    includes = [ { path = "${rootPath}/config/gitconfig"; } ];
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
      # tmuxPlugins.resurrect
      tmuxPlugins.sensible
      tmuxPlugins.extrakto
      tmuxPlugins.yank
      tmuxPlugins.continuum
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit =
      lib.strings.fileContents "${rootPath}/config/config.fish";
    plugins = [{
      name = "pure";
      src = pkgs.fishPlugins.pure;
    }];
  };

  programs.readline = {
    enable = true;
    extraConfig = lib.strings.fileContents "${rootPath}/config/inputrc";
  };

}
