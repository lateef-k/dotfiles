{ inputs, lib, config, pkgs, ... }:

let
  util = (import ../../lib/util.nix config.lib);

  isDarwin = lib.strings.hasSuffix "darwin" builtins.currentSystem;
  isLinux = lib.strings.hasSuffix "linux" builtins.currentSystem;
in lib.mkMerge [

  {
    home.packages = (with pkgs; [
      wget
      binutils
      pipx
      ncdu
      gh
      tldr
      nix-doc
      gocryptfs
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      uv
      lazygit
      jq
      claude-code
      pkgs.playwright-driver.browsers
      tree
    ]) ++ (with pkgs.python312Packages; [ llm ]);

    programs.fish = {
      interactiveShellInit = ''
              export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
              export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
        		'';
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = { global = { load_dotenv = true; }; };
    };

  }

  # Conditionally include this if linux
  (lib.mkIf isLinux {

    home.packages = (with pkgs; [ xclip iw ]);

    programs.rofi = {
      enable = true;
      theme = "gruvbox-dark-hard";
      terminal = "${pkgs.kitty}/bin/kitty";
      extraConfig = { modi = "window,drun,ssh,combi"; };
    };
  })

]
