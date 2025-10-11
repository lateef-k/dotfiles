{ inputs, lib, config, pkgs, ... }:

let
  isDarwin = lib.strings.hasSuffix "-darwin" builtins.currentSystem;
  isLinux = lib.strings.hasSuffix "-linux" builtins.currentSystem;
in lib.mkMerge [
  {
    # ----------------------------------- SETUP ------------------------------------
    programs.home-manager.enable = true;
    home.username = "ludvi";
    home.packages = (with pkgs; [ libarchive ripgrep fd mosh rlwrap file fzf ]);

    nixpkgs.config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      allowUnfreePredicate = (_: true);
    };

    programs.fish = {
      enable = true;
      interactiveShellInit =
        lib.strings.fileContents "${inputs.self}/config/fish/config.fish";
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = { global = { load_dotenv = true; }; };
    };

    programs.git = {
      enable = true;
      includes = [{ path = "${inputs.self}/config/gitconfig"; }];
    };

    programs.vim = {
      enable = true;
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
  }

  (lib.optionalAttrs isLinux {
    home.homeDirectory = "/home/ludvi";
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
    home.stateVersion = "24.05";
  })

  (lib.optionalAttrs isDarwin {
    home.homeDirectory = "/Users/ludvi";
    home.stateVersion = "24.11";
  })
]
