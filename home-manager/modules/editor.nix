

{ inputs, lib, config, pkgs, pkgs-unstable, rootPath, ... }: {

  imports = [
    "${
      fetchTarball
      "https://github.com/msteen/nixos-vscode-server/tarball/master"
    }/modules/vscode-server/home.nix"
  ];

  home.packages = (with pkgs; [ sqlite gnumake python312 nodejs_22 ])
    ++ (with pkgs-unstable; [
      nixfmt-classic
      stylua
      black
      isort
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      pyright
      ruff
      nixd
      lua-language-server
    ]);

  home.sessionVariables.EDITOR = "nvim";

  # Neovim
  #------------
  programs.neovim = {
    enable = true;
    package =
      inputs.neovim-nightly-overlay.packages.${pkgs.system}.default; # If you want to use Neovim nightly
    plugins = [ pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars ];
  };
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Dotfiles/config/nvim";
    };
  };

  xdg.dataFile = {
    # prepend this path when starting treesitter, and it'll see the parsers
    # `:echo &runtimepath` and `:echo nvim_get_runtime_file('parser', v:true)` 
    "nvim/nix/nvim-treesitter/parser" = {
      source = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths =
          pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      };
      recursive = true;
    };
  };

}
