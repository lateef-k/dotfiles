{ inputs, lib, config, pkgs, pkgs-unstable, rootPath, ... }:

let util = (import ../../lib/util.nix config.lib);

in {
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
    mosh
    nerdfonts
    iw
    pipx
    file
    ncdu
    gh
    tldr
    just
    nix-doc
    wget
    binutils
    htop
    rlwrap
    gocryptfs
    zotero_7
    libarchive
  ]) ++ (with pkgs.python311Packages; [ llm ])
    ++ (with pkgs-unstable; [ uv lazygit ]);

  programs.zoxide.enable = true;

  programs.git = {
    enable = true;
    includes = [{ path = "${rootPath}/config/gitconfig"; }];
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
    # # this messes with nix itself, but fixes numpy
    # shellInitLast = ''
    #   set -x LD_LIBRARY_PATH "${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
    #   set -x LD_LIBRARY_PATH "${
    #     pkgs.lib.makeLibraryPath [ pkgs.python312 pkgs.zlib pkgs.poetry ]
    #   }/lib:$LD_LIBRARY_PATH"
    # '';
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
