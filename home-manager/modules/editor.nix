

{ inputs, lib, config, pkgs, rootPath, ... }: {

  imports = [
    "${
      fetchTarball
      "https://github.com/msteen/nixos-vscode-server/tarball/master"
    }/modules/vscode-server/home.nix"
  ];

  home.packages = with pkgs; [
    nixfmt-classic
    stylua
    black
    isort
    sqlite
    gnumake
    python312
    pyright
    nixd
    lua-language-server
    nodePackages.bash-language-server
    vim
  ];

  home.sessionVariables.EDITOR = "nvim";

  # Neovim
  #------------
  programs.neovim = {
    enable = true;
    package =
      inputs.neovim-nightly-overlay.packages.${pkgs.system}.default; # If you want to use Neovim nightly
    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
  };
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/config/nvim";
    };
  };

  xdg.dataFile = {
    "nvim/nix/nvim-treesitter" = {
      source = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      recursive = true;
    };

    "nvim/nix/nvim-treesitter/parser" = {
      source = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      };
      recursive = true;
    };
  };

}
