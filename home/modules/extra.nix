{ config, pkgs, lib, inputs, ... }:

let cfg = config.bundle.extra;
in {
  options.bundle.extra = {
    gui.enable = lib.mkEnableOption "Enable graphical applications";
    dev.enable = lib.mkEnableOption "Enable development packages";
    neovim.enable = lib.mkEnableOption "Enable Neovim configuration";
    obsidian.enable = lib.mkEnableOption "Enable Obsidian auto-start service";
    browserAutomation.enable =
      lib.mkEnableOption "Enable Playwright browser automation";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.gui.enable {
      home.packages = with pkgs; [ dbeaver-bin zotero_7 ];

      programs.rofi = {
        enable = true;
        theme = "gruvbox-dark-hard";
        terminal = "${pkgs.kitty}/bin/kitty";
        extraConfig = { modi = "window,drun,ssh,combi"; };
      };

      programs.firefox.enable = true;
      programs.chromium.enable = true;
      programs.kitty = {
        enable = true;
        extraConfig = ''
          hide_window_decorations yes
          shell ${pkgs.fish}/bin/fish
        '';
        shellIntegration.mode = "";
      };

      programs.vscode = {
        enable = true;
        package = pkgs.vscode.fhs;
      };
    })

    (lib.mkIf cfg.dev.enable {
      home.packages = with pkgs; [
        sqlite
        gnumake
        nixfmt-classic
        nixd
        stylua
        nodejs_22
        flutter
        python312
        black
        isort
        pyright
        ruff
        nodePackages.typescript-language-server
        nodePackages.bash-language-server
        lua-language-server
        prettierd
      ];
    })

    (lib.mkIf cfg.neovim.enable {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
        plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
      };

      xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Admin/dotfiles/config/nvim";

      xdg.dataFile."nvim/nix/nvim-treesitter/parser".source = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      };

      home.sessionVariables.EDITOR = lib.mkForce "nvim";
    })

    (lib.mkIf cfg.obsidian.enable {
      home.packages = with pkgs; [ obsidian ];

      systemd.user.services.obsidian = {
        Unit = {
          Description = "Start Obsidian at login to sync";
          After = [ "graphical-session.target" ];
          Requires = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.obsidian}/bin/obsidian";
          Restart = "on-failure";
          Environment = [ "DISPLAY=:0" "XAUTHORITY=%h/.Xauthority" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    })

    (lib.mkIf cfg.browserAutomation.enable {
      home.packages = with pkgs; [ playwright-driver.browsers ];

      programs.fish.interactiveShellInit = ''
        export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
        export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
      '';
    })
  ];
}

