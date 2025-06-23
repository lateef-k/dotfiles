

{ inputs, lib, config, pkgs, ... }: {

  imports = [
    "${
      fetchTarball
      "https://github.com/msteen/nixos-vscode-server/tarball/master"
    }/modules/vscode-server/home.nix"
  ];
  services.vscode-server.enable = true;
  services.vscode-server.enableFHS = true;

  home.packages = (with pkgs; [
    sqlite
    gnumake
    python312
    nodejs_22
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

    # runs with the correct dynamica libraries
    # (pkgs.writeShellScriptBin "aider" ''
    #   export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
    #   exec ${pkgs.pipx}/bin/pipx "run" "aider-chat"
    # '')
    #
    aider-chat
  ]);

  home.sessionVariables.EDITOR = lib.mkForce "nvim";

  # Neovim
  #------------
  programs.neovim = {
    enable = true;
    viAlias = true;
    package =
      inputs.neovim-nightly-overlay.packages.${pkgs.system}.default; # If you want to use Neovim nightly
    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
  };

  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Admin/dotfiles/config/nvim";
    };
  };

  home.file.".aider.conf.yml".source =
    "${config.home.homeDirectory}/Admin/dotfiles/config/aider.conf.yml";

  xdg.dataFile = {
    # prepend this path when starting treesitter, and it'll see the parsers
    # `:echo &runtimepath` and `:echo nvim_get_runtime_file('parser', v:true)` 
    "nvim/nix/nvim-treesitter/parser" = {
      source = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      };
      recursive = true;
    };
  };

}
