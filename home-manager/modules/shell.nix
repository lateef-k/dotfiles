{ inputs, lib, config, pkgs, pkgs-unstable, rootPath, ... }: {
  imports = [
    "${
      fetchTarball
      "https://github.com/msteen/nixos-vscode-server/tarball/master"
    }/modules/vscode-server/home.nix"
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
    hello-unfree
  ]) ++ (with pkgs-unstable; [ uv ]);

  programs.zoxide.enable = true;

  programs.git = {
    enable = true;
    userName = "lateef";
    userEmail = "dev@lateefk.com";
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    mouse = true;
    escapeTime = 10;
    extraConfig = lib.strings.fileContents "${rootPath}/config/tmux.conf";
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

  programs.zsh = { enable = true; };

  programs.readline = {
    enable = true;
    extraConfig = lib.strings.fileContents "${rootPath}/config/inputrc";
  };

}
