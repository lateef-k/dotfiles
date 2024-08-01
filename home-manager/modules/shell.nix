{ inputs, lib, config, pkgs, ... }: {

  imports = [
    "${
      fetchTarball
      "https://github.com/msteen/nixos-vscode-server/tarball/master"
    }/modules/vscode-server/home.nix"
  ];

  home.packages = with pkgs; [
    cachix
    ripgrep
    fd
    fzf
    devbox
    just
    nixfmt-classic
    stylua
    black
    isort
    tldr
    python312
    sqlite
    mosh
    gnumake
    pyright
    nixd
    lua-language-server
  ];

  home.sessionVariables.EDITOR = "nvim";

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
    extraConfig = lib.strings.fileContents
      "${config.home.homeDirectory}/dotfiles/programs/tmux/tmux.conf";
    plugins = with pkgs; [
      # tmuxPlugins.resurrect
      tmuxPlugins.sensible
      tmuxPlugins.extrakto
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          # set -g @continuum-restore 'on'
          # set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];

  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      DEVBOX_NO_PROMPT = true;
      DIRENV_LOG_FORMAT = "";
    };
    bashrcExtra = lib.strings.fileContents
      "${config.home.homeDirectory}/dotfiles/programs/bash/.bashrc";
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [{
      name = "pure";
      src = pkgs.fishPlugins.pure;
    }];
  };

  programs.readline = {
    enable = true;
    extraConfig = lib.strings.fileContents
      "${config.home.homeDirectory}/dotfiles/programs/readline/.inputrc";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  # Neovim
  #------------
  programs.neovim = {
    enable = true;
    package =
      inputs.neovim-nightly-overlay.packages.${pkgs.system}.default; # If you want to use Neovim nightly
    # extraLuaConfig = builtins.readFile
    #   "${config.home.homeDirectory}/dotfiles/programs/neovim/init.lua";
    viAlias = true;
    vimAlias = true;
    # vimDiffAlias = true;
    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
  };

  home.file."${config.home.homeDirectory}/.config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/programs/nvim";
  };

  home.file."${config.home.homeDirectory}/.local/share/nvim/nix/nvim-treesitter" =
    {
      source = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      recursive = true;
    };

  home.file."${config.home.homeDirectory}/.local/share/nvim/nix/nvim-treesitter/parser" =
    {
      source = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      };
      recursive = true;
    };
  #--------------
  #
  # services.vscode-server.enable = true;
  # services.vscode-server.enableFHS = true;

  # programs.vscode.enable = true;

}
